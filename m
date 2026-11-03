Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793675995;
	b=TjB1AS18ZmkOusicBJ9vVCSAu1OPc8nz+SEkkwoMk3GAmTyk9SsYD5v9m8a2b0l67Wgj
	 ptBLR6uA7fXzWi6a8IraSt63Tofha20xGdiVm85QqufAJzqf8+JBdyVW8vgF9MGh/yISy
	 +hbiiPE9zO7xBFIxPY+hJsRTKNQxKMiGCFcrSUjwVYl+MGNlOjY69LqQcPlcgYPePQN3k
	 mJXnv5qNm6OcLASQtirQWapUG1Km0TiqcFS0kOm4tRpAeUZoSqEXSd936Z99EgSUzNnqO
	 VZXsncrLT3q9EQZHrdWItVK5b5oj+xoBQ2LleXrBnrXSMnqA/sSfoKSf8U9OUcFp8kA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793675995;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=7qv2F/IU6sW8LtWAobrtVI/BJO8mkCYn0VKzQAJs+hY=;
	b=ijPtI0gs+zIv/5OFvT/JnsCnpz+keWcoFdVc1PL4D9oAMZaPJpbouTqdaoBw2cIKCva9
	 LzcJnrnFn17SbQC79NbItLI2vBGfslST0fn7243bvK5XVO/fqJYsw9Ylurz1ZPq4KKPo/
	 D7qPHUW/OgS0eAW2SamDXKlwg/iFwrBObRhT99iCVOMMth98akZjVaex5jF81aW0KpQI8
	 1RNZgU1MKVOmxyxbukg2e2LJm7wDrZ/LdAa16/3Iu4eJehomIQXvHA71Py3koY/iV/VCV
	 H48lG6BBpGX2CtrDEM48C4ifCP+ulcnIc6mi+0MFzYRv9RBJI5f0URY5KNRRmb/p+iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="uxq3/M2j";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF07606A337
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 03:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uxq3/M2j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 782871F0093A;
	Tue,  3 Nov 2026 03:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793675994;
	bh=7qv2F/IU6sW8LtWAobrtVI/BJO8mkCYn0VKzQAJs+hY=;
	h=Date:To:From:Subject;
	b=uxq3/M2jg9NSJUqAbpPynYAAV0aSjDZEUX3WPrunX6eQy8cXK7W7p1/REEvB+NMCe
	 l+rvRWans7BSCCyoRE8aFGGiNVG30+swm09/K0bVZTNMjTlM0aPUzbSOZzAOXouKHB
	 nISHdjLAGqUbN94FYFHPuENYwA1sosdF0FKqf4oY=
Date: Mon, 02 Nov 2026 19:19:54 -0800
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,brauner@kernel.org,
	dennylin0707@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-hotfixes-stable] fat-fix-parent-link-count-when-replacing-a-sibling-directory.patch removed from -mm tree
Message-Id: <20261103031954.782871F0093A@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: fat: fix parent link count when replacing a sibling directory
has been removed from the -mm tree.  Its filename was
     fat-fix-parent-link-count-when-replacing-a-sibling-directory.patch

This patch was dropped because it was merged into the mm-nonmm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hungyu Lin <dennylin0707@gmail.com>
Subject: fat: fix parent link count when replacing a sibling directory
Date: Fri, 30 Oct 2026 06:00:11 +0000

vfat_rename() and do_msdos_rename() adjust parent link counts only when
updating the dotdot entry for a move between different parents.  Replacing
an existing empty directory in the same parent also removes a
subdirectory, but leaves the parent's link count unchanged.

For example, renaming one of two sibling directories over the other leaves
the parent with four links instead of three.  stat and ls report the stale
count, and find -links 3 does not match the parent.

Drop the parent's link count for this case after the source entry has been
removed successfully.  Leave cross-parent renames, regular files and the
existing error paths unchanged.

Share the parent link count check with rmdir through fat_dir_drop_nlink().
Only decrement counts of at least three and report a filesystem error
otherwise, rather than reducing a corrupted directory's count below two. 
Export the helper for the VFAT and MSDOS modules.

