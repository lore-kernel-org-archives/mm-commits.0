From: akpm@osdl.org
Subject: + serial-add-pcmcia-ids-for-quatech-dsp-100-dual-rs232.patch added to -mm tree
Date: Fri, 02 Feb 2007 17:15:21 -0800
Message-ID: <200702030115.l131FL8n022962@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47782 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933406AbXBCBPr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Feb 2007 20:15:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: osv@javad.com, alan@redhat.com, linux@dominikbrodowski.net, rmk@arm.linux.org.uk


The patch titled
     serial: Add PCMCIA IDs for Quatech DSP-100 dual RS232  adapter
has been added to the -mm tree.  Its filename is
     serial-add-pcmcia-ids-for-quatech-dsp-100-dual-rs232.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: serial: Add PCMCIA IDs for Quatech DSP-100 dual RS232  adapter
From: Sergei Organov <osv@javad.com>

Add PCMCIA IDs for Quatech DSP-100 dual RS232 adapter.

Signed-off-by: Sergei Organov <osv@javad.com>
Acked-by: Alan Cox <alan@redhat.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/serial/serial_cs.c |    5 +++++
 include/pcmcia/ciscode.h   |    1 +
 2 files changed, 6 insertions(+)

diff -puN drivers/serial/serial_cs.c~serial-add-pcmcia-ids-for-quatech-dsp-100-dual-rs232 drivers/serial/serial_cs.c
--- a/drivers/serial/serial_cs.c~serial-add-pcmcia-ids-for-quatech-dsp-100-dual-rs232
+++ a/drivers/serial/serial_cs.c
@@ -249,6 +249,10 @@ static const struct serial_quirk quirks[
 		.multi	= 2,
 	}, {
 		.manfid	= MANFID_QUATECH,
+		.prodid	= PRODID_QUATECH_DUAL_RS232_G,
+		.multi	= 2,
+	}, {
+		.manfid	= MANFID_QUATECH,
 		.prodid	= PRODID_QUATECH_QUAD_RS232,
 		.multi	= 4,
 	}, {
@@ -893,6 +897,7 @@ static struct pcmcia_device_id serial_id
 	PCMCIA_DEVICE_PROD_ID12("OEM      ", "C288MX     ", 0xb572d360, 0xd2385b7a),
 	PCMCIA_DEVICE_PROD_ID12("PCMCIA   ", "C336MX     ", 0x99bcafe9, 0xaa25bcab),
 	PCMCIA_DEVICE_PROD_ID12("Quatech Inc", "PCMCIA Dual RS-232 Serial Port Card", 0xc4420b35, 0x92abc92f),
+	PCMCIA_DEVICE_PROD_ID12("Quatech Inc", "Dual RS-232 Serial Port PC Card", 0xc4420b35, 0x031a380d),
 	PCMCIA_PFC_DEVICE_CIS_PROD_ID12(1, "PCMCIA", "EN2218-LAN/MODEM", 0x281f1c5d, 0x570f348e, "PCMLM28.cis"),
 	PCMCIA_PFC_DEVICE_CIS_PROD_ID12(1, "PCMCIA", "UE2218-LAN/MODEM", 0x281f1c5d, 0x6fdcacee, "PCMLM28.cis"),
 	PCMCIA_PFC_DEVICE_CIS_PROD_ID12(1, "Psion Dacom", "Gold Card V34 Ethernet", 0xf5f025c2, 0x338e8155, "PCMLM28.cis"),
diff -puN include/pcmcia/ciscode.h~serial-add-pcmcia-ids-for-quatech-dsp-100-dual-rs232 include/pcmcia/ciscode.h
--- a/include/pcmcia/ciscode.h~serial-add-pcmcia-ids-for-quatech-dsp-100-dual-rs232
+++ a/include/pcmcia/ciscode.h
@@ -95,6 +95,7 @@
 #define PRODID_QUATECH_DUAL_RS232	0x0012
 #define PRODID_QUATECH_DUAL_RS232_D1	0x0007
 #define PRODID_QUATECH_DUAL_RS232_D2	0x0052
+#define PRODID_QUATECH_DUAL_RS232_G	0x004d
 #define PRODID_QUATECH_QUAD_RS232	0x001b
 #define PRODID_QUATECH_DUAL_RS422	0x000e
 #define PRODID_QUATECH_QUAD_RS422	0x0045
_

Patches currently in -mm which might be from osv@javad.com are

char-mxser_new-alter-locking-in-isr.patch
char-mxser_new-fix-twice-resource-releasing.patch
char-mxser_new-do-not-null-driver_data.patch
char-mxser_new-lock-count-and-flags.patch
char-mxser_new-fix-sparse-warning.patch
serial-add-pcmcia-ids-for-quatech-dsp-100-dual-rs232.patch
