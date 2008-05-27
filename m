From: akpm@linux-foundation.org
Subject: - serial-support-for-instashield-is-400-four-port-rs-232-pci-card.patch removed from -mm tree
Date: Tue, 27 May 2008 00:26:58 -0700
Message-ID: <200805270726.m4R7QwH0014716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756164AbYE0HbA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 03:31:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iggarpe@t2i.com, mm-commits@vger.kernel.org


The patch titled
     serial: support for InstaShield IS-400 four port RS-232 PCI card
has been removed from the -mm tree.  Its filename was
     serial-support-for-instashield-is-400-four-port-rs-232-pci-card.pa=
tch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: serial: support for InstaShield IS-400 four port RS-232 PCI ca=
rd
=46rom: Ignacio Garc=EDa P=E9rez <iggarpe@t2i.com>

Add support for the InstaShield IS-400 four port RS-232 PCI card.

Signed-off-by: Ignacio Garc=EDa P=E9rez <iggarpe@t2i.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pci.c |    7 ++++++-
 include/linux/pci_ids.h   |    1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/serial/8250_pci.c~serial-support-for-instashield-is-4=
00-four-port-rs-232-pci-card drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~serial-support-for-instashield-is-400-f=
our-port-rs-232-pci-card
+++ a/drivers/serial/8250_pci.c
@@ -2602,7 +2602,12 @@ static struct pci_device_id serial_pci_t
 	{	PCI_VENDOR_ID_INTASHIELD, PCI_DEVICE_ID_INTASHIELD_IS200,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,	/* 135a.0811 */
 		pbn_b2_2_115200 },
-
+	/*
+	 * IntaShield IS-400
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, PCI_DEVICE_ID_INTASHIELD_IS400,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,    /* 135a.0dc0 */
+		pbn_b2_4_115200 },
 	/*
 	 * Perle PCI-RAS cards
 	 */
diff -puN include/linux/pci_ids.h~serial-support-for-instashield-is-400=
-four-port-rs-232-pci-card include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~serial-support-for-instashield-is-400-fou=
r-port-rs-232-pci-card
+++ a/include/linux/pci_ids.h
@@ -1761,6 +1761,7 @@
=20
 #define PCI_VENDOR_ID_INTASHIELD	0x135a
 #define PCI_DEVICE_ID_INTASHIELD_IS200	0x0d80
+#define PCI_DEVICE_ID_INTASHIELD_IS400	0x0dc0
=20
 #define PCI_VENDOR_ID_QUATECH		0x135C
 #define PCI_DEVICE_ID_QUATECH_QSC100	0x0010
_

Patches currently in -mm which might be from iggarpe@t2i.com are


--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
