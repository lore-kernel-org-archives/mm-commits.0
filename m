Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD55B519DF7
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 16:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791908943; cv=none; b=k9NIhc2KZq+9q5CyB8nvdkB4PynZ5MMTWJUo6bAs0EXqQFf+f3Iir8pD/eh4MjARnjhSGzXjp8KDw2xMYZpzf6g0teEniABf8Z0T3i542IPejtl8yDDcVikySxfv5F4EhD4+CIccvsoe52gVaUs1slujLUtMIKodAyh+3V1caW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791908943; c=relaxed/simple;
	bh=rAJVXrHjRrPijrEowWkIT12/t3CLMe/XG1K2Vcpnx2g=;
	h=Date:To:From:Subject:Message-Id; b=G3r756nVu5YqRfOyQcNL45M8FnIOMhNeuZyXv4PHkotnEKabvUaGQjvhZczxEVeDq3EeLyGLL/d2G67SZNrAq6LB8f4esMMF3JLTfXo6wdMJRB+5NIAYYQqaaJ/yK0TSlPV9y3nExM7Z+nq6/X4XJXi9AUXtMYZj/wT4J8pCLPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DJtcoHey; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DJtcoHey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40BEB1F000FF;
	Tue, 13 Oct 2026 16:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791908942;
	bh=Z5wz4LJckN0FzW6vHuTQJfqUchr3J8ECgQlWKp3bsF0=;
	h=Date:To:From:Subject;
	b=DJtcoHeyO9cHjfQva6HkQH8Nh538FzsRZIaya6Uf8LPry81dS7uIZnk5AY6wgjFvY
	 YvDrU8wPTVwNGys/A46s8DcUK72PR4J8c0UdG+Xqij9FNQLPIDcPb9semSycpdKuC0
	 0xtSkd0VraEdsEwrMxFrRSnCObb4MJHCL5KAm29s=
Date: Tue, 13 Oct 2026 09:29:01 -0700
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,teczm@foxmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fat-roll-back-the-new-entry-when-create-mkdir-fails-to-build-the-inode.patch added to mm-nonmm-unstable branch
Message-Id: <20261013162902.40BEB1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fat: roll back the new entry when create/mkdir fails to build the inode
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fat-roll-back-the-new-entry-when-create-mkdir-fails-to-build-the-inode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fat-roll-back-the-new-entry-when-create-mkdir-fails-to-build-the-inode.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: zhoumin <teczm@foxmail.com>
Subject: fat: roll back the new entry when create/mkdir fails to build the inode
Date: Mon, 12 Oct 2026 21:20:06 +0800

vfat_create(), vfat_mkdir(), msdos_create() and msdos_mkdir() add the
on-disk entry before calling fat_build_inode() to set up the VFS inode. 
If fat_build_inode() fails, the error is returned but the entry stays on
disk and the file or directory shows up after remount.

Remove the entry in that case.  For mkdir, also free the directory cluster
and decrement the parent's link count.

Link: https://lore.kernel.org/tencent_4EDD66523CED299DB0C99498B4D8C939A009@qq.com
Signed-off-by: zhoumin <teczm@foxmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/namei_msdos.c |   22 ++++++++++++++++++----
 fs/fat/namei_vfat.c  |   22 ++++++++++++++++++----
 2 files changed, 36 insertions(+), 8 deletions(-)

--- a/fs/fat/namei_msdos.c~fat-roll-back-the-new-entry-when-create-mkdir-fails-to-build-the-inode
+++ a/fs/fat/namei_msdos.c
@@ -292,11 +292,17 @@ static int msdos_create(struct mnt_idmap
 	if (err)
 		goto out;
 	inode = fat_build_inode(sb, sinfo.de, sinfo.i_pos);
-	brelse(sinfo.bh);
 	if (IS_ERR(inode)) {
+		int err2;
+
 		err = PTR_ERR(inode);
+		err2 = fat_remove_entries(dir, &sinfo);
+		if (err2)
+			fat_msg(sb, KERN_WARNING,
+				"failed to roll back new entry (%d)", err2);
 		goto out;
 	}
+	brelse(sinfo.bh);
 	fat_truncate_time(inode, &ts, FAT_UPDATE_ATIME | FAT_UPDATE_CMTIME);
 	/* timestamp is already written, so mark_inode_dirty() is unneeded. */
 
@@ -381,12 +387,20 @@ static struct dentry *msdos_mkdir(struct
 	inc_nlink(dir);
 
 	inode = fat_build_inode(sb, sinfo.de, sinfo.i_pos);
-	brelse(sinfo.bh);
 	if (IS_ERR(inode)) {
+		int err2;
+
 		err = PTR_ERR(inode);
-		/* the directory was completed, just return a error */
-		goto out;
+		err2 = fat_remove_entries(dir, &sinfo);
+		if (err2) {
+			fat_msg(sb, KERN_WARNING,
+				"failed to roll back new entry (%d)", err2);
+			goto out;
+		}
+		drop_nlink(dir);
+		goto out_free;
 	}
+	brelse(sinfo.bh);
 	set_nlink(inode, 2);
 	fat_truncate_time(inode, &ts, FAT_UPDATE_ATIME | FAT_UPDATE_CMTIME);
 	/* timestamp is already written, so mark_inode_dirty() is unneeded. */
--- a/fs/fat/namei_vfat.c~fat-roll-back-the-new-entry-when-create-mkdir-fails-to-build-the-inode
+++ a/fs/fat/namei_vfat.c
@@ -771,11 +771,17 @@ static int vfat_create(struct mnt_idmap
 	inode_inc_iversion(dir);
 
 	inode = fat_build_inode(sb, sinfo.de, sinfo.i_pos);
-	brelse(sinfo.bh);
 	if (IS_ERR(inode)) {
+		int err2;
+
 		err = PTR_ERR(inode);
+		err2 = fat_remove_entries(dir, &sinfo);
+		if (err2)
+			fat_msg(sb, KERN_WARNING,
+				"failed to roll back new entry (%d)", err2);
 		goto out;
 	}
+	brelse(sinfo.bh);
 	inode_inc_iversion(inode);
 
 	d_instantiate(dentry, inode);
@@ -870,12 +876,20 @@ static struct dentry *vfat_mkdir(struct
 	inc_nlink(dir);
 
 	inode = fat_build_inode(sb, sinfo.de, sinfo.i_pos);
-	brelse(sinfo.bh);
 	if (IS_ERR(inode)) {
+		int err2;
+
 		err = PTR_ERR(inode);
-		/* the directory was completed, just return a error */
-		goto out;
+		err2 = fat_remove_entries(dir, &sinfo);
+		if (err2) {
+			fat_msg(sb, KERN_WARNING,
+				"failed to roll back new entry (%d)", err2);
+			goto out;
+		}
+		drop_nlink(dir);
+		goto out_free;
 	}
+	brelse(sinfo.bh);
 	inode_inc_iversion(inode);
 	set_nlink(inode, 2);
 
_

Patches currently in -mm which might be from teczm@foxmail.com are

fat-roll-back-the-new-entry-when-create-mkdir-fails-to-build-the-inode.patch

