From: akpm@linux-foundation.org
Subject: + cciss-add-performant-mode-support-for-stars-sirius-move-next_command-function-from-ifdef.patch added to -mm tree
Date: Fri, 04 Jun 2010 16:50:56 -0700
Message-ID: <201006042350.o54Nou8t025382@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757454Ab0FDXvI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jun 2010 19:51:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike.miller@hp.com, axboe@kernel.dk, scameron@beardog.cce.hp.com


The patch titled
     cciss: move next_command function from ifdef
has been added to the -mm tree.  Its filename is
     cciss-add-performant-mode-support-for-stars-sirius-move-next_command-function-from-ifdef.patch

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
Subject: cciss: move next_command function from ifdef
From: Mike Miller <mike.miller@hp.com>

The definition of next_command also ended up in wrong place It ended up
inside an "#ifdef CONFIG_PROCFS".  Already caught by Randy Dunlap and a
couple others.  Tried to put it somewhere that made sense.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |   45 ++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff -puN drivers/block/cciss.c~cciss-add-performant-mode-support-for-stars-sirius-move-next_command-function-from-ifdef drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-add-performant-mode-support-for-stars-sirius-move-next_command-function-from-ifdef
+++ a/drivers/block/cciss.c
@@ -205,6 +205,7 @@ static void cciss_hba_release(struct dev
 static void cciss_device_release(struct device *dev);
 static void cciss_free_gendisk(ctlr_info_t *h, int drv_index);
 static void cciss_free_drive_info(ctlr_info_t *h, int drv_index);
+static inline u32 next_command(ctlr_info_t *h);
 
 /* performant mode helper functions */
 static void  calc_bucket_map(int *bucket, int num_buckets, int nsgs,
@@ -366,28 +367,6 @@ static const char *raid_label[] = { "0",
 
 #ifdef CONFIG_PROC_FS
 
-static inline u32 next_command(ctlr_info_t *h)
-{
-	u32 a;
-
-	if (unlikely(h->transMethod != CFGTBL_Trans_Performant))
-		return h->access.command_completed(h);
-
-	if ((*(h->reply_pool_head) & 1) == (h->reply_pool_wraparound)) {
-		a = *(h->reply_pool_head); /* Next cmd in ring buffer */
-		(h->reply_pool_head)++;
-		h->commands_outstanding--;
-	} else {
-		a = FIFO_EMPTY;
-	}
-	/* Check for wraparound */
-	if (h->reply_pool_head == (h->reply_pool + h->max_commands)) {
-		h->reply_pool_head = h->reply_pool;
-		h->reply_pool_wraparound ^= 1;
-	}
-	return a;
-}
-
 /*
  * Report information about this controller.
  */
@@ -3403,6 +3382,28 @@ static inline void finish_cmd(ctlr_info_
 #endif
 }
 
+static inline u32 next_command(ctlr_info_t *h)
+{
+	u32 a;
+
+	if (unlikely(h->transMethod != CFGTBL_Trans_Performant))
+		return h->access.command_completed(h);
+
+	if ((*(h->reply_pool_head) & 1) == (h->reply_pool_wraparound)) {
+		a = *(h->reply_pool_head); /* Next cmd in ring buffer */
+		(h->reply_pool_head)++;
+		h->commands_outstanding--;
+	} else {
+		a = FIFO_EMPTY;
+	}
+	/* Check for wraparound */
+	if (h->reply_pool_head == (h->reply_pool + h->max_commands)) {
+		h->reply_pool_head = h->reply_pool;
+		h->reply_pool_wraparound ^= 1;
+	}
+	return a;
+}
+
 /* process completion of an indexed ("direct lookup") command */
 static inline u32 process_indexed_cmd(ctlr_info_t *h, u32 raw_tag)
 {
_

Patches currently in -mm which might be from mike.miller@hp.com are

cciss-enqueue-and-submit-io.patch
cciss-clean-up-interrupt-handler.patch
cciss-clean-up-interrupt-handler-make-sure-we-request-the-performant-mode-irq.patch
cciss-check-for-msi-in-interrupt_not_for_us.patch
cciss-make-interrupt-access-methods-return-type-bool.patch
cciss-add-performant-mode-support-for-stars-sirius.patch
cciss-add-performant-mode-support-for-stars-sirius-fix-call-to-put_controller_in_performant_mode.patch
cciss-add-performant-mode-support-for-stars-sirius-move-next_command-function-from-ifdef.patch
cciss-add-performant-mode-support-for-stars-sirius-remove-errant-debug-code.patch
cciss-add-performant-mode-support-for-stars-sirius-change-pad-value-from-32-to-0.patch
cciss-new-controller-support-and-bump-driver-version.patch

