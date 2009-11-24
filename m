From: akpm@linux-foundation.org
Subject: + gru-fix-bug-in-exception-handling.patch added to -mm tree
Date: Tue, 24 Nov 2009 11:58:44 -0800
Message-ID: <200911241958.nAOJwiii019476@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932748AbZKXT6k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Nov 2009 14:58:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     gru: fix bug in exception handling
has been added to the -mm tree.  Its filename is
     gru-fix-bug-in-exception-handling.patch

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
Subject: gru: fix bug in exception handling
From: Jack Steiner <steiner@sgi.com>

Fix a GRU driver bug converting a CBR address to the context that contains
the CBR.  The conversion is rarely done so performance does not matter.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grukservices.c |   30 +++++++++++++++++++-------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff -puN drivers/misc/sgi-gru/grukservices.c~gru-fix-bug-in-exception-handling drivers/misc/sgi-gru/grukservices.c
--- a/drivers/misc/sgi-gru/grukservices.c~gru-fix-bug-in-exception-handling
+++ a/drivers/misc/sgi-gru/grukservices.c
@@ -97,9 +97,6 @@
 #define ASYNC_HAN_TO_BID(h)	((h) - 1)
 #define ASYNC_BID_TO_HAN(b)	((b) + 1)
 #define ASYNC_HAN_TO_BS(h)	gru_base[ASYNC_HAN_TO_BID(h)]
-#define KCB_TO_GID(cb)		((cb - gru_start_vaddr) /		\
-					(GRU_SIZE * GRU_CHIPLETS_PER_BLADE))
-#define KCB_TO_BS(cb)		gru_base[KCB_TO_GID(cb)]
 
 #define GRU_NUM_KERNEL_CBR	1
 #define GRU_NUM_KERNEL_DSR_BYTES 256
@@ -388,11 +385,28 @@ int gru_get_cb_exception_detail(void *cb
 		struct control_block_extended_exc_detail *excdet)
 {
 	struct gru_control_block_extended *cbe;
-	struct gru_blade_state *bs;
-	int cbrnum;
-
-	bs = KCB_TO_BS(cb);
-	cbrnum = thread_cbr_number(bs->bs_kgts, get_cb_number(cb));
+	struct gru_thread_state *kgts = NULL;
+	unsigned long off;
+	int cbrnum, bid;
+
+	/*
+	 * Locate kgts for cb. This algorithm is SLOW but
+	 * this function is rarely called (ie., almost never).
+	 * Performance does not matter.
+	 */
+	for_each_possible_blade(bid) {
+		if (!gru_base[bid])
+			break;
+		kgts = gru_base[bid]->bs_kgts;
+		if (!kgts || !kgts->ts_gru)
+			continue;
+		off = cb - kgts->ts_gru->gs_gru_base_vaddr;
+		if (off < GRU_SIZE)
+			break;
+		kgts = NULL;
+	}
+	BUG_ON(!kgts);
+	cbrnum = thread_cbr_number(kgts, get_cb_number(cb));
 	cbe = get_cbe(GRUBASE(cb), cbrnum);
 	gru_flush_cache(cbe);	/* CBE not coherent */
 	sync_core();
_

Patches currently in -mm which might be from steiner@sgi.com are

linux-next.patch
x86-uv-introduce-a-means-to-translate-from-gpa-socket_paddr.patch
x86-uv-xpc-needs-to-provide-an-abstraction-for-uv_gpa.patch
x86-uv-introduce-uv_gpa_is_mmr.patch
x86-uv-implement-a-gru_read_gpa-kernel-function.patch
x86-uv-update-xpc-to-handle-updated-bios-interface.patch
x86-uv-xpc-null-deref-when-mesq-becomes-empty.patch
x86-uv-xpc_make_first_contact-hang-due-to-not-accepting-active-state.patch
x86-uv-xpc-receive-message-reuse-triggers-invalid-bug_on.patch
gru-initial-gru-based-on-blade-topology.patch
gru-add-comments-raised-in-previous-code-reviews.patch
gru-fix-istatus-race-in-gru-tlb-dropin.patch
gru-handle-blades-without-memory.patch
gru-allow-users-to-specify-gru-chiplet-1.patch
gru-allow-users-to-specify-gru-chiplet-2.patch
gru-allow-users-to-specify-gru-chiplet-3.patch
gru-fix-bug-in-module-unload.patch
gru-improve-messages-for-malfunctioning-grus.patch
gru-support-64-bit-gru-addresses.patch
gru-handle-failures-to-mmu_notifier_register.patch
gru-add-debug-option-for-cache-flushing.patch
gru-add-test-for-gru_copy_gpa.patch
gru-check-for-valid-vma.patch
gru-fix-prefetch-and-speculation-bugs.patch
gru-update-irq-infrastructure.patch
gru-add-additional-gru-statistics.patch
gru-expicitly-set-instruction-status-to-active.patch
gru-preload-tlb-for-bcopy-instructions.patch
gru-fix-bug-in-exception-handling.patch
gru-add-symbolic-names-for-gru-error-code.patch
gru-remove-stray-local_irq_enable.patch
gru-check-for-correct-gru-chiplet-assignment.patch
gru-update-gru-structures-to-match-latest-hardware-spec.patch
gru-fix-bug-in-allocation-of-kernel-contexts.patch
gru-add-hugepage-support.patch
gru-fix-gru-interrupt-race-at-deallocate.patch
gru-improve-gru-tlb-dropin-statistics.patch
gru-update-driver-version-number.patch

