Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65A71EB64DD
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jul 2023 19:31:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbjGYTba (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jul 2023 15:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbjGYTb0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jul 2023 15:31:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD7BF1FF7
        for <mm-commits@vger.kernel.org>; Tue, 25 Jul 2023 12:31:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FC8961890
        for <mm-commits@vger.kernel.org>; Tue, 25 Jul 2023 19:31:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3DECC433C7;
        Tue, 25 Jul 2023 19:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690313484;
        bh=KMMwmbTiXGY0jojFfh6WKK16T73U++m9T48kebSTbqE=;
        h=Date:To:From:Subject:From;
        b=q+4oiomm2UuBDrUS07Wwp189ta+CJTFavoFKzzfdF6L4kDysazv2hIhWLU7en2Lam
         1Kenb7nR/RhTbi0OtfOMWDjIqhDKGk5l0QK8516UXT2bHNEV8QUh67ooHvQJ+7Nsm5
         CL1gcRYGfBKGv/QsweVbkJNIYTZuarmOUWMR/rt0=
Date:   Tue, 25 Jul 2023 12:31:24 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, osalvador@suse.de,
        npiggin@gmail.com, muchun.song@linux.dev, mpe@ellerman.id.au,
        mike.kravetz@oracle.com, joao.m.martins@oracle.com,
        dan.j.williams@intel.com, christophe.leroy@csgroup.eu,
        catalin.marinas@arm.com, aneesh.kumar@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-mm-trace-convert-trace-event-to-trace-event-class.patch added to mm-unstable branch
Message-Id: <20230725193124.B3DECC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm/trace: convert trace event to trace event class
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-mm-trace-convert-trace-event-to-trace-event-class.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-mm-trace-convert-trace-event-to-trace-event-class.patch

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
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: powerpc/mm/trace: convert trace event to trace event class
Date: Tue, 25 Jul 2023 00:37:54 +0530

A follow-up patch will add a pud variant for this same event.  Using event
class makes that addition simpler.

No functional change in this patch.

Link: https://lkml.kernel.org/r/20230724190759.483013-9-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/book3s64/hash_pgtable.c  |    2 -
 arch/powerpc/mm/book3s64/radix_pgtable.c |    2 -
 include/trace/events/thp.h               |   23 ++++++++++++++-------
 3 files changed, 18 insertions(+), 9 deletions(-)

--- a/arch/powerpc/mm/book3s64/hash_pgtable.c~powerpc-mm-trace-convert-trace-event-to-trace-event-class
+++ a/arch/powerpc/mm/book3s64/hash_pgtable.c
@@ -214,7 +214,7 @@ unsigned long hash__pmd_hugepage_update(
 
 	old = be64_to_cpu(old_be);
 
-	trace_hugepage_update(addr, old, clr, set);
+	trace_hugepage_update_pmd(addr, old, clr, set);
 	if (old & H_PAGE_HASHPTE)
 		hpte_do_hugepage_flush(mm, addr, pmdp, old);
 	return old;
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c~powerpc-mm-trace-convert-trace-event-to-trace-event-class
+++ a/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -962,7 +962,7 @@ unsigned long radix__pmd_hugepage_update
 #endif
 
 	old = radix__pte_update(mm, addr, pmdp_ptep(pmdp), clr, set, 1);
-	trace_hugepage_update(addr, old, clr, set);
+	trace_hugepage_update_pmd(addr, old, clr, set);
 
 	return old;
 }
--- a/include/trace/events/thp.h~powerpc-mm-trace-convert-trace-event-to-trace-event-class
+++ a/include/trace/events/thp.h
@@ -8,25 +8,29 @@
 #include <linux/types.h>
 #include <linux/tracepoint.h>
 
-TRACE_EVENT(hugepage_set_pmd,
+DECLARE_EVENT_CLASS(hugepage_set,
 
-	    TP_PROTO(unsigned long addr, unsigned long pmd),
-	    TP_ARGS(addr, pmd),
+	    TP_PROTO(unsigned long addr, unsigned long pte),
+	    TP_ARGS(addr, pte),
 	    TP_STRUCT__entry(
 		    __field(unsigned long, addr)
-		    __field(unsigned long, pmd)
+		    __field(unsigned long, pte)
 		    ),
 
 	    TP_fast_assign(
 		    __entry->addr = addr;
-		    __entry->pmd = pmd;
+		    __entry->pte = pte;
 		    ),
 
-	    TP_printk("Set pmd with 0x%lx with 0x%lx", __entry->addr, __entry->pmd)
+	    TP_printk("Set page table entry with 0x%lx with 0x%lx", __entry->addr, __entry->pte)
 );
 
+DEFINE_EVENT(hugepage_set, hugepage_set_pmd,
+	    TP_PROTO(unsigned long addr, unsigned long pmd),
+	    TP_ARGS(addr, pmd)
+);
 
-TRACE_EVENT(hugepage_update,
+DECLARE_EVENT_CLASS(hugepage_update,
 
 	    TP_PROTO(unsigned long addr, unsigned long pte, unsigned long clr, unsigned long set),
 	    TP_ARGS(addr, pte, clr, set),
@@ -48,6 +52,11 @@ TRACE_EVENT(hugepage_update,
 	    TP_printk("hugepage update at addr 0x%lx and pte = 0x%lx clr = 0x%lx, set = 0x%lx", __entry->addr, __entry->pte, __entry->clr, __entry->set)
 );
 
+DEFINE_EVENT(hugepage_update, hugepage_update_pmd,
+	    TP_PROTO(unsigned long addr, unsigned long pmd, unsigned long clr, unsigned long set),
+	    TP_ARGS(addr, pmd, clr, set)
+);
+
 DECLARE_EVENT_CLASS(migration_pmd,
 
 		TP_PROTO(unsigned long addr, unsigned long pmd),
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-hugepage-pud-allow-arch-specific-helper-function-to-check-huge-page-pud-support.patch
mm-change-pudp_huge_get_and_clear_full-take-vm_area_struct-as-arg.patch
mm-vmemmap-improve-vmemmap_can_optimize-and-allow-architectures-to-override.patch
mm-vmemmap-allow-architectures-to-override-how-vmemmap-optimization-works.patch
mm-add-pud_same-similar-to-__have_arch_p4d_same.patch
mm-huge-pud-use-transparent-huge-pud-helpers-only-with-config_transparent_hugepage.patch
mm-vmemmap-optimization-split-hugetlb-and-devdax-vmemmap-optimization.patch
powerpc-mm-trace-convert-trace-event-to-trace-event-class.patch
powerpc-book3s64-mm-enable-transparent-pud-hugepage.patch
powerpc-book3s64-vmemmap-switch-radix-to-use-a-different-vmemmap-handling-function.patch
powerpc-book3s64-radix-add-support-for-vmemmap-optimization-for-radix.patch
powerpc-book3s64-radix-remove-mmu_vmemmap_psize.patch
powerpc-book3s64-radix-add-debug-message-to-give-more-details-of-vmemmap-allocation.patch

