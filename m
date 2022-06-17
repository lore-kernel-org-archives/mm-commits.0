Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16DA8CCA481
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379758AbiFQC7S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379898AbiFQC7N (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:59:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5311C66203
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:59:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4E1561D46
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44882C3411A;
        Fri, 17 Jun 2022 02:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434750;
        bh=Bun1+/K//QK4z2YcVBUi/oKhAvd1R6+/EtxGvySR/CM=;
        h=Date:To:From:Subject:From;
        b=v8G/qFPdqTYwxL6pCXAShJGUKU6KsAth4UY3uIMvbiZRdYbV+wd9nfwhp2rGB0pMI
         oDdKL6SJD152lyqOHD0Z0qjKdRqNeq0oFTGAvb3EtiiuThV+Ci3R54SdT3Eb9IxQcY
         fpg/pCLE0dH0IcbylHjigVk6FX8wQhULWKGjv2wA=
Date:   Thu, 16 Jun 2022 19:59:09 -0700
To:     mm-commits@vger.kernel.org, walters@verbum.org,
        usama.anjum@collabora.com, pjones@redhat.com,
        lennart@poettering.net, javierm@redhat.com, ckellner@redhat.com,
        cccheng@synology.com, alexl@redhat.com,
        hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fat-factor-out-reusable-code-in-vfat_rename-as-helper-functions.patch removed from -mm tree
Message-Id: <20220617025910.44882C3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fat: factor out reusable code in vfat_rename() as helper functions
has been removed from the -mm tree.  Its filename was
     fat-factor-out-reusable-code-in-vfat_rename-as-helper-functions.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: fat: factor out reusable code in vfat_rename() as helper functions
Date: Fri, 10 Jun 2022 09:57:19 +0200

The vfat_rename() function is quite big and there are code blocks that can
be moved into helper functions.  This not only simplify the implementation
of that function but also allows these helpers to be reused.

For example, the helpers can be used by the handler of the RENAME_EXCHANGE
flag once this is implemented in a subsequent patch.

Link: https://lkml.kernel.org/r/20220610075721.1182745-3-javierm@redhat.com
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Alexander Larsson <alexl@redhat.com>
Cc: Christian Kellner <ckellner@redhat.com>
Cc: Chung-Chiang Cheng <cccheng@synology.com>
Cc: Colin Walters <walters@verbum.org>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Peter Jones <pjones@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/namei_vfat.c |   89 ++++++++++++++++++++++++++----------------
 1 file changed, 57 insertions(+), 32 deletions(-)

--- a/fs/fat/namei_vfat.c~fat-factor-out-reusable-code-in-vfat_rename-as-helper-functions
+++ a/fs/fat/namei_vfat.c
@@ -889,16 +889,55 @@ out:
 	return err;
 }
 
