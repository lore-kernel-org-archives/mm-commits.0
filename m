From: akpm@linux-foundation.org
Subject: [merged] rapidio-apply-rx-tx-enable-to-active-switch-ports-only.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:20:32 -0700
Message-ID: <20121005202032.AD2181E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:38327 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUUd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:20:33 -0400
Received: by mail-vb0-f74.google.com with SMTP id s24so237420vbi.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:20:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: apply RX/TX enable to active switch ports only
has been removed from the -mm tree.  Its filename was
     rapidio-apply-rx-tx-enable-to-active-switch-ports-only.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: apply RX/TX enable to active switch ports only

Apply port RX/TX enable operations only to active switch ports.

RapidIO specification (Part 6: LP-Serial Physical Layer) recommends to
keep Output Port Enable (TX) and Input Port Enable (RX) control bits in
disabled state (0b0) after device reset.  It also allows to have
implementation specific reset state for these bits.

This patch ensures that TX/RX enable action is applied only to active
switch's ports while preserving an initial state of inactive ones.

This patch is intended to keep inactive switch ports with inbound and
outbound packet transfers disabled to block unexpected packets during hot
insertion event.  While it does not fix any visible malfunction it is
intended to prevent such events in future.  

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/rapidio/rio-scan.c~rapidio-apply-rx-tx-enable-to-active-switch-ports-only drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-apply-rx-tx-enable-to-active-switch-ports-only
+++ a/drivers/rapidio/rio-scan.c
@@ -839,12 +839,10 @@ static int __devinit rio_enum_peer(struc
 		for (port_num = 0;
 		     port_num < RIO_GET_TOTAL_PORTS(rdev->swpinfo);
 		     port_num++) {
-			/*Enable Input Output Port (transmitter reviever)*/
-			rio_enable_rx_tx_port(port, 0,
+			if (sw_inport == port_num) {
+				rio_enable_rx_tx_port(port, 0,
 					      RIO_ANY_DESTID(port->sys_size),
 					      hopcount, port_num);
