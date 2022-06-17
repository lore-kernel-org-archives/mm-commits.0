Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29412C43334
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:59:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379928AbiFQC7p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379904AbiFQC7P (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:59:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB3E65D31
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:59:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB235B826F5
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:59:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60764C34114;
        Fri, 17 Jun 2022 02:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434751;
        bh=wbY3UQE6YQvqpZJCwR4jHdPTG9OxX4phQZYLsxAOuF8=;
        h=Date:To:From:Subject:From;
        b=CxY55qaJW+diVgh5c8rDHESXEPdTAkhNWXLnrb6uZET8hM5yDvB1wmvzXTRRBgppd
         B45y1TA7yvjaHPdSQoAOH5bC+yloHsTuzIN6RsistJ2ALYJ0eL3QweJWplgRmheyNO
         4rPtLw2F834xs6NM4xVD5k3uQc/k8xuS0sal6OVg=
Date:   Thu, 16 Jun 2022 19:59:10 -0700
To:     mm-commits@vger.kernel.org, walters@verbum.org,
        usama.anjum@collabora.com, pjones@redhat.com,
        lennart@poettering.net, hirofumi@mail.parknet.co.jp,
        ckellner@redhat.com, cccheng@synology.com, alexl@redhat.com,
        javierm@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fat-add-renameat2-rename_exchange-flag-support.patch removed from -mm tree
Message-Id: <20220617025911.60764C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fat: add renameat2 RENAME_EXCHANGE flag support
has been removed from the -mm tree.  Its filename was
     fat-add-renameat2-rename_exchange-flag-support.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Javier Martinez Canillas <javierm@redhat.com>
Subject: fat: add renameat2 RENAME_EXCHANGE flag support
Date: Fri, 10 Jun 2022 09:57:20 +0200

The renameat2 RENAME_EXCHANGE flag allows to atomically exchange two paths
but is currently not supported by the Linux vfat filesystem driver.

Add a vfat_rename_exchange() helper function that implements this support.

The super block lock is acquired during the operation to ensure atomicity,
and in the error path actions made are reversed also with the mutex held.

It makes the operation as transactional as possible, within the limitation
impossed by vfat due not having a journal with logs to replay.

Link: https://lkml.kernel.org/r/20220610075721.1182745-4-javierm@redhat.com
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

 fs/fat/namei_vfat.c |  123 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 122 insertions(+), 1 deletion(-)

--- a/fs/fat/namei_vfat.c~fat-add-renameat2-rename_exchange-flag-support
+++ a/fs/fat/namei_vfat.c
@@ -1042,13 +1042,134 @@ error_inode:
 	goto out;
 }
 
