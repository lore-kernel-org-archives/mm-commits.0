From: akpm@linux-foundation.org
Subject: + isdn-hisax-modularize-card-setup.patch added to -mm tree
Date: Thu, 14 Feb 2008 23:07:15 -0800
Message-ID: <200802150707.m1F77F6e025195@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38479 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758612AbYBOHHx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 02:07:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff@garzik.org, greg@kroah.com, kkeil@suse.de


The patch titled
     isdn: HiSax: modularize card setup
has been added to the -mm tree.  Its filename is
     isdn-hisax-modularize-card-setup.patch

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
Subject: isdn: HiSax: modularize card setup
From: Jeff Garzik <jeff@garzik.org>

Now that the previous no-behavior-change code movement patches have occurred,
we can easily replace the big per-card "call the setup function for <this
card>" switch statement with a function pointer.

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hisax/config.c    |   14 +++++++++-----
 drivers/isdn/hisax/hisax_cfg.h |    2 ++
 2 files changed, 11 insertions(+), 5 deletions(-)

diff -puN drivers/isdn/hisax/config.c~isdn-hisax-modularize-card-setup drivers/isdn/hisax/config.c
--- a/drivers/isdn/hisax/config.c~isdn-hisax-modularize-card-setup
+++ a/drivers/isdn/hisax/config.c
@@ -1169,7 +1169,9 @@ outf_cs:
 /* Used from an exported function but calls __devinit functions.
  * Tell modpost not to warn (__ref)
  */
-static int __ref checkcard(int cardnr, char *id, int *busy_flag, struct module *lockowner)
+static int __ref checkcard(int cardnr, char *id, int *busy_flag,
+			   struct module *lockowner,
+		    	   hisax_setup_func_t card_setup)
 {
 	int ret;
 	struct IsdnCard *card = cards + cardnr;
@@ -1187,7 +1189,7 @@ static int __ref checkcard(int cardnr, c
 	       (card->protocol == ISDN_PTYPE_NI1) ? "NI1" :
 	       "NONE", cs->iif.id, cs->myid);
 
-	ret = hisax_cs_setup_card(card);
+	ret = card_setup(card);
 	if (!ret) {
 		ll_unload(cs);
 		goto outf_cs;
@@ -1241,7 +1243,8 @@ static int HiSax_inithardware(int *busy_
 			else
 				sprintf(ids, "%s%d", id, i);
 		}
-		if (checkcard(i, ids, busy_flag, THIS_MODULE)) {
+		if (checkcard(i, ids, busy_flag, THIS_MODULE,
+			      hisax_cs_setup_card)) {
 			foundcards++;
 			i++;
 		} else {
@@ -1549,7 +1552,8 @@ int hisax_init_pcmcia(void *pcm_iob, int
 		sprintf(ids, "HiSax%d", nrcards);
 	else
 		sprintf(ids, "HiSax");
-	if (!checkcard(nrcards, ids, busy_flag, THIS_MODULE))
+	if (!checkcard(nrcards, ids, busy_flag, THIS_MODULE,
+		       hisax_cs_setup_card))
 		goto error;
 
 	ret = nrcards;
@@ -1595,7 +1599,7 @@ int hisax_register(struct hisax_d_if *hi
 	cards[i].protocol = protocol;
 	sprintf(id, "%s%d", name, i);
 	nrcards++;
-	retval = checkcard(i, id, NULL, hisax_d_if->owner);
+	retval = checkcard(i, id, NULL, hisax_d_if->owner, hisax_cs_setup_card);
 	if (retval == 0) { // yuck
 		cards[i].typ = 0;
 		nrcards--;
diff -puN drivers/isdn/hisax/hisax_cfg.h~isdn-hisax-modularize-card-setup drivers/isdn/hisax/hisax_cfg.h
--- a/drivers/isdn/hisax/hisax_cfg.h~isdn-hisax-modularize-card-setup
+++ a/drivers/isdn/hisax/hisax_cfg.h
@@ -60,5 +60,7 @@ struct IsdnCard {
 	IsdnCardState_t	*cs;
 };
 
+typedef int (*hisax_setup_func_t)(struct IsdnCard *card);
+
 extern void	HiSax_closecard(int);
 extern int	hisax_init_pcmcia(void *, int *, IsdnCard_t *);
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
git-libata-all.patch
git-net.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch
usb-net-asix-does-not-really-need-10-100mbit.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
isdn-pci-add-missing-file.patch
isdn-hisax-modularize-card-setup.patch
isdn-hisax-eliminate-many-unnecessary-references-to-cardtype.patch
isdn-ready-hisax-driver-for-modularization.patch
isdn-hisax-bkm_a4t-convert-to-pci-hotplug-api.patch
isdn-hisax-enternow-convert-to-pci-hotplug-api.patch
isdn-hisax-hfc_pci-w6692-convert-to-pci-hotplug-api.patch
isdn-hisax-nj_s-nj_u-convert-to-pci-hotplug-api.patch
isdn-hisax-telespci-convert-to-pci-hotplug-api.patch
isdn-hisax-avm_pci-convert-to-modern-pci-isa-pnp-probing.patch
isdn-hisax-gazel-convert-to-modern-isa-pci-probing.patch
isdn-hisax-niccy-convert-to-modern-isa-pnp-pci-probing.patch
isdn-hisax-diva-convert-to-modern-isa-pnp-pci-probing.patch
isdn-hisax-bkm_a8-convert-to-pci-hotplug-api.patch
