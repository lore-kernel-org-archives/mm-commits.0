From: akpm@linux-foundation.org
Subject: + serial-clear-proper-mpsc-interrupt-cause-bits.patch added to -mm tree
Date: Sat, 23 Jun 2007 09:51:32 -0700
Message-ID: <200706231651.l5NGpTXT019594@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51855 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756518AbXFWQvn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 12:51:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaylubo@motorola.com, mgreer@mvista.com


The patch titled
     serial: clear proper MPSC interrupt cause bits
has been added to the -mm tree.  Its filename is
     serial-clear-proper-mpsc-interrupt-cause-bits.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: serial: clear proper MPSC interrupt cause bits
From: Jay Lubomirski <jaylubo@motorola.com>

Don't clobber the interrupt cause bits for both MPSC controllers when
clearing the interrupt for one of them.  Just clear the one that is
supposed to be cleared.

Signed-off-by: Jay Lubomirski <jaylubo@motorola.com>
Acked-by: Mark A. Greer <mgreer@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/mpsc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/serial/mpsc.c~serial-clear-proper-mpsc-interrupt-cause-bits drivers/serial/mpsc.c
--- a/drivers/serial/mpsc.c~serial-clear-proper-mpsc-interrupt-cause-bits
+++ a/drivers/serial/mpsc.c
@@ -503,7 +503,8 @@ mpsc_sdma_intr_ack(struct mpsc_port_info
 
 	if (pi->mirror_regs)
 		pi->shared_regs->SDMA_INTR_CAUSE_m = 0;
-	writel(0, pi->shared_regs->sdma_intr_base + SDMA_INTR_CAUSE);
+	writeb(0x00, pi->shared_regs->sdma_intr_base + SDMA_INTR_CAUSE +
+	       pi->port.line);
 	return;
 }
 
_

Patches currently in -mm which might be from jaylubo@motorola.com are

serial-clear-proper-mpsc-interrupt-cause-bits.patch
