From: akpm@linux-foundation.org
Subject: + smc911x-remove-duplicate-debug-printout.patch added to -mm tree
Date: Mon, 08 Sep 2008 16:02:58 -0700
Message-ID: <200809082302.m88N2wp5014763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752695AbYIHXDn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Sep 2008 19:03:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: damm@igel.co.jp, jacmet@sunsite.dk


The patch titled
     smc911x: remove duplicate debug printout
has been added to the -mm tree.  Its filename is
     smc911x-remove-duplicate-debug-printout.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: smc911x: remove duplicate debug printout
From: Magnus Damm <damm@igel.co.jp>

Remove duplicated debug printout.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/smc911x.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/net/smc911x.c~smc911x-remove-duplicate-debug-printout drivers/net/smc911x.c
--- a/drivers/net/smc911x.c~smc911x-remove-duplicate-debug-printout
+++ a/drivers/net/smc911x.c
@@ -1174,8 +1174,6 @@ static irqreturn_t smc911x_interrupt(int
 
 	spin_unlock_irqrestore(&lp->lock, flags);
 
-	DBG(3, "%s: Interrupt done (%d loops)\n", dev->name, 8-timeout);
