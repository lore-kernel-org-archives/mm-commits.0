From: akpm@osdl.org
Subject: - i386-modpost-smpboot-code-warning-fix.patch removed from -mm tree
Date: Sat, 06 Jan 2007 23:58:46 -0800
Message-ID: <200701070758.l077wk2a012978@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40784 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932449AbXAGH6x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 02:58:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@in.ibm.com, ak@suse.de, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     i386: modpost smpboot code warning fix
has been removed from the -mm tree.  Its filename was
     i386-modpost-smpboot-code-warning-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: modpost smpboot code warning fix
From: Vivek Goyal <vgoyal@in.ibm.com>

o Currently synchronize_tsc_ap() is of type __init. It is called by
  smp_callin() which is of type __cpuinit. So synchronize_tsc_ap()
  should be of type __cpuinit.

o Modpost generates warnings for i386 if CONFIG_RELOCATABLE=y and
  CONFIG_HOTPLUG_CPU=y

WARNING: vmlinux - Section mismatch: reference to .init.data: from .text between 'start_secondary' (at offset 0xc01164dc) and 'initialize_secondary'
WARNING: vmlinux - Section mismatch: reference to .init.data: from .text between 'start_secondary' (at offset 0xc01164e8) and 'initialize_secondary'

o tsc is of type __initdata. It should be of type __cpuinitdata.

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/smpboot.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/smpboot.c~i386-modpost-smpboot-code-warning-fix arch/i386/kernel/smpboot.c
--- a/arch/i386/kernel/smpboot.c~i386-modpost-smpboot-code-warning-fix
+++ a/arch/i386/kernel/smpboot.c
@@ -227,7 +227,7 @@ static struct {
 	atomic_t count_start;
 	atomic_t count_stop;
 	unsigned long long values[NR_CPUS];
-} tsc __initdata = {
+} tsc __cpuinitdata = {
 	.start_flag = ATOMIC_INIT(0),
 	.count_start = ATOMIC_INIT(0),
 	.count_stop = ATOMIC_INIT(0),
@@ -332,7 +332,7 @@ static void __init synchronize_tsc_bp(vo
 		printk("passed.\n");
 }
 
-static void __init synchronize_tsc_ap(void)
+static void __cpuinit synchronize_tsc_ap(void)
 {
 	int i;
 
_

Patches currently in -mm which might be from vgoyal@in.ibm.com are

scsi-megaraid_mmmbox-init-fix-for-kdump.patch
i386-cpu-hotplug-smpboot-misc-modpost-warning-fixes.patch
convert-some-functions-to-__init-to-avoid-modpost-warnings.patch
i386-move-startup_32-in-texthead-section.patch
break-init-in-two-parts-to-avoid-modpost-warnings.patch
i386-fix-memory-hotplug-related-modpost-generated-warning.patch
i386-make-apic-probe-function-non-init.patch
modpost-add-more-symbols-to-whitelist-pattern2.patch
modpost-whitelist-reference-to-more-symbols-pattern-3.patch
clockevents-i386-drivers.patch
