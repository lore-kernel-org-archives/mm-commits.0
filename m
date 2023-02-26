Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5DD5C64ED6
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 22:13:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjBZWNj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Feb 2023 17:13:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjBZWNh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Feb 2023 17:13:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D98D323
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 14:13:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECA97B80C83
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 22:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FAC5C433D2;
        Sun, 26 Feb 2023 22:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677449613;
        bh=8y9FkJbFM/uoG1GF0PRnmyCC7JJ6gCRASyNyk/TkH0E=;
        h=Date:To:From:Subject:From;
        b=sCtmzi/sQpIUTOIYmt9ff0ZtdxsWNQYskv30KNsRTEghwJ69CIr9EjpGKBWeOoK8l
         65L2B9OAOhKVeUM2TGAwp4+rL37n3g8EZKe0FYosZUPAlQnV+vZErMLXfG8gMXZ7gm
         bwPKjh+9XQ6XT8Cb4bvZdg9iEIVIbzLqS4WH6EV8=
Date:   Sun, 26 Feb 2023 14:13:33 -0800
To:     mm-commits@vger.kernel.org, will@kernel.org,
        torvalds@linux-foundation.org, riel@redhat.com,
        peterz@infradead.org, nadav.amit@gmail.com, mpe@ellerman.id.au,
        luto@kernel.org, dave.hansen@linux.intel.com,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        npiggin@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable.patch added to mm-unstable branch
Message-Id: <20230226221333.9FAC5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lazy tlb: allow lazy tlb mm refcounting to be configurable
has been added to the -mm mm-unstable branch.  Its filename is
     lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable.patch

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
From: Nicholas Piggin <npiggin@gmail.com>
Subject: lazy tlb: allow lazy tlb mm refcounting to be configurable
Date: Fri, 3 Feb 2023 17:18:35 +1000

Add CONFIG_MMU_TLB_REFCOUNT which enables refcounting of the lazy tlb mm
when it is context switched.  This can be disabled by architectures that
don't require this refcounting if they clean up lazy tlb mms when the last
refcount is dropped.  Currently this is always enabled, so the patch
introduces no functional change.

Link: https://lkml.kernel.org/r/20230203071837.1136453-4-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff --git a/arch/Kconfig~lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable b/arch/Kconfig
--- a/arch/Kconfig~lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable
+++ b/arch/Kconfig
@@ -465,6 +465,23 @@ config ARCH_WANT_IRQS_OFF_ACTIVATE_MM
 	  irqs disabled over activate_mm. Architectures that do IPI based TLB
 	  shootdowns should enable this.
 
+# Use normal mm refcounting for MMU_LAZY_TLB kernel thread references.
+# MMU_LAZY_TLB_REFCOUNT=n can improve the scalability of context switching
+# to/from kernel threads when the same mm is running on a lot of CPUs (a large
+# multi-threaded application), by reducing contention on the mm refcount.
+#
+# This can be disabled if the architecture ensures no CPUs are using an mm as a
+# "lazy tlb" beyond its final refcount (i.e., by the time __mmdrop frees the mm
+# or its kernel page tables). This could be arranged by arch_exit_mmap(), or
+# final exit(2) TLB flush, for example.
+#
+# To implement this, an arch *must*:
+# Ensure the _lazy_tlb variants of mmgrab/mmdrop are used when manipulating
+# the lazy tlb reference of a kthread's ->active_mm (non-arch code has been
+# converted already).
+config MMU_LAZY_TLB_REFCOUNT
+	def_bool y
+
 config ARCH_HAVE_NMI_SAFE_CMPXCHG
 	bool
 
diff --git a/Documentation/mm/active_mm.rst~lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable b/Documentation/mm/active_mm.rst
--- a/Documentation/mm/active_mm.rst~lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable
+++ b/Documentation/mm/active_mm.rst
@@ -2,6 +2,12 @@
 Active MM
 =========
 
+Note, the mm_count refcount may no longer include the "lazy" users
+(running tasks with ->active_mm == mm && ->mm == NULL) on kernels
+with CONFIG_MMU_LAZY_TLB_REFCOUNT=n. Taking and releasing these lazy
+references must be done with mmgrab_lazy_tlb() and mmdrop_lazy_tlb()
+helpers, which abstract this config option.
+
 ::
 
  List:       linux-kernel
diff --git a/include/linux/sched/mm.h~lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable b/include/linux/sched/mm.h
--- a/include/linux/sched/mm.h~lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable
+++ b/include/linux/sched/mm.h
@@ -82,17 +82,29 @@ static inline void mmdrop_sched(struct mm_struct *mm)
 /* Helpers for lazy TLB mm refcounting */
 static inline void mmgrab_lazy_tlb(struct mm_struct *mm)
 {
-	mmgrab(mm);
+	if (IS_ENABLED(CONFIG_MMU_LAZY_TLB_REFCOUNT))
+		mmgrab(mm);
 }
 
 static inline void mmdrop_lazy_tlb(struct mm_struct *mm)
 {
-	mmdrop(mm);
+	if (IS_ENABLED(CONFIG_MMU_LAZY_TLB_REFCOUNT)) {
+		mmdrop(mm);
+	} else {
+		/*
+		 * mmdrop_lazy_tlb must provide a full memory barrier, see the
+		 * membarrier comment finish_task_switch which relies on this.
+		 */
+		smp_mb();
+	}
 }
 
 static inline void mmdrop_lazy_tlb_sched(struct mm_struct *mm)
 {
-	mmdrop_sched(mm);
+	if (IS_ENABLED(CONFIG_MMU_LAZY_TLB_REFCOUNT))
+		mmdrop_sched(mm);
+	else
+		smp_mb(); /* see mmdrop_lazy_tlb() above */
 }
 
 /**
_

Patches currently in -mm which might be from npiggin@gmail.com are

kthread-simplify-kthread_use_mm-refcounting.patch
lazy-tlb-introduce-lazy-tlb-mm-refcount-helper-functions.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable.patch
lazy-tlb-shoot-lazies-non-refcounting-lazy-tlb-mm-reference-handling-scheme.patch
powerpc-64s-enable-mmu_lazy_tlb_shootdown.patch

