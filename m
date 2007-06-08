From: akpm@linux-foundation.org
Subject: - lguest-more-lazy_hcalls.patch removed from -mm tree
Date: Thu, 07 Jun 2007 23:13:57 -0700
Message-ID: <200706080613.l586Dv0m020969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36807 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754707AbXFHGOI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 02:14:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest: more lazy_hcalls
has been removed from the -mm tree.  Its filename was
     lguest-more-lazy_hcalls.patch

This patch was dropped because it was folded into lguest-the-guest-code.patch

------------------------------------------------------
Subject: lguest: more lazy_hcalls
From: Rusty Russell <rusty@rustcorp.com.au>

Some hypercalls can be batched: lazy_hcall is the wrapper which determines
this, so it's pretty harmless to use lazy_hcall() instead of hcall().

Before:
Time for one context switch via pipe: 6745 (6521 - 13966)

After:
Time for one context switch via pipe: 5406 (5170 - 7467)

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/lguest.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/lguest/lguest.c~lguest-more-lazy_hcalls drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c~lguest-more-lazy_hcalls
+++ a/drivers/lguest/lguest.c
@@ -227,7 +227,7 @@ static void lguest_cpuid(unsigned int *e
 static unsigned long current_cr0, current_cr3;
 static void lguest_write_cr0(unsigned long val)
 {
-	hcall(LHCALL_TS, val & 8, 0, 0);
+	lazy_hcall(LHCALL_TS, val & 8, 0, 0);
 	current_cr0 = val;
 }
 
@@ -249,7 +249,7 @@ static unsigned long lguest_read_cr2(voi
 
 static void lguest_write_cr3(unsigned long cr3)
 {
-	hcall(LHCALL_NEW_PGTABLE, cr3, 0, 0);
+	lazy_hcall(LHCALL_NEW_PGTABLE, cr3, 0, 0);
 	current_cr3 = cr3;
 }
 
@@ -289,7 +289,7 @@ static void lguest_set_pte(pte_t *ptep, 
 	*ptep = pteval;
 	/* Don't bother with hypercall before initial setup. */
 	if (current_cr3)
-		hcall(LHCALL_FLUSH_TLB, 1, 0, 0);
+		lazy_hcall(LHCALL_FLUSH_TLB, 1, 0, 0);
 }
 
 static void lguest_flush_tlb_single(unsigned long addr)
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

git-kbuild.patch
paravirt-helper-to-disable-all-io-space.patch
paravirt-helper-to-disable-all-io-space-fix.patch
xen-disable-all-non-virtual-devices.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
use-menuconfig-objects-ii-module-menu.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-more-lazy_hcalls.patch
lguest-the-guest-code-tsc-fix.patch
lguest-the-guest-code-suppress-ide-probing.patch
lguest-the-host-code.patch
lguest-the-host-code-tidyups.patch
lguest-the-host-code-tidyups-update.patch
lguest-the-host-code-borkages.patch
lguest-faster-tls-switching.patch
lguest-the-host-code-dont-signal-like-crazy-use-lhreq_break-command.patch
lguest-the-host-code-use-tsc.patch
lguest-the-host-code-use-hrtimers.patch
lguest-the-host-code-update-for-mm-simplify-boot_params.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-makefile-and-kconfig-tidyups.patch
lguest-the-console-driver.patch
lguest-the-console-driver-tidyups.patch
lguest-the-net-driver.patch
lguest-the-net-driver-tidyups.patch
lguest-the-net-driver-tidyups-update.patch
lguest-the-net-driver-include-fix.patch
lguest-the-block-driver.patch
lguest-the-block-driver-tidyups.patch
lguest-the-block-driver-tidyups-update.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-example-launcher-fix.patch
lguest-dont-signal-like-crazy-use-lhreq_break-command-doc.patch
lguest-documentation-infrastructure-and-chapter-i.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
