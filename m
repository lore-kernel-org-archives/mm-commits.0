Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 599ABC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4397F6108E
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347450AbhIBVQa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:16:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347511AbhIBVQ3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:16:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7A4660FDA;
        Thu,  2 Sep 2021 21:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630617330;
        bh=BG5qgapEkLVW0Ox9ID/gZUtzivBIj8xYMKwJ0xaP9FQ=;
        h=Date:From:To:Subject:From;
        b=lKkcnaRPxu0YKdpxUOm4G3h6FUZHFsee+gYQ8aK2dXhgxkmCRZfEp2+nYWLcUfq0w
         vHlfSIcCpVDk3cmjPe7FF//cFFD8BO9cqU8GdDr1/fEj5aRCdAstUqI6ZA3+8ONlK8
         bBl9NHdFvTmUmMMPIFgrXumwRPcgdWgNouAeSGQs=
Date:   Thu, 02 Sep 2021 14:15:30 -0700
From:   akpm@linux-foundation.org
To:     anton@ozlabs.org, benh@kernel.crashing.org, luto@kernel.org,
        mm-commits@vger.kernel.org, npiggin@gmail.com, paulus@ozlabs.org,
        rdunlap@infradead.org
Subject:  [folded-merged]
 lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix-2.patch
 removed from -mm tree
Message-ID: <20210902211530.P8saRTGC-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix-2
has been removed from the -mm tree.  Its filename was
     lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix-2.patch

This patch was dropped because it was folded into lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable.patch

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix-2

Explain the requirements for lazy tlb mm refcounting in the comment,
to help with archs that may want to disable this by some means other
than MMU_LAZY_TLB_SHOOTDOWN.

Link: https://lkml.kernel.org/r/1623121605.j47gdpccep.astroid@bobo.none
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Cc: Anton Blanchard <anton@ozlabs.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/Kconfig~lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix-2
+++ a/arch/Kconfig
@@ -426,6 +426,16 @@ config ARCH_WANT_IRQS_OFF_ACTIVATE_MM
 	  shootdowns should enable this.
 
 # Use normal mm refcounting for MMU_LAZY_TLB kernel thread references.
+# MMU_LAZY_TLB_REFCOUNT=n can improve the scalability of context switching
+# to/from kernel threads when the same mm is running on a lot of CPUs (a large
+# multi-threaded application), by reducing contention on the mm refcount.
+#
+# This can be disabled if the architecture ensures no CPUs are using an mm as a
+# "lazy tlb" beyond its final refcount (i.e., by the time __mmdrop frees the mm
+# or its kernel page tables). This could be arranged by arch_exit_mmap(), or
+# final exit(2) TLB flush, for example. arch code must also ensure the
+# _lazy_tlb variants of mmgrab/mmdrop are used when dropping the lazy reference
+# to a kthread ->active_mm (non-arch code has been converted already).
 config MMU_LAZY_TLB_REFCOUNT
 	def_bool y
 
_

Patches currently in -mm which might be from npiggin@gmail.com are

lazy-tlb-introduce-lazy-mm-refcount-helper-functions.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable.patch
lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-option.patch
lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-option-fix.patch
powerpc-64s-enable-mmu_lazy_tlb_shootdown.patch
fs-epoll-use-a-per-cpu-counter-for-users-watches-count.patch

