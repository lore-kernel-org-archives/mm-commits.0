From: akpm@linux-foundation.org
Subject: + jsm-remove-ch_cpstime-field.patch added to -mm tree
Date: Thu, 01 Oct 2009 13:54:21 -0700
Message-ID: <200910012054.n91KsLjb014489@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075AbZJAUzJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Oct 2009 16:55:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: leitao@linux.vnet.ibm.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, scottk@digi.com


The patch titled
     jsm: remove ch_cpstime field
has been added to the -mm tree.  Its filename is
     jsm-remove-ch_cpstime-field.patch

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
Subject: jsm: remove ch_cpstime field
From: Breno Leitao <leitao@linux.vnet.ibm.com>

Currently the field jsm_channel->ch_cpstime is defined but never used, so
this patch removes it.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
Cc: Greg KH <greg@kroah.com>
Cc: Scott Kilau <scottk@digi.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/jsm/jsm.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/serial/jsm/jsm.h~jsm-remove-ch_cpstime-field drivers/serial/jsm/jsm.h
--- a/drivers/serial/jsm/jsm.h~jsm-remove-ch_cpstime-field
+++ a/drivers/serial/jsm/jsm.h
@@ -206,8 +206,6 @@ struct jsm_channel {
 
 	u64		ch_close_delay;	/* How long we should drop RTS/DTR for */
 
-	u64		ch_cpstime;	/* Time for CPS calculations	*/
