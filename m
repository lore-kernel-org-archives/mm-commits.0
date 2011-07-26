From: akpm@linux-foundation.org
Subject: [merged] sparc64-add-support-for-_page_special.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:53:13 -0700
Message-ID: <201107260752.p6Q7qGCO003108@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752976Ab1GZHwx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:52:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     sparc64: add support for _PAGE_SPECIAL
has been removed from the -mm tree.  Its filename was
     sparc64-add-support-for-_page_special.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sparc64: add support for _PAGE_SPECIAL
From: David S. Miller <davem@davemloft.net>

Luckily there are still a few software PTE bits remaining and they even
match up in both the sun4u and sun4v pte layouts.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/pgtable_64.h |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN arch/sparc/include/asm/pgtable_64.h~sparc64-add-support-for-_page_special arch/sparc/include/asm/pgtable_64.h
--- a/arch/sparc/include/asm/pgtable_64.h~sparc64-add-support-for-_page_special
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -95,6 +95,10 @@
 /* PTE bits which are the same in SUN4U and SUN4V format.  */
 #define _PAGE_VALID	  _AC(0x8000000000000000,UL) /* Valid TTE            */
 #define _PAGE_R	  	  _AC(0x8000000000000000,UL) /* Keep ref bit uptodate*/
+#define _PAGE_SPECIAL     _AC(0x0200000000000000,UL) /* Special page         */
+
+/* Advertise support for _PAGE_SPECIAL */
+#define __HAVE_ARCH_PTE_SPECIAL
 
 /* SUN4U pte bits... */
 #define _PAGE_SZ4MB_4U	  _AC(0x6000000000000000,UL) /* 4MB Page             */
@@ -104,6 +108,7 @@
 #define _PAGE_NFO_4U	  _AC(0x1000000000000000,UL) /* No Fault Only        */
 #define _PAGE_IE_4U	  _AC(0x0800000000000000,UL) /* Invert Endianness    */
 #define _PAGE_SOFT2_4U	  _AC(0x07FC000000000000,UL) /* Software bits, set 2 */
+#define _PAGE_SPECIAL_4U  _AC(0x0200000000000000,UL) /* Special page         */
 #define _PAGE_RES1_4U	  _AC(0x0002000000000000,UL) /* Reserved             */
 #define _PAGE_SZ32MB_4U	  _AC(0x0001000000000000,UL) /* (Panther) 32MB page  */
 #define _PAGE_SZ256MB_4U  _AC(0x2001000000000000,UL) /* (Panther) 256MB page */
@@ -133,6 +138,7 @@
 #define _PAGE_ACCESSED_4V _AC(0x1000000000000000,UL) /* Accessed (ref'd)     */
 #define _PAGE_READ_4V	  _AC(0x0800000000000000,UL) /* Readable SW Bit      */
 #define _PAGE_WRITE_4V	  _AC(0x0400000000000000,UL) /* Writable SW Bit      */
+#define _PAGE_SPECIAL_4V  _AC(0x0200000000000000,UL) /* Special page         */
 #define _PAGE_PADDR_4V	  _AC(0x00FFFFFFFFFFE000,UL) /* paddr[55:13]         */
 #define _PAGE_IE_4V	  _AC(0x0000000000001000,UL) /* Invert Endianness    */
 #define _PAGE_E_4V	  _AC(0x0000000000000800,UL) /* side-Effect          */
@@ -302,10 +308,10 @@ static inline pte_t pte_modify(pte_t pte
 	: "=r" (mask), "=r" (tmp)
 	: "i" (_PAGE_PADDR_4U | _PAGE_MODIFIED_4U | _PAGE_ACCESSED_4U |
 	       _PAGE_CP_4U | _PAGE_CV_4U | _PAGE_E_4U | _PAGE_PRESENT_4U |
-	       _PAGE_SZBITS_4U),
+	       _PAGE_SZBITS_4U | _PAGE_SPECIAL),
 	  "i" (_PAGE_PADDR_4V | _PAGE_MODIFIED_4V | _PAGE_ACCESSED_4V |
 	       _PAGE_CP_4V | _PAGE_CV_4V | _PAGE_E_4V | _PAGE_PRESENT_4V |
-	       _PAGE_SZBITS_4V));
+	       _PAGE_SZBITS_4V | _PAGE_SPECIAL));
 
 	return __pte((pte_val(pte) & mask) | (pgprot_val(prot) & ~mask));
 }
@@ -502,6 +508,7 @@ static inline pte_t pte_mkyoung(pte_t pt
 
 static inline pte_t pte_mkspecial(pte_t pte)
 {
+	pte_val(pte) |= _PAGE_SPECIAL;
 	return pte;
 }
 
@@ -607,9 +614,9 @@ static inline unsigned long pte_present(
 	return val;
 }
 
-static inline int pte_special(pte_t pte)
+static inline unsigned long pte_special(pte_t pte)
 {
-	return 0;
+	return pte_val(pte) & _PAGE_SPECIAL;
 }
 
 #define pmd_set(pmdp, ptep)	\
_

Patches currently in -mm which might be from davem@davemloft.net are

origin.patch
linux-next.patch
maintainers-orphan-framerelay-dlci.patch
proc_fork_connector-a-lockless-real_parent-usage-is-not-safe.patch
sparc-exec-remove-redundant-addr_limit-assignment.patch
kprobes-silence-debug_strict_user_copy_checks=y-warning.patch
drivers-edac-mpc85xx_edacc-correct-offset_in_page-mask-bits-in-edac_mc_handle_ce.patch
atomic-use-linux-atomich.patch
atomic-move-atomic_add_unless-to-generic-code.patch
atomic-cleanup-asm-generic-atomich-inclusion.patch
atomic-update-comments-in-atomich.patch

