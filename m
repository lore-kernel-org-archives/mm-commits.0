Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3241AC433E0
	for <mm-commits@archiver.kernel.org>; Thu,  4 Feb 2021 23:56:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECAD564FA3
	for <mm-commits@archiver.kernel.org>; Thu,  4 Feb 2021 23:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbhBDX4k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 4 Feb 2021 18:56:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:50620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231366AbhBDX4f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Feb 2021 18:56:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14E0F64FA9;
        Thu,  4 Feb 2021 23:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612482954;
        bh=yIHhTnU/+nyJ9HGoxo/QJUNmeKMDNqoxcBNU9PZReJI=;
        h=Date:From:To:Subject:From;
        b=q9tcH5jr9STqvImmKgUokR8qQ2ZCwWFynVsNvKACaxCCiLPs6dfBL60ARC66r8tgR
         2byVdFSx5T+tZ8Eo6ooG8OorlA/vZFgPcNKzK+HGI14R1OFNMvuGH0feZUStq1kw1C
         eKXL0fQOD019EUVzF7vYGlo4A7Mn5aNYoz9/USjM=
Date:   Thu, 04 Feb 2021 15:55:53 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20210204235553.ozjSwTqhj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/overlayfs/copy_up.c |    4 ----
 fs/overlayfs/inode.c   |    4 ----
 2 files changed, 8 deletions(-)

--- a/fs/overlayfs/inode.c~linux-next-git-rejects
+++ a/fs/overlayfs/inode.c
@@ -355,11 +355,7 @@ int ovl_xattr_set(struct dentry *dentry,
 
 	if (!value && !upperdentry) {
 		old_cred = ovl_override_creds(dentry->d_sb);
-<<<<<<< HEAD
-		err = vfs_getxattr(realdentry, name, NULL, 0);
-=======
 		err = vfs_getxattr(&init_user_ns, realdentry, name, NULL, 0);
->>>>>>> linux-next/akpm-base
 		revert_creds(old_cred);
 		if (err < 0)
 			goto out_drop_write;
--- a/fs/overlayfs/copy_up.c~linux-next-git-rejects
+++ a/fs/overlayfs/copy_up.c
@@ -115,11 +115,7 @@ retry:
 			goto retry;
 		}
 
-<<<<<<< HEAD
-		error = vfs_setxattr(new, name, value, size, 0);
-=======
 		error = vfs_setxattr(&init_user_ns, new, name, value, size, 0);
->>>>>>> linux-next/akpm-base
 		if (error) {
 			if (error != -EOPNOTSUPP || ovl_must_copy_xattr(name))
 				break;
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
linux-next-git-rejects.patch

