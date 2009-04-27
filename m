From: akpm@linux-foundation.org
Subject: + jsm-remove-unused-spinlock.patch added to -mm tree
Date: Mon, 27 Apr 2009 13:00:02 -0700
Message-ID: <200904272000.n3RK022t031570@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758601AbZD0UBx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Apr 2009 16:01:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: leitao@linux.vnet.ibm.com, alan@lxorguk.ukuu.org.uk


The patch titled
     jsm: remove unused spinlock
has been added to the -mm tree.  Its filename is
     jsm-remove-unused-spinlock.patch

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
Subject: jsm: remove unused spinlock
From: Breno Leitao <leitao@linux.vnet.ibm.com>

Remove the bd_lock spinlock (inside jsm_board structure).  The lock is
initialized in the probe function and not used anymore.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/jsm/jsm.h        |    2 --
 drivers/serial/jsm/jsm_driver.c |    1 -
 2 files changed, 3 deletions(-)

diff -puN drivers/serial/jsm/jsm.h~jsm-remove-unused-spinlock drivers/serial/jsm/jsm.h
--- a/drivers/serial/jsm/jsm.h~jsm-remove-unused-spinlock
+++ a/drivers/serial/jsm/jsm.h
@@ -130,8 +130,6 @@ struct jsm_board
 	struct pci_dev	*pci_dev;
 	u32		maxports;	/* MAX ports this board can handle */
 
-	spinlock_t	bd_lock;	/* Used to protect board */
