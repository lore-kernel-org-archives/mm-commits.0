Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09175C2B9F4
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 02:46:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E472E61166
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 02:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbhFOCsh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Jun 2021 22:48:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230040AbhFOCsg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Jun 2021 22:48:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98C9A613CC;
        Tue, 15 Jun 2021 02:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623724729;
        bh=NqjiLxHRp5PzUlPy8qGIx8/99hjIS4geWAZrKllpza8=;
        h=Date:From:To:Subject:From;
        b=kEkDDaB9q7yqJaCOhXJztZFgEiYa5k9+d5P925qCYZIj78oDMt5aG9qABUPoiPCez
         yL1dBf2C+NX3e2KXdC5MskumBQ0Cdc+FXQNaqfao/9seUPWi3SE7UVrljX0K7Z0Q+7
         fB3uqi+VURcMp2CoVfrHF1PjhzbeguxyDXBKOtKA=
Date:   Mon, 14 Jun 2021 19:38:49 -0700
From:   akpm@linux-foundation.org
To:     anton@ozlabs.org, benh@kernel.crashing.org, luto@kernel.org,
        mm-commits@vger.kernel.org, npiggin@gmail.com, paulus@ozlabs.org,
        rdunlap@infradead.org
Subject:  +
 lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix-2.patch added
 to -mm tree
Message-ID: <20210615023849.40X36g6UE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix-2
has been added to the -mm tree.  Its filename is
     lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix-2.patch

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
@@ -419,6 +419,16 @@ config ARCH_WANT_IRQS_OFF_ACTIVATE_MM
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
lazy-tlb-introduce-lazy-mm-refcount-helper-functions-fix.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix-2.patch
lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-option.patch
lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-option-fix.patch
powerpc-64s-enable-mmu_lazy_tlb_shootdown.patch