Link: https://lore.kernel.org/20261030060011.70237-1-dennylin0707@gmail.com
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Christian Brauner <brauner@kernel.org>
---

 fs/fat/dir.c         |   10 ++++++++++
 fs/fat/fat.h         |    1 +
 fs/fat/namei_msdos.c |    9 +++------
 fs/fat/namei_vfat.c  |    9 +++------
 4 files changed, 17 insertions(+), 12 deletions(-)

--- a/fs/fat/dir.c~fat-fix-parent-link-count-when-replacing-a-sibling-directory
+++ a/fs/fat/dir.c
@@ -963,6 +963,16 @@ int fat_dir_empty(struct inode *dir)
 }
 EXPORT_SYMBOL_GPL(fat_dir_empty);
 
+void fat_dir_drop_nlink(struct inode *dir)
+{
+	if (dir->i_nlink >= 3)
+		drop_nlink(dir);
+	else
+		fat_fs_error(dir->i_sb, "parent dir link count too low (%u)",
+			     dir->i_nlink);
+}
+EXPORT_SYMBOL_GPL(fat_dir_drop_nlink);
+
 /*
  * fat_subdirs counts the number of sub-directories of dir. It can be run
  * on directories being created.
--- a/fs/fat/fat.h~fat-fix-parent-link-count-when-replacing-a-sibling-directory
+++ a/fs/fat/fat.h
@@ -332,6 +332,7 @@ extern const struct file_operations fat_
 extern int fat_search_long(struct inode *inode, const unsigned char *name,
 			   int name_len, struct fat_slot_info *sinfo);
 extern int fat_dir_empty(struct inode *dir);
+void fat_dir_drop_nlink(struct inode *dir);
 extern int fat_subdirs(struct inode *dir);
 extern int fat_scan(struct inode *dir, const unsigned char *name,
 		    struct fat_slot_info *sinfo);
--- a/fs/fat/namei_msdos.c~fat-fix-parent-link-count-when-replacing-a-sibling-directory
+++ a/fs/fat/namei_msdos.c
@@ -333,12 +333,7 @@ static int msdos_rmdir(struct inode *dir
 	err = fat_remove_entries(dir, &sinfo);	/* and releases bh */
 	if (err)
 		goto out;
-	if (dir->i_nlink >= 3)
-		drop_nlink(dir);
-	else {
-		fat_fs_error(sb, "parent dir link count too low (%u)",
-			dir->i_nlink);
-	}
+	fat_dir_drop_nlink(dir);
 
 	clear_nlink(inode);
 	fat_detach(inode);
@@ -565,6 +560,8 @@ static int do_msdos_rename(struct inode
 		(void)sync_inode_metadata(old_dir, 1);
 
 	if (new_inode) {
+		if (is_dir && old_dir == new_dir)
+			fat_dir_drop_nlink(old_dir);
 		drop_nlink(new_inode);
 		if (is_dir)
 			drop_nlink(new_inode);
--- a/fs/fat/namei_vfat.c~fat-fix-parent-link-count-when-replacing-a-sibling-directory
+++ a/fs/fat/namei_vfat.c
@@ -809,12 +809,7 @@ static int vfat_rmdir(struct inode *dir,
 	err = fat_remove_entries(dir, &sinfo);	/* and releases bh */
 	if (err)
 		goto out;
-	if (dir->i_nlink >= 3)
-		drop_nlink(dir);
-	else {
-		fat_fs_error(sb, "parent dir link count too low (%u)",
-			dir->i_nlink);
-	}
+	fat_dir_drop_nlink(dir);
 
 	clear_nlink(inode);
 	fat_truncate_time(inode, NULL, FAT_UPDATE_ATIME | FAT_UPDATE_CMTIME);
@@ -1011,6 +1006,8 @@ static int vfat_rename(struct inode *old
 	vfat_update_dir_metadata(old_dir, &ts);
 
 	if (new_inode) {
+		if (is_dir && old_dir == new_dir)
+			fat_dir_drop_nlink(old_dir);
 		drop_nlink(new_inode);
 		if (is_dir)
 			drop_nlink(new_inode);
_

Patches currently in -mm which might be from dennylin0707@gmail.com are

delayacct-preserve-delay-extrema-when-aggregating-taskstats.patch
shmem-clamp-negative-used-block-samples-in-statfs.patch

