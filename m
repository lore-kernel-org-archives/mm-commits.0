From: akpm@linux-foundation.org
Subject: [patch 010/123] drivers/pcmcia/m32r_pcc.c: check return from
 add_pcc_socket
Date: Mon, 12 Dec 2016 16:41:05 -0800
Message-ID: <584f43a1.fLpTvfgipJi/gzJU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40410 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753038AbcLMAlG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:41:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, sudipm.mukherjee@gmail.com, sudip.mukherjee@codethink.co.uk

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
