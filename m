From: akpm@linux-foundation.org
Subject: [merged] pcmcia-m32r_pcc-check-return-from-add_pcc_socket.patch
 removed from -mm tree
Date: Wed, 14 Dec 2016 11:23:02 -0800
Message-ID: <58519c16.lCucfyn3V73Do4SG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43846 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756499AbcLNTXD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:23:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, sudip.mukherjee@codethink.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/pcmcia/m32r_pcc.c: check return from add_pcc_socket
has been removed from the -mm tree.  Its filename was
     pcmcia-m32r_pcc-check-return-from-add_pcc_socket.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: drivers/pcmcia/m32r_pcc.c: check return from add_pcc_socket

If request_irq() fails it passes the error to the caller. The caller
now checks it and jumps to the common error path on failure.

Link: http://lkml.kernel.org/r/1474237304-897-3-git-send-email-sudipm.mukherjee@gmail.com
Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/m32r_pcc.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/pcmcia/m32r_pcc.c~pcmcia-m32r_pcc-check-return-from-add_pcc_socket drivers/pcmcia/m32r_pcc.c
--- a/drivers/pcmcia/m32r_pcc.c~pcmcia-m32r_pcc-check-return-from-add_pcc_socket
+++ a/drivers/pcmcia/m32r_pcc.c
@@ -696,10 +696,16 @@ static int __init init_m32r_pcc(void)
 
 	pcc_sockets = 0;
 
-	add_pcc_socket(M32R_PCC0_BASE, PCC0_IRQ, M32R_PCC0_MAPBASE, 0x1000);
+	ret = add_pcc_socket(M32R_PCC0_BASE, PCC0_IRQ, M32R_PCC0_MAPBASE,
+			     0x1000);
+	if (ret)
+		goto unreg_dev;
 
 #ifdef CONFIG_M32RPCC_SLOT2
-	add_pcc_socket(M32R_PCC1_BASE, PCC1_IRQ, M32R_PCC1_MAPBASE, 0x2000);
+	ret = add_pcc_socket(M32R_PCC1_BASE, PCC1_IRQ, M32R_PCC1_MAPBASE,
+			     0x2000);
+	if (ret)
+		goto unreg_dev;
 #endif
 
 	if (pcc_sockets == 0) {
_

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are


