Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 612BEC47082
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 04:16:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39A6B6124B
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 04:16:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhFHER4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Jun 2021 00:17:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhFHER4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 8 Jun 2021 00:17:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CF0B60FE3;
        Tue,  8 Jun 2021 04:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623125748;
        bh=MQRgC1RBmFp8JZRIDNWNXQdOcKGDA4dw5J736ZfVt5w=;
        h=Date:From:To:Subject:From;
        b=OpvJPhWpmqHd0V9UFtZ7v6LjOliuyCrwnAAFyulcvRe8X8svsyHd5qsfxBDhbYMHa
         lJTz/pX1n2GgWMPlU7apUO8aZ7DZpIavRKALeetJ5SYtAIa5DVlVMdqRSiUh99jGpr
         OQiRcQ10C3NkF+HjR32nMlVgPypeT5QZI0zF26OE=
Date:   Mon, 07 Jun 2021 21:15:48 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, npiggin@gmail.com, sfr@canb.auug.org.au
Subject:  +
 lazy-tlb-introduce-lazy-mm-refcount-helper-functions-fix.patch added to -mm
 tree
Message-ID: <20210608041548.qp54AiPBy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lazy-tlb-introduce-lazy-mm-refcount-helper-functions-fix
has been added to the -mm tree.  Its filename is
     lazy-tlb-introduce-lazy-mm-refcount-helper-functions-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lazy-tlb-introduce-lazy-mm-refcount-helper-functions-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lazy-tlb-introduce-lazy-mm-refcount-helper-functions-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1314,6 +1314,11 @@ void kthread_use_mm(struct mm_struct *mm
 	WARN_ON_ONCE(!(tsk->flags & PF_KTHREAD));
 	WARN_ON_ONCE(tsk->mm);
 
+	/*
+	 * It's possible that tsk->active_mm == mm here, but we must
+	 * still mmgrab(mm) and mmdrop_lazy_tlb(active_mm), because lazy
+	 * mm may not have its own refcount (see mmgrab/drop_lazy_tlb()).
+	 */
 	mmgrab(mm);
 
 	task_lock(tsk);
@@ -1338,12 +1343,9 @@ void kthread_use_mm(struct mm_struct *mm
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
lazy-tlb-introduce-lazy-mm-refcount-helper-functions-fix.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable.patch
lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-option.patch
powerpc-64s-enable-mmu_lazy_tlb_shootdown.patch

