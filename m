Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C82B334C11
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967405; cv=none; b=RcscpCz5ZHVmjIuugWeBp1LQekRFpnmIYVgNd9d0wa4IgbYaXw3Nhu8k4p1LwYZzbdMT2IrIa063oY/Whv4JZ9/+BxRM4nEyBqoVAO+mz6MdCC8c+Ltbixp/uK2YfeaLh1Ui9XIWa1G1XG2epmzajFygXKfKy/tP4U4dgReBkOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967405; c=relaxed/simple;
	bh=PY8clQj8oa47+7LcMzbyy7sL3Uig2e6vp0EUeaMwVSA=;
	h=Date:To:From:Subject:Message-Id; b=ihBNtdZO7TJct5eie9UUfez9GzYrE89CAAEas8pdijeccqFUTJwI1WzaIFSnFAa10748RHm4kuqm/VJbkXNa8RB9tayDjzxV1bH3s4kH520tRehxVzBa/+nOg1c5Drs8qGAFlcMuG2wr96OS3VtCFhY1p87XfFvGwKxy6xySSJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DmWpCggf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DmWpCggf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F343C16AAE;
	Wed, 21 Jan 2026 03:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967404;
	bh=PY8clQj8oa47+7LcMzbyy7sL3Uig2e6vp0EUeaMwVSA=;
	h=Date:To:From:Subject:From;
	b=DmWpCggfVcK2a3wTsrAXG3O8/hILW8jtFZalDrg6kJ+TKSJruQWTwQ4orljeyoA7K
	 LgJ7gsZjZuEdtZn/VwfSo/qYFq+uDDD+Mhv1diJNnffV1o077ppUJWe3jwYOQPwZFE
	 kRKk7YCQl7KGU10SY60x4y0Sy2loC1YlI7oMqj4c=
Date: Tue, 20 Jan 2026 19:50:04 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,jack@suse.cz,hirofumi@mail.parknet.co.jp,brauner@kernel.org,zhiyuzhang999@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fat-avoid-parent-link-count-underflow-in-rmdir.patch removed from -mm tree
Message-Id: <20260121035004.8F343C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fat: avoid parent link count underflow in rmdir
has been removed from the -mm tree.  Its filename was
     fat-avoid-parent-link-count-underflow-in-rmdir.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhiyu Zhang <zhiyuzhang999@gmail.com>
Subject: fat: avoid parent link count underflow in rmdir
Date: Thu, 1 Jan 2026 19:11:48 +0800

Corrupted FAT images can leave a directory inode with an incorrect
i_nlink (e.g. 2 even though subdirectories exist). rmdir then
unconditionally calls drop_nlink(dir) and can drive i_nlink to 0,
triggering the WARN_ON in drop_nlink().

Add a sanity check in vfat_rmdir() and msdos_rmdir(): only drop the
parent link count when it is at least 3, otherwise report a filesystem
error.

Link: https://lkml.kernel.org/r/20260101111148.1437-1-zhiyuzhang999@gmail.com
Fixes: 9a53c3a783c2 ("[PATCH] r/o bind mounts: unlink: monitor i_nlink")
Signed-off-by: Zhiyu Zhang <zhiyuzhang999@gmail.com>
Reported-by: Zhiyu Zhang <zhiyuzhang999@gmail.com>
Closes: https://lore.kernel.org/linux-fsdevel/aVN06OKsKxZe6-Kv@casper.infradead.org/T/#t
Tested-by: Zhiyu Zhang <zhiyuzhang999@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/namei_msdos.c |    7 ++++++-
 fs/fat/namei_vfat.c  |    7 ++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

--- a/fs/fat/namei_msdos.c~fat-avoid-parent-link-count-underflow-in-rmdir
+++ a/fs/fat/namei_msdos.c
@@ -325,7 +325,12 @@ static int msdos_rmdir(struct inode *dir
 	err = fat_remove_entries(dir, &sinfo);	/* and releases bh */
 	if (err)
 		goto out;
-	drop_nlink(dir);
+	if (dir->i_nlink >= 3)
+		drop_nlink(dir);
+	else {
+		fat_fs_error(sb, "parent dir link count too low (%u)",
+			dir->i_nlink);
+	}
 
 	clear_nlink(inode);
 	fat_truncate_time(inode, NULL, S_CTIME);
--- a/fs/fat/namei_vfat.c~fat-avoid-parent-link-count-underflow-in-rmdir
+++ a/fs/fat/namei_vfat.c
@@ -804,7 +804,12 @@ static int vfat_rmdir(struct inode *dir,
 	err = fat_remove_entries(dir, &sinfo);	/* and releases bh */
 	if (err)
 		goto out;
-	drop_nlink(dir);
+	if (dir->i_nlink >= 3)
+		drop_nlink(dir);
+	else {
+		fat_fs_error(sb, "parent dir link count too low (%u)",
+			dir->i_nlink);
+	}
 
 	clear_nlink(inode);
 	fat_truncate_time(inode, NULL, S_ATIME|S_MTIME);
_

Patches currently in -mm which might be from zhiyuzhang999@gmail.com are


