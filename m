From: akpm@linux-foundation.org
Subject: + char-mxser-add-support-for-cp112ul.patch added to -mm tree
Date: Fri, 11 Sep 2009 14:34:51 -0700
Message-ID: <200909112134.n8BLYpcd020721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53607 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754010AbZIKVf2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Sep 2009 17:35:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     Char: mxser, add support for CP112UL
has been added to the -mm tree.  Its filename is
     char-mxser-add-support-for-cp112ul.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: mxser, add support for CP112UL
From: Jiri Slaby <jirislaby@gmail.com>

Add support for MOXA:0x1120 pci device.  It's a 2-port device and differs
in no way from the others.  So this turns out to be a trivial
pci_device_id change.

Also increase the version number.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/char/mxser.c~char-mxser-add-support-for-cp112ul drivers/char/mxser.c
--- a/drivers/char/mxser.c~char-mxser-add-support-for-cp112ul
+++ a/drivers/char/mxser.c
@@ -48,7 +48,7 @@
 
 #include "mxser.h"
 
-#define	MXSER_VERSION	"2.0.4"		/* 1.12 */
+#define	MXSER_VERSION	"2.0.5"		/* 1.14 */
 #define	MXSERMAJOR	 174
 
 #define MXSER_BOARDS		4	/* Max. boards */
@@ -69,6 +69,7 @@
 #define PCI_DEVICE_ID_POS104UL	0x1044
 #define PCI_DEVICE_ID_CB108	0x1080
 #define PCI_DEVICE_ID_CP102UF	0x1023
+#define PCI_DEVICE_ID_CP112UL	0x1120
 #define PCI_DEVICE_ID_CB114	0x1142
 #define PCI_DEVICE_ID_CP114UL	0x1143
 #define PCI_DEVICE_ID_CB134I	0x1341
@@ -139,7 +140,8 @@ static const struct mxser_cardinfo mxser
 	{ "CP-138U series",	8, },
 	{ "POS-104UL series",	4, },
 	{ "CP-114UL series",	4, },
-/*30*/	{ "CP-102UF series",	2, }
+/*30*/	{ "CP-102UF series",	2, },
+	{ "CP-112UL series",	2, },
 };
 
 /* driver_data correspond to the lines in the structure above
@@ -170,6 +172,7 @@ static struct pci_device_id mxser_pcibrd
 	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_POS104UL),	.driver_data = 28 },
 	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_CP114UL),	.driver_data = 29 },
 	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_CP102UF),	.driver_data = 30 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_CP112UL),	.driver_data = 31 },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, mxser_pcibrds);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
md-dm-log-fix-cn_ulog_callback-declaration.patch
mtd-sst25l-fix-lock-imbalance.patch
isdn-hisax-fix-lock-imbalance.patch
isdn-eicon-use-offsetof.patch
isdn-eicon-return-on-error.patch
icom-converting-space-to-tabs.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
char-mxser-add-support-for-cp112ul.patch
char-mxser-use-thre-for-aspp_oqueue-ioctl.patch
usb-serial-mct_u232-fix-tty-refcnt.patch
kcore-use-registerd-physmem-information.patch
kcore-register-vmemmap-range.patch
kcore-register-vmemmap-range-fix.patch
kcore-register-module-area-in-generic-way.patch
video-console-use-div_round_up.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch
drivers-char-rio-rioctrlc-off-by-one-error-in-rioctrlc.patch
char-riscom8-fix-tty-refcnt.patch
memstick-move-dev_dbg.patch
reiser4.patch
fs-reiser4-add-parenths-around-x-y.patch

