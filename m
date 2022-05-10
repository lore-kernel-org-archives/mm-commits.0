Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECF5FC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235995AbiEJERB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236017AbiEJEQY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:16:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93575457A4
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:11:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E0D861726
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80172C385A6;
        Tue, 10 May 2022 04:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155911;
        bh=QfuaOW+Pc9VvXAps2ZvYphsxO9mIc4hbJcNuNQ+nQ4Q=;
        h=Date:To:From:Subject:From;
        b=tv2X8JF+0LnzHYMzYd0y05az9HL7u4O8VkY2XtWFVAl76ca4RuWVpsO/Q8Xx1Y9uu
         w+PDF4hF0qvAcwNGht2u9QDn6lUTSY9D3ZtpGJAhII0AKqkdr5sQ3uxjKQLfm13jEX
         uVGqdf4uawBS3u2s/62E+IXYIP83JoP8vBypVVaU=
Date:   Mon, 09 May 2022 21:11:50 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, anshuman.khandual@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-debug_vm_pgtable-drop-protection_map-usage.patch removed from -mm tree
Message-Id: <20220510041151.80172C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/debug_vm_pgtable: drop protection_map[] usage
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-drop-protection_map-usage.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/debug_vm_pgtable: drop protection_map[] usage

Patch series "mm: protection_map[] cleanups".


This patch (of 2):

Although protection_map[] contains the platform defined page protection
map for a given vm_flags combination, vm_get_page_prot() is the right
interface to use.  This will also reduce dependency on protection_map[]
which is going to be dropped off completely later on.

Link: https://lkml.kernel.org/r/20220404031840.588321-1-anshuman.khandual@arm.com
Link: https://lkml.kernel.org/r/20220404031840.588321-2-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-drop-protection_map-usage
+++ a/mm/debug_vm_pgtable.c
@@ -93,7 +93,7 @@ struct pgtable_debug_args {
 
 static void __init pte_basic_tests(struct pgtable_debug_args *args, int idx)
 {
-	pgprot_t prot = protection_map[idx];
+	pgprot_t prot = vm_get_page_prot(idx);
 	pte_t pte = pfn_pte(args->fixed_pte_pfn, prot);
 	unsigned long val = idx, *ptr = &val;
 
@@ -101,7 +101,7 @@ static void __init pte_basic_tests(struc
 
 	/*
 	 * This test needs to be executed after the given page table entry
-	 * is created with pfn_pte() to make sure that protection_map[idx]
+	 * is created with pfn_pte() to make sure that vm_get_page_prot(idx)
 	 * does not have the dirty bit enabled from the beginning. This is
 	 * important for platforms like arm64 where (!PTE_RDONLY) indicate
 	 * dirty bit being set.
@@ -190,7 +190,7 @@ static void __init pte_savedwrite_tests(
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static void __init pmd_basic_tests(struct pgtable_debug_args *args, int idx)
 {
-	pgprot_t prot = protection_map[idx];
+	pgprot_t prot = vm_get_page_prot(idx);
 	unsigned long val = idx, *ptr = &val;
 	pmd_t pmd;
 
@@ -202,7 +202,7 @@ static void __init pmd_basic_tests(struc
 
 	/*
 	 * This test needs to be executed after the given page table entry
-	 * is created with pfn_pmd() to make sure that protection_map[idx]
+	 * is created with pfn_pmd() to make sure that vm_get_page_prot(idx)
 	 * does not have the dirty bit enabled from the beginning. This is
 	 * important for platforms like arm64 where (!PTE_RDONLY) indicate
 	 * dirty bit being set.
@@ -325,7 +325,7 @@ static void __init pmd_savedwrite_tests(
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 static void __init pud_basic_tests(struct pgtable_debug_args *args, int idx)
 {
-	pgprot_t prot = protection_map[idx];
+	pgprot_t prot = vm_get_page_prot(idx);
 	unsigned long val = idx, *ptr = &val;
 	pud_t pud;
 
@@ -337,7 +337,7 @@ static void __init pud_basic_tests(struc
 
 	/*
 	 * This test needs to be executed after the given page table entry
-	 * is created with pfn_pud() to make sure that protection_map[idx]
+	 * is created with pfn_pud() to make sure that vm_get_page_prot(idx)
 	 * does not have the dirty bit enabled from the beginning. This is
 	 * important for platforms like arm64 where (!PTE_RDONLY) indicate
 	 * dirty bit being set.
@@ -1106,14 +1106,14 @@ static int __init init_args(struct pgtab
 	/*
 	 * Initialize the debugging data.
 	 *
-	 * protection_map[0] (or even protection_map[8]) will help create
-	 * page table entries with PROT_NONE permission as required for
-	 * pxx_protnone_tests().
+	 * vm_get_page_prot(VM_NONE) or vm_get_page_prot(VM_SHARED|VM_NONE)
+	 * will help create page table entries with PROT_NONE permission as
+	 * required for pxx_protnone_tests().
 	 */
 	memset(args, 0, sizeof(*args));
 	args->vaddr              = get_random_vaddr();
 	args->page_prot          = vm_get_page_prot(VMFLAGS);
-	args->page_prot_none     = protection_map[0];
+	args->page_prot_none     = vm_get_page_prot(VM_NONE);
 	args->is_contiguous_page = false;
 	args->pud_pfn            = ULONG_MAX;
 	args->pmd_pfn            = ULONG_MAX;
@@ -1248,12 +1248,19 @@ static int __init debug_vm_pgtable(void)
 		return ret;
 
 	/*
-	 * Iterate over the protection_map[] to make sure that all
+	 * Iterate over each possible vm_flags to make sure that all
 	 * the basic page table transformation validations just hold
 	 * true irrespective of the starting protection value for a
 	 * given page table entry.
+	 *
+	 * Protection based vm_flags combinatins are always linear
+	 * and increasing i.e starting from VM_NONE and going upto
+	 * (VM_SHARED | READ | WRITE | EXEC).
 	 */
-	for (idx = 0; idx < ARRAY_SIZE(protection_map); idx++) {
+#define VM_FLAGS_START	(VM_NONE)
+#define VM_FLAGS_END	(VM_SHARED | VM_EXEC | VM_WRITE | VM_READ)
+
+	for (idx = VM_FLAGS_START; idx <= VM_FLAGS_END; idx++) {
 		pte_basic_tests(&args, idx);
 		pmd_basic_tests(&args, idx);
 		pud_basic_tests(&args, idx);
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are


