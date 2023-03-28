Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB122C76196
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:21:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjC1XV0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjC1XVM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:21:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FBD1708
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16AEDB81EEC
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1C7C433D2;
        Tue, 28 Mar 2023 23:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045667;
        bh=VvWI0KrHW0INOI+lmrUTTuCzUT5OqjFXwgsev5n38ss=;
        h=Date:To:From:Subject:From;
        b=B0EANEpE8bKQW+7zp8BmHOgHhzor8ZywAL7fIL0e8xjDaYH8vsaH6Zt6KpiKvjPY/
         V3yOTwHdZuV/u23tG0QtjeD6Q4YMsOGwGCgggyXGGmBZ8blw/LCyZt9OFAdh1T8uV/
         1ZaBggdCfXyycfjH1QiBax6hLfABswdLcPqBlJ+Y=
Date:   Tue, 28 Mar 2023 16:21:07 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        torvalds@linux-foundation.org, riel@redhat.com,
        peterz@infradead.org, nadav.amit@gmail.com, mpe@ellerman.id.au,
        luto@kernel.org, dave.hansen@linux.intel.com,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        npiggin@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable.patch removed from -mm tree
Message-Id: <20230328232107.CA1C7C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lazy tlb: allow lazy tlb mm refcounting to be configurable
has been removed from the -mm tree.  Its filename was
     lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 Documentation/mm/active_mm.rst |    6 ++++++
 arch/Kconfig                   |   17 +++++++++++++++++
 include/linux/sched/mm.h       |   18 +++++++++++++++---
 3 files changed, 38 insertions(+), 3 deletions(-)

--- a/arch/Kconfig~lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable
+++ a/arch/Kconfig
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
 
--- a/Documentation/mm/active_mm.rst~lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable
+++ a/Documentation/mm/active_mm.rst
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
--- a/include/linux/sched/mm.h~lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable
+++ a/include/linux/sched/mm.h
@@ -82,17 +82,29 @@ static inline void mmdrop_sched(struct m
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


