From: akpm@linux-foundation.org
Subject: - pnp-simplify-quirk-debug-output.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:00:08 -0700
Message-ID: <200804282200.m3SM08a7018667@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965498AbYD1WAR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 18:00:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, mm-commits@vger.kernel.org


The patch titled
     PNP: simplify quirk debug output
has been removed from the -mm tree.  Its filename was
     pnp-simplify-quirk-debug-output.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PNP: simplify quirk debug output
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

print_fn_descriptor_symbol() prints the address if we don't have a symbol,
so no need to print both.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/quirks.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/pnp/quirks.c~pnp-simplify-quirk-debug-output drivers/pnp/quirks.c
--- a/drivers/pnp/quirks.c~pnp-simplify-quirk-debug-output
+++ a/drivers/pnp/quirks.c
@@ -214,8 +214,8 @@ void pnp_fixup_device(struct pnp_dev *de
 			quirk = pnp_fixups[i].quirk_function;
 
 #ifdef DEBUG
-			dev_dbg(&dev->dev, "calling quirk 0x%p", quirk);
-			print_fn_descriptor_symbol(": %s()\n",
+			dev_dbg(&dev->dev, "calling ");
+			print_fn_descriptor_symbol("%s()\n",
 				(unsigned long) *quirk);
 #endif
 			(*quirk)(dev);
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

