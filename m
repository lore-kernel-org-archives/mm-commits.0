Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21415C4167B
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:14:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BB41610CE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:14:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347275AbhIBVPw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:15:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347282AbhIBVPu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:15:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0A7061051;
        Thu,  2 Sep 2021 21:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630617291;
        bh=/O1Dd7HIquWDgfZKV6l8Vz2LMrn23E1S7ZH7peM1UXU=;
        h=Date:From:To:Subject:From;
        b=wzojgvG2CQaJV06AAMrbhlit5W25OzBJsdCiZmI7upUnzOAM7LkoeaCY4CJNQL8vs
         wTsawXmUON22IUWe3eRVOXGmV8TQWhJxfSnQNWSYSP7BES/7+LQAovLt4ONEtw5XRo
         2XZBwy0jeRmg9WbpLj+ijJs+VtYmfxU3dZSx+8cg=
Date:   Thu, 02 Sep 2021 14:14:51 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, npiggin@gmail.com, sfr@canb.auug.org.au
Subject:  [folded-merged]
 lazy-tlb-introduce-lazy-mm-refcount-helper-functions-fix.patch removed from
 -mm tree
Message-ID: <20210902211451.FISHEASOT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lazy-tlb-introduce-lazy-mm-refcount-helper-functions-fix
has been removed from the -mm tree.  Its filename was
     lazy-tlb-introduce-lazy-mm-refcount-helper-functions-fix.patch

This patch was dropped because it was folded into lazy-tlb-introduce-lazy-mm-refcount-helper-functions.patch

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: lazy-tlb-introduce-lazy-mm-refcount-helper-functions-fix

Fix a refcounting bug in kthread_use_mm (the mm reference is increased
unconditionally now, but the lazy tlb refcount is still only dropped only
if mm != active_mm).

Link: https://lkml.kernel.org/r/1623125298.bx63h3mopj.astroid@bobo.none
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/kernel/kthread.c~lazy-tlb-introduce-lazy-mm-refcount-helper-functions-fix
+++ a/kernel/kthread.c
@@ -1350,6 +1350,11 @@ void kthread_use_mm(struct mm_struct *mm
 	WARN_ON_ONCE(!(tsk->flags & PF_KTHREAD));
 	WARN_ON_ONCE(tsk->mm);
 
+	/*
+	 * It's possible that tsk->active_mm == mm here, but we must
+	 * still mmgrab(mm) and mmdrop_lazy_tlb(active_mm), because lazy
+	 * mm may not have its own refcount (see mmgrab/drop_lazy_tlb()).
+	 */
 	mmgrab(mm);
 
 	task_lock(tsk);
@@ -1374,12 +1379,9 @@ void kthread_use_mm(struct mm_struct *mm
 	 * memory barrier after storing to tsk->mm, before accessing
 	 * user-space memory. A full memory barrier for membarrier
 	 * {PRIVATE,GLOBAL}_EXPEDITED is implicitly provided by
-	 * mmdrop(), or explicitly with smp_mb().
+	 * mmdrop_lazy_tlb().
 	 */
-	if (active_mm != mm)
-		mmdrop_lazy_tlb(active_mm);
-	else
-		smp_mb();
+	mmdrop_lazy_tlb(active_mm);
 
 	to_kthread(tsk)->oldfs = force_uaccess_begin();
 }
_

Patches currently in -mm which might be from npiggin@gmail.com are

lazy-tlb-introduce-lazy-mm-refcount-helper-functions.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix-2.patch
lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-option.patch
lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-option-fix.patch
powerpc-64s-enable-mmu_lazy_tlb_shootdown.patch
fs-epoll-use-a-per-cpu-counter-for-users-watches-count.patch

