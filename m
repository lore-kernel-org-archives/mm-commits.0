From: akpm@linux-foundation.org
Subject: + sgi-gru-restructure-the-gru-vtop-functions.patch added to -mm tree
Date: Tue, 27 Jan 2009 16:25:08 -0800
Message-ID: <200901280025.n0S0P8VQ004876@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54294 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751798AbZA1AZM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 19:25:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     sgi-gru: restructure the GRU vtop functions
has been added to the -mm tree.  Its filename is
     sgi-gru-restructure-the-gru-vtop-functions.patch

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
Subject: sgi-gru: restructure the GRU vtop functions
From: Jack Steiner <steiner@sgi.com>

Restructure the GRU vtop functions in preparation for future changes. 
This patch simply moves code around & does not change the algorithm.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufault.c |   68 +++++++++++++++++++-----------
 1 file changed, 44 insertions(+), 24 deletions(-)

diff -puN drivers/misc/sgi-gru/grufault.c~sgi-gru-restructure-the-gru-vtop-functions drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~sgi-gru-restructure-the-gru-vtop-functions
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -267,6 +267,44 @@ err:
 	return 1;
 }
 
+static int gru_vtop(struct gru_thread_state *gts, unsigned long vaddr,
+		    int write, int atomic, unsigned long *gpa, int *pageshift)
+{
+	struct mm_struct *mm = gts->ts_mm;
+	struct vm_area_struct *vma;
+	unsigned long paddr;
+	int ret, ps;
+
+	vma = find_vma(mm, vaddr);
+	if (!vma)
+		goto inval;
+
+	/*
+	 * Atomic lookup is faster & usually works even if called in non-atomic
+	 * context.
+	 */
+	rmb();	/* Must/check ms_range_active before loading PTEs */
+	ret = atomic_pte_lookup(vma, vaddr, write, &paddr, &ps);
+	if (ret) {
+		if (atomic)
+			goto upm;
+		if (non_atomic_pte_lookup(vma, vaddr, write, &paddr, &ps))
+			goto inval;
+	}
+	if (is_gru_paddr(paddr))
+		goto inval;
+	paddr = paddr & ~((1UL << ps) - 1);
+	*gpa = uv_soc_phys_ram_to_gpa(paddr);
+	*pageshift = ps;
+	return 0;
+
+inval:
+	return -1;
+upm:
+	return -2;
+}
+
+
 /*
  * Drop a TLB entry into the GRU. The fault is described by info in an TFH.
  *	Input:
@@ -281,10 +319,8 @@ static int gru_try_dropin(struct gru_thr
 			  struct gru_tlb_fault_handle *tfh,
 			  unsigned long __user *cb)
 {
-	struct mm_struct *mm = gts->ts_mm;
-	struct vm_area_struct *vma;
-	int pageshift, asid, write, ret;
-	unsigned long paddr, gpa, vaddr;
+	int pageshift = 0, asid, write, ret, atomic = !cb;
+	unsigned long gpa = 0, vaddr = 0;
 
 	/*
 	 * NOTE: The GRU contains magic hardware that eliminates races between
@@ -318,28 +354,12 @@ static int gru_try_dropin(struct gru_thr
 	if (atomic_read(&gts->ts_gms->ms_range_active))
 		goto failactive;
 
-	vma = find_vma(mm, vaddr);
-	if (!vma)
-		goto failinval;
-
-	/*
-	 * Atomic lookup is faster & usually works even if called in non-atomic
-	 * context.
-	 */
-	rmb();	/* Must/check ms_range_active before loading PTEs */
-	ret = atomic_pte_lookup(vma, vaddr, write, &paddr, &pageshift);
-	if (ret) {
-		if (!cb)
-			goto failupm;
-		if (non_atomic_pte_lookup(vma, vaddr, write, &paddr,
-					  &pageshift))
-			goto failinval;
-	}
-	if (is_gru_paddr(paddr))
+	ret = gru_vtop(gts, vaddr, write, atomic, &gpa, &pageshift);
+	if (ret == -1)
 		goto failinval;
+	if (ret == -2)
+		goto failupm;
 
-	paddr = paddr & ~((1UL << pageshift) - 1);
-	gpa = uv_soc_phys_ram_to_gpa(paddr);
 	gru_cb_set_istatus_active(cb);
 	tfh_write_restart(tfh, gpa, GAA_RAM, vaddr, asid, write,
 			  GRU_PAGESIZE(pageshift));
_

Patches currently in -mm which might be from steiner@sgi.com are

sgi-gru-add-definitions-of-x86_64-gru-mmrs.patch
sgi-gru-add-definitions-of-ia64-gru-mmrs.patch
sgi-gru-add-macros-for-using-the-uv-hub-to-send-interrupts.patch
sgi-gru-misc-gru-cleanup.patch
sgi-gru-improvements-to-gru-debug-messages-statistics.patch
sgi-gru-change-gru-cch-commands-from-inline-functions-to-outofline-functions.patch
sgi-gru-add-statistics-to-the-gru-context-management-functions.patch
sgi-gru-add-support-for-a-user-to-explicitly-unload-a-gru-context.patch
sgi-gru-asid-context-management-bug-fixes.patch
sgi-gru-restructure-the-gru-vtop-functions.patch
sgi-gru-add-support-to-the-gru-driver-for-message-queue-interrupts.patch
sgi-gru-macro-for-scanning-all-gru-chiplets.patch
sgi-gru-fix-bugs-related-to-module-unload-of-the-gru-driver.patch
sgi-gru-support-multiple-pagesizes-in-gru.patch

