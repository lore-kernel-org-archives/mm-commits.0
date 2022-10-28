Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EA54FA3740
	for <mm-commits@archiver.kernel.org>; Fri, 28 Oct 2022 21:08:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiJ1VIK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Oct 2022 17:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiJ1VHi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2022 17:07:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52329249D37
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 14:07:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1072BB82C97
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 21:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0201C433C1;
        Fri, 28 Oct 2022 21:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666991254;
        bh=0kFFGwVXu3kw8maIPYvOOH3gBq5qb9CK+HbxjHy3OUE=;
        h=Date:To:From:Subject:From;
        b=g1Q+GZRhJjVBUXkzni+jVUCpdvhw/rFDpLJ8UPbHaKcgdUQyX0GEUtopLcDnYBACN
         BKCZDaCXBhilwwe7UY0VfJvnUnWeHB5hSPs/6ExSw2bH59C/kCYbuphDuLJePgOxAq
         rKQUq5VSn78hfRuTncg2SsbXdZJTSgPhXsTq1Pjw=
Date:   Fri, 28 Oct 2022 14:07:33 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        viro@zeniv.linux.org.uk, tglx@linutronix.de, keescook@chromium.org,
        ebiederm@xmission.com, bigeasy@linutronix.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-multi-gen-lru-move-lru_gen_add_mm-out-of-irq-off-region.patch removed from -mm tree
Message-Id: <20221028210734.A0201C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: multi-gen LRU: move lru_gen_add_mm() out of IRQ-off region
has been removed from the -mm tree.  Its filename was
     mm-multi-gen-lru-move-lru_gen_add_mm-out-of-irq-off-region.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


