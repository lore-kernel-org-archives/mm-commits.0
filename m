From: akpm@linux-foundation.org
Subject: - x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:52:00 -0800
Message-ID: <200702150852.l1F8q0Oo025339@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40385 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965569AbXBOIwQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:52:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@suse.de, ebiederm@xmission.com, luigi.genoni@pirelli.com, mm-commits@vger.kernel.org


The patch titled
     x86_64-survive-having-no-irq-mapping-for-a-vector-fix
has been removed from the -mm tree.  Its filename was
     x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64-survive-having-no-irq-mapping-for-a-vector-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: "Luigi Genoni" <luigi.genoni@pirelli.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/irq.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN arch/x86_64/kernel/irq.c~x86_64-survive-having-no-irq-mapping-for-a-vector-fix arch/x86_64/kernel/irq.c
--- a/arch/x86_64/kernel/irq.c~x86_64-survive-having-no-irq-mapping-for-a-vector-fix
+++ a/arch/x86_64/kernel/irq.c
@@ -15,9 +15,11 @@
 #include <linux/seq_file.h>
 #include <linux/module.h>
 #include <linux/delay.h>
+
 #include <asm/uaccess.h>
 #include <asm/io_apic.h>
 #include <asm/idle.h>
+#include <asm/smp.h>
 
 atomic_t irq_err_count;
 
@@ -140,10 +142,10 @@ asmlinkage unsigned int do_IRQ(struct pt
 	else {
 		if (!disable_apic)
 			ack_APIC_irq();
-
 		if (printk_ratelimit())
-			printk(KERN_EMERG "%s: %d.%d No irq handler for vector\n",
-				__func__, smp_processor_id(), vector);
+			printk(KERN_EMERG "%s: %d.%d No irq handler for "
+					"vector\n", __FUNCTION__,
+					smp_processor_id(), vector);
 	}
 
 	irq_exit();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-agpgart.patch
git-arm.patch
git-cpufreq.patch
powerpc-rtas-msi-support-fix.patch
git-drm.patch
git-dvb.patch
sis-warning-fixes.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler-tidy.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-mips-fixup.patch
git-mtd.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
Fabric7-VIOC-driver-fixes.patch
git-backlight.patch
git-backlight-sony-fix.patch
git-sh.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-unionfs-fixup.patch
before-x86_64-mm-mmconfig-share.patch
after-before-x86_64-mm-mmconfig-share.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
kprobes-list-all-active-probes-in-the-system.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-epoll-compat-code-to-kernel-compatc-tidy.patch
revert-x86_64-mm-putreg-check.patch
git-gccbug-fixup.patch
