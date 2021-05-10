Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3D58C433B4
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:27:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5DC6613EE
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:27:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhEJE2M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 00:28:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229936AbhEJE2L (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 00:28:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA1396142D;
        Mon, 10 May 2021 04:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620620827;
        bh=b5g/H/fp0ITgoEgtmfdaTV8LTkfXKiFWzQnssLFIgu0=;
        h=Date:From:To:Subject:From;
        b=UYth1iaanGQ3ZgUNI8YYO6qbP6/19ZsyfTKfpSOxx2s5O03Tt3yLtyaChFIBgEj2n
         xOVHsrCAR+T8FphsYbPee/8E4W0G6JMHAw3UMZlSJemmFm1RBEPN5HKXGdRf6tGCLm
         u5EHwJfgnTcmHshcVIAzilRgPZK1LbF6+zjZPtVA=
Date:   Sun, 09 May 2021 21:27:07 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, liushixin2@huawei.com,
        mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?mm-debug=5Fvm=5Fpgtable-remove-redundant-pfn=5Fpmd-pte-and-f?=
 =?US-ASCII?Q?ix-one-comment-mistake.patch?= added to -mm tree
Message-ID: <20210510042707.8c_DQKgFB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: remove redundant pfn_{pmd/pte}() and fix one comment mistake
has been added to the -mm tree.  Its filename is
     mm-debug_vm_pgtable-remove-redundant-pfn_pmd-pte-and-fix-one-comment-mistake.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug_vm_pgtable-remove-redundant-pfn_pmd-pte-and-fix-one-comment-mistake.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_vm_pgtable-remove-redundant-pfn_pmd-pte-and-fix-one-comment-mistake.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shixin Liu <liushixin2@huawei.com>
Subject: mm/debug_vm_pgtable: remove redundant pfn_{pmd/pte}() and fix one comment mistake

Remove redundant pfn_{pmd/pte}() in {pmd/pte}_advanced_tests() and adjust
pfn_pud() in pud_advanced_tests() to make it similar with other two
functions.

In addition, the branch condition should be CONFIG_TRANSPARENT_HUGEPAGE
instead of CONFIG_ARCH_HAS_PTE_DEVMAP.

Link: https://lkml.kernel.org/r/20210419071820.750217-2-liushixin2@huawei.com
Signed-off-by: Shixin Liu <liushixin2@huawei.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-remove-redundant-pfn_pmd-pte-and-fix-one-comment-mistake
+++ a/mm/debug_vm_pgtable.c
@@ -91,7 +91,7 @@ static void __init pte_advanced_tests(st
 				      unsigned long pfn, unsigned long vaddr,
 				      pgprot_t prot)
 {
-	pte_t pte = pfn_pte(pfn, prot);
+	pte_t pte;
 
 	/*
 	 * Architectures optimize set_pte_at by avoiding TLB flush.
@@ -185,7 +185,7 @@ static void __init pmd_advanced_tests(st
 				      unsigned long pfn, unsigned long vaddr,
 				      pgprot_t prot, pgtable_t pgtable)
 {
-	pmd_t pmd = pfn_pmd(pfn, prot);
+	pmd_t pmd;
 
 	if (!has_transparent_hugepage())
 		return;
@@ -300,7 +300,7 @@ static void __init pud_advanced_tests(st
 				      unsigned long pfn, unsigned long vaddr,
 				      pgprot_t prot)
 {
-	pud_t pud = pfn_pud(pfn, prot);
+	pud_t pud;
 
 	if (!has_transparent_hugepage())
 		return;
@@ -309,6 +309,7 @@ static void __init pud_advanced_tests(st
 	/* Align the address wrt HPAGE_PUD_SIZE */
 	vaddr = (vaddr & HPAGE_PUD_MASK) + HPAGE_PUD_SIZE;
 
+	pud = pfn_pud(pfn, prot);
 	set_pud_at(mm, vaddr, pudp, pud);
 	pudp_set_wrprotect(mm, vaddr, pudp);
 	pud = READ_ONCE(*pudp);
@@ -742,12 +743,12 @@ static void __init pmd_swap_soft_dirty_t
 	WARN_ON(!pmd_swp_soft_dirty(pmd_swp_mksoft_dirty(pmd)));
 	WARN_ON(pmd_swp_soft_dirty(pmd_swp_clear_soft_dirty(pmd)));
 }
-#else  /* !CONFIG_ARCH_HAS_PTE_DEVMAP */
+#else  /* !CONFIG_TRANSPARENT_HUGEPAGE */
 static void __init pmd_soft_dirty_tests(unsigned long pfn, pgprot_t prot) { }
 static void __init pmd_swap_soft_dirty_tests(unsigned long pfn, pgprot_t prot)
 {
 }
-#endif /* CONFIG_ARCH_HAS_PTE_DEVMAP */
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 static void __init pte_swap_tests(unsigned long pfn, pgprot_t prot)
 {
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-debug_vm_pgtable-move-pmd-pud_huge_tests-out-of-config_transparent_hugepage.patch
mm-debug_vm_pgtable-remove-redundant-pfn_pmd-pte-and-fix-one-comment-mistake.patch

