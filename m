From: akpm@linux-foundation.org
Subject: - pnp-in-debug-resource-dump-make-empty-list-obvious.patch removed from -mm tree
Date: Mon, 23 Jun 2008 14:03:34 -0700
Message-ID: <200806232103.m5NL3Yje016190@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758220AbYFWVE0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 17:04:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, abelay@mit.edu, castet.matthieu@free.fr, lenb@kernel.org, perex@perex.cz, rene.herman@gmail.com, shaohua.li@intel.com, tiwai@suse.de, trenn@suse.de, mm-commits@v


The patch titled
     pnp: in debug resource dump, make empty list obvious
has been removed from the -mm tree.  Its filename was
     pnp-in-debug-resource-dump-make-empty-list-obvious.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnp: in debug resource dump, make empty list obvious
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

If the resource list is empty, say that explicitly.  Previously, it was
confusing because often the heading was followed by zero resource lines,
then some "add resource" lines from auto-assignment, so the "add" lines
looked like current resources.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-by: Rene Herman <rene.herman@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/support.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/pnp/support.c~pnp-in-debug-resource-dump-make-empty-list-obvious drivers/pnp/support.c
--- a/drivers/pnp/support.c~pnp-in-debug-resource-dump-make-empty-list-obvious
+++ a/drivers/pnp/support.c
@@ -77,7 +77,12 @@ void dbg_pnp_show_resources(struct pnp_d
 	struct pnp_resource *pnp_res;
 	struct resource *res;
 
-	dev_dbg(&dev->dev, "current resources: %s\n", desc);
+	if (list_empty(&dev->resources)) {
+		dev_dbg(&dev->dev, "%s: no current resources\n", desc);
+		return;
+	}
+
+	dev_dbg(&dev->dev, "%s: current resources:\n", desc);
 	list_for_each_entry(pnp_res, &dev->resources, list) {
 		res = &pnp_res->res;
 
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch
make-pnp_add_card_id-static.patch

