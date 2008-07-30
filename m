From: akpm@linux-foundation.org
Subject: + pnp-fix-formatting-of-dbg_pnp_show_resources-output.patch added to -mm tree
Date: Wed, 30 Jul 2008 03:18:30 -0700
Message-ID: <200807301018.m6UAIUlJ020894@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752234AbYG3KTZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 06:19:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, clem@clem.clem-digital.net, rene.herman@keyaccess.nl


The patch titled
     pnp: fix formatting of dbg_pnp_show_resources() output
has been added to the -mm tree.  Its filename is
     pnp-fix-formatting-of-dbg_pnp_show_resources-output.patch

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
firmware-use-dev_printk-when-possible.patch
resources-tidy-__request_region.patch
pnp-fix-formatting-of-dbg_pnp_show_resources-output.patch

