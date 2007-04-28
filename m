From: akpm@linux-foundation.org
Subject: - i386-pte-simplify-ops.patch removed from -mm tree
Date: Sat, 28 Apr 2007 03:55:37 -0700
Message-ID: <200704281055.l3SAtbkL020191@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965774AbXD1Kzk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 06:55:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     i386: pte simplify ops
has been removed from the -mm tree.  Its filename was
     i386-pte-simplify-ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: pte simplify ops
From: Zachary Amsden <zach@vmware.com>

Add comment and condense code to make use of native_local_ptep_get_and_clear
function.  Also, it turns out the 2-level and 3-level paging definitions were
identical, so move the common definition into pgtable.h

Signed-off-by: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/pgtable-2level.h |   10 ----------
 include/asm-i386/pgtable-3level.h |   10 ----------
 include/asm-i386/pgtable.h        |   17 +++++++++++++++--
 3 files changed, 15 insertions(+), 22 deletions(-)

diff -puN include/asm-i386/pgtable-2level.h~i386-pte-simplify-ops include/asm-i386/pgtable-2level.h
--- a/include/asm-i386/pgtable-2level.h~i386-pte-simplify-ops
+++ a/include/asm-i386/pgtable-2level.h
@@ -41,16 +41,6 @@ static inline void native_pte_clear(stru
 	*xp = __pte(0);
 }
 
-/* local pte updates need not use xchg for locking */
-static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
-{
-	pte_t res;
-
-	res = *ptep;
-	native_pte_clear(NULL, 0, ptep);
-	return res;
-}
-
 #ifdef CONFIG_SMP
 static inline pte_t native_ptep_get_and_clear(pte_t *xp)
 {
diff -puN include/asm-i386/pgtable-3level.h~i386-pte-simplify-ops include/asm-i386/pgtable-3level.h
--- a/include/asm-i386/pgtable-3level.h~i386-pte-simplify-ops
+++ a/include/asm-i386/pgtable-3level.h
@@ -139,16 +139,6 @@ static inline void pud_clear (pud_t * pu
 #define pmd_offset(pud, address) ((pmd_t *) pud_page(*(pud)) + \
 			pmd_index(address))
 
-/* local pte updates need not use xchg for locking */
-static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
-{
-	pte_t res;
-
-	res = *ptep;
-	native_pte_clear(NULL, 0, ptep);
-	return res;
-}
-
 #ifdef CONFIG_SMP
 static inline pte_t native_ptep_get_and_clear(pte_t *ptep)
 {
diff -puN include/asm-i386/pgtable.h~i386-pte-simplify-ops include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h~i386-pte-simplify-ops
+++ a/include/asm-i386/pgtable.h
@@ -269,6 +269,16 @@ extern void vmalloc_sync_all(void);
 #define pte_update_defer(mm, addr, ptep)	do { } while (0)
 #endif
 
+/* local pte updates need not use xchg for locking */
+static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
+{
+	pte_t res = *ptep;
+
+	/* Pure native function needs no input for mm, addr */
+	native_pte_clear(NULL, 0, ptep);
+	return res;
+}
+
 /*
  * We only update the dirty/accessed state if we set
  * the dirty bit by hand in the kernel, since the hardware
@@ -343,8 +353,11 @@ static inline pte_t ptep_get_and_clear_f
 {
 	pte_t pte;
 	if (full) {
-		pte = *ptep;
-		native_pte_clear(mm, addr, ptep);
+		/*
+		 * Full address destruction in progress; paravirt does not
+		 * care about updates and native needs no locking
+		 */
+		pte = native_local_ptep_get_and_clear(ptep);
 	} else {
 		pte = ptep_get_and_clear(mm, addr, ptep);
 	}
_

Patches currently in -mm which might be from zach@vmware.com are

git-acpi.patch
fix-buslogic-to-stop-using-check_region.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
ignore-stolen-time-in-the-softlockup-watchdog-fix.patch
