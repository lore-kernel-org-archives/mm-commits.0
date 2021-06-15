Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E64FC48BE6
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 02:46:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56831611CE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 02:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhFOCsh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Jun 2021 22:48:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230082AbhFOCsg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Jun 2021 22:48:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFB1561059;
        Tue, 15 Jun 2021 02:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623724689;
        bh=cZzJmvObAhdTzfDg5LPXi7+Kdk1+r8/S88FT/0IYqK4=;
        h=Date:From:To:Subject:From;
        b=Tu3QYotx8NH7DxWBwXWLOXgNKby71Ea4CgVhAaMt6paSdf4SvxnN5CTS8dahCGQ46
         LZqSLgCINPdQ8NxpcChuzkFdSu7aJG8WHjNzqMk8NJR7WS++DGzcVVlp483A4yPso2
         PA03R/ZEP4LzQXSPAdqCn2XmX998LeGFyv9bxypg=
Date:   Mon, 14 Jun 2021 19:38:09 -0700
From:   akpm@linux-foundation.org
To:     anton@ozlabs.org, benh@kernel.crashing.org, luto@kernel.org,
        mm-commits@vger.kernel.org, npiggin@gmail.com, paulus@ozlabs.org,
        rdunlap@infradead.org
Subject:  +
 lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-option-fix.patch added to
 -mm tree
Message-ID: <20210615023809.QWQEZlh6u%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-option-fix
has been added to the -mm tree.  Its filename is
     lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-option-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-option-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-option-fix.patch

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
@@ -423,15 +423,16 @@ config MMU_LAZY_TLB_REFCOUNT
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
lazy-tlb-introduce-lazy-mm-refcount-helper-functions-fix.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable.patch
lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-option.patch
lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-option-fix.patch
powerpc-64s-enable-mmu_lazy_tlb_shootdown.patch

