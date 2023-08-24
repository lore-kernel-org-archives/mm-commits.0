Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D703FC727BC
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244046AbjHXXWe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244104AbjHXXWC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:22:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6FBA1
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:22:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BF8763676
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61750C433C7;
        Thu, 24 Aug 2023 23:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919319;
        bh=xQabXLH9A+1AFTpAsf1U8HtMLABtZReRqu4PyP++jDw=;
        h=Date:To:From:Subject:From;
        b=kQzq/y5lHuKI2EMCLr0GgVmwDturB4F3tgfEKtc3BJ0hOA1SotVbrr9tsyFukCl9q
         6DIRwjSeHvf5FvuBYuhcb1sl/mRgI1ZcujRgaUnkMS5vvCiLzZReTJmMmlJC5qi0LB
         XaG+A9SnMF+rcVr98jgqebCaqFVwcNi8i2EpAKdw=
Date:   Thu, 24 Aug 2023 16:21:58 -0700
To:     mm-commits@vger.kernel.org, jannh@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-userfaultfd-remove-stale-comment-about-core-dump-locking.patch removed from -mm tree
Message-Id: <20230824232159.61750C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: userfaultfd: remove stale comment about core dump locking
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-remove-stale-comment-about-core-dump-locking.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: mm: userfaultfd: remove stale comment about core dump locking
Date: Tue, 15 Aug 2023 23:22:16 +0200

Since commit 7f3bfab52cab ("mm/gup: take mmap_lock in get_dump_page()"),
which landed in v5.10, core dumping doesn't enter fault handling without
holding the mmap_lock anymore.  Remove the stale parts of the comments,
but leave the behavior as-is - letting core dumping block on userfault
handling would be a bad idea and could lead to deadlocks if the dumping
process was handling its own userfaults.

Link: https://lkml.kernel.org/r/20230815212216.264445-1-jannh@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/fs/userfaultfd.c~mm-userfaultfd-remove-stale-comment-about-core-dump-locking
+++ a/fs/userfaultfd.c
@@ -428,15 +428,11 @@ vm_fault_t handle_userfault(struct vm_fa
 	 * FOLL_DUMP case, anon memory also checks for FOLL_DUMP with
 	 * the no_page_table() helper in follow_page_mask(), but the
 	 * shmem_vm_ops->fault method is invoked even during
-	 * coredumping without mmap_lock and it ends up here.
+	 * coredumping and it ends up here.
 	 */
 	if (current->flags & (PF_EXITING|PF_DUMPCORE))
 		goto out;
 
-	/*
-	 * Coredumping runs without mmap_lock so we can only check that
-	 * the mmap_lock is held, if PF_DUMPCORE was not set.
-	 */
 	assert_fault_locked(vmf);
 
 	ctx = vma->vm_userfaultfd_ctx.ctx;
_

Patches currently in -mm which might be from jannh@google.com are


