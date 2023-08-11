Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FD86C04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:06:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237201AbjHKXGh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236554AbjHKXF1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:05:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7E33C33
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:03:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33E7A67AC6
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:03:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCCEC433C7;
        Fri, 11 Aug 2023 23:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794999;
        bh=ltiTOL7z3Dbq/dBER7UpSTCw4CCHbEbtZtS2jEh0QHI=;
        h=Date:To:From:Subject:From;
        b=pPfAdDUpo1QtBUFEHNec4pf1Rd4OgCKxDahalpCW948HfU+pkdjuGVmaOGkL8FHON
         nKrJtwcAZJ5IDxxjsp9JLlPAGkpGmpHuLONbuGsd2DdzpfFOPfz/iyVTka6mM3S05E
         O5kMkRewM16SkKctHOR4br/ecSwZ9xFyiNpSlPGI=
Date:   Fri, 11 Aug 2023 16:03:19 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, osalvador@suse.de,
        npiggin@gmail.com, muchun.song@linux.dev, mpe@ellerman.id.au,
        mike.kravetz@oracle.com, joao.m.martins@oracle.com,
        dan.j.williams@intel.com, christophe.leroy@csgroup.eu,
        catalin.marinas@arm.com, aneesh.kumar@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-mm-trace-convert-trace-event-to-trace-event-class.patch removed from -mm tree
Message-Id: <20230811230319.8DCCEC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: powerpc/mm/trace: convert trace event to trace event class
has been removed from the -mm tree.  Its filename was
     powerpc-mm-trace-convert-trace-event-to-trace-event-class.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-memory_hotplug-simplify-arch_mhp_memmap_on_memory_enable-kconfig.patch
mm-memory_hotplug-allow-memmap-on-memory-hotplug-request-to-fallback.patch
mm-memory_hotplug-allow-architecture-to-override-memmap-on-memory-support-check.patch
mm-memory_hotplug-support-memmap_on_memory-when-memmap-is-not-aligned-to-pageblocks.patch
powerpc-book3s64-memhotplug-enable-memmap-on-memory-for-radix.patch
mm-memory_hotplug-embed-vmem_altmap-details-in-memory-block.patch

