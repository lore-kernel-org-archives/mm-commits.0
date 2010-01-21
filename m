From: akpm@linux-foundation.org
Subject: [merged] kfifo-fix-kfifo_out_locked-race-bug.patch removed from -mm tree
Date: Thu, 21 Jan 2010 13:26:55 -0800
Message-ID: <201001212126.o0LLQtET030595@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52381 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755317Ab0AUV1d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 16:27:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefani@seibold.net, jhovold@gmail.com, zaitcev@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kfifo: fix kfifo_out_locked race bug
has been removed from the -mm tree.  Its filename was
     kfifo-fix-kfifo_out_locked-race-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kfifo: fix kfifo_out_locked race bug
From: Stefani Seibold <stefani@seibold.net>

Fix a wrong optimization in include/linux/kfifo.h which could cause a race
in kfifo_out_locked.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Reported-by: Johan Hovold <jhovold@gmail.com>
Cc: Pete Zaitcev <zaitcev@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfifo.h |    7 -------
 1 file changed, 7 deletions(-)

diff -puN include/linux/kfifo.h~kfifo-fix-kfifo_out_locked-race-bug include/linux/kfifo.h
--- a/include/linux/kfifo.h~kfifo-fix-kfifo_out_locked-race-bug
+++ a/include/linux/kfifo.h
@@ -228,13 +228,6 @@ static inline __must_check unsigned int 
 
 	ret = kfifo_out(fifo, to, n);
 
-	/*
-	 * optimization: if the FIFO is empty, set the indices to 0
-	 * so we don't wrap the next time
-	 */
-	if (kfifo_is_empty(fifo))
-		kfifo_reset(fifo);
