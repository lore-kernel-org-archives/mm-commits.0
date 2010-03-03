From: akpm@linux-foundation.org
Subject: [wrecked] drivers-pcmcia-yenta_socketc-ene-cb712-cardbus-bridge-needs-special-treatment-with-echo-audio-indigo-soundcards.patch removed from -mm tree
Date: Wed, 03 Mar 2010 11:55:30 -0800
Message-ID: <201003031955.o23JtUmE028053@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751001Ab0CCTzn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Mar 2010 14:55:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michal.pecio@gmail.com, daniel.ritz@gmx.ch, linux@dominikbrodowski.net, mm-commits@vger.kernel.org


The patch titled
     drivers/pcmcia/yenta_socket.c: ENE CB712 CardBus bridge needs special treatment with Echo Audio Indigo soundcards
has been removed from the -mm tree.  Its filename was
     drivers-pcmcia-yenta_socketc-ene-cb712-cardbus-bridge-needs-special-treatment-with-echo-audio-indigo-soundcards.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/pcmcia/yenta_socket.c: ENE CB712 CardBus bridge needs special treatment with Echo Audio Indigo soundcards
From: Michal Pecio <michal.pecio@gmail.com>

Indigos are well known for distortions when running on some buggy ENE
controllers.  There is a workaround in the yenta driver, but for some
reason it isn't activated on CB712.  However, I own a laptop with such
chip and it seems that it also is affected - I can clearly hear occasional
cracks, especially under heavy network load, and in Windows XP the card is
completely unusable.

This simple change fixed things for me.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=15191

Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Daniel Ritz <daniel.ritz@gmx.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/yenta_socket.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pcmcia/yenta_socket.c~drivers-pcmcia-yenta_socketc-ene-cb712-cardbus-bridge-needs-special-treatment-with-echo-audio-indigo-soundcards drivers/pcmcia/yenta_socket.c
--- a/drivers/pcmcia/yenta_socket.c~drivers-pcmcia-yenta_socketc-ene-cb712-cardbus-bridge-needs-special-treatment-with-echo-audio-indigo-soundcards
+++ a/drivers/pcmcia/yenta_socket.c
@@ -1409,7 +1409,7 @@ static struct pci_device_id yenta_table[
 	CB_ID(PCI_VENDOR_ID_TI, PCI_DEVICE_ID_TI_7610, TI12XX),
 
 	CB_ID(PCI_VENDOR_ID_ENE, PCI_DEVICE_ID_ENE_710, TI12XX),
-	CB_ID(PCI_VENDOR_ID_ENE, PCI_DEVICE_ID_ENE_712, TI12XX),
+	CB_ID(PCI_VENDOR_ID_ENE, PCI_DEVICE_ID_ENE_712, ENE),
 	CB_ID(PCI_VENDOR_ID_ENE, PCI_DEVICE_ID_ENE_720, TI12XX),
 	CB_ID(PCI_VENDOR_ID_ENE, PCI_DEVICE_ID_ENE_722, TI12XX),
 	CB_ID(PCI_VENDOR_ID_ENE, PCI_DEVICE_ID_ENE_1211, ENE),
_

Patches currently in -mm which might be from michal.pecio@gmail.com are

linux-next.patch
drivers-pcmcia-yenta_socketc-ene-cb712-cardbus-bridge-needs-special-treatment-with-echo-audio-indigo-soundcards.patch

