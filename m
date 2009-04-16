From: akpm@linux-foundation.org
Subject: + char-cyclades-load-firmware-even-on-ze.patch added to -mm tree
Date: Thu, 16 Apr 2009 16:51:21 -0700
Message-ID: <200904162351.n3GNpLwG032501@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757974AbZDPXxQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Apr 2009 19:53:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     char: cyclades, load firmware even on Ze
has been added to the -mm tree.  Its filename is
     char-cyclades-load-firmware-even-on-ze.patch

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
Subject: char: cyclades, load firmware even on Ze
From: Jiri Slaby <jirislaby@gmail.com>

Ze needs firmware to be loaded as well as Zo.  Move cyz_load_fw one level
upper to achieve that.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-load-firmware-even-on-ze drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-load-firmware-even-on-ze
+++ a/drivers/char/cyclades.c
@@ -5043,6 +5043,7 @@ static int __devinit cy_pci_probe(struct
 			nchan = ZE_V1_NPORTS;
 		} else {
 			card_name = "Cyclades-8Zo";
+			nchan = 8;
 
 #ifdef CY_PCI_DEBUG
 			if (mailbox == ZO_V1) {
@@ -5065,15 +5066,11 @@ static int __devinit cy_pci_probe(struct
 			 */
 			if ((mailbox == ZO_V1) || (mailbox == ZO_V2))
 				cy_writel(addr2 + ID_ADDRESS, 0L);
-
-			retval = cyz_load_fw(pdev, addr2, addr0, irq);
-			if (retval)
-				goto err_unmap;
-			/* This must be a Cyclades-8Zo/PCI.  The extendable
-			   version will have a different device_id and will
-			   be allocated its maximum number of ports. */
-			nchan = 8;
 		}
+
+		retval = cyz_load_fw(pdev, addr2, addr0, irq);
+		if (retval)
+			goto err_unmap;
 	}
 
 	if ((cy_next_channel + nchan) > NR_PORTS) {
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
icom-converting-space-to-tabs.patch
char-isicom-fix-build-warning.patch
char-cyclades-load-firmware-even-on-ze.patch
char-cyclades-dont-kill-fw.patch
char-cyclades-remove-spurious-check-in-isr.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

