Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06C2BC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232987AbiEJEV3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236007AbiEJEUC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4CE2AC6E2
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:14:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2BF66176A
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:14:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C6EC385A6;
        Tue, 10 May 2022 04:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156097;
        bh=hhndUnkBWGfYdqRlDRcqZGJKlSx8PuMLtI7L5ge4IBM=;
        h=Date:To:From:Subject:From;
        b=DEhoRba8rnpLqNQqsOvrEIseFjXyEZ9PxACUzOy9Uh1Bq36YU/HDGebrdlCVhIZZ+
         g7Xwlrnf8NdE52TLg06IlXWXdNKGyeB3yweMgkcaKwBhxvd+h9n28PG1v0MRDFUjAG
         VotLzQibvTS08KYj+NZtOLMtBEtpaGdRnhY9/8fw=
Date:   Mon, 09 May 2022 21:14:56 -0700
To:     mm-commits@vger.kernel.org, zhangliang5@huawei.com,
        willy@infradead.org, will@kernel.org, vbabka@suse.cz,
        tglx@linutronix.de, shakeelb@google.com, rppt@linux.ibm.com,
        riel@surriel.com, peterx@redhat.com, pedrodemargomes@gmail.com,
        paulus@samba.org, oleg@redhat.com, oded.gabbay@gmail.com,
        namit@vmware.com, mpe@ellerman.id.au, mingo@redhat.com,
        mike.kravetz@oracle.com, mhocko@kernel.org,
        kirill.shutemov@linux.intel.com, jhubbard@nvidia.com,
        jgg@nvidia.com, jannh@google.com, jack@suse.cz, hughd@google.com,
        hch@lst.de, hca@linux.ibm.com, guro@fb.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, ddutile@redhat.com,
        dave.hansen@linux.intel.com, catalin.marinas@arm.com, bp@alien8.de,
        benh@kernel.crashing.org, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-debug_vm_pgtable-add-tests-for-__have_arch_pte_swp_exclusive.patch removed from -mm tree
Message-Id: <20220510041456.F2C6EC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/debug_vm_pgtable: add tests for __HAVE_ARCH_PTE_SWP_EXCLUSIVE
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-add-tests-for-__have_arch_pte_swp_exclusive.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/debug_vm_pgtable: add tests for __HAVE_ARCH_PTE_SWP_EXCLUSIVE

Let's test that __HAVE_ARCH_PTE_SWP_EXCLUSIVE works as expected.

Link: https://lkml.kernel.org/r/20220329164329.208407-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Liang Zhang <zhangliang5@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Nadav Amit <namit@vmware.com>
Cc: Oded Gabbay <oded.gabbay@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-add-tests-for-__have_arch_pte_swp_exclusive
+++ a/mm/debug_vm_pgtable.c
@@ -837,6 +837,19 @@ static void __init pmd_soft_dirty_tests(
 static void __init pmd_swap_soft_dirty_tests(struct pgtable_debug_args *args) { }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
+static void __init pte_swap_exclusive_tests(struct pgtable_debug_args *args)
+{
+#ifdef __HAVE_ARCH_PTE_SWP_EXCLUSIVE
+	pte_t pte = pfn_pte(args->fixed_pte_pfn, args->page_prot);
+
+	pr_debug("Validating PTE swap exclusive\n");
+	pte = pte_swp_mkexclusive(pte);
+	WARN_ON(!pte_swp_exclusive(pte));
+	pte = pte_swp_clear_exclusive(pte);
+	WARN_ON(pte_swp_exclusive(pte));
+#endif /* __HAVE_ARCH_PTE_SWP_EXCLUSIVE */
+}
+
 static void __init pte_swap_tests(struct pgtable_debug_args *args)
 {
 	swp_entry_t swp;
@@ -1295,6 +1308,8 @@ static int __init debug_vm_pgtable(void)
 	pte_swap_soft_dirty_tests(&args);
 	pmd_swap_soft_dirty_tests(&args);
 
+	pte_swap_exclusive_tests(&args);
+
 	pte_swap_tests(&args);
 	pmd_swap_tests(&args);
 
_

Patches currently in -mm which might be from david@redhat.com are


