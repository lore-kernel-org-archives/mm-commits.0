From: akpm@linux-foundation.org
Subject: + gru-cleanup-gru-inline-functions.patch added to -mm tree
Date: Mon, 08 Jun 2009 16:11:24 -0700
Message-ID: <200906082311.n58NBOPg031069@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751883AbZFHXLY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jun 2009 19:11:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     gru: cleanup gru inline functions
has been added to the -mm tree.  Its filename is
     gru-cleanup-gru-inline-functions.patch

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
Subject: gru: cleanup gru inline functions
From: Jack Steiner <steiner@sgi.com>

Cleanup of GRU inline functions to eliminate unnecessary inline code. 
Update function descriptions.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/gru_instructions.h |   33 ++++++++++------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff -puN drivers/misc/sgi-gru/gru_instructions.h~gru-cleanup-gru-inline-functions drivers/misc/sgi-gru/gru_instructions.h
--- a/drivers/misc/sgi-gru/gru_instructions.h~gru-cleanup-gru-inline-functions
+++ a/drivers/misc/sgi-gru/gru_instructions.h
@@ -623,9 +623,11 @@ static inline int gru_get_cb_substatus(v
 	return cbs->isubstatus;
 }
 
-/* Check the status of a CB. If the CB is in UPM mode, call the
- * OS to handle the UPM status.
- * Returns the CB status field value (0 for normal completion)
+/*
+ * User interface to check an instruction status. UPM and exceptions
+ * are handled automatically. However, this function does NOT wait
+ * for an active instruction to complete.
+ *
  */
 static inline int gru_check_status(void *cb)
 {
@@ -633,34 +635,31 @@ static inline int gru_check_status(void 
 	int ret;
 
 	ret = cbs->istatus;
-	if (ret == CBS_CALL_OS)
+	if (ret != CBS_ACTIVE)
 		ret = gru_check_status_proc(cb);
 	return ret;
 }
 
-/* Wait for CB to complete.
- * Returns the CB status field value (0 for normal completion)
+/*
+ * User interface (via inline function) to wait for an instruction
+ * to complete. Completion status (IDLE or EXCEPTION is returned
+ * to the user. Exception due to hardware errors are automatically
+ * retried before returning an exception.
+ *
  */
 static inline int gru_wait(void *cb)
 {
-	struct gru_control_block_status *cbs = (void *)cb;
-	int ret = cbs->istatus;
-
-	if (ret != CBS_IDLE)
-		ret = gru_wait_proc(cb);
-	return ret;
+	return gru_wait_proc(cb);
 }
 
-/* Wait for CB to complete. Aborts program if error. (Note: error does NOT
+/*
+ * Wait for CB to complete. Aborts program if error. (Note: error does NOT
  * mean TLB mis - only fatal errors such as memory parity error or user
  * bugs will cause termination.
  */
 static inline void gru_wait_abort(void *cb)
 {
-	struct gru_control_block_status *cbs = (void *)cb;
-
-	if (cbs->istatus != CBS_IDLE)
-		gru_wait_abort_proc(cb);
+	gru_wait_abort_proc(cb);
 }
 
 
_

Patches currently in -mm which might be from steiner@sgi.com are

linux-next.patch
page-allocator-clear-n_high_memory-map-before-se-set-it-again.patch
gru-bug-fixes-for-gru-exception-handling.patch
gru-dump-chiplet-state.patch
gru-dump-chiplet-state-update.patch
gru-dynamic-allocation-of-kernel-contexts.patch
gru-dynamic-allocation-of-kernel-contexts-update.patch
gru-change-context-load-and-unload.patch
gru-support-cch_allocate-for-kernel-threads.patch
gru-change-resource-assignment-for-kernel-threads.patch
gru-support-contexts-with-zero-dsrs-or-cbrs.patch
gru-fix-handling-of-mesq-failures.patch
gru-check-context-state-on-reload.patch
gru-support-instruction-completion-interrupts.patch
gru-support-for-asynchronous-gru-instructions.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
gru-update-gru-kernel-self-tests.patch
gru-update-gru-kernel-self-tests-fix.patch
gru-update-to-rev-09-of-gru-spec.patch
gru-fix-cache-coherency-issues-with-instruction-retry.patch
gru-add-user-request-to-explicitly-unload-a-gru-context.patch
gru-fix-automatic-retry-of-gru-instruction-failures.patch
gru-collect-per-context-user-statistics.patch
gru-delete-user-request-for-fetching-chiplet-status.patch
gru-cleanup-gru-inline-functions.patch
gru-generic-infrastructure-for-context-options.patch
gru-add-user-request-to-specify-gru-slice.patch
gru-fix-potential-use-after-free-when-purging-gru-tlbs.patch
gru-fixes-to-grudump-utility.patch
gru-remove-references-to-the-obsolete-global-status-handle.patch
gru-copyright-fixes.patch

