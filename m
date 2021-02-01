Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 582A7C433E6
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 19:22:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EE0A64EA5
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 19:22:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhBATWQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 1 Feb 2021 14:22:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:44860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231797AbhBATWN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Feb 2021 14:22:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EC4F64E8D;
        Mon,  1 Feb 2021 19:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612207293;
        bh=6NuqKtIlQ+S8GSgbLZ8Q5hP2ViJxj48dpNzT6skuKNY=;
        h=Date:From:To:Subject:From;
        b=w+hmqN2bYXCYXh8f6EwjFlpEJ5sWVbxQCA7Ap8Y/zmUsBpNbAGuWMrpE4SYY1uFp2
         tpUnocN0ATjzXT3mhHFKitb6GbsordNDw+KlsYP6ayNLHxUOFSGbevOr79TdsEDocH
         fKfp7OqTCQFtAgoDKL/KxGyVf9SbMsleevkA9LGQ=
Date:   Mon, 01 Feb 2021 11:21:32 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20210201192132.I1iEbq1xs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c |    3 ---
 fs/ecryptfs/inode.c                                  |    4 ----
 net/switchdev/switchdev.c                            |    9 ---------
 3 files changed, 16 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -447,8 +447,6 @@ int mlx5e_ethtool_set_channels(struct ml
 		goto out;
 	}
 
-<<<<<<< HEAD
-=======
 	/* Don't allow changing the number of channels if HTB offload is active,
 	 * because the numeration of the QoS SQs will change, while per-queue
 	 * qdiscs are attached.
@@ -460,7 +458,6 @@ int mlx5e_ethtool_set_channels(struct ml
 		goto out;
 	}
 
->>>>>>> linux-next/akpm-base
 	new_channels.params = *cur_params;
 	new_channels.params.num_channels = count;
 
--- a/fs/ecryptfs/inode.c~linux-next-git-rejects
+++ a/fs/ecryptfs/inode.c
@@ -1046,11 +1046,7 @@ ecryptfs_setxattr(struct dentry *dentry,
 		goto out;
 	}
 	inode_lock(lower_inode);
-<<<<<<< HEAD
-	rc = __vfs_setxattr_locked(lower_dentry, name, value, size, flags, NULL);
-=======
 	rc = __vfs_setxattr_locked(&init_user_ns, lower_dentry, name, value, size, flags, NULL);
->>>>>>> linux-next/akpm-base
 	inode_unlock(lower_inode);
 	if (!rc && inode)
 		fsstack_copy_attr_all(inode, lower_inode);
--- a/net/switchdev/switchdev.c~linux-next-git-rejects
+++ a/net/switchdev/switchdev.c
@@ -388,12 +388,7 @@ static int __switchdev_handle_port_obj_a
 	extack = switchdev_notifier_info_to_extack(&port_obj_info->info);
 
 	if (check_cb(dev)) {
-<<<<<<< HEAD
-		err = add_cb(dev, port_obj_info->obj, port_obj_info->trans,
-			     extack);
-=======
 		err = add_cb(dev, port_obj_info->obj, extack);
->>>>>>> linux-next/akpm-base
 		if (err != -EOPNOTSUPP)
 			port_obj_info->handled = true;
 		return err;
@@ -500,11 +495,7 @@ static int __switchdev_handle_port_attr_
 	int err = -EOPNOTSUPP;
 
 	if (check_cb(dev)) {
-<<<<<<< HEAD
-		err = set_cb(dev, port_attr_info->attr, port_attr_info->trans);
-=======
 		err = set_cb(dev, port_attr_info->attr);
->>>>>>> linux-next/akpm-base
 		if (err != -EOPNOTSUPP)
 			port_attr_info->handled = true;
 		return err;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fix.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch
mm-memcg-add-swapcache-stat-for-memcg-v2-fix.patch
kasan-add-match-all-tag-tests-fix-fix.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
bdi-use-might_alloc-fix.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
lib-stackdepot-add-support-to-disable-stack-depot-fix.patch
initramfs-panic-with-memory-information-fix.patch
linux-next-rejects.patch
fs-ramfs-inodec-update-inode_operationstmpfile.patch
kernel-forkc-export-kernel_thread-to-modules.patch

