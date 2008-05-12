From: akpm@linux-foundation.org
Subject: + pnp-cleanup-pnp_fixup_device.patch added to -mm tree
Date: Mon, 12 May 2008 15:55:52 -0700
Message-ID: <200805122255.m4CMtqE2013339@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756210AbYELW4g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 18:56:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rene.herman@gmail.com, bjorn.helgaas@hp.com, len.brown@intel.com, tiwai@suse.de, uwe.bugla@gmx.de


The patch titled
     pnp: clean up pnp_fixup_device()
has been added to the -mm tree.  Its filename is
     pnp-cleanup-pnp_fixup_device.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnp: clean up pnp_fixup_device()
From: Rene Herman <rene.herman@gmail.com>

Make it look a bit more like pci_fixup_device/pci_do_fixups.  Also print
the PnP ID and delete the () from the "foo+0x0/0x1234()".

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Tested-by: Uwe Bugla <uwe.bugla@gmx.de>
Acked-by: Uwe Bugla <uwe.bugla@gmx.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Len Brown <len.brown@intel.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/quirks.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff -puN drivers/pnp/quirks.c~pnp-cleanup-pnp_fixup_device drivers/pnp/quirks.c
--- a/drivers/pnp/quirks.c~pnp-cleanup-pnp_fixup_device
+++ a/drivers/pnp/quirks.c
@@ -212,20 +212,16 @@ static struct pnp_fixup pnp_fixups[] = {
 
 void pnp_fixup_device(struct pnp_dev *dev)
 {
-	int i = 0;
-	void (*quirk)(struct pnp_dev *);
-
-	while (*pnp_fixups[i].id) {
-		if (compare_pnp_id(dev->id, pnp_fixups[i].id)) {
-			quirk = pnp_fixups[i].quirk_function;
+	struct pnp_fixup *f;
 
+	for (f = pnp_fixups; *f->id; f++) {
+		if (!compare_pnp_id(dev->id, f->id))
+			continue;
 #ifdef DEBUG
-			dev_dbg(&dev->dev, "calling ");
-			print_fn_descriptor_symbol("%s()\n",
-				(unsigned long) *quirk);
+		dev_dbg(&dev->dev, "%s: calling ", f->id);
+		print_fn_descriptor_symbol("%s\n",
+				(unsigned long) f->quirk_function);
 #endif
-			(*quirk)(dev);
-		}
-		i++;
+		f->quirk_function(dev);
 	}
 }
_

Patches currently in -mm which might be from rene.herman@gmail.com are

pnp-cleanup-pnp_fixup_device.patch
pnp-add-pnp_build_option-to-the-api.patch
pnp-add-isapnp-mpu-option-quirks.patch
make-pnp_add_card_id-static.patch

