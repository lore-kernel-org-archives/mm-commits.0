From: akpm@linux-foundation.org
Subject: [merged] dvb-usb-gp8psk-fix-potential-null-derefernce.patch removed from -mm tree
Date: Thu, 06 May 2010 12:09:05 -0400
Message-ID: <201005061910.o46JAZ38008539@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754263Ab0EFTKz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 May 2010 15:10:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, alannisota@gmail.com, mchehab@infradead.org, pb@linuxtv.org, mm-commits@vger.kernel.org


The patch titled
     dvb-usb: gp8psk, fix potential null derefernce
has been removed from the -mm tree.  Its filename was
     dvb-usb-gp8psk-fix-potential-null-derefernce.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible-fix.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible-fix-2.patch
edac-add-__init-to-i7core_xeon_pci_fixup.patch

