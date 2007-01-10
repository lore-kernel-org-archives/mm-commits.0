From: akpm@osdl.org
Subject: - convert-some-functions-to-__init-to-avoid-modpost-warnings.patch removed from -mm tree
Date: Wed, 10 Jan 2007 15:03:20 -0800
Message-ID: <200701102303.l0AN3KhY010811@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33356 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965248AbXAJXDZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 18:03:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Convert some functions to __init to avoid MODPOST warnings
has been removed from the -mm tree.  Its filename was
     convert-some-functions-to-__init-to-avoid-modpost-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Convert some functions to __init to avoid MODPOST warnings
From: Vivek Goyal <vgoyal@in.ibm.com>

o Some functions which should have been in init sections as they are called
  only once. Put them in init sections. Otherwise MODPOST generates warning
  as these functions are placed in .text and they end up accessing something
  in init sections.

WARNING: vmlinux - Section mismatch: reference to .init.text:migration_init
from .text between 'do_pre_smp_initcalls' (at offset 0xc01000d1) and
'run_init_process'

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/setup.c |    2 +-
 init/main.c              |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/setup.c~convert-some-functions-to-__init-to-avoid-modpost-warnings arch/i386/kernel/setup.c
--- a/arch/i386/kernel/setup.c~convert-some-functions-to-__init-to-avoid-modpost-warnings
+++ a/arch/i386/kernel/setup.c
@@ -496,7 +496,7 @@ static void set_mca_bus(int x) { }
 #endif
 
 /* Overridden in paravirt.c if CONFIG_PARAVIRT */
-char * __attribute__((weak)) memory_setup(void)
+char * __init __attribute__((weak)) memory_setup(void)
 {
 	return machine_specific_memory_setup();
 }
diff -puN init/main.c~convert-some-functions-to-__init-to-avoid-modpost-warnings init/main.c
--- a/init/main.c~convert-some-functions-to-__init-to-avoid-modpost-warnings
+++ a/init/main.c
@@ -703,7 +703,7 @@ static void __init do_basic_setup(void)
 	do_initcalls();
 }
 
-static void do_pre_smp_initcalls(void)
+static void __init do_pre_smp_initcalls(void)
 {
 	extern int spawn_ksoftirqd(void);
 #ifdef CONFIG_SMP
_

Patches currently in -mm which might be from vgoyal@in.ibm.com are

change-cpu_up-and-co-from-__devinit-to-__cpuinit.patch
kdump-documentation-update-for-2620.patch
pci-quirks-modpost-warning-fix.patch
i386-sched_clock-using-init-data-tsc_disable-fix.patch
make-noirqdebug_setup-function-non-init-to-fix-modpost-warning.patch
scsi-megaraid_mmmbox-init-fix-for-kdump.patch
clockevents-i386-drivers.patch
