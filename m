Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E24F2C001DC
	for <mm-commits@archiver.kernel.org>; Wed, 26 Jul 2023 19:41:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjGZTlJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 Jul 2023 15:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjGZTlI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jul 2023 15:41:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0851F19BF
        for <mm-commits@vger.kernel.org>; Wed, 26 Jul 2023 12:41:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A8D261CB1
        for <mm-commits@vger.kernel.org>; Wed, 26 Jul 2023 19:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA565C433C7;
        Wed, 26 Jul 2023 19:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690400466;
        bh=Tvel0s8uizucFcHNZlXWqz+G/pKgH9ki1Aw8kjwrSQg=;
        h=Date:To:From:Subject:From;
        b=RCO/8+U1Mfpb79sfK5UNEAnxMNg3+Vgac8GjvAjLzu69lrMQDE+0Bl6hGV29gGMXz
         fBvGqG39p4em/aQJPA6XEJGsVL9gdEr8Y+dBhM1WfTuUpgIfaijXXyDmV4WQyc3CGn
         oq40FeF0JbyAAeHyyS0TPaYsDlBAeHPqQ9U2CINY=
Date:   Wed, 26 Jul 2023 12:41:05 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, osalvador@suse.de,
        npiggin@gmail.com, muchun.song@linux.dev, mpe@ellerman.id.au,
        mike.kravetz@oracle.com, joao.m.martins@oracle.com,
        dan.j.williams@intel.com, christophe.leroy@csgroup.eu,
        catalin.marinas@arm.com, aneesh.kumar@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugepage-pud-allow-arch-specific-helper-function-to-check-huge-page-pud-support-fix.patch added to mm-unstable branch
Message-Id: <20230726194105.DA565C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: Use the new has_transparent_pud_hugepage()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugepage-pud-allow-arch-specific-helper-function-to-check-huge-page-pud-support-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugepage-pud-allow-arch-specific-helper-function-to-check-huge-page-pud-support-fix.patch

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
mm-hugepage-pud-allow-arch-specific-helper-function-to-check-huge-page-pud-support-fix.patch
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
powerpc-book3s64-radix-add-support-for-vmemmap-optimization-for-radix-fix.patch
powerpc-book3s64-radix-remove-mmu_vmemmap_psize.patch
powerpc-book3s64-radix-add-debug-message-to-give-more-details-of-vmemmap-allocation.patch

