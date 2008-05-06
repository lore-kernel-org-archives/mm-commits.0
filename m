From: akpm@linux-foundation.org
Subject: + pnp-add-detail-to-debug-resource-dump.patch added to -mm tree
Date: Tue, 06 May 2008 12:00:49 -0700
Message-ID: <200805061900.m46J0nnP022209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53890 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753867AbYEFTCE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 15:02:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, abelay@mit.edu, castet.matthieu@free.fr, lenb@kernel.org, perex@perex.cz, rene.herman@keyaccess.nl, shaohua.li@intel.com, tiwai@suse.de, trenn@suse.de


The patch titled
     pnp: add detail to debug resource dump
has been added to the -mm tree.  Its filename is
     pnp-add-detail-to-debug-resource-dump.patch

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
Subject: pnp: add detail to debug resource dump
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

In the debug resource dump, decode the flags and indicate when a resource is
disabled or has been automatically assigned.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/support.c |   34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff -puN drivers/pnp/support.c~pnp-add-detail-to-debug-resource-dump drivers/pnp/support.c
--- a/drivers/pnp/support.c~pnp-add-detail-to-debug-resource-dump
+++ a/drivers/pnp/support.c
@@ -63,28 +63,46 @@ void dbg_pnp_show_resources(struct pnp_d
 	for (i = 0; i < PNP_MAX_IRQ; i++) {
 		res = pnp_get_resource(dev, IORESOURCE_IRQ, i);
 		if (res && !(res->flags & IORESOURCE_UNSET))
-			dev_dbg(&dev->dev, "  irq %lld flags %#lx\n",
-				(unsigned long long) res->start, res->flags);
+			dev_dbg(&dev->dev, "  irq %lld flags %#lx%s%s\n",
+				(unsigned long long) res->start, res->flags,
+				res->flags & IORESOURCE_DISABLED ?
+					" DISABLED" : "",
+				res->flags & IORESOURCE_AUTO ?
+					" AUTO" : "");
 	}
 	for (i = 0; i < PNP_MAX_DMA; i++) {
 		res = pnp_get_resource(dev, IORESOURCE_DMA, i);
 		if (res && !(res->flags & IORESOURCE_UNSET))
-			dev_dbg(&dev->dev, "  dma %lld flags %#lx\n",
-				(unsigned long long) res->start, res->flags);
+			dev_dbg(&dev->dev, "  dma %lld flags %#lx%s%s\n",
+				(unsigned long long) res->start, res->flags,
+				res->flags & IORESOURCE_DISABLED ?
+					" DISABLED" : "",
+				res->flags & IORESOURCE_AUTO ?
+					" AUTO" : "");
 	}
 	for (i = 0; i < PNP_MAX_PORT; i++) {
 		res = pnp_get_resource(dev, IORESOURCE_IO, i);
 		if (res && !(res->flags & IORESOURCE_UNSET))
-			dev_dbg(&dev->dev, "  io  %#llx-%#llx flags %#lx\n",
+			dev_dbg(&dev->dev, "  io  %#llx-%#llx flags %#lx"
+				"%s%s\n",
 				(unsigned long long) res->start,
-				(unsigned long long) res->end, res->flags);
+				(unsigned long long) res->end, res->flags,
+				res->flags & IORESOURCE_DISABLED ?
+					" DISABLED" : "",
+				res->flags & IORESOURCE_AUTO ?
+					" AUTO" : "");
 	}
 	for (i = 0; i < PNP_MAX_MEM; i++) {
 		res = pnp_get_resource(dev, IORESOURCE_MEM, i);
 		if (res && !(res->flags & IORESOURCE_UNSET))
-			dev_dbg(&dev->dev, "  mem %#llx-%#llx flags %#lx\n",
+			dev_dbg(&dev->dev, "  mem %#llx-%#llx flags %#lx"
+				"%s%s\n",
 				(unsigned long long) res->start,
-				(unsigned long long) res->end, res->flags);
+				(unsigned long long) res->end, res->flags,
+				res->flags & IORESOURCE_DISABLED ?
+					" DISABLED" : "",
+				res->flags & IORESOURCE_AUTO ?
+					" AUTO" : "");
 	}
 #endif
 }
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

linux-next.patch
acpi_pm_device_sleep_state-cleanup.patch
acpi-fix-drivers-acpi-gluec-build-error.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
pnp-set-irq-index-in-sysfs-set-irq-interface.patch
pnp-add-detail-to-debug-resource-dump.patch
pnp-remove-pnp_resourceindex.patch
pnp-add-pnp_resource_type-internal-interface.patch
pnp-add-pnp_resource_type_name-helper-function.patch
pnp-replace-pnp_resource_table-with-dynamically-allocated-resources.patch
pnp-remove-ratelimit-on-add-resource-failures.patch
pnp-dont-sort-by-type-in-sys-resources.patch
make-pnp_add_card_id-static.patch

