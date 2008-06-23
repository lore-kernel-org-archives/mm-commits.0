From: akpm@linux-foundation.org
Subject: - pnp-replace-pnp_resource_table-with-dynamically-allocated-resources-fix.patch removed from -mm tree
Date: Mon, 23 Jun 2008 14:03:05 -0700
Message-ID: <200806232103.m5NL35Aa016133@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757775AbYFWVDO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 17:03:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, mm-commits@vger.kernel.org


The patch titled
     pnp-replace-pnp_resource_table-with-dynamically-allocated-resources fix
has been removed from the -mm tree.  Its filename was
     pnp-replace-pnp_resource_table-with-dynamically-allocated-resources-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnp-replace-pnp_resource_table-with-dynamically-allocated-resources fix
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

We still need the IORESOURCE_DISABLED check for MEM resources there,
and I think it's missing from the version of
pnp-replace-pnp_resource_table-with-dynamically-allocated-resources.patch
that you just added to -mm.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/system.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/pnp/system.c~pnp-replace-pnp_resource_table-with-dynamically-allocated-resources-fix drivers/pnp/system.c
--- a/drivers/pnp/system.c~pnp-replace-pnp_resource_table-with-dynamically-allocated-resources-fix
+++ a/drivers/pnp/system.c
@@ -60,6 +60,8 @@ static void reserve_resources_of_dev(str
 	int i;
 
 	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_IO, i)); i++) {
+		if (res->flags & IORESOURCE_DISABLED)
+			continue;
 		if (res->start == 0)
 			continue;	/* disabled */
 		if (res->start < 0x100)
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch
make-pnp_add_card_id-static.patch

