Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792560641;
	b=hsgjgh+Lx1d9/TPMeIa3rFR1Sjw54sLUpMznk07bQGnVR/6Wa9sD8GfRyfmCpWmUdSpv
	 cfhdgSmiCpgGtksB8D4175j+xvX6JGpJGl6Jf6g2FDdP0rxLYtn1TJh1o+PDBXFzc7tmP
	 aOrctXjru9hkADahqFnHP1OGzPaKprDY0uv34Cg5xMygcS8TNne1ZF7Vklaub5ChqpWfb
	 DDDDRljhR1mmolvXMDnVYFkR7tSwRnuXsNXCddztUyMHAZUV8Z23Qk7Y4nFFdDvINkk7m
	 vKNiYYD7Fx4QtmV3nO6lN3DuzDPPcdwLFE2w6gRbmp7W9bOTe5xGkhbjMZYBbfOfTlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792560641;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=80FvHmMbPRLEmyrSZ41Ja1iGExaS3SKkHuWyPEjxT6I=;
	b=X88MMKo7t9SwmIuPaMjuUJlKnaYrpNwOfJI1F9RJezB+6uDzOBvfGeIfaxNdRltVEuwt
	 mj1bRw1tcGr2SFl+VQ1k5UzVIZg9R+64M2EcEcBBjq8jadsSMVnrvx7W+MNXXJxz1mk/o
	 f7Fcug8/K9Fh/7Rse6/VXh0Qid+l9EKzWVxqzxpWYNxggjBFRO/gDSBW9IDiMSZgbg4ph
	 sURw5ac6HfJv7KQNkNcVHmaLkg4z5Cz31HLHqKNYfX0jYuw+mkHqTZGMUexo67fg6oYzS
	 KyvE1Lp2LQ9taIW/6p54vWVsdnldkjdg2mEovPy5SEAkDLu84+tczHSYHJQIX/oXPAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rAFHgEDs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812DF606A32A
	for <mm-commits@vger.kernel.org>; Wed, 21 Oct 2026 05:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rAFHgEDs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8391F000CA;
	Wed, 21 Oct 2026 05:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792560641;
	bh=80FvHmMbPRLEmyrSZ41Ja1iGExaS3SKkHuWyPEjxT6I=;
	h=Date:To:From:Subject;
	b=rAFHgEDsb4Ft2w+dBPJN/sn/Nd8LIYEJUNFPh0gcTBDEtPApoCSK2oZXWX3i21DM8
	 TaJysY4S0Y/Xv/DTRwZUd8N8u4MC8IPATRV4lfvP3Xs9cuWghAA45mP2HoasxnWcJ9
	 1Zjtu1W9+E5Xxj3ci3NsqkWgHZ24OArKn70GWWNg=
Date: Tue, 20 Oct 2026 22:30:40 -0700
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,teczm@foxmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fat-roll-back-the-new-entry-when-create-mkdir-fails-to-build-the-inode.patch removed from -mm tree
Message-Id: <20261021053041.4D8391F000CA@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: fat: roll back the new entry when create/mkdir fails to build the inode
has been removed from the -mm tree.  Its filename was
     fat-roll-back-the-new-entry-when-create-mkdir-fails-to-build-the-inode.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org" export _fat_msg() to modules]
Link: https://lore.kernel.org/tencent_4EDD66523CED299DB0C99498B4D8C939A009@qq.com
Signed-off-by: zhoumin <teczm@foxmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/misc.c        |    1 +
 fs/fat/namei_msdos.c |   22 ++++++++++++++++++----
 fs/fat/namei_vfat.c  |   22 ++++++++++++++++++----
 3 files changed, 37 insertions(+), 8 deletions(-)

--- a/fs/fat/misc.c~fat-roll-back-the-new-entry-when-create-mkdir-fails-to-build-the-inode
+++ a/fs/fat/misc.c
@@ -62,6 +62,7 @@ void _fat_msg(struct super_block *sb, co
 	_printk(FAT_PRINTK_PREFIX "%pV\n", level, sb->s_id, &vaf);
 	va_end(args);
 }
+EXPORT_SYMBOL_GPL(_fat_msg);
 
 /* Flushes the number of free clusters on FAT32 */
 /* XXX: Need to write one per FSINFO block.  Currently only writes 1 */
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


