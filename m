From: akpm@linux-foundation.org
Subject: + gru-improve-messages-for-malfunctioning-grus.patch added to -mm tree
Date: Tue, 24 Nov 2009 11:58:21 -0800
Message-ID: <200911241958.nAOJwLJ1018508@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49775 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932718AbZKXT6R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Nov 2009 14:58:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     gru: improve messages for malfunctioning GRUs
has been added to the -mm tree.  Its filename is
     gru-improve-messages-for-malfunctioning-grus.patch

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
Subject: gru: improve messages for malfunctioning GRUs
From: Jack Steiner <steiner@sgi.com>

Improve error messages for malfunctioning GRUs.  Identify the type of
instruction that is failing.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/gruhandles.c |   22 +++++++++++++++++++---
 drivers/misc/sgi-gru/gruhandles.h |    6 ++++++
 2 files changed, 25 insertions(+), 3 deletions(-)

diff -puN drivers/misc/sgi-gru/gruhandles.c~gru-improve-messages-for-malfunctioning-grus drivers/misc/sgi-gru/gruhandles.c
--- a/drivers/misc/sgi-gru/gruhandles.c~gru-improve-messages-for-malfunctioning-grus
+++ a/drivers/misc/sgi-gru/gruhandles.c
@@ -54,6 +54,21 @@ static void start_instruction(void *h)
 	gru_flush_cache(h);
 }
 
+static void report_instruction_timeout(void *h)
+{
+	unsigned long goff = GSEGPOFF((unsigned long)h);
+	char *id = "???";
+
+	if (TYPE_IS(CCH, goff))
+		id = "CCH";
+	else if (TYPE_IS(TGH, goff))
+		id = "TGH";
+	else if (TYPE_IS(TFH, goff))
+		id = "TFH";
+
+	panic(KERN_ALERT "GRU %p (%s) is malfunctioning\n", h, id);
+}
+
 static int wait_instruction_complete(void *h, enum mcs_op opc)
 {
 	int status;
@@ -64,9 +79,10 @@ static int wait_instruction_complete(voi
 		status = GET_MSEG_HANDLE_STATUS(h);
 		if (status != CCHSTATUS_ACTIVE)
 			break;
-		if (GRU_OPERATION_TIMEOUT < (get_cycles() - start_time))
-			panic("GRU %p is malfunctioning: start %ld, end %ld\n",
-			      h, start_time, (unsigned long)get_cycles());
+		if (GRU_OPERATION_TIMEOUT < (get_cycles() - start_time)) {
+			report_instruction_timeout(h);
+			start_time = get_cycles();
+		}
 	}
 	if (gru_options & OPT_STATS)
 		update_mcs_stats(opc, get_cycles() - start_time);
diff -puN drivers/misc/sgi-gru/gruhandles.h~gru-improve-messages-for-malfunctioning-grus drivers/misc/sgi-gru/gruhandles.h
--- a/drivers/misc/sgi-gru/gruhandles.h~gru-improve-messages-for-malfunctioning-grus
+++ a/drivers/misc/sgi-gru/gruhandles.h
@@ -91,6 +91,12 @@
 /* Convert an arbitrary handle address to the beginning of the GRU segment */
 #define GRUBASE(h)		((void *)((unsigned long)(h) & ~(GRU_SIZE - 1)))
 
+/* Test a valid handle address to determine the type */
+#define TYPE_IS(hn, h)		((h) >= GRU_##hn##_BASE && (h) <	\
+		GRU_##hn##_BASE + GRU_NUM_##hn * GRU_HANDLE_STRIDE &&   \
+		(((h) & (GRU_HANDLE_STRIDE - 1)) == 0))
+
+
 /* General addressing macros. */
 static inline void *get_gseg_base_address(void *base, int ctxnum)
 {
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

