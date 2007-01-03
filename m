From: akpm@osdl.org
Subject: + i386-fix-modpost-warning-in-smp-trampoline-code.patch added to -mm tree
Date: Wed, 03 Jan 2007 13:16:09 -0800
Message-ID: <200701032116.l03LG96Y031508@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50999 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932141AbXACVRz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 3 Jan 2007 16:17:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vgoyal@in.ibm.com, ak@suse.de, ebiederm@xmission.com


The patch titled
     i386: fix modpost warning in SMP trampoline code
has been added to the -mm tree.  Its filename is
     i386-fix-modpost-warning-in-smp-trampoline-code.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: fix modpost warning in SMP trampoline code
From: Vivek Goyal <vgoyal@in.ibm.com>

o MODPOST generates warning for i386 if kernel is compiled with
  CONFIG_RELOCATABLE=y

WARNING: vmlinux - Section mismatch: reference to .init.text:startup_32_smp
from .data between 'trampoline_data' (at offset 0xc0519cf8) and 'boot_gdt'

o trampoline code/data can go into init section is CPU hotplug is not
  enabled.

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/trampoline.S |    5 +++++
 1 files changed, 5 insertions(+)

diff -puN arch/i386/kernel/trampoline.S~i386-fix-modpost-warning-in-smp-trampoline-code arch/i386/kernel/trampoline.S
--- a/arch/i386/kernel/trampoline.S~i386-fix-modpost-warning-in-smp-trampoline-code
+++ a/arch/i386/kernel/trampoline.S
@@ -38,6 +38,11 @@
 
 .data
 
+/* We can free up trampoline after bootup if cpu hotplug is not supported. */
+#ifndef CONFIG_HOTPLUG_CPU
+.section ".init.data","aw",@progbits
+#endif
+
 .code16
 
 ENTRY(trampoline_data)
_

Patches currently in -mm which might be from vgoyal@in.ibm.com are

i386-restore-config_physical_start-option.patch
i386-fix-modpost-warning-in-smp-trampoline-code.patch
i386-fix-another-modpost-warning.patch
i386-modpost-smpboot-code-warning-fix.patch
i386-cpu-hotplug-smpboot-misc-modpost-warning-fixes.patch
convert-some-functions-to-__init-to-avoid-modpost-warnings.patch
i386-move-startup_32-in-texthead-section.patch
break-init-in-two-parts-to-avoid-modpost-warnings.patch
i386-fix-memory-hotplug-related-modpost-generated-warning.patch
i386-make-apic-probe-function-non-init.patch
modpost-add-more-symbols-to-whitelist-pattern2.patch
modpost-whitelist-reference-to-more-symbols-pattern-3.patch
i386-specify-section-flags-while-creating-new-sections.patch
clockevents-i386-drivers.patch
