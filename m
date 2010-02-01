From: akpm@linux-foundation.org
Subject: + drivers-pcmcia-yenta_socketc-ene-cb712-cardbus-bridge-needs-special-treatment-with-echo-audio-indigo-soundcards.patch added to -mm tree
Date: Mon, 01 Feb 2010 13:29:22 -0800
Message-ID: <201002012129.o11LTM4Y013529@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36352 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754806Ab0BAV3a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 16:29:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michal.pecio@gmail.com, daniel.ritz@gmx.ch, linux@dominikbrodowski.net


The patch titled
     drivers/pcmcia/yenta_socket.c: ENE CB712 CardBus bridge needs special treatment with Echo Audio Indigo soundcards
has been added to the -mm tree.  Its filename is
     drivers-pcmcia-yenta_socketc-ene-cb712-cardbus-bridge-needs-special-treatment-with-echo-audio-indigo-soundcards.patch

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
@@ -1408,7 +1408,7 @@ static struct pci_device_id yenta_table[
 	CB_ID(PCI_VENDOR_ID_TI, PCI_DEVICE_ID_TI_7610, TI12XX),
 
 	CB_ID(PCI_VENDOR_ID_ENE, PCI_DEVICE_ID_ENE_710, TI12XX),
-	CB_ID(PCI_VENDOR_ID_ENE, PCI_DEVICE_ID_ENE_712, TI12XX),
+	CB_ID(PCI_VENDOR_ID_ENE, PCI_DEVICE_ID_ENE_712, ENE),
 	CB_ID(PCI_VENDOR_ID_ENE, PCI_DEVICE_ID_ENE_720, TI12XX),
 	CB_ID(PCI_VENDOR_ID_ENE, PCI_DEVICE_ID_ENE_722, TI12XX),
 	CB_ID(PCI_VENDOR_ID_ENE, PCI_DEVICE_ID_ENE_1211, ENE),
_

Patches currently in -mm which might be from michal.pecio@gmail.com are

drivers-pcmcia-yenta_socketc-ene-cb712-cardbus-bridge-needs-special-treatment-with-echo-audio-indigo-soundcards.patch

