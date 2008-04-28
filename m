From: akpm@linux-foundation.org
Subject: - pnp-skip-dev-protocol-null-checks.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:00:06 -0700
Message-ID: <200804282200.m3SM068j018664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965620AbYD1WAm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 18:00:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, ambx1@neo.rr.com, bunk@kernel.org, rene.herman@keyaccess.nl, mm-commits@vger.kernel.org


The patch titled
     PNP: skip dev->protocol NULL checks
has been removed from the -mm tree.  Its filename was
     pnp-skip-dev-protocol-null-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
smsc-ircc2-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
nsc-ircc-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
simplify-initcall_debug-output.patch
proc-introduce-proc_create_data-to-setup-de-data.patch
drivers-use-non-racy-method-for-proc-entries-creation-2.patch
parport_pc-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
tpm-change-kconfig-dependencies-from-pnpacpi-to-pnp.patch

