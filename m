From: akpm@linux-foundation.org
Subject: - parport_serial-netmos-9855-fix.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:24:47 -0800
Message-ID: <200802070024.m170OSai006610@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58714 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932448AbYBGAqQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:46:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chripell@fsfe.org, bjorn.helgaas@hp.com, ms@gewi.kfunigraz.ac.at, thor@math.TU-Berlin.DE, mm-commits@vger.kernel.org


The patch titled
     parport_serial: netmos 9855 fix
has been removed from the -mm tree.  Its filename was
     parport_serial-netmos-9855-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: parport_serial: netmos 9855 fix
From: Christian Pellegrin <chripell@fsfe.org>

Fix wrong netmos 9855 serial port configuration.

On loading only one serial port was present and it wasn't working.  After
looking in the data sheet I realized that the base address was wrong.  For
further reference here is lspci and relevant dmesg output:

02:00.0 Communication controller: NetMos Technology PCI 9855 Multi-I/O
Controller (rev 01) (prog-if 02)
        Subsystem: LSI Logic / Symbios Logic Unknown device 0022
        Flags: medium devsel, IRQ 19
        I/O ports at df00 [size=8]
        I/O ports at de00 [size=8]
        I/O ports at dd00 [size=8]
        I/O ports at dc00 [size=8]
        I/O ports at db00 [size=8]
        I/O ports at da00 [size=16]

parport1: PC-style at 0xdd00 [PCSPP,TRISTATE]
parport2: PC-style at 0xdf00 [PCSPP,TRISTATE,EPP]
0000:02:00.0: ttyS0 at I/O 0xdb00 (irq = 19) is a 16550A
0000:02:00.0: ttyS1 at I/O 0xda00 (irq = 19) is a 16550A

Signed-off-by: Christian Pellegrin <chripell@fsfe.org>
Cc: Thomas Richter <thor@math.TU-Berlin.DE>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Martin Schitter <ms@gewi.kfunigraz.ac.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_serial.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/parport/parport_serial.c~parport_serial-netmos-9855-fix drivers/parport/parport_serial.c
--- a/drivers/parport/parport_serial.c~parport_serial-netmos-9855-fix
+++ a/drivers/parport/parport_serial.c
@@ -77,7 +77,7 @@ static struct parport_pc_pci cards[] __d
 	/* titan_110l */		{ 1, { { 3, -1 }, } },
 	/* titan_210l */		{ 1, { { 3, -1 }, } },
 	/* netmos_9xx5_combo */		{ 1, { { 2, -1 }, }, netmos_parallel_init },
-	/* netmos_9855 */		{ 1, { { 0, -1 }, }, netmos_parallel_init },
+	/* netmos_9855 */		{ 1, { { 2, -1 }, }, netmos_parallel_init },
 	/* avlab_1s1p     */		{ 1, { { 1, 2}, } },
 	/* avlab_1s2p     */		{ 2, { { 1, 2}, { 3, 4 },} },
 	/* avlab_2s1p     */		{ 1, { { 2, 3}, } },
@@ -185,7 +185,7 @@ static struct pciserial_board pci_parpor
 		.uart_offset	= 8,
 	},
 	[netmos_9855] = {
-		.flags		= FL_BASE2 | FL_BASE_BARS,
+		.flags		= FL_BASE4 | FL_BASE_BARS,
 		.num_ports	= 1,
 		.base_baud	= 115200,
 		.uart_offset	= 8,
_

Patches currently in -mm which might be from chripell@fsfe.org are

origin.patch
