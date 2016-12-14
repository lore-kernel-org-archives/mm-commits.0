From: akpm@linux-foundation.org
Subject: [merged] pcmcia-m32r_pcc-check-return-from-request_irq.patch
 removed from -mm tree
Date: Wed, 14 Dec 2016 11:22:58 -0800
Message-ID: <58519c12.d/B58fYHkm2Azgiv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43834 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756499AbcLNTW7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:22:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, sudip.mukherjee@codethink.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/pcmcia/m32r_pcc.c: check return from request_irq
has been removed from the -mm tree.  Its filename was
     pcmcia-m32r_pcc-check-return-from-request_irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: drivers/pcmcia/m32r_pcc.c: check return from request_irq

While building m32r allmodconfig we were getting warning:

drivers/pcmcia/m32r_pcc.c:331:2:
 warning: ignoring return value of 'request_irq',
 declared with attribute warn_unused_result

request_irq() can fail and we should always be checking the result from
it. Check the result and return it to the caller.

Link: http://lkml.kernel.org/r/1474237304-897-1-git-send-email-sudipm.mukherjee@gmail.com
Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/m32r_pcc.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN drivers/pcmcia/m32r_pcc.c~pcmcia-m32r_pcc-check-return-from-request_irq drivers/pcmcia/m32r_pcc.c
--- a/drivers/pcmcia/m32r_pcc.c~pcmcia-m32r_pcc-check-return-from-request_irq
+++ a/drivers/pcmcia/m32r_pcc.c
@@ -296,10 +296,11 @@ static int __init is_alive(u_short sock)
 	return 0;
 }
 
-static void add_pcc_socket(ulong base, int irq, ulong mapaddr,
-			   unsigned int ioaddr)
+static int add_pcc_socket(ulong base, int irq, ulong mapaddr,
+			  unsigned int ioaddr)
 {
   	pcc_socket_t *t = &socket[pcc_sockets];
+	int err;
 
 	/* add sockets */
 	t->ioaddr = ioaddr;
@@ -328,11 +329,16 @@ static void add_pcc_socket(ulong base, i
 	t->socket.irq_mask = 0;
 	t->socket.pci_irq = 2 + pcc_sockets; /* XXX */
 
-	request_irq(irq, pcc_interrupt, 0, "m32r-pcc", pcc_interrupt);
+	err = request_irq(irq, pcc_interrupt, 0, "m32r-pcc", pcc_interrupt);
+	if (err) {
+		if (t->base > 0)
+			release_region(t->base, 0x20);
+		return err;
+	}
 
 	pcc_sockets++;
 
-	return;
+	return 0;
 }
 
 
_

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are


