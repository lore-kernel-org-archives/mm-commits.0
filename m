From: akpm@linux-foundation.org
Subject: - serial-clear-proper-mpsc-interrupt-cause-bits.patch removed from -mm tree
Date: Fri, 29 Jun 2007 13:41:07 -0700
Message-ID: <200706292041.l5TKf7hv022553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32954 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755206AbXF2Uup (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jun 2007 16:50:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaylubo@motorola.com, mgreer@mvista.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     serial: clear proper MPSC interrupt cause bits
has been removed from the -mm tree.  Its filename was
     serial-clear-proper-mpsc-interrupt-cause-bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: serial: clear proper MPSC interrupt cause bits
From: Jay Lubomirski <jaylubo@motorola.com>

The interrupt clearing code in mpsc_sdma_intr_ack() mistakenly clears the
interrupt for both controllers instead of just the one its supposed to.
This can result in the other controller appearing to hang because its
interrupt was effectively lost.

So, don't clear the interrupt cause bits for both MPSC controllers when
clearing the interrupt for one of them.  Just clear the one that is
supposed to be cleared.

Signed-off-by: Jay Lubomirski <jaylubo@motorola.com>
Acked-by: Mark A. Greer <mgreer@mvista.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/mpsc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

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

origin.patch
