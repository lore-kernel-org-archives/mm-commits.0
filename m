From: akpm@linux-foundation.org
Subject: [merged] sgi-gru-change-gru-cch-commands-from-inline-functions-to-outofline-functions.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:37:27 -0700
Message-ID: <200904061937.n36JbR5H012945@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752162AbZDFT5A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:57:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     sgi-gru: change GRU CCH commands from inline functions to outofline functions
has been removed from the -mm tree.  Its filename was
     sgi-gru-change-gru-cch-commands-from-inline-functions-to-outofline-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-gru: change GRU CCH commands from inline functions to outofline functions
From: Jack Steiner <steiner@sgi.com>

Change the GRU instructions that manage contexts from inline functions to
out-of-line functions.  This simplifies adding statistics & error checking
to these functions.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/Makefile     |    2 
 drivers/misc/sgi-gru/gruhandles.c |  197 ++++++++++++++++++++++++++++
 drivers/misc/sgi-gru/gruhandles.h |  174 ++----------------------
 drivers/misc/sgi-gru/grutables.h  |    3 
 4 files changed, 217 insertions(+), 159 deletions(-)

diff -puN drivers/misc/sgi-gru/Makefile~sgi-gru-change-gru-cch-commands-from-inline-functions-to-outofline-functions drivers/misc/sgi-gru/Makefile
--- a/drivers/misc/sgi-gru/Makefile~sgi-gru-change-gru-cch-commands-from-inline-functions-to-outofline-functions
+++ a/drivers/misc/sgi-gru/Makefile
@@ -3,5 +3,5 @@ ifdef CONFIG_SGI_GRU_DEBUG
 endif
 
 obj-$(CONFIG_SGI_GRU) := gru.o
-gru-y := grufile.o grumain.o grufault.o grutlbpurge.o gruprocfs.o grukservices.o
+gru-y := grufile.o grumain.o grufault.o grutlbpurge.o gruprocfs.o grukservices.o gruhandles.o
 
