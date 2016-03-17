From: akpm@linux-foundation.org
Subject: [folded-merged] mm-cleanup-pte_alloc-interfaces-fix-2.patch
 removed from -mm tree
Date: Thu, 17 Mar 2016 13:56:00 -0700
Message-ID: <56eb19e0.b9OB6ko6FjTwobH/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44409 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030437AbcCQU4B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 16:56:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-cleanup-pte_alloc-interfaces-fix-2
has been removed from the -mm tree.  Its filename was
     mm-cleanup-pte_alloc-interfaces-fix-2.patch

This patch was dropped because it was folded into mm-cleanup-pte_alloc-interfaces.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: mm-cleanup-pte_alloc-interfaces-fix-2

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/mmu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/arm/mm/mmu.c~mm-cleanup-pte_alloc-interfaces-fix-2 arch/arm/mm/mmu.c
--- a/arch/arm/mm/mmu.c~mm-cleanup-pte_alloc-interfaces-fix-2
+++ a/arch/arm/mm/mmu.c
@@ -732,7 +732,7 @@ static void *__init late_alloc(unsigned
 	return ptr;
 }
 
-static pte_t * __init pte_alloc(pmd_t *pmd, unsigned long addr,
+static pte_t * __init arm_pte_alloc(pmd_t *pmd, unsigned long addr,
 				unsigned long prot,
 				void *(*alloc)(unsigned long sz))
 {
@@ -747,7 +747,7 @@ static pte_t * __init pte_alloc(pmd_t *p
 static pte_t * __init early_pte_alloc(pmd_t *pmd, unsigned long addr,
 				      unsigned long prot)
 {
-	return pte_alloc(pmd, addr, prot, early_alloc);
+	return arm_pte_alloc(pmd, addr, prot, early_alloc);
 }
 
 static void __init alloc_init_pte(pmd_t *pmd, unsigned long addr,
@@ -756,7 +756,7 @@ static void __init alloc_init_pte(pmd_t
 				  void *(*alloc)(unsigned long sz),
 				  bool ng)
 {
-	pte_t *pte = pte_alloc(pmd, addr, type->prot_l1, alloc);
+	pte_t *pte = arm_pte_alloc(pmd, addr, type->prot_l1, alloc);
 	do {
 		set_pte_ext(pte, pfn_pte(pfn, __pgprot(type->prot_pte)),
 			    ng ? PTE_EXT_NG : 0);
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-cleanup-pte_alloc-interfaces.patch

