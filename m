From: akpm@linux-foundation.org
Subject: + simplify-initcall_debug-output.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:33:40 -0800
Message-ID: <200802230734.m1N7YTD8018292@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751722AbYBWHx6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:53:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com


The patch titled
     Simplify initcall_debug output
has been added to the -mm tree.  Its filename is
     simplify-initcall_debug-output.patch

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
@@ -680,10 +680,8 @@ static void __init do_initcalls(void)
 		int result;
 
 		if (initcall_debug) {
-			printk("Calling initcall 0x%p", *call);
-			print_fn_descriptor_symbol(": %s()",
+			print_fn_descriptor_symbol("calling  %s()\n",
 					(unsigned long) *call);
-			printk("\n");
 			t0 = ktime_get();
 		}
 
@@ -693,15 +691,10 @@ static void __init do_initcalls(void)
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
@@ -717,10 +710,9 @@ static void __init do_initcalls(void)
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

mm-only-enforce-acpi-resource-conflict-checks.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup-update.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch
pci-simplify-quirk-debug-output.patch
pci-remove-pci=routeirq-noise-from-dmesg.patch
simplify-initcall_debug-output.patch
pnp-skip-dev-protocol-null-checks.patch
pnp-simplify-quirk-debug-output.patch
