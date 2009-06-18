From: akpm@linux-foundation.org
Subject: [merged] gru-cleanup-gru-inline-functions.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:49:04 -0700
Message-ID: <200906182249.n5IMn4fa008146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54243 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756605AbZFRWwC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:52:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: cleanup gru inline functions
has been removed from the -mm tree.  Its filename was
     gru-cleanup-gru-inline-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
