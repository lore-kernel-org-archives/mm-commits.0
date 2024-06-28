Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3C41876;
	Fri, 28 Jun 2024 00:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719533207; cv=none; b=dDzZb1w8o5gExN01mfbKOcshKdkYigtKU6r45i9XIuQjA5v+4N1o5bIjb1CRWLpo5iwqUzkPSILaOMHq5hw+9VraG09G7XQ8b/wI88GyEyQTHsFPVxMJ/8uQE8EOIG20YNK6Ft5dhLTb+AXwx0VArzdgjRKlt4D/q1FPuqF7d7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719533207; c=relaxed/simple;
	bh=SJAGSbcPb+Nhx1APzxO5vUmsgUNgEEMwUTd24R1gqBI=;
	h=Date:To:From:Subject:Message-Id; b=Q3x95i9lcroFI8GAmBkYURLHL0SbdH/Ph2wKnx4yJJsjcWzYNBxX5K+UU9oI/qUbDEhz/NHpvek55wvxrXL/M3EOn4ov4AmRzed9bJJP3+EzHcoo0ztJ/kh4izovnuSFFc9XyBg1wHmd4PBIbp6WFBfIhjETvdrzlPti1slodps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aInDS1jN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aInDS1jN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF7CC2BBFC;
	Fri, 28 Jun 2024 00:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719533206;
	bh=SJAGSbcPb+Nhx1APzxO5vUmsgUNgEEMwUTd24R1gqBI=;
	h=Date:To:From:Subject:From;
	b=aInDS1jNby/n7Oc/LsA7GJVKoNi75sIphAARwG3QfEqjlcJWdoDnGv9Zaydv/6UK7
	 ldd7Y4tNcULhQ01/arj+Xf7zzOMmT1/7pY0JZf1h0YP4p1XJtYe8CK5RP2FUkBWb8u
	 kZgYM1c8XF0K4/kCDjzEdtdjK9UUGWwP+sjZPzsM=
Date: Thu, 27 Jun 2024 17:06:46 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,jack@suse.cz,hdanton@sina.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-add-missing-check-for-inode-numbers-on-directory-entries.patch removed from -mm tree
Message-Id: <20240628000646.AEF7CC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: add missing check for inode numbers on directory entries
has been removed from the -mm tree.  Its filename was
     nilfs2-add-missing-check-for-inode-numbers-on-directory-entries.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: add missing check for inode numbers on directory entries
Date: Sun, 23 Jun 2024 14:11:34 +0900

Syzbot reported that mounting and unmounting a specific pattern of
corrupted nilfs2 filesystem images causes a use-after-free of metadata
file inodes, which triggers a kernel bug in lru_add_fn().

As Jan Kara pointed out, this is because the link count of a metadata file
gets corrupted to 0, and nilfs_evict_inode(), which is called from iput(),
tries to delete that inode (ifile inode in this case).

The inconsistency occurs because directories containing the inode numbers
of these metadata files that should not be visible in the namespace are
read without checking.

Fix this issue by treating the inode numbers of these internal files as
errors in the sanity check helper when reading directory folios/pages.

Also thanks to Hillf Danton and Matthew Wilcox for their initial mm-layer
analysis.

Link: https://lkml.kernel.org/r/20240623051135.4180-3-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+d79afb004be235636ee8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d79afb004be235636ee8
Reported-by: Jan Kara <jack@suse.cz>
Closes: https://lkml.kernel.org/r/20240617075758.wewhukbrjod5fp5o@quack3
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/dir.c   |    6 ++++++
 fs/nilfs2/nilfs.h |    5 +++++
 2 files changed, 11 insertions(+)

--- a/fs/nilfs2/dir.c~nilfs2-add-missing-check-for-inode-numbers-on-directory-entries
+++ a/fs/nilfs2/dir.c
@@ -135,6 +135,9 @@ static bool nilfs_check_folio(struct fol
 			goto Enamelen;
 		if (((offs + rec_len - 1) ^ offs) & ~(chunk_size-1))
 			goto Espan;
+		if (unlikely(p->inode &&
+			     NILFS_PRIVATE_INODE(le64_to_cpu(p->inode))))
+			goto Einumber;
 	}
 	if (offs != limit)
 		goto Eend;
@@ -160,6 +163,9 @@ Enamelen:
 	goto bad_entry;
 Espan:
 	error = "directory entry across blocks";
+	goto bad_entry;
+Einumber:
+	error = "disallowed inode number";
 bad_entry:
 	nilfs_error(sb,
 		    "bad entry in directory #%lu: %s - offset=%lu, inode=%lu, rec_len=%zd, name_len=%d",
--- a/fs/nilfs2/nilfs.h~nilfs2-add-missing-check-for-inode-numbers-on-directory-entries
+++ a/fs/nilfs2/nilfs.h
@@ -121,6 +121,11 @@ enum {
 	((ino) >= NILFS_FIRST_INO(sb) ||				\
 	 ((ino) < NILFS_USER_INO && (NILFS_SYS_INO_BITS & BIT(ino))))
 
+#define NILFS_PRIVATE_INODE(ino) ({					\
+	ino_t __ino = (ino);						\
+	((__ino) < NILFS_USER_INO && (__ino) != NILFS_ROOT_INO &&	\
+	 (__ino) != NILFS_SKETCH_INO); })
+
 /**
  * struct nilfs_transaction_info: context information for synchronization
  * @ti_magic: Magic number
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


