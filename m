From: akpm@linux-foundation.org
Subject: [merged] jsm-rewriting-a-bad-log-message.patch removed from -mm tree
Date: Fri, 09 Oct 2009 15:05:29 -0700
Message-ID: <200910092205.n99M5T42021524@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934683AbZJIWGU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Oct 2009 18:06:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: leitao@linux.vnet.ibm.com, greg@kroah.com, scottk@digi.com, mm-commits@vger.kernel.org


The patch titled
     jsm: rewrite a bad log message
has been removed from the -mm tree.  Its filename was
     jsm-rewriting-a-bad-log-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jsm: rewrite a bad log message
From: Breno Leitao <leitao@linux.vnet.ibm.com>

jsm displays "Device Added" 8 times (for a 8 port device).  This patch
just makes things more informative, showing the port (instead of the
device) that was added.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
Cc: Greg KH <greg@kroah.com>
Cc: Scott Kilau <scottk@digi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/jsm/jsm_tty.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/jsm/jsm_tty.c~jsm-rewriting-a-bad-log-message drivers/serial/jsm/jsm_tty.c
--- a/drivers/serial/jsm/jsm_tty.c~jsm-rewriting-a-bad-log-message
+++ a/drivers/serial/jsm/jsm_tty.c
@@ -472,7 +472,7 @@ int __devinit jsm_uart_port_init(struct 
 		if (uart_add_one_port (&jsm_uart_driver, &brd->channels[i]->uart_port))
 			printk(KERN_INFO "jsm: add device failed\n");
 		else
-			printk(KERN_INFO "Added device \n");
+			printk(KERN_INFO "jsm: Port %d added\n", i);
 	}
 
 	jsm_printk(INIT, INFO, &brd->pci_dev, "finish\n");
_

Patches currently in -mm which might be from leitao@linux.vnet.ibm.com are

linux-next.patch

