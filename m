From: akpm@linux-foundation.org
Subject: - isapnp-handle-independent-options-following-dependent-ones.patch removed from -mm tree
Date: Mon, 23 Jun 2008 14:03:59 -0700
Message-ID: <200806232103.m5NL3xdH016230@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48495 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758718AbYFWVEe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 17:04:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, abelay@mit.edu, castet.matthieu@free.fr, lenb@kernel.org, perex@perex.cz, rene.herman@keyaccess.nl, shaohua.li@intel.com, tiwai@suse.de, trenn@suse.de, mm-commit


The patch titled
     isapnp: handle independent options following dependent ones
has been removed from the -mm tree.  Its filename was
     isapnp-handle-independent-options-following-dependent-ones.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isapnp: handle independent options following dependent ones
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

The ISAPNP spec recommends that independent options precede dependent
ones, but this is not actually required.  The current ISAPNP code
incorrectly puts such trailing independent options at the end of the last
dependent option list.

This patch fixes that bug by resetting the current option list to the
independent list when we see an "End Dependent Functions" tag.  PNPBIOS
and PNPACPI handle this the same way.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Len Brown <lenb@kernel.org>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/isapnp/core.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/pnp/isapnp/core.c~isapnp-handle-independent-options-following-dependent-ones drivers/pnp/isapnp/core.c
--- a/drivers/pnp/isapnp/core.c~isapnp-handle-independent-options-following-dependent-ones
+++ a/drivers/pnp/isapnp/core.c
@@ -584,14 +584,14 @@ static int __init isapnp_create_device(s
 {
 	int number = 0, skip = 0, priority, compat = 0;
 	unsigned char type, tmp[17];
-	struct pnp_option *option;
+	struct pnp_option *option, *option_independent;
 	struct pnp_dev *dev;
 	u32 eisa_id;
 	char id[8];
 
 	if ((dev = isapnp_parse_device(card, size, number++)) == NULL)
 		return 1;
-	option = pnp_register_independent_option(dev);
+	option_independent = option = pnp_register_independent_option(dev);
 	if (!option) {
 		kfree(dev);
 		return 1;
@@ -613,6 +613,7 @@ static int __init isapnp_create_device(s
 				size = 0;
 				skip = 0;
 				option = pnp_register_independent_option(dev);
+				option_independent = option;
 				if (!option) {
 					kfree(dev);
 					return 1;
@@ -662,6 +663,10 @@ static int __init isapnp_create_device(s
 		case _STAG_ENDDEP:
 			if (size != 0)
 				goto __skip;
+			if (option_independent == option)
+				dev_warn(&dev->dev, "missing "
+					 "_STAG_STARTDEP tag\n");
+			option = option_independent;
 			dev_dbg(&dev->dev, "end dependent options\n");
 			break;
 		case _STAG_IOPORT:
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch
make-pnp_add_card_id-static.patch

