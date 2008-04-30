From: akpm@linux-foundation.org
Subject: - simplify-initcall_debug-output.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:40:02 -0700
Message-ID: <200804300540.m3U5e2Ow028926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754306AbYD3FkL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:40:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, mm-commits@vger.kernel.org


The patch titled
     Simplify initcall_debug output
has been removed from the -mm tree.  Its filename was
     simplify-initcall_debug-output.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Simplify initcall_debug output
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

print_fn_descriptor_symbol() prints the address if we don't have a symbol, so
no need to print both.

Also, combine printing return value with elapsed time.  Changes this:

  Calling initcall 0xc05b7a70: pci_mmcfg_late_insert_resources+0x0/0x50()
  initcall 0xc05b7a70: pci_mmcfg_late_insert_resources+0x0/0x50() returned 1.
  initcall 0xc05b7a70 ran for 0 msecs: pci_mmcfg_late_insert_resources+0x0/0x50()
  initcall at 0xc05b7a70: pci_mmcfg_late_insert_resources+0x0/0x50(): returned with error code 1

to this:

  calling  pci_mmcfg_late_insert_resources+0x0/0x50()
  initcall pci_mmcfg_late_insert_resources+0x0/0x50() returned 1 after 0 msecs
  initcall pci_mmcfg_late_insert_resources+0x0/0x50() returned with error code 1

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff -puN init/main.c~simplify-initcall_debug-output init/main.c
--- a/init/main.c~simplify-initcall_debug-output
+++ a/init/main.c
@@ -700,10 +700,8 @@ static void __init do_initcalls(void)
 		int result;
 
 		if (initcall_debug) {
-			printk("Calling initcall 0x%p", *call);
-			print_fn_descriptor_symbol(": %s()",
+			print_fn_descriptor_symbol("calling  %s()\n",
 					(unsigned long) *call);
-			printk("\n");
 			t0 = ktime_get();
 		}
 
@@ -713,15 +711,10 @@ static void __init do_initcalls(void)
 			t1 = ktime_get();
 			delta = ktime_sub(t1, t0);
 
-			printk("initcall 0x%p", *call);
-			print_fn_descriptor_symbol(": %s()",
+			print_fn_descriptor_symbol("initcall %s()",
 					(unsigned long) *call);
-			printk(" returned %d.\n", result);
-
-			printk("initcall 0x%p ran for %Ld msecs: ",
-				*call, (unsigned long long)delta.tv64 >> 20);
-			print_fn_descriptor_symbol("%s()\n",
-				(unsigned long) *call);
+			printk(" returned %d after %Ld msecs\n", result,
+				(unsigned long long) delta.tv64 >> 20);
 		}
 
 		if (result && result != -ENODEV && initcall_debug) {
@@ -737,10 +730,9 @@ static void __init do_initcalls(void)
 			local_irq_enable();
 		}
 		if (msg) {
-			printk(KERN_WARNING "initcall at 0x%p", *call);
-			print_fn_descriptor_symbol(": %s()",
+			print_fn_descriptor_symbol(KERN_WARNING "initcall %s()",
 					(unsigned long) *call);
-			printk(": returned with %s\n", msg);
+			printk(" returned with %s\n", msg);
 		}
 	}
 
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
git-acpi.patch
acpi_pm_device_sleep_state-cleanup.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
drivers-use-non-racy-method-for-proc-entries-creation-2-rio.patch
smsc-ircc2-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
nsc-ircc-wrap-pnp-probe-code-in-ifdef-config_pnp.patch

