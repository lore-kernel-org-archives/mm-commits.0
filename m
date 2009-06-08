From: akpm@linux-foundation.org
Subject: + gru-fix-automatic-retry-of-gru-instruction-failures.patch added to -mm tree
Date: Mon, 08 Jun 2009 16:11:18 -0700
Message-ID: <200906082311.n58NBI8Z031004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41578 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756164AbZFHXLS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jun 2009 19:11:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     gru: fix automatic retry of gru instruction failures
has been added to the -mm tree.  Its filename is
     gru-fix-automatic-retry-of-gru-instruction-failures.patch

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
Subject: gru: fix automatic retry of gru instruction failures
From: Jack Steiner <steiner@sgi.com>

Fix bug in automatic retry of GRU instruction failures.  CBR substatus
(message queue failure) was being checked incorrectly.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grukservices.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/misc/sgi-gru/grukservices.c~gru-fix-automatic-retry-of-gru-instruction-failures drivers/misc/sgi-gru/grukservices.c
--- a/drivers/misc/sgi-gru/grukservices.c~gru-fix-automatic-retry-of-gru-instruction-failures
+++ a/drivers/misc/sgi-gru/grukservices.c
@@ -436,11 +436,10 @@ static int gru_retry_exception(void *cb)
 	int retry = EXCEPTION_RETRY_LIMIT;
 
 	while (1)  {
-		if (gru_get_cb_message_queue_substatus(cb))
-			break;
 		if (gru_wait_idle_or_exception(gen) == CBS_IDLE)
 			return CBS_IDLE;
-
+		if (gru_get_cb_message_queue_substatus(cb))
+			return CBS_EXCEPTION;
 		gru_get_cb_exception_detail(cb, &excdet);
 		if ((excdet.ecause & ~EXCEPTION_RETRY_BITS) ||
 				(excdet.cbrexecstatus & CBR_EXS_ABORT_OCC))
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

