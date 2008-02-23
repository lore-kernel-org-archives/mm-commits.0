From: akpm@linux-foundation.org
Subject: + pnp-skip-dev-protocol-null-checks.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:34:58 -0800
Message-ID: <200802230735.m1N7ZlIn018378@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51519 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756773AbYBWICq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 03:02:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, ambx1@neo.rr.com, bunk@kernel.org, rene.herman@keyaccess.nl


The patch titled
     PNP: skip dev->protocol NULL checks
has been added to the -mm tree.  Its filename is
     pnp-skip-dev-protocol-null-checks.patch

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
Subject: PNP: skip dev->protocol NULL checks
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Every PNP device should have a valid protocol pointer.  If it doesn't,
something's wrong and we should oops so we can find and fix the problem.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Adrian Bunk <bunk@kernel.org>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/driver.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/pnp/driver.c~pnp-skip-dev-protocol-null-checks drivers/pnp/driver.c
--- a/drivers/pnp/driver.c~pnp-skip-dev-protocol-null-checks
+++ a/drivers/pnp/driver.c
@@ -167,7 +167,7 @@ static int pnp_bus_suspend(struct device
 			return error;
 	}
 
-	if (pnp_dev->protocol && pnp_dev->protocol->suspend)
+	if (pnp_dev->protocol->suspend)
 		pnp_dev->protocol->suspend(pnp_dev, state);
 	return 0;
 }
@@ -181,7 +181,7 @@ static int pnp_bus_resume(struct device 
 	if (!pnp_drv)
 		return 0;
 
-	if (pnp_dev->protocol && pnp_dev->protocol->resume)
+	if (pnp_dev->protocol->resume)
 		pnp_dev->protocol->resume(pnp_dev);
 
 	if (pnp_can_write(pnp_dev)) {
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

mm-only-enforce-acpi-resource-conflict-checks.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup-update.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch
pci-simplify-quirk-debug-output.patch
pci-remove-pci=routeirq-noise-from-dmesg.patch
simplify-initcall_debug-output.patch
pnp-skip-dev-protocol-null-checks.patch
pnp-simplify-quirk-debug-output.patch