+static int vfat_get_dotdot_de(struct inode *inode, struct buffer_head **bh,
+			      struct msdos_dir_entry **de)
+{
+	if (S_ISDIR(inode->i_mode)) {
+		if (fat_get_dotdot_entry(inode, bh, de))
+			return -EIO;
+	}
+	return 0;
+}
+
+static int vfat_sync_ipos(struct inode *dir, struct inode *inode)
+{
+	if (IS_DIRSYNC(dir))
+		return fat_sync_inode(inode);
+	mark_inode_dirty(inode);
+	return 0;
+}
+
+static int vfat_update_dotdot_de(struct inode *dir, struct inode *inode,
+				 struct buffer_head *dotdot_bh,
+				 struct msdos_dir_entry *dotdot_de)
+{
+	fat_set_start(dotdot_de, MSDOS_I(dir)->i_logstart);
+	mark_buffer_dirty_inode(dotdot_bh, inode);
+	if (IS_DIRSYNC(dir))
+		return sync_dirty_buffer(dotdot_bh);
+	return 0;
+}
+
+static void vfat_update_dir_metadata(struct inode *dir, struct timespec64 *ts)
+{
+	inode_inc_iversion(dir);
+	fat_truncate_time(dir, ts, S_CTIME | S_MTIME);
+	if (IS_DIRSYNC(dir))
+		(void)fat_sync_inode(dir);
+	else
+		mark_inode_dirty(dir);
+}
+
 static int vfat_rename(struct inode *old_dir, struct dentry *old_dentry,
 		       struct inode *new_dir, struct dentry *new_dentry)
 {
 	struct buffer_head *dotdot_bh;
-	struct msdos_dir_entry *dotdot_de;
+	struct msdos_dir_entry *dotdot_de = NULL;
 	struct inode *old_inode, *new_inode;
 	struct fat_slot_info old_sinfo, sinfo;
 	struct timespec64 ts;
 	loff_t new_i_pos;
-	int err, is_dir, update_dotdot, corrupt = 0;
+	int err, is_dir, corrupt = 0;
 	struct super_block *sb = old_dir->i_sb;
 
 	old_sinfo.bh = sinfo.bh = dotdot_bh = NULL;
@@ -909,15 +948,13 @@ static int vfat_rename(struct inode *old
 	if (err)
 		goto out;
 
-	is_dir = S_ISDIR(old_inode->i_mode);
-	update_dotdot = (is_dir && old_dir != new_dir);
-	if (update_dotdot) {
-		if (fat_get_dotdot_entry(old_inode, &dotdot_bh, &dotdot_de)) {
-			err = -EIO;
+	if (old_dir != new_dir) {
+		err = vfat_get_dotdot_de(old_inode, &dotdot_bh, &dotdot_de);
+		if (err)
 			goto out;
-		}
 	}
 
+	is_dir = S_ISDIR(old_inode->i_mode);
 	ts = current_time(old_dir);
 	if (new_inode) {
 		if (is_dir) {
@@ -938,21 +975,15 @@ static int vfat_rename(struct inode *old
 
 	fat_detach(old_inode);
 	fat_attach(old_inode, new_i_pos);
-	if (IS_DIRSYNC(new_dir)) {
-		err = fat_sync_inode(old_inode);
+	err = vfat_sync_ipos(new_dir, old_inode);
+	if (err)
+		goto error_inode;
+
+	if (dotdot_de) {
+		err = vfat_update_dotdot_de(new_dir, old_inode, dotdot_bh,
+					    dotdot_de);
 		if (err)
-			goto error_inode;
-	} else
-		mark_inode_dirty(old_inode);
-
-	if (update_dotdot) {
-		fat_set_start(dotdot_de, MSDOS_I(new_dir)->i_logstart);
-		mark_buffer_dirty_inode(dotdot_bh, old_inode);
-		if (IS_DIRSYNC(new_dir)) {
-			err = sync_dirty_buffer(dotdot_bh);
-			if (err)
-				goto error_dotdot;
-		}
+			goto error_dotdot;
 		drop_nlink(old_dir);
 		if (!new_inode)
  			inc_nlink(new_dir);
@@ -962,12 +993,7 @@ static int vfat_rename(struct inode *old
 	old_sinfo.bh = NULL;
 	if (err)
 		goto error_dotdot;
-	inode_inc_iversion(old_dir);
-	fat_truncate_time(old_dir, &ts, S_CTIME|S_MTIME);
-	if (IS_DIRSYNC(old_dir))
-		(void)fat_sync_inode(old_dir);
-	else
-		mark_inode_dirty(old_dir);
+	vfat_update_dir_metadata(old_dir, &ts);
 
 	if (new_inode) {
 		drop_nlink(new_inode);
@@ -987,10 +1013,9 @@ error_dotdot:
 	/* data cluster is shared, serious corruption */
 	corrupt = 1;
 
-	if (update_dotdot) {
-		fat_set_start(dotdot_de, MSDOS_I(old_dir)->i_logstart);
-		mark_buffer_dirty_inode(dotdot_bh, old_inode);
-		corrupt |= sync_dirty_buffer(dotdot_bh);
+	if (dotdot_de) {
+		corrupt |= vfat_update_dotdot_de(old_dir, old_inode, dotdot_bh,
+						 dotdot_de);
 	}
 error_inode:
 	fat_detach(old_inode);
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are


