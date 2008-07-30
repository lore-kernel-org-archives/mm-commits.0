From: akpm@linux-foundation.org
Subject: - pnp-fix-formatting-of-dbg_pnp_show_resources-output.patch removed from -mm tree
Date: Wed, 30 Jul 2008 11:21:23 -0700
Message-ID: <200807301821.m6UILNkH008683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753490AbYG3SVl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 14:21:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, clem@clem.clem-digital.net, rene.herman@keyaccess.nl, mm-commits@vger.kernel.org


The patch titled
     pnp: fix formatting of dbg_pnp_show_resources() output
has been removed from the -mm tree.  Its filename was
     pnp-fix-formatting-of-dbg_pnp_show_resources-output.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnp: fix formatting of dbg_pnp_show_resources() output
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Each resource should be printed on its own line, so start snprintf'ing
at the beginning of the buffer every time through the loop.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Reported-by: Pete Clements <clem@clem.clem-digital.net>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/support.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/pnp/support.c~pnp-fix-formatting-of-dbg_pnp_show_resources-output drivers/pnp/support.c
--- a/drivers/pnp/support.c~pnp-fix-formatting-of-dbg_pnp_show_resources-output
+++ a/drivers/pnp/support.c
@@ -77,7 +77,7 @@ void dbg_pnp_show_resources(struct pnp_d
 {
 #ifdef DEBUG
 	char buf[128];
-	int len = 0;
+	int len;
 	struct pnp_resource *pnp_res;
 	struct resource *res;
 
@@ -89,6 +89,7 @@ void dbg_pnp_show_resources(struct pnp_d
 	dev_dbg(&dev->dev, "%s: current resources:\n", desc);
 	list_for_each_entry(pnp_res, &dev->resources, list) {
 		res = &pnp_res->res;
+		len = 0;
 
 		len += snprintf(buf + len, sizeof(buf) - len, "  %-3s ",
 				pnp_resource_type_name(res));
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

mm-only-enforce-acpi-resource-conflict-checks.patch
amd64-agp-run-fallback-when-no-bridges-found-not-when-driver-registration-fails.patch
agp-use-dev_printk-when-possible.patch
drivers-telephony-ixjc-depends-on-pnp.patch
pnp-fix-formatting-of-dbg_pnp_show_resources-output.patch
firmware-use-dev_printk-when-possible.patch
resources-tidy-__request_region.patch

