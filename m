Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 335B9FA3740
	for <mm-commits@archiver.kernel.org>; Thu, 27 Oct 2022 18:43:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234493AbiJ0Snc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Oct 2022 14:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235086AbiJ0Snb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2022 14:43:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83309C223
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 11:43:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FBC862443
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 18:43:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0EE3C433D6;
        Thu, 27 Oct 2022 18:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666896209;
        bh=vLOkbQ75xxJfUeX0tjXlu4IgLJn/BfskzDedRTjefgY=;
        h=Date:To:From:Subject:From;
        b=oSjVjO7Gw7LBFlpVNQryhuuwxxsE3WL/dH68djU+HCL28k/c0tizo8fpPyK134s+8
         EHGMSfn2rF6bTRkB6zRq3GHdWN18LgWPZ2fvYw+NQxhh5vtP5ErAEeIH3YH9QGnv/Z
         UBSG2y8svgM1pWm0k+nCcwCYsmjQmzZ23hnXhss8=
Date:   Thu, 27 Oct 2022 11:43:28 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        viro@zeniv.linux.org.uk, tglx@linutronix.de, keescook@chromium.org,
        ebiederm@xmission.com, bigeasy@linutronix.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-move-lru_gen_add_mm-out-of-irq-off-region.patch added to mm-hotfixes-unstable branch
Message-Id: <20221027184329.A0EE3C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: multi-gen LRU: move lru_gen_add_mm() out of IRQ-off region
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-multi-gen-lru-move-lru_gen_add_mm-out-of-irq-off-region.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-multi-gen-lru-move-lru_gen_add_mm-out-of-irq-off-region.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm: multi-gen LRU: move lru_gen_add_mm() out of IRQ-off region
Date: Wed, 26 Oct 2022 15:48:30 +0200

lru_gen_add_mm() has been added within an IRQ-off region in the commit
mentioned below.  The other invocations of lru_gen_add_mm() are not within
an IRQ-off region.

The invocation within IRQ-off region is problematic on PREEMPT_RT because
the function is using a spin_lock_t which must not be used within
IRQ-disabled regions.

The other invocations of lru_gen_add_mm() occur while
task_struct::alloc_lock is acquired.  Move lru_gen_add_mm() after
interrupts are enabled and before task_unlock().

Link: https://lkml.kernel.org/r/20221026134830.711887-1-bigeasy@linutronix.de
Fixes: bd74fdaea1460 ("mm: multi-gen LRU: support page table walks")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Yu Zhao <yuzhao@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/exec.c~mm-multi-gen-lru-move-lru_gen_add_mm-out-of-irq-off-region
+++ a/fs/exec.c
@@ -1012,7 +1012,6 @@ static int exec_mmap(struct mm_struct *m
 	active_mm = tsk->active_mm;
 	tsk->active_mm = mm;
 	tsk->mm = mm;
-	lru_gen_add_mm(mm);
 	/*
 	 * This prevents preemption while active_mm is being loaded and
 	 * it and mm are being updated, which could cause problems for
@@ -1025,6 +1024,7 @@ static int exec_mmap(struct mm_struct *m
 	activate_mm(active_mm, mm);
 	if (IS_ENABLED(CONFIG_ARCH_WANT_IRQS_OFF_ACTIVATE_MM))
 		local_irq_enable();
+	lru_gen_add_mm(mm);
 	task_unlock(tsk);
 	lru_gen_use_mm(mm);
 	if (old_mm) {
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

mm-multi-gen-lru-move-lru_gen_add_mm-out-of-irq-off-region.patch

