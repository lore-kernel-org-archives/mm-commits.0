Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541C71A01B4;
	Mon, 24 Jun 2024 23:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719270190; cv=none; b=OpfjfN49ZiXtgPjUwLS1QdGbYaKXeOYYjQtPLAqIvRMoooGNDKDR1adplP31ma3UI/V4ahBBnw9PSjXzMLxzXrXQgzrMyOPmuD8v8qgYFqWjyNFyRBnBWmfOqRqdbD0PLluwEI6ec22ePHCJbJV49fQlu7Lxzm0WuHXC5R6zxFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719270190; c=relaxed/simple;
	bh=4/AZYkcWF860eCnrOZk9i/YyThUmbdbaySM6jZ35S8U=;
	h=Date:To:From:Subject:Message-Id; b=pIwl80qyfOk3lCOJ6pA/d4gRD7LhNKHTE21giDEW/IRUWHMD4C2cSNKUCAyyu+ZRBVuFMykKM6D8Y4bEG70GW76QYGnKsTSoTjI8vpKTzAibEa9quS76ZD4H0Z+XiZr+QP9urw1cBzyV5j5lx3r6qMdrvC3rzpLGpWSjwvc1Pis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SKhBRRn3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SKhBRRn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A19C2BBFC;
	Mon, 24 Jun 2024 23:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719270189;
	bh=4/AZYkcWF860eCnrOZk9i/YyThUmbdbaySM6jZ35S8U=;
	h=Date:To:From:Subject:From;
	b=SKhBRRn3CujQaQ2OXLUYfT4KKe6EyrZdBE7VxxZF+4nYb+FYJ9iN5tsSTqOXK2ro1
	 UNsZZP4ejAi1ykwL4uA1dfVJyM1+YG3E7WaJ7hwaFk0KEZdqwjhOVQ7nU+0vbNSlqL
	 GYyRe8A5Q6/wVe2ASwF+VcuQESP0kh5JstajNOnM=
Date: Mon, 24 Jun 2024 16:03:09 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,jack@suse.cz,hdanton@sina.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-add-missing-check-for-inode-numbers-on-directory-entries.patch added to mm-hotfixes-unstable branch
Message-Id: <20240624230309.D5A19C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: add missing check for inode numbers on directory entries
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-add-missing-check-for-inode-numbers-on-directory-entries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-add-missing-check-for-inode-numbers-on-directory-entries.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

nilfs2-fix-inode-number-range-checks.patch
nilfs2-add-missing-check-for-inode-numbers-on-directory-entries.patch
nilfs2-fix-incorrect-inode-allocation-from-reserved-inodes.patch
nilfs2-prepare-backing-device-folios-for-writing-after-adding-checksums.patch
nilfs2-do-not-call-inode_attach_wb-directly.patch

