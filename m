Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EA87C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 00:27:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B947A61492
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 00:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbhA1A1F (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Jan 2021 19:27:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:56704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231782AbhA1AZP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Jan 2021 19:25:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C96E164DD4;
        Thu, 28 Jan 2021 00:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611793475;
        bh=d+Almr4opXn7OJ1/3wlvr+Dwz1M2L6jO97STLOx6K28=;
        h=Date:From:To:Subject:From;
        b=TmsywqbIZIf8hEmOfzFeEuMA/qCPV3X+lGyXMmcK1LARNssbQC1g+yyjX7ckV9KSo
         owwGTDbQWaFuh0+rUiTeIG6Up9RKzSiJUgzPMrlBLrGIfleuO4GsG3hycHvIK1SHWM
         E7kzMrYc74k5R+yBzLOTbKil6ijDnl8S3k/iedWc=
Date:   Wed, 27 Jan 2021 16:24:34 -0800
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        christian.brauner@ubuntu.com, mm-commits@vger.kernel.org
Subject:  + fs-ramfs-inodec-update-inode_operationstmpfile.patch
 added to -mm tree
Message-ID: <20210128002434.VFjN2L2X0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ramfs/inode.c: update inode_operations.tmpfile
has been added to the -mm tree.  Its filename is
     fs-ramfs-inodec-update-inode_operationstmpfile.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-ramfs-inodec-update-inode_operationstmpfile.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-ramfs-inodec-update-inode_operationstmpfile.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fix.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch
mm-memcg-add-swapcache-stat-for-memcg-v2-fix.patch
kasan-add-match-all-tag-tests-fix-fix.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
bdi-use-might_alloc-fix.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
initramfs-panic-with-memory-information-fix.patch
linux-next-rejects.patch
fs-ramfs-inodec-update-inode_operationstmpfile.patch
kernel-forkc-export-kernel_thread-to-modules.patch

