From: akpm@linux-foundation.org
Subject: [merged] jsm-remove-unused-spinlock.patch removed from -mm tree
Date: Wed, 29 Apr 2009 12:18:00 -0700
Message-ID: <200904291918.n3TJI0ZX030863@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53216 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753152AbZD2TTq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Apr 2009 15:19:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: leitao@linux.vnet.ibm.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     jsm: remove unused spinlock
has been removed from the -mm tree.  Its filename was
     jsm-remove-unused-spinlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
