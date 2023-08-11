Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F417CC0015E
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234124AbjHKWhG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbjHKWhF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:37:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A251FED
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:37:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 975AB6347F
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F125CC433C7;
        Fri, 11 Aug 2023 22:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691793424;
        bh=5PG8ABOS2tITQd4Oc9m2EHvrn2uFh7NOv1l5byIxqAc=;
        h=Date:To:From:Subject:From;
        b=y2zTCXvULa9LmB0l8TuvEk3LT6qjP3MO5ABJ9Rsc/M5GirXWvYJTf9vRDBcm2cSqm
         Z4K8oJbpmmmraSXmBY2G0nA5UeJmTv5oEDqD2DRJQ3qDH24IgSg6yXIQfP4z/W0dW/
         aVKduZJNM5AzTJ7vhP6c3TQHYoTvYZ8EcJrshBoc=
Date:   Fri, 11 Aug 2023 15:37:03 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, osalvador@suse.de,
        npiggin@gmail.com, muchun.song@linux.dev, mpe@ellerman.id.au,
        mike.kravetz@oracle.com, joao.m.martins@oracle.com,
        dan.j.williams@intel.com, christophe.leroy@csgroup.eu,
        catalin.marinas@arm.com, aneesh.kumar@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hugepage-pud-allow-arch-specific-helper-function-to-check-huge-page-pud-support-fix.patch removed from -mm tree
Message-Id: <20230811223703.F125CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/debug_vm_pgtable: Use the new has_transparent_pud_hugepage()
has been removed from the -mm tree.  Its filename was
     mm-hugepage-pud-allow-arch-specific-helper-function-to-check-huge-page-pud-support-fix.patch

This patch was dropped because it was folded into mm-hugepage-pud-allow-arch-specific-helper-function-to-check-huge-page-pud-support.patch

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/debug_vm_pgtable: Use the new has_transparent_pud_hugepage()
Date: Wed, 26 Jul 2023 13:45:28 +0530

Use the new helper to check pud hugepage support.  Architecture like ppc64
will enable the config value CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD and
can still have pud hugepage support disabled for hash translation.

Link: https://lkml.kernel.org/r/87tttrvtaj.fsf@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
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

 mm/debug_vm_pgtable.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-hugepage-pud-allow-arch-specific-helper-function-to-check-huge-page-pud-support-fix
+++ a/mm/debug_vm_pgtable.c
@@ -302,7 +302,7 @@ static void __init pud_basic_tests(struc
 	unsigned long val = idx, *ptr = &val;
 	pud_t pud;
 
-	if (!has_transparent_hugepage())
+	if (!has_transparent_pud_hugepage())
 		return;
 
 	pr_debug("Validating PUD basic (%pGv)\n", ptr);
@@ -343,7 +343,7 @@ static void __init pud_advanced_tests(st
 	unsigned long vaddr = args->vaddr;
 	pud_t pud;
 
-	if (!has_transparent_hugepage())
+	if (!has_transparent_pud_hugepage())
 		return;
 
 	page = (args->pud_pfn != ULONG_MAX) ? pfn_to_page(args->pud_pfn) : NULL;
@@ -405,7 +405,7 @@ static void __init pud_leaf_tests(struct
 {
 	pud_t pud;
 
-	if (!has_transparent_hugepage())
+	if (!has_transparent_pud_hugepage())
 		return;
 
 	pr_debug("Validating PUD leaf\n");
@@ -732,7 +732,7 @@ static void __init pud_devmap_tests(stru
 {
 	pud_t pud;
 
-	if (!has_transparent_hugepage())
+	if (!has_transparent_pud_hugepage())
 		return;
 
 	pr_debug("Validating PUD devmap\n");
@@ -981,7 +981,7 @@ static void __init pud_thp_tests(struct
 {
 	pud_t pud;
 
-	if (!has_transparent_hugepage())
+	if (!has_transparent_pud_hugepage())
 		return;
 
 	pr_debug("Validating PUD based THP\n");
@@ -1022,8 +1022,7 @@ static void __init destroy_args(struct p
 
 	/* Free (huge) page */
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
-	    IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD) &&
-	    has_transparent_hugepage() &&
+	    has_transparent_pud_hugepage() &&
 	    args->pud_pfn != ULONG_MAX) {
 		if (args->is_contiguous_page) {
 			free_contig_range(args->pud_pfn,
@@ -1274,8 +1273,7 @@ static int __init init_args(struct pgtab
 	 * if we fail to allocate (huge) pages.
 	 */
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
-	    IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD) &&
-	    has_transparent_hugepage()) {
+	    has_transparent_pud_hugepage()) {
 		page = debug_vm_pgtable_alloc_huge_page(args,
 				HPAGE_PUD_SHIFT - PAGE_SHIFT);
 		if (page) {
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
powerpc-book3s64-vmemmap-switch-radix-to-use-a-different-vmemmap-handling-function-fix.patch
powerpc-book3s64-vmemmap-switch-radix-to-use-a-different-vmemmap-handling-function-fix-2.patch
powerpc-book3s64-radix-add-support-for-vmemmap-optimization-for-radix.patch
powerpc-book3s64-radix-add-support-for-vmemmap-optimization-for-radix-fix.patch
powerpc-book3s64-radix-remove-mmu_vmemmap_psize.patch
powerpc-book3s64-radix-remove-mmu_vmemmap_psize-fix.patch
powerpc-book3s64-radix-add-debug-message-to-give-more-details-of-vmemmap-allocation.patch
mm-memory_hotplug-simplify-arch_mhp_memmap_on_memory_enable-kconfig.patch
mm-memory_hotplug-allow-memmap-on-memory-hotplug-request-to-fallback.patch
mm-memory_hotplug-allow-architecture-to-override-memmap-on-memory-support-check.patch
mm-memory_hotplug-support-memmap_on_memory-when-memmap-is-not-aligned-to-pageblocks.patch
powerpc-book3s64-memhotplug-enable-memmap-on-memory-for-radix.patch
mm-memory_hotplug-embed-vmem_altmap-details-in-memory-block.patch

