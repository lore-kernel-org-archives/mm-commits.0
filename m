From: akpm@osdl.org
Subject: + i386-make-apic-probe-function-non-init.patch added to -mm tree
Date: Wed, 27 Dec 2006 13:12:23 -0800
Message-ID: <200612272112.kBRLCNNT020323@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35152 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754747AbWL0VMu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 16:12:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vgoyal@in.ibm.com, ak@suse.de, ebiederm@xmission.com


The patch titled
     i386: make apic probe function non-init
has been added to the -mm tree.  Its filename is
     i386-make-apic-probe-function-non-init.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: make apic probe function non-init
From: Vivek Goyal <vgoyal@in.ibm.com>

o struct genapic contains pointer to probe() function which is of type
  __init. Hence MODPOST generates warning if kernel is compiled with
  CONFIG_RELOCATABLE=y for i386.

WARNING: vmlinux - Section mismatch: reference to .init.text: from .data between 'apic_summit' (at offset 0xc058b504) and 'apic_bigsmp'
WARNING: vmlinux - Section mismatch: reference to .init.text: from .data between 'apic_bigsmp' (at offset 0xc058b5a4) and 'cpu.4471'
WARNING: vmlinux - Section mismatch: reference to .init.text: from .data between 'apic_es7000' (at offset 0xc058b644) and 'apic_default'
WARNING: vmlinux - Section mismatch: reference to .init.text: from .data between 'apic_default' (at offset 0xc058b6e4) and 'interrupt'

o One of the possible options is to put special case check in MODPOST to
  not emit warnings for this case but I think it is not a very good option
  in terms of maintenance.

o Another option is to make probe() function non __init. Anyway this function
  is really small so not freeing this memory after init is not a big deal.
  Secondly, from a programming perspective, probably genapic should not
  provide pointers to functions which have been freed as genapic is non
  __init and is used even after initialization is complete.

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/mach-generic/bigsmp.c  |    2 +-
 arch/i386/mach-generic/default.c |    2 +-
 arch/i386/mach-generic/es7000.c  |    2 +-
 arch/i386/mach-generic/summit.c  |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/i386/mach-generic/bigsmp.c~i386-make-apic-probe-function-non-init arch/i386/mach-generic/bigsmp.c
--- a/arch/i386/mach-generic/bigsmp.c~i386-make-apic-probe-function-non-init
+++ a/arch/i386/mach-generic/bigsmp.c
@@ -45,7 +45,7 @@ static struct dmi_system_id __initdata b
 };
 
 
-static __init int probe_bigsmp(void)
+static int probe_bigsmp(void)
 { 
 	if (def_to_bigsmp)
         	dmi_bigsmp = 1;
diff -puN arch/i386/mach-generic/default.c~i386-make-apic-probe-function-non-init arch/i386/mach-generic/default.c
--- a/arch/i386/mach-generic/default.c~i386-make-apic-probe-function-non-init
+++ a/arch/i386/mach-generic/default.c
@@ -18,7 +18,7 @@
 #include <asm/mach-default/mach_mpparse.h>
 
 /* should be called last. */
-static __init int probe_default(void)
+static int probe_default(void)
 { 
 	return 1;
 } 
diff -puN arch/i386/mach-generic/es7000.c~i386-make-apic-probe-function-non-init arch/i386/mach-generic/es7000.c
--- a/arch/i386/mach-generic/es7000.c~i386-make-apic-probe-function-non-init
+++ a/arch/i386/mach-generic/es7000.c
@@ -19,7 +19,7 @@
 #include <asm/mach-es7000/mach_mpparse.h>
 #include <asm/mach-es7000/mach_wakecpu.h>
 
-static __init int probe_es7000(void)
+static int probe_es7000(void)
 {
 	/* probed later in mptable/ACPI hooks */
 	return 0;
diff -puN arch/i386/mach-generic/summit.c~i386-make-apic-probe-function-non-init arch/i386/mach-generic/summit.c
--- a/arch/i386/mach-generic/summit.c~i386-make-apic-probe-function-non-init
+++ a/arch/i386/mach-generic/summit.c
@@ -18,7 +18,7 @@
 #include <asm/mach-summit/mach_ipi.h>
 #include <asm/mach-summit/mach_mpparse.h>
 
-static __init int probe_summit(void)
+static int probe_summit(void)
 { 
 	/* probed later in mptable/ACPI hooks */
 	return 0;
_

Patches currently in -mm which might be from vgoyal@in.ibm.com are

i386-cpu-hotplug-smpboot-misc-modpost-warning-fixes.patch
convert-some-functions-to-__init-to-avoid-modpost-warnings.patch
i386-move-startup_32-in-texthead-section.patch
break-init-in-two-parts-to-avoid-modpost-warnings.patch
i386-fix-memory-hotplug-related-modpost-generated-warning.patch
i386-restore-config_physical_start-option.patch
i386-make-apic-probe-function-non-init.patch
modpost-add-more-symbols-to-whitelist-pattern2.patch
modpost-whitelist-reference-to-more-symbols-pattern-3.patch
clockevents-i386-drivers.patch

