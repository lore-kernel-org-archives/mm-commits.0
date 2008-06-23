From: akpm@linux-foundation.org
Subject: - pnp-remove-extra-0x100-bit-from-option-priority.patch removed from -mm tree
Date: Mon, 23 Jun 2008 14:03:56 -0700
Message-ID: <200806232103.m5NL3ugp016227@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758272AbYFWVE1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 17:04:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, abelay@mit.edu, castet.matthieu@free.fr, lenb@kernel.org, perex@perex.cz, rene.herman@gmail.com, rene.herman@keyaccess.nl, shaohua.li@intel.com, tiwai@suse.det


The patch titled
     pnp: remove extra 0x100 bit from option priority
has been removed from the -mm tree.  Its filename was
     pnp-remove-extra-0x100-bit-from-option-priority.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnp: remove extra 0x100 bit from option priority
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

When building resource options, ISAPNP and PNPBIOS set the priority to
something like "0x100 | PNP_RES_PRIORITY_ACCEPTABLE", but we immediately
mask off the 0x100 again in pnp_build_option(), so that bit looks
superfluous.

Thanks to Rene Herman <rene.herman@gmail.com> for pointing this out.

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

 drivers/pnp/isapnp/core.c      |    8 +++-----
 drivers/pnp/pnpacpi/rsparser.c |    2 +-
 drivers/pnp/pnpbios/rsparser.c |    6 +++---
 3 files changed, 7 insertions(+), 9 deletions(-)

diff -puN drivers/pnp/isapnp/core.c~pnp-remove-extra-0x100-bit-from-option-priority drivers/pnp/isapnp/core.c
--- a/drivers/pnp/isapnp/core.c~pnp-remove-extra-0x100-bit-from-option-priority
+++ a/drivers/pnp/isapnp/core.c
@@ -582,7 +582,7 @@ isapnp_parse_name(char *name, unsigned i
 static int __init isapnp_create_device(struct pnp_card *card,
 				       unsigned short size)
 {
-	int number = 0, skip = 0, priority = 0, compat = 0;
+	int number = 0, skip = 0, priority, compat = 0;
 	unsigned char type, tmp[17];
 	struct pnp_option *option;
 	struct pnp_dev *dev;
@@ -621,7 +621,6 @@ static int __init isapnp_create_device(s
 			} else {
 				skip = 1;
 			}
-			priority = 0;
 			compat = 0;
 			break;
 		case _STAG_COMPATDEVID:
@@ -650,10 +649,10 @@ static int __init isapnp_create_device(s
 		case _STAG_STARTDEP:
 			if (size > 1)
 				goto __skip;
-			priority = 0x100 | PNP_RES_PRIORITY_ACCEPTABLE;
+			priority = PNP_RES_PRIORITY_ACCEPTABLE;
 			if (size > 0) {
 				isapnp_peek(tmp, size);
-				priority = 0x100 | tmp[0];
+				priority = tmp[0];
 				size = 0;
 			}
 			option = pnp_register_dependent_option(dev, priority);
@@ -663,7 +662,6 @@ static int __init isapnp_create_device(s
 		case _STAG_ENDDEP:
 			if (size != 0)
 				goto __skip;
-			priority = 0;
 			dev_dbg(&dev->dev, "end dependent options\n");
 			break;
 		case _STAG_IOPORT:
diff -puN drivers/pnp/pnpacpi/rsparser.c~pnp-remove-extra-0x100-bit-from-option-priority drivers/pnp/pnpacpi/rsparser.c
--- a/drivers/pnp/pnpacpi/rsparser.c~pnp-remove-extra-0x100-bit-from-option-priority
+++ a/drivers/pnp/pnpacpi/rsparser.c
@@ -545,7 +545,7 @@ struct acpipnp_parse_option_s {
 static __init acpi_status pnpacpi_option_resource(struct acpi_resource *res,
 						  void *data)
 {
-	int priority = 0;
+	int priority;
 	struct acpipnp_parse_option_s *parse_data = data;
 	struct pnp_dev *dev = parse_data->dev;
 	struct pnp_option *option = parse_data->option;
diff -puN drivers/pnp/pnpbios/rsparser.c~pnp-remove-extra-0x100-bit-from-option-priority drivers/pnp/pnpbios/rsparser.c
--- a/drivers/pnp/pnpbios/rsparser.c~pnp-remove-extra-0x100-bit-from-option-priority
+++ a/drivers/pnp/pnpbios/rsparser.c
@@ -315,7 +315,7 @@ pnpbios_parse_resource_option_data(unsig
 					struct pnp_dev *dev)
 {
 	unsigned int len, tag;
-	int priority = 0;
+	int priority;
 	struct pnp_option *option, *option_independent;
 
 	if (!p)
@@ -389,9 +389,9 @@ pnpbios_parse_resource_option_data(unsig
 		case SMALL_TAG_STARTDEP:
 			if (len > 1)
 				goto len_err;
-			priority = 0x100 | PNP_RES_PRIORITY_ACCEPTABLE;
+			priority = PNP_RES_PRIORITY_ACCEPTABLE;
 			if (len > 0)
-				priority = 0x100 | p[1];
+				priority = p[1];
 			option = pnp_register_dependent_option(dev, priority);
 			if (!option)
 				return NULL;
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch
make-pnp_add_card_id-static.patch

