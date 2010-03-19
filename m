From: akpm@linux-foundation.org
Subject: + dvb-usb-gp8psk-fix-potential-null-derefernce.patch added to -mm tree
Date: Fri, 19 Mar 2010 16:54:23 -0700
Message-ID: <201003192354.o2JNsNT6019382@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752186Ab0CSXzQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 19:55:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jslaby@suse.cz, alannisota@gmail.com, mchehab@infradead.org, pb@linuxtv.org


The patch titled
     dvb-usb: gp8psk, fix potential null derefernce
has been added to the -mm tree.  Its filename is
     dvb-usb-gp8psk-fix-potential-null-derefernce.patch

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
Subject: dvb-usb: gp8psk, fix potential null derefernce
From: Jiri Slaby <jslaby@suse.cz>

Stanse found that in gp8psk_load_bcm4500fw there is missing a check for
return value of kmalloc. Add one and bail out appropriatelly.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Nisota <alannisota@gmail.com>
Cc: Patrick Boettcher <pb@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/dvb-usb/gp8psk.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/media/dvb/dvb-usb/gp8psk.c~dvb-usb-gp8psk-fix-potential-null-derefernce drivers/media/dvb/dvb-usb/gp8psk.c
--- a/drivers/media/dvb/dvb-usb/gp8psk.c~dvb-usb-gp8psk-fix-potential-null-derefernce
+++ a/drivers/media/dvb/dvb-usb/gp8psk.c
@@ -105,6 +105,10 @@ static int gp8psk_load_bcm4500fw(struct 
 
 	ptr = fw->data;
 	buf = kmalloc(64, GFP_KERNEL | GFP_DMA);
+	if (!buf) {
+		ret = -ENOMEM;
+		goto out_rel_fw;
+	}
 
 	while (ptr[0] != 0xff) {
 		u16 buflen = ptr[0] + 4;
_

Patches currently in -mm which might be from jslaby@suse.cz are

origin.patch
linux-next.patch
gpu-vga_switcheroo-fix-lock-imbalance.patch
dvb-usb-gp8psk-fix-potential-null-derefernce.patch
kernel-user-remove-unreachable-code.patch
edac-add-__init-to-i7core_xeon_pci_fixup.patch

