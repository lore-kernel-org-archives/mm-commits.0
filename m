From: akpm@linux-foundation.org
Subject: + s6gmac-xtensa-s6000-on-chip-ethernet-driver-fix.patch added to -mm tree
Date: Thu, 09 Apr 2009 21:44:44 -0700
Message-ID: <200904100444.n3A4iiUk026064@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47928 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387AbZDJEse (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 00:48:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jw@emlix.com, chris@zankel.net, davem@davemloft.net, dg@emlix.com, os@emlix.com


The patch titled
     s6gmac: don't use device->bus_id directly
has been added to the -mm tree.  Its filename is
     s6gmac-xtensa-s6000-on-chip-ethernet-driver-fix.patch

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
Subject: s6gmac: don't use device->bus_id directly
From: Johannes Weiner <jw@emlix.com>

Use the dev_name() helper to get a name string for a device instead of
open-coding random device field accesses.

With commit 1fa5ae8 ("driver core: get rid of struct device's bus_id
string array" in place, this is not just a cleanup but a compilation fix.

Signed-off-by: Johannes Weiner <jw@emlix.com>
Cc: Oskar Schirmer <os@emlix.com>
Cc: Daniel Glockner <dg@emlix.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Christian Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/s6gmac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/s6gmac.c~s6gmac-xtensa-s6000-on-chip-ethernet-driver-fix drivers/net/s6gmac.c
--- a/drivers/net/s6gmac.c~s6gmac-xtensa-s6000-on-chip-ethernet-driver-fix
+++ a/drivers/net/s6gmac.c
@@ -795,7 +795,7 @@ static inline int s6gmac_phy_start(struc
 	struct phy_device *p = NULL;
 	while ((!(p = pd->mii.bus->phy_map[i])) && (i < PHY_MAX_ADDR))
 		i++;
-	p = phy_connect(dev, p->dev.bus_id, &s6gmac_adjust_link, 0,
+	p = phy_connect(dev, dev_name(&p->dev), &s6gmac_adjust_link, 0,
 			PHY_INTERFACE_MODE_RGMII);
 	if (IS_ERR(p)) {
 		printk(KERN_ERR "%s: Could not attach to PHY\n", dev->name);
_

Patches currently in -mm which might be from jw@emlix.com are

xtensa-add-flat-support-checkpatch-fixes.patch
xtensa-variant-specific-code.patch
xtensa-cache-inquiry-and-unaligned-cache-handling-functions.patch
xtensa-allow-platform-and-variant-to-initialize-own-irq-chips.patch
xtensa-support-s6000-gpio-irqs-and-alternate-function-selection.patch
s6gmac-xtensa-s6000-on-chip-ethernet-driver.patch
s6gmac-xtensa-s6000-on-chip-ethernet-driver-fix.patch
xtensa-s6105-specific-configuration-for-s6gmac.patch
xtensa-enable-s6gmac-in-s6105_defconfig.patch
flat-fix-data-sections-alignment.patch