+static void vfat_exchange_ipos(struct inode *old_inode, struct inode *new_inode,
+			       loff_t old_i_pos, loff_t new_i_pos)
+{
+	fat_detach(old_inode);
+	fat_detach(new_inode);
+	fat_attach(old_inode, new_i_pos);
+	fat_attach(new_inode, old_i_pos);
+}
+
+static void vfat_move_nlink(struct inode *src, struct inode *dst)
+{
+	drop_nlink(src);
+	inc_nlink(dst);
+}
+
+static int vfat_rename_exchange(struct inode *old_dir, struct dentry *old_dentry,
+				struct inode *new_dir, struct dentry *new_dentry)
+{
+	struct buffer_head *old_dotdot_bh = NULL, *new_dotdot_bh = NULL;
+	struct msdos_dir_entry *old_dotdot_de = NULL, *new_dotdot_de = NULL;
+	struct inode *old_inode, *new_inode;
+	struct timespec64 ts = current_time(old_dir);
+	loff_t old_i_pos, new_i_pos;
+	int err, corrupt = 0;
+	struct super_block *sb = old_dir->i_sb;
+
+	old_inode = d_inode(old_dentry);
+	new_inode = d_inode(new_dentry);
+
+	/* Acquire super block lock for the operation to be atomic */
+	mutex_lock(&MSDOS_SB(sb)->s_lock);
+
+	/* if directories are not the same, get ".." info to update */
+	if (old_dir != new_dir) {
+		err = vfat_get_dotdot_de(old_inode, &old_dotdot_bh,
+					 &old_dotdot_de);
+		if (err)
+			goto out;
+
+		err = vfat_get_dotdot_de(new_inode, &new_dotdot_bh,
+					 &new_dotdot_de);
+		if (err)
+			goto out;
+	}
+
+	old_i_pos = MSDOS_I(old_inode)->i_pos;
+	new_i_pos = MSDOS_I(new_inode)->i_pos;
+
+	vfat_exchange_ipos(old_inode, new_inode, old_i_pos, new_i_pos);
+
+	err = vfat_sync_ipos(old_dir, new_inode);
+	if (err)
+		goto error_exchange;
+	err = vfat_sync_ipos(new_dir, old_inode);
+	if (err)
+		goto error_exchange;
+
+	/* update ".." directory entry info */
+	if (old_dotdot_de) {
+		err = vfat_update_dotdot_de(new_dir, old_inode, old_dotdot_bh,
+					    old_dotdot_de);
+		if (err)
+			goto error_old_dotdot;
+	}
+	if (new_dotdot_de) {
+		err = vfat_update_dotdot_de(old_dir, new_inode, new_dotdot_bh,
+					    new_dotdot_de);
+		if (err)
+			goto error_new_dotdot;
+	}
+
+	/* if cross directory and only one is a directory, adjust nlink */
+	if (!old_dotdot_de != !new_dotdot_de) {
+		if (old_dotdot_de)
+			vfat_move_nlink(old_dir, new_dir);
+		else
+			vfat_move_nlink(new_dir, old_dir);
+	}
+
+	vfat_update_dir_metadata(old_dir, &ts);
+	/* if directories are not the same, update new_dir as well */
+	if (old_dir != new_dir)
+		vfat_update_dir_metadata(new_dir, &ts);
+
+out:
+	brelse(old_dotdot_bh);
+	brelse(new_dotdot_bh);
+	mutex_unlock(&MSDOS_SB(sb)->s_lock);
+
+	return err;
+
+error_new_dotdot:
+	if (new_dotdot_de) {
+		corrupt |= vfat_update_dotdot_de(new_dir, new_inode,
+						 new_dotdot_bh, new_dotdot_de);
+	}
+
+error_old_dotdot:
+	if (old_dotdot_de) {
+		corrupt |= vfat_update_dotdot_de(old_dir, old_inode,
+						 old_dotdot_bh, old_dotdot_de);
+	}
+
+error_exchange:
+	vfat_exchange_ipos(old_inode, new_inode, new_i_pos, old_i_pos);
+	corrupt |= vfat_sync_ipos(new_dir, new_inode);
+	corrupt |= vfat_sync_ipos(old_dir, old_inode);
+
+	if (corrupt < 0) {
+		fat_fs_error(new_dir->i_sb,
+			     "%s: Filesystem corrupted (i_pos %lld, %lld)",
+			     __func__, old_i_pos, new_i_pos);
+	}
+	goto out;
+}
+
 static int vfat_rename2(struct user_namespace *mnt_userns, struct inode *old_dir,
 			struct dentry *old_dentry, struct inode *new_dir,
 			struct dentry *new_dentry, unsigned int flags)
 {
-	if (flags & ~RENAME_NOREPLACE)
+	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
 		return -EINVAL;
 
+	if (flags & RENAME_EXCHANGE) {
+		return vfat_rename_exchange(old_dir, old_dentry,
+					    new_dir, new_dentry);
+	}
+
 	/* VFS already handled RENAME_NOREPLACE, handle it as a normal rename */
 	return vfat_rename(old_dir, old_dentry, new_dir, new_dentry);
 }
_

Patches currently in -mm which might be from javierm@redhat.com are


