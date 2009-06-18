From: akpm@linux-foundation.org
Subject: [merged] gru-fix-automatic-retry-of-gru-instruction-failures.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:48:58 -0700
Message-ID: <200906182248.n5IMmwDU008028@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758235AbZFRWt0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:49:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: fix automatic retry of gru instruction failures
has been removed from the -mm tree.  Its filename was
     gru-fix-automatic-retry-of-gru-instruction-failures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
