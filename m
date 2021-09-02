Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BDADC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:16:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BA8A61074
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346827AbhIBVRZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:17:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347474AbhIBVRV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:17:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FF2360FDA;
        Thu,  2 Sep 2021 21:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630617382;
        bh=WMmBJg9JoxcUswjrXz2plZuKpKjcbisoPhYEpY0s0DQ=;
        h=Date:From:To:Subject:From;
        b=RG6HD55uAOa8ZkUCzJge6REFShSvLrs5s6PU+6wHno2YV7I1JZA9YtMgHSmz5mMED
         V8pCH3Lx2fQ4C5I8OhwRH2QSvAToGj0TSWiFGnlQ+Cxk2p6xTTmVLNXGGhie6IQYPz
         h29b9e5qS30Q+SjqUDp79GmCays/9Fok2whwgzOU=
Date:   Thu, 02 Sep 2021 14:16:21 -0700
From:   akpm@linux-foundation.org
To:     anton@ozlabs.org, benh@kernel.crashing.org, luto@kernel.org,
        mm-commits@vger.kernel.org, npiggin@gmail.com, paulus@ozlabs.org,
        rdunlap@infradead.org
Subject:  [folded-merged]
 lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-option-fix.patch removed
 from -mm tree
Message-ID: <20210902211621.idGecAz-n%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-option-fix
has been removed from the -mm tree.  Its filename was
     lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-option-fix.patch

This patch was dropped because it was folded into lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-option.patch

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-option-fix

Update the comment to be clearer, and account for the improvement
to MMU_LAZY_TLB_REFCOUNT comment.

Link: https://lkml.kernel.org/r/1623121901.mszkmmum0n.astroid@bobo.none
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Cc: Anton Blanchard <anton@ozlabs.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/arch/Kconfig~lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-option-fix
+++ a/arch/Kconfig
@@ -440,15 +440,16 @@ config MMU_LAZY_TLB_REFCOUNT
 	def_bool y
 	depends on !MMU_LAZY_TLB_SHOOTDOWN
 
-# Instead of refcounting the lazy mm struct for kernel thread references
-# (which can cause contention with multi-threaded apps on large multiprocessor
-# systems), this option causes __mmdrop to IPI all CPUs in the mm_cpumask and
-# switch to init_mm if they were using the to-be-freed mm as the lazy tlb. To
-# implement this, architectures must use _lazy_tlb variants of mm refcounting
-# when releasing kernel thread mm references, and mm_cpumask must include at
-# least all possible CPUs in which the mm might be lazy, at the time of the
-# final mmdrop. mmgrab/mmdrop in arch/ code must be switched to _lazy_tlb
-# postfix as necessary.
+# This option allows MMU_LAZY_TLB_REFCOUNT=n. It ensures no CPUs are using an
+# mm as a lazy tlb beyond its last reference count, by shooting down these
+# users before the mm is deallocated. __mmdrop() first IPIs all CPUs that may
+# be using the mm as a lazy tlb, so that they may switch themselves to using
+# init_mm for their active mm. mm_cpumask(mm) is used to determine which CPUs
+# may be using mm as a lazy tlb mm.
+#
+# To implement this, an arch must ensure mm_cpumask(mm) contains at least all
+# possible CPUs in which the mm is lazy, and it must meet the requirements for
+# MMU_LAZY_TLB_REFCOUNT=n (see above).
 config MMU_LAZY_TLB_SHOOTDOWN
 	bool
 
_

Patches currently in -mm which might be from npiggin@gmail.com are

lazy-tlb-introduce-lazy-mm-refcount-helper-functions.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable.patch
lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-option.patch
powerpc-64s-enable-mmu_lazy_tlb_shootdown.patch
fs-epoll-use-a-per-cpu-counter-for-users-watches-count.patch

