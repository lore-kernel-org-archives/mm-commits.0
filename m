Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 191FAC001B0
	for <mm-commits@archiver.kernel.org>; Thu, 13 Jul 2023 17:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjGMRLg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Jul 2023 13:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbjGMRLf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2023 13:11:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E23D110
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 10:11:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C02C761AFB
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 17:11:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2453BC433C8;
        Thu, 13 Jul 2023 17:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689268293;
        bh=e1LNdlO80F5EBrOzq0m+YQUz+mLbBUMJxLN8Lm399kg=;
        h=Date:To:From:Subject:From;
        b=YYYPlih4LHsYpIo8/RrjFjR8CDAHa8LzM9BnpG5Celofmob2qOwd1aHY37jEJOdVO
         UXkiimKv96/nmmNMwmUvxab+mVmIQQIz/g3vKDaiIYMqj8gfkv3YThrogyKY/20dh9
         DJEIR1Sq+rbpVoFbBzgOvtlP7IHZcszBR0hstyYg=
Date:   Thu, 13 Jul 2023 10:11:32 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
        hughd@google.com, djwong@kernel.org, cmaiolino@redhat.com,
        brauner@kernel.org, lczerner@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-make-shmem_inode_acct_block-return-error.patch added to mm-unstable branch
Message-Id: <20230713171133.2453BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: make shmem_inode_acct_block() return error
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-make-shmem_inode_acct_block-return-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-make-shmem_inode_acct_block-return-error.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Lukas Czerner <lczerner@redhat.com>
Subject: shmem: make shmem_inode_acct_block() return error
Date: Thu, 13 Jul 2023 15:48:43 +0200

Patch series "shmem: Add user and group quota support for tmpfs", v4.

People have been asking for quota support in tmpfs many times in the past
mostly to avoid one malicious user, or misbehaving user/program to consume
all of the system memory.  This has been partially solved with the size
mount option, but some problems still prevail.

One of the problems is the fact that /dev/shm is still generally
unprotected with this and another is administration overhead of managing
multiple tmpfs mounts and lack of more fine grained control.

Quota support can solve all these problems in a somewhat standard way
people are already familiar with from regular file systems.  It can give
us more fine grained control over how much memory user/groups can consume.
Additionally it can also control number of inodes and with special quota
mount options introduced with a second patch we can set global limits
allowing us to replace the size mount option with quota entirely.

Currently the standard userspace quota tools (quota, xfs_quota) are only
using quotactl ioctl which is expecting a block device.  I patched quota
[1] and xfs_quota [2] to use quotactl_fd in case we want to run the tools
on mount point directory to work nicely with tmpfs.

The implementation was tested on patched version of xfstests [3].

[1] https://github.com/lczerner/quota/tree/quotactl_fd_support
[2] https://github.com/lczerner/xfsprogs/tree/quotactl_fd_support
[3] https://github.com/lczerner/xfstests/tree/tmpfs_quota_support


This patch (of 6):

Make shmem_inode_acct_block() return proper error code instead of bool. 
This will be useful later when we introduce quota support.

There should be no functional change.

Link: https://lkml.kernel.org/r/20230713134848.249779-1-cem@kernel.org
Link: https://lkml.kernel.org/r/20230713134848.249779-2-cem@kernel.org
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/mm/shmem.c~shmem-make-shmem_inode_acct_block-return-error
+++ a/mm/shmem.c
@@ -199,13 +199,14 @@ static inline void shmem_unacct_blocks(u
 		vm_unacct_memory(pages * VM_ACCT(PAGE_SIZE));
 }
 
-static inline bool shmem_inode_acct_block(struct inode *inode, long pages)
+static inline int shmem_inode_acct_block(struct inode *inode, long pages)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
+	int err = -ENOSPC;
 
 	if (shmem_acct_block(info->flags, pages))
-		return false;
+		return err;
 
 	if (sbinfo->max_blocks) {
 		if (percpu_counter_compare(&sbinfo->used_blocks,
@@ -214,11 +215,11 @@ static inline bool shmem_inode_acct_bloc
 		percpu_counter_add(&sbinfo->used_blocks, pages);
 	}
 
-	return true;
+	return 0;
 
 unacct:
 	shmem_unacct_blocks(info->flags, pages);
-	return false;
+	return err;
 }
 
 static inline void shmem_inode_unacct_blocks(struct inode *inode, long pages)
@@ -370,7 +371,7 @@ bool shmem_charge(struct inode *inode, l
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	unsigned long flags;
 
-	if (!shmem_inode_acct_block(inode, pages))
+	if (shmem_inode_acct_block(inode, pages))
 		return false;
 
 	/* nrpages adjustment first, then shmem_recalc_inode() when balanced */
@@ -1605,13 +1606,14 @@ static struct folio *shmem_alloc_and_acc
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct folio *folio;
 	int nr;
-	int err = -ENOSPC;
+	int err;
 
 	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
 		huge = false;
 	nr = huge ? HPAGE_PMD_NR : 1;
 
-	if (!shmem_inode_acct_block(inode, nr))
+	err = shmem_inode_acct_block(inode, nr);
+	if (err)
 		goto failed;
 
 	if (huge)
@@ -2462,7 +2464,7 @@ int shmem_mfill_atomic_pte(pmd_t *dst_pm
 	int ret;
 	pgoff_t max_off;
 
-	if (!shmem_inode_acct_block(inode, 1)) {
+	if (shmem_inode_acct_block(inode, 1)) {
 		/*
 		 * We may have got a page, returned -ENOENT triggering a retry,
 		 * and now we find ourselves with -ENOMEM. Release the page, to
_

Patches currently in -mm which might be from lczerner@redhat.com are

shmem-make-shmem_inode_acct_block-return-error.patch
add-default-quota-limit-mount-options.patch

