From: akpm@linux-foundation.org
Subject: + sparc64-add-support-for-_page_special.patch added to -mm tree
Date: Wed, 13 Jul 2011 15:34:00 -0700
Message-ID: <201107132234.p6DMY0eu007434@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752518Ab1GMWeF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jul 2011 18:34:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davem@davemloft.net, a.p.zijlstra@chello.nl


The patch titled
     sparc64: add support for _PAGE_SPECIAL
has been added to the -mm tree.  Its filename is
     sparc64-add-support-for-_page_special.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
maintainers-orphan-framerelay-dlci.patch
drivers-net-skgec-support-dlink-dge-530t-rev-c1.patch
pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const.patch
sparc-exec-remove-redundant-addr_limit-assignment.patch
sparc64-kill-page-table-quicklists.patch
sparc64-use-rcu-page-table-freeing.patch
sparc64-add-support-for-_page_special.patch
sparc64-implement-get_user_pages_fast.patch
kprobes-silence-debug_strict_user_copy_checks=y-warning.patch
notifiers-cpu-move-cpu-notifiers-into-cpuh.patch
notifiers-net-move-netdevice-notifiers-into-netdeviceh.patch
notifiers-sys-move-reboot-notifiers-into-rebooth.patch
notifiers-pm-move-pm-notifiers-into-suspendh.patch
notifiers-pm-move-pm-notifiers-into-suspendh-update.patch
notifiers-vt-move-vt-notifiers-into-vth.patch
atomic-use-linux-atomich.patch
atomic-move-atomic_add_unless-to-generic-code.patch
atomic-cleanup-asm-generic-atomich-inclusion.patch
atomic-update-comments-in-atomich.patch

