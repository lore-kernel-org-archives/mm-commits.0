From: akpm@linux-foundation.org
Subject: + kfifo-fix-kfifo_out_locked-race-bug.patch added to -mm tree
Date: Fri, 08 Jan 2010 15:15:22 -0800
Message-ID: <201001082315.o08NFMoS019948@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752161Ab0AHXPw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jan 2010 18:15:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stefani@seibold.net, jhovold@gmail.com, zaitcev@redhat.com


The patch titled
     kfifo: fix kfifo_out_locked race bug
has been added to the -mm tree.  Its filename is
     kfifo-fix-kfifo_out_locked-race-bug.patch

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
