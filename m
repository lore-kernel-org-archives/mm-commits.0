From: akpm@linux-foundation.org
Subject: [merged] icom-fix-compile-errors-when-defining-icom_trace.patch removed from -mm tree
Date: Wed, 03 Jun 2009 13:02:47 -0700
Message-ID: <200906032002.n53K2l5r002031@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54287 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755189AbZFCUDZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jun 2009 16:03:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: leitao@linux.vnet.ibm.com, alan@lxorguk.ukuu.org.uk, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     icom: fix compile errors when defining ICOM_TRACE
has been removed from the -mm tree.  Its filename was
     icom-fix-compile-errors-when-defining-icom_trace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: icom: fix compile errors when defining ICOM_TRACE
From: Breno Leitao <leitao@linux.vnet.ibm.com>

As it is, defining ICOM_TRACE produces some compile errors, as "parameter
name omitted" and "redefinition of `trace'"

This patch removes the wrong trace definition.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/icom.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff -puN drivers/serial/icom.c~icom-fix-compile-errors-when-defining-icom_trace drivers/serial/icom.c
--- a/drivers/serial/icom.c~icom-fix-compile-errors-when-defining-icom_trace
+++ a/drivers/serial/icom.c
@@ -137,7 +137,12 @@ static LIST_HEAD(icom_adapter_head);
 static spinlock_t icom_lock;
 
 #ifdef ICOM_TRACE
-static inline void trace(struct icom_port *, char *, unsigned long) {};
+static inline void trace(struct icom_port *icom_port, char *trace_pt,
+			unsigned long trace_data)
+{
+	dev_info(&icom_port->adapter->pci_dev->dev, ":%d:%s - %lx\n",
+	icom_port->port, trace_pt, trace_data);
+}
 #else
 static inline void trace(struct icom_port *icom_port, char *trace_pt, unsigned long trace_data) {};
 #endif
@@ -1644,15 +1649,6 @@ static void __exit icom_exit(void)
 module_init(icom_init);
 module_exit(icom_exit);
 
-#ifdef ICOM_TRACE
-static inline void trace(struct icom_port *icom_port, char *trace_pt,
-		  unsigned long trace_data)
-{
-	dev_info(&icom_port->adapter->pci_dev->dev, ":%d:%s - %lx\n",
-		 icom_port->port, trace_pt, trace_data);
-}
-#endif
