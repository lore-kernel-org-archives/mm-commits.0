From: akpm@linux-foundation.org
Subject: + jsm-defining-init-function-as-__devinit.patch added to -mm tree
Date: Wed, 11 Mar 2009 15:22:43 -0700
Message-ID: <200903112222.n2BMMhTn010919@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753356AbZCKWYh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Mar 2009 18:24:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: leitao@linux.vnet.ibm.com, Scott.Kilau@digi.com, alan@lxorguk.ukuu.org.uk, jirislaby@gmail.com


The patch titled
     jsm: define init function as __devinit
has been added to the -mm tree.  Its filename is
     jsm-defining-init-function-as-__devinit.patch

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
Subject: jsm: define init function as __devinit
From: Breno Leitao <leitao@linux.vnet.ibm.com>

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Scott Kilau <Scott.Kilau@digi.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/jsm/jsm_driver.c |    2 +-
 drivers/serial/jsm/jsm_tty.c    |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/serial/jsm/jsm_driver.c~jsm-defining-init-function-as-__devinit drivers/serial/jsm/jsm_driver.c
--- a/drivers/serial/jsm/jsm_driver.c~jsm-defining-init-function-as-__devinit
+++ a/drivers/serial/jsm/jsm_driver.c
@@ -52,7 +52,7 @@ int jsm_debug;
 module_param(jsm_debug, int, 0);
 MODULE_PARM_DESC(jsm_debug, "Driver debugging level");
 
-static int jsm_probe_one(struct pci_dev *pdev, const struct pci_device_id *ent)
+static int __devinit jsm_probe_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int rc = 0;
 	struct jsm_board *brd;
diff -puN drivers/serial/jsm/jsm_tty.c~jsm-defining-init-function-as-__devinit drivers/serial/jsm/jsm_tty.c
--- a/drivers/serial/jsm/jsm_tty.c~jsm-defining-init-function-as-__devinit
+++ a/drivers/serial/jsm/jsm_tty.c
@@ -366,7 +366,7 @@ static struct uart_ops jsm_ops = {
  * Init the tty subsystem.  Called once per board after board has been
  * downloaded and init'ed.
  */
-int jsm_tty_init(struct jsm_board *brd)
+int __devinit jsm_tty_init(struct jsm_board *brd)
 {
 	int i;
 	void __iomem *vaddr;
@@ -430,7 +430,7 @@ int jsm_tty_init(struct jsm_board *brd)
 	return 0;
 }
 
-int jsm_uart_port_init(struct jsm_board *brd)
+int __devinit jsm_uart_port_init(struct jsm_board *brd)
 {
 	int i;
 	struct jsm_channel *ch;
_

Patches currently in -mm which might be from leitao@linux.vnet.ibm.com are

linux-next.patch
jsm-cleanup.patch
icom-converting-space-to-tabs.patch
icom-removing-unused-variables.patch
jsm-defining-init-function-as-__devinit.patch

