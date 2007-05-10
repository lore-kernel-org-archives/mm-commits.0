From: akpm@linux-foundation.org
Subject: + m32r-fix-tme_handler-to-check-_page_present-bit.patch added to -mm tree
Date: Wed, 09 May 2007 22:23:49 -0700
Message-ID: <200705100523.l4A5NnHp012959@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755401AbXEJFYE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 01:24:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: takata@linux-m32r.org, hitoshiy@linux-m32r.org


The patch titled
     m32r: fix tme_handler to check _PAGE_PRESENT bit
has been added to the -mm tree.  Its filename is
     m32r-fix-tme_handler-to-check-_page_present-bit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m32r: fix tme_handler to check _PAGE_PRESENT bit
From: Hirokazu Takata <takata@linux-m32r.org>

Fix the tlb-miss handler (tme_handler) to check _PAGE_PRESENT bit
in order to handle file-mapped or swapped-out pages correctly.

This patch is required to fix unexpected page errors for m32r.

Signed-off-by: Hitoshi Yamamoto <hitoshiy@linux-m32r.org>
Signed-off-by: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/mm/mmu.S |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff -puN arch/m32r/mm/mmu.S~m32r-fix-tme_handler-to-check-_page_present-bit arch/m32r/mm/mmu.S
--- a/arch/m32r/mm/mmu.S~m32r-fix-tme_handler-to-check-_page_present-bit
+++ a/arch/m32r/mm/mmu.S
@@ -163,7 +163,8 @@ ENTRY(tme_handler)
 
 	; pte_data = (unsigned long)pte_val(*pte);
 	ld	r2, @r3			; r2: pte data
-	or3	r2, r2, #2		; _PAGE_PRESENT(=2)
+	and3	r3, r2, #2		; _PAGE_PRESENT(=2) check
+	beqz	r3, 3f
 
 	.fillinsn
 5:
@@ -264,11 +265,8 @@ ENTRY(tme_handler)
 ;
 	and3	r1, r1, #0xeff
 	ldi	r4, #611		; _KERNPG_TABLE(=611)
-	beq	r1, r4, 4f		; !pmd_bad(*pmd) ?
-	.fillinsn
-3:
-	ldi	r1, #0			; r1: pte_data = 0
-	bra	5f
+	bne	r1, r4, 3f		; !pmd_bad(*pmd) ?
+
 	.fillinsn
 4:
 	; pte = pte_offset(pmd, address);
@@ -282,8 +280,10 @@ ENTRY(tme_handler)
 	add	r4, r3			; r4: pte
 	; pte_data = (unsigned long)pte_val(*pte);
 	ld	r1, @r4			; r1: pte_data
-	.fillinsn
+	and3	r3, r1, #2		; _PAGE_PRESENT(=2) check
+	beqz	r3, 3f
 
+	.fillinsn
 ;; set tlb
 ; r0: address, r1: pte_data, r2: entry
 ; r3,r4: (free)
@@ -295,8 +295,7 @@ ENTRY(tme_handler)
 	and3	r4, r4, #(MMU_CONTEXT_ASID_MASK)
 	or	r3, r4
 	st	r3, @r2
-	or3	r4, r1, #2		; _PAGE_PRESENT(=2)
-	st	r4, @(4,r2)		; set_tlb_data(entry, pte_data);
+	st	r1, @(4,r2)		; set_tlb_data(entry, pte_data);
 
 	ld	r4, @sp+
 	ld	r3, @sp+
@@ -306,6 +305,11 @@ ENTRY(tme_handler)
 	ld	sp, @sp+
 	rte
 
+	.fillinsn
+3:
+	ldi	r1, #2			; r1: pte_data = 0 | _PAGE_PRESENT(=2)
+	bra	5b
+
 #else
 #error unknown isa configuration
 #endif
_

Patches currently in -mm which might be from takata@linux-m32r.org are

origin.patch
m32r-fix-switch_to-macro-to-push-pop-frame-pointer-if.patch
m32r-fix-switch_to-macro-to-push-pop-frame-pointer-if-fix.patch
m32r-fix-tme_handler-to-check-_page_present-bit.patch
m32r-fix-pte_to_pgoff.patch
