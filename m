From: akpm@linux-foundation.org
Subject: - serial-mpsc-set-baudrate-when-brg-divider-is-set.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:27:54 -0800
Message-ID: <200802052227.m15MRZah011807@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59043 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932232AbYBEWnD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgreer@mvista.com, mm-commits@vger.kernel.org


The patch titled
     serial: MPSC: set baudrate when BRG divider is set.
has been removed from the -mm tree.  Its filename was
     serial-mpsc-set-baudrate-when-brg-divider-is-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: MPSC: set baudrate when BRG divider is set.
From: Mark A. Greer <mgreer@mvista.com>

The clock to generate the desired baudrate with the MPSC is first divided
by the Baud Rate Generator (BRG) and then by the MPSC itself.  So, when the
BRG divider is changed, the MPSC divider must also be changed to generate
the correct baudrate.  During MPSC initialization, the BRG divider is
changed but the MPSC divider isn't changed until much later.  This results
in some printk's coming out garbled.  To fix that, set the MPSC divider at
the same time that the BRG divider is changed.

Signed-off-by: Mark A. Greer <mgreer@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/mpsc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/serial/mpsc.c~serial-mpsc-set-baudrate-when-brg-divider-is-set drivers/serial/mpsc.c
--- a/drivers/serial/mpsc.c~serial-mpsc-set-baudrate-when-brg-divider-is-set
+++ a/drivers/serial/mpsc.c
@@ -612,6 +612,7 @@ static void mpsc_hw_init(struct mpsc_por
 
 	/* No preamble, 16x divider, low-latency, */
 	writel(0x04400400, pi->mpsc_base + MPSC_MMCRH);
+	mpsc_set_baudrate(pi, pi->default_baud);
 
 	if (pi->mirror_regs) {
 		pi->MPSC_CHR_1_m = 0;
_

Patches currently in -mm which might be from mgreer@mvista.com are

origin.patch
