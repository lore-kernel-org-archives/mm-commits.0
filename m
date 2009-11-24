From: akpm@linux-foundation.org
Subject: + gru-update-gru-structures-to-match-latest-hardware-spec.patch added to -mm tree
Date: Tue, 24 Nov 2009 11:58:52 -0800
Message-ID: <200911241958.nAOJwq2q019783@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932763AbZKXT6s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Nov 2009 14:58:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     gru: update GRU structures to match latest hardware spec
has been added to the -mm tree.  Its filename is
     gru-update-gru-structures-to-match-latest-hardware-spec.patch

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
Subject: gru: update GRU structures to match latest hardware spec
From: Jack Steiner <steiner@sgi.com>

Add a few new definitions for chipset MMR field names.  This matches rev
0.7 of the hardware spec.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/gru_instructions.h |    5 ++++-
 drivers/misc/sgi-gru/gruhandles.h       |   11 +++++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff -puN drivers/misc/sgi-gru/gru_instructions.h~gru-update-gru-structures-to-match-latest-hardware-spec drivers/misc/sgi-gru/gru_instructions.h
--- a/drivers/misc/sgi-gru/gru_instructions.h~gru-update-gru-structures-to-match-latest-hardware-spec
+++ a/drivers/misc/sgi-gru/gru_instructions.h
@@ -265,6 +265,7 @@ struct gru_instruction {
 #define CBE_CAUSE_PROTOCOL_STATE_DATA_ERROR	(1 << 16)
 #define CBE_CAUSE_RA_RESPONSE_DATA_ERROR	(1 << 17)
 #define CBE_CAUSE_HA_RESPONSE_DATA_ERROR	(1 << 18)
+#define CBE_CAUSE_FORCED_ERROR			(1 << 19)
 
 /* CBE cbrexecstatus bits */
 #define CBR_EXS_ABORT_OCC_BIT			0
@@ -273,13 +274,15 @@ struct gru_instruction {
 #define CBR_EXS_QUEUED_BIT			3
 #define CBR_EXS_TLB_INVAL_BIT			4
 #define CBR_EXS_EXCEPTION_BIT			5
+#define CBR_EXS_CB_INT_PENDING_BIT		6
 
 #define CBR_EXS_ABORT_OCC			(1 << CBR_EXS_ABORT_OCC_BIT)
 #define CBR_EXS_INT_OCC				(1 << CBR_EXS_INT_OCC_BIT)
 #define CBR_EXS_PENDING				(1 << CBR_EXS_PENDING_BIT)
 #define CBR_EXS_QUEUED				(1 << CBR_EXS_QUEUED_BIT)
-#define CBR_TLB_INVAL				(1 << CBR_EXS_TLB_INVAL_BIT)
+#define CBR_EXS_TLB_INVAL			(1 << CBR_EXS_TLB_INVAL_BIT)
 #define CBR_EXS_EXCEPTION			(1 << CBR_EXS_EXCEPTION_BIT)
+#define CBR_EXS_CB_INT_PENDING			(1 << CBR_EXS_CB_INT_PENDING_BIT)
 
 /*
  * Exceptions are retried for the following cases. If any OTHER bits are set
diff -puN drivers/misc/sgi-gru/gruhandles.h~gru-update-gru-structures-to-match-latest-hardware-spec drivers/misc/sgi-gru/gruhandles.h
--- a/drivers/misc/sgi-gru/gruhandles.h~gru-update-gru-structures-to-match-latest-hardware-spec
+++ a/drivers/misc/sgi-gru/gruhandles.h
@@ -252,6 +252,17 @@ enum gru_tgh_state {
 	TGHSTATE_RESTART_CTX,
 };
 
+enum gru_tgh_cause {
+	TGHCAUSE_RR_ECC,
+	TGHCAUSE_TLB_ECC,
+	TGHCAUSE_LRU_ECC,
+	TGHCAUSE_PS_ECC,
+	TGHCAUSE_MUL_ERR,
+	TGHCAUSE_DATA_ERR,
+	TGHCAUSE_SW_FORCE
+};
+
+
 /*
  * TFH - TLB Global Handle
  * 	Used for TLB dropins into the GRU TLB.
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