diff -puN /dev/null drivers/misc/sgi-gru/gruhandles.c
--- /dev/null
+++ a/drivers/misc/sgi-gru/gruhandles.c
@@ -0,0 +1,197 @@
+/*
+ *              GRU KERNEL MCS INSTRUCTIONS
+ *
+ *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+
+#include <linux/kernel.h>
+#include "gru.h"
+#include "grulib.h"
+#include "grutables.h"
+
+/* 10 sec */
+#ifdef CONFIG_IA64
+#include <asm/processor.h>
+#define GRU_OPERATION_TIMEOUT	(((cycles_t) local_cpu_data->itc_freq)*10)
+#else
+#include <asm/tsc.h>
+#define GRU_OPERATION_TIMEOUT	((cycles_t) tsc_khz*10*1000)
+#endif
+
+/* Extract the status field from a kernel handle */
+#define GET_MSEG_HANDLE_STATUS(h)	(((*(unsigned long *)(h)) >> 16) & 3)
+
+static void start_instruction(void *h)
+{
+	unsigned long *w0 = h;
+
+	wmb();		/* setting CMD bit must be last */
+	*w0 = *w0 | 1;
+	gru_flush_cache(h);
+}
+
+static int wait_instruction_complete(void *h, enum mcs_op opc)
+{
+	int status;
+	cycles_t start_time = get_cycles();
+
+	while (1) {
+		cpu_relax();
+		status = GET_MSEG_HANDLE_STATUS(h);
+		if (status != CCHSTATUS_ACTIVE)
+			break;
+		if (GRU_OPERATION_TIMEOUT < (get_cycles() - start_time))
+			panic("GRU %p is malfunctioning\n", h);
+	}
+	return status;
+}
+
+#if defined CONFIG_IA64
+static void cch_allocate_set_asids(
+		  struct gru_context_configuration_handle *cch, int asidval)
+{
+	int i;
+
+	for (i = 0; i < 8; i++) {
+		cch->asid[i] = (asidval++);
+#if 0
+		/* ZZZ hugepages not supported yet */
+		if (i == RGN_HPAGE)
+			cch->sizeavail[i] = GRU_SIZEAVAIL(hpage_shift);
+		else
+#endif
+			cch->sizeavail[i] = GRU_SIZEAVAIL(PAGE_SHIFT);
+	}
+}
+#elif defined CONFIG_X86_64
+static void cch_allocate_set_asids(
+		  struct gru_context_configuration_handle *cch, int asidval)
+{
+	int i;
+
+	for (i = 0; i < 8; i++) {
+		cch->asid[i] = asidval++;
+		cch->sizeavail[i] = GRU_SIZEAVAIL(PAGE_SHIFT) |
+			GRU_SIZEAVAIL(21);
+	}
+}
+#endif
+
+int cch_allocate(struct gru_context_configuration_handle *cch,
+			       int asidval, unsigned long cbrmap,
+			       unsigned long dsrmap)
+{
+	cch_allocate_set_asids(cch, asidval);
+	cch->dsr_allocation_map = dsrmap;
+	cch->cbr_allocation_map = cbrmap;
+	cch->opc = CCHOP_ALLOCATE;
+	start_instruction(cch);
+	return wait_instruction_complete(cch, cchop_allocate);
+}
+
+int cch_start(struct gru_context_configuration_handle *cch)
+{
+	cch->opc = CCHOP_START;
+	start_instruction(cch);
+	return wait_instruction_complete(cch, cchop_start);
+}
+
+int cch_interrupt(struct gru_context_configuration_handle *cch)
+{
+	cch->opc = CCHOP_INTERRUPT;
+	start_instruction(cch);
+	return wait_instruction_complete(cch, cchop_interrupt);
+}
+
+int cch_deallocate(struct gru_context_configuration_handle *cch)
+{
+	cch->opc = CCHOP_DEALLOCATE;
+	start_instruction(cch);
+	return wait_instruction_complete(cch, cchop_deallocate);
+}
+
+int cch_interrupt_sync(struct gru_context_configuration_handle
+				     *cch)
+{
+	cch->opc = CCHOP_INTERRUPT_SYNC;
+	start_instruction(cch);
+	return wait_instruction_complete(cch, cchop_interrupt_sync);
+}
+
+int tgh_invalidate(struct gru_tlb_global_handle *tgh,
+				 unsigned long vaddr, unsigned long vaddrmask,
+				 int asid, int pagesize, int global, int n,
+				 unsigned short ctxbitmap)
+{
+	tgh->vaddr = vaddr;
+	tgh->asid = asid;
+	tgh->pagesize = pagesize;
+	tgh->n = n;
+	tgh->global = global;
+	tgh->vaddrmask = vaddrmask;
+	tgh->ctxbitmap = ctxbitmap;
+	tgh->opc = TGHOP_TLBINV;
+	start_instruction(tgh);
+	return wait_instruction_complete(tgh, tghop_invalidate);
+}
+
+void tfh_write_only(struct gru_tlb_fault_handle *tfh,
+				  unsigned long pfn, unsigned long vaddr,
+				  int asid, int dirty, int pagesize)
+{
+	tfh->fillasid = asid;
+	tfh->fillvaddr = vaddr;
+	tfh->pfn = pfn;
+	tfh->dirty = dirty;
+	tfh->pagesize = pagesize;
+	tfh->opc = TFHOP_WRITE_ONLY;
+	start_instruction(tfh);
+}
+
+void tfh_write_restart(struct gru_tlb_fault_handle *tfh,
+				     unsigned long paddr, int gaa,
+				     unsigned long vaddr, int asid, int dirty,
+				     int pagesize)
+{
+	tfh->fillasid = asid;
+	tfh->fillvaddr = vaddr;
+	tfh->pfn = paddr >> GRU_PADDR_SHIFT;
+	tfh->gaa = gaa;
+	tfh->dirty = dirty;
+	tfh->pagesize = pagesize;
+	tfh->opc = TFHOP_WRITE_RESTART;
+	start_instruction(tfh);
+}
+
+void tfh_restart(struct gru_tlb_fault_handle *tfh)
+{
+	tfh->opc = TFHOP_RESTART;
+	start_instruction(tfh);
+}
+
+void tfh_user_polling_mode(struct gru_tlb_fault_handle *tfh)
+{
+	tfh->opc = TFHOP_USER_POLLING_MODE;
+	start_instruction(tfh);
+}
+
+void tfh_exception(struct gru_tlb_fault_handle *tfh)
+{
+	tfh->opc = TFHOP_EXCEPTION;
+	start_instruction(tfh);
+}
+
diff -puN drivers/misc/sgi-gru/gruhandles.h~sgi-gru-change-gru-cch-commands-from-inline-functions-to-outofline-functions drivers/misc/sgi-gru/gruhandles.h
--- a/drivers/misc/sgi-gru/gruhandles.h~sgi-gru-change-gru-cch-commands-from-inline-functions-to-outofline-functions
+++ a/drivers/misc/sgi-gru/gruhandles.h
@@ -495,164 +495,22 @@ enum gru_cbr_state {
 /* minimum TLB purge count to ensure a full purge */
 #define GRUMAXINVAL		1024UL
 
+int cch_allocate(struct gru_context_configuration_handle *cch,
+       int asidval, unsigned long cbrmap, unsigned long dsrmap);
 
-/* Extract the status field from a kernel handle */
-#define GET_MSEG_HANDLE_STATUS(h)	(((*(unsigned long *)(h)) >> 16) & 3)
-
-static inline void start_instruction(void *h)
-{
-	unsigned long *w0 = h;
-
-	wmb();		/* setting CMD bit must be last */
-	*w0 = *w0 | 1;
-	gru_flush_cache(h);
-}
-
-static inline int wait_instruction_complete(void *h)
-{
-	int status;
-
-	do {
-		cpu_relax();
-		barrier();
-		status = GET_MSEG_HANDLE_STATUS(h);
-	} while (status == CCHSTATUS_ACTIVE);
-	return status;
-}
-
-#if defined CONFIG_IA64
-static inline void cch_allocate_set_asids(
-		  struct gru_context_configuration_handle *cch, int asidval)
-{
-	int i;
-
-	for (i = 0; i <= RGN_HPAGE; i++) {  /*  assume HPAGE is last region */
-		cch->asid[i] = (asidval++);
-#if 0
-		/* ZZZ hugepages not supported yet */
-		if (i == RGN_HPAGE)
-			cch->sizeavail[i] = GRU_SIZEAVAIL(hpage_shift);
-		else
-#endif
-			cch->sizeavail[i] = GRU_SIZEAVAIL(PAGE_SHIFT);
-	}
-}
-#elif defined CONFIG_X86_64
-static inline void cch_allocate_set_asids(
-		  struct gru_context_configuration_handle *cch, int asidval)
-{
-	int i;
-
-	for (i = 0; i < 8; i++) {
-		cch->asid[i] = asidval++;
-		cch->sizeavail[i] = GRU_SIZEAVAIL(PAGE_SHIFT) |
-			GRU_SIZEAVAIL(21);
-	}
-}
-#endif
-
-static inline int cch_allocate(struct gru_context_configuration_handle *cch,
-			       int asidval, unsigned long cbrmap,
-			       unsigned long dsrmap)
-{
-	cch_allocate_set_asids(cch, asidval);
-	cch->dsr_allocation_map = dsrmap;
-	cch->cbr_allocation_map = cbrmap;
-	cch->opc = CCHOP_ALLOCATE;
-	start_instruction(cch);
-	return wait_instruction_complete(cch);
-}
-
-static inline int cch_start(struct gru_context_configuration_handle *cch)
-{
-	cch->opc = CCHOP_START;
-	start_instruction(cch);
-	return wait_instruction_complete(cch);
-}
-
-static inline int cch_interrupt(struct gru_context_configuration_handle *cch)
-{
-	cch->opc = CCHOP_INTERRUPT;
-	start_instruction(cch);
-	return wait_instruction_complete(cch);
-}
-
-static inline int cch_deallocate(struct gru_context_configuration_handle *cch)
-{
-	cch->opc = CCHOP_DEALLOCATE;
-	start_instruction(cch);
-	return wait_instruction_complete(cch);
-}
-
-static inline int cch_interrupt_sync(struct gru_context_configuration_handle
-				     *cch)
-{
-	cch->opc = CCHOP_INTERRUPT_SYNC;
-	start_instruction(cch);
-	return wait_instruction_complete(cch);
-}
-
-static inline int tgh_invalidate(struct gru_tlb_global_handle *tgh,
-				 unsigned long vaddr, unsigned long vaddrmask,
-				 int asid, int pagesize, int global, int n,
-				 unsigned short ctxbitmap)
-{
-	tgh->vaddr = vaddr;
-	tgh->asid = asid;
-	tgh->pagesize = pagesize;
-	tgh->n = n;
-	tgh->global = global;
-	tgh->vaddrmask = vaddrmask;
-	tgh->ctxbitmap = ctxbitmap;
-	tgh->opc = TGHOP_TLBINV;
-	start_instruction(tgh);
-	return wait_instruction_complete(tgh);
-}
-
-static inline void tfh_write_only(struct gru_tlb_fault_handle *tfh,
-				  unsigned long pfn, unsigned long vaddr,
-				  int asid, int dirty, int pagesize)
-{
-	tfh->fillasid = asid;
-	tfh->fillvaddr = vaddr;
-	tfh->pfn = pfn;
-	tfh->dirty = dirty;
-	tfh->pagesize = pagesize;
-	tfh->opc = TFHOP_WRITE_ONLY;
-	start_instruction(tfh);
-}
-
-static inline void tfh_write_restart(struct gru_tlb_fault_handle *tfh,
-				     unsigned long paddr, int gaa,
-				     unsigned long vaddr, int asid, int dirty,
-				     int pagesize)
-{
-	tfh->fillasid = asid;
-	tfh->fillvaddr = vaddr;
-	tfh->pfn = paddr >> GRU_PADDR_SHIFT;
-	tfh->gaa = gaa;
-	tfh->dirty = dirty;
-	tfh->pagesize = pagesize;
-	tfh->opc = TFHOP_WRITE_RESTART;
-	start_instruction(tfh);
-}
-
-static inline void tfh_restart(struct gru_tlb_fault_handle *tfh)
-{
-	tfh->opc = TFHOP_RESTART;
-	start_instruction(tfh);
-}
-
-static inline void tfh_user_polling_mode(struct gru_tlb_fault_handle *tfh)
-{
-	tfh->opc = TFHOP_USER_POLLING_MODE;
-	start_instruction(tfh);
-}
-
-static inline void tfh_exception(struct gru_tlb_fault_handle *tfh)
-{
-	tfh->opc = TFHOP_EXCEPTION;
-	start_instruction(tfh);
-}
+int cch_start(struct gru_context_configuration_handle *cch);
+int cch_interrupt(struct gru_context_configuration_handle *cch);
+int cch_deallocate(struct gru_context_configuration_handle *cch);
+int cch_interrupt_sync(struct gru_context_configuration_handle *cch);
+int tgh_invalidate(struct gru_tlb_global_handle *tgh, unsigned long vaddr,
+	unsigned long vaddrmask, int asid, int pagesize, int global, int n,
+	unsigned short ctxbitmap);
+void tfh_write_only(struct gru_tlb_fault_handle *tfh, unsigned long pfn,
+	unsigned long vaddr, int asid, int dirty, int pagesize);
+void tfh_write_restart(struct gru_tlb_fault_handle *tfh, unsigned long paddr,
+	int gaa, unsigned long vaddr, int asid, int dirty, int pagesize);
+void tfh_restart(struct gru_tlb_fault_handle *tfh);
+void tfh_user_polling_mode(struct gru_tlb_fault_handle *tfh);
+void tfh_exception(struct gru_tlb_fault_handle *tfh);
 
 #endif /* __GRUHANDLES_H__ */
diff -puN drivers/misc/sgi-gru/grutables.h~sgi-gru-change-gru-cch-commands-from-inline-functions-to-outofline-functions drivers/misc/sgi-gru/grutables.h
--- a/drivers/misc/sgi-gru/grutables.h~sgi-gru-change-gru-cch-commands-from-inline-functions-to-outofline-functions
+++ a/drivers/misc/sgi-gru/grutables.h
@@ -239,6 +239,9 @@ struct gru_stats_s {
 
 };
 
+enum mcs_op {cchop_allocate, cchop_start, cchop_interrupt, cchop_interrupt_sync,
+	cchop_deallocate, tghop_invalidate, mcsop_last};
+
 #define OPT_DPRINT	1
 #define OPT_STATS	2
 #define GRU_QUICKLOOK	4
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

