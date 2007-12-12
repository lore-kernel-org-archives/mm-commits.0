From: akpm@linux-foundation.org
Subject: + parport_serial-netmos-9855-fix.patch added to -mm tree
Date: Wed, 12 Dec 2007 01:16:44 -0800
Message-ID: <200712120916.lBC9Giah002679@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45229 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757818AbXLLJRO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 04:17:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chripell@fsfe.org, bjorn.helgaas@hp.com, ms@gewi.kfunigraz.ac.at, thor@math.TU-Berlin.DE


The patch titled
     parport_serial: netmos 9855 fix
has been added to the -mm tree.  Its filename is
     parport_serial-netmos-9855-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: parport_serial: netmos 9855 fix
From: Christian Pellegrin <chripell@fsfe.org>

Fix wrong netmos 9855 serial port configuration.

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

parport_serial-netmos-9855-fix.patch
