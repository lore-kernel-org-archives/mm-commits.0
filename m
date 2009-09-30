From: akpm@linux-foundation.org
Subject: + jsm-rewriting-a-bad-log-message.patch added to -mm tree
Date: Wed, 30 Sep 2009 13:56:56 -0700
Message-ID: <200909302056.n8UKuutA013455@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753764AbZI3U45 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Sep 2009 16:56:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: leitao@linux.vnet.ibm.com, greg@kroah.com, scottk@digi.com


The patch titled
     jsm: rewrite a bad log message
has been added to the -mm tree.  Its filename is
     jsm-rewriting-a-bad-log-message.patch

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

jsm-irq-handlers-doesnt-need-to-have-irq_disabled-enabled.patch
jsm-rewriting-a-bad-log-message.patch
icom-converting-space-to-tabs.patch

