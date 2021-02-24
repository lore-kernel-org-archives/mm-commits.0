Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F539C433E6
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 19:10:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F083860202
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 19:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235160AbhBXTKP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 14:10:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:40250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235950AbhBXTJK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 14:09:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C46F464F0B;
        Wed, 24 Feb 2021 18:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614193021;
        bh=gP6m1fKrgO9Hd1uLqSiNXVnIZHdq1IMoXSDPQMECUsM=;
        h=Date:From:To:Subject:From;
        b=OFF5YacyBEe31f9SxlcjGZPJuzzTq2B2GkacAb0VwJLvi6Zja3UDvb53yK04EKCGj
         DIAdNCCoclgNdKxLUmqJ/n0MlCMCVlm9DYkzM20x/Y4Ztmrtt8x11TsGNcYy9VASQz
         NYpyDpU6qX39pKx+MwqycQDO7VL62qg0v7vpYBjo=
Date:   Wed, 24 Feb 2021 10:57:00 -0800
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        christian.brauner@ubuntu.com, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 fs-ramfs-inodec-update-inode_operationstmpfile.patch removed from -mm tree
Message-ID: <20210224185700.F235txReG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ramfs/inode.c: update inode_operations.tmpfile
has been removed from the -mm tree.  Its filename was
     fs-ramfs-inodec-update-inode_operationstmpfile.patch

This patch was dropped because it was folded into ramfs-support-o_tmpfile.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/ramfs/inode.c: update inode_operations.tmpfile

Update "ramfs: support O_TMPFILE" for 549c7297717c32ee ("fs: make helpers
idmap mount aware").

Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ramfs/inode.c~fs-ramfs-inodec-update-inode_operationstmpfile
+++ a/fs/ramfs/inode.c
@@ -151,7 +151,8 @@ static int ramfs_symlink(struct user_nam
 	return error;
 }
 
-static int ramfs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
+static int ramfs_tmpfile(struct user_namespace *mnt_userns,
+			 struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	struct inode *inode;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ramfs-support-o_tmpfile.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fix.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch
mm-memcg-add-swapcache-stat-for-memcg-v2-fix.patch
kasan-add-match-all-tag-tests-fix-fix.patch
mm.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-memory_hotplug-prevalidate-the-address-range-being-added-with-platform-fix.patch
bdi-use-might_alloc-fix.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
lib-stackdepot-add-support-to-disable-stack-depot-fix.patch
seq_file-document-how-per-entry-resources-are-managed-fix.patch
initramfs-panic-with-memory-information-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

