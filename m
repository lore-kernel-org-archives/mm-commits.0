From: akpm@linux-foundation.org
Subject: - fix-null-pointer-dereference-in-ia64_machine_kexec.patch removed from -mm tree
Date: Wed, 07 Feb 2007 11:52:18 -0800
Message-ID: <200702071952.l17JqIxY025230@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33770 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161373AbXBGTxo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 14:53:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, horms@verge.net.au, jlan@sgi.com, magnus@valinux.co.jp, stable@kernel.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Fix NULL-pointer dereference in ia64_machine_kexec()
has been removed from the -mm tree.  Its filename was
     fix-null-pointer-dereference-in-ia64_machine_kexec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix NULL-pointer dereference in ia64_machine_kexec()
From: Bernhard Walle <bwalle@suse.de>

This patch fixes a NULL-pointer dereference in ia64_machine_kexec().

The variable ia64_kimage is set in machine_kexec_prepare() which is
called from sys_kexec_load(). If kdump wasn't configured before,
ia64_kimage is NULL.  machine_kdump_on_init() passes ia64_kimage() to
machine_kexec() which assumes a valid value.

The patch also adds a few sanity checks for the image to simplify
debugging of similar problems in future.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Magnus Damm <magnus@valinux.co.jp>
Cc: Simon Horman <horms@verge.net.au>
Cc: Jay Lan <jlan@sgi.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/crash.c         |    5 +++++
 arch/ia64/kernel/machine_kexec.c |    2 ++
 2 files changed, 7 insertions(+)

diff -puN arch/ia64/kernel/crash.c~fix-null-pointer-dereference-in-ia64_machine_kexec arch/ia64/kernel/crash.c
--- a/arch/ia64/kernel/crash.c~fix-null-pointer-dereference-in-ia64_machine_kexec
+++ a/arch/ia64/kernel/crash.c
@@ -118,6 +118,11 @@ machine_crash_shutdown(struct pt_regs *p
 static void
 machine_kdump_on_init(void)
 {
+	if (!ia64_kimage) {
+		printk(KERN_NOTICE "machine_kdump_on_init(): "
+				"kdump not configured\n");
+		return;
+	}
 	local_irq_disable();
 	kexec_disable_iosapic();
 	machine_kexec(ia64_kimage);
diff -puN arch/ia64/kernel/machine_kexec.c~fix-null-pointer-dereference-in-ia64_machine_kexec arch/ia64/kernel/machine_kexec.c
--- a/arch/ia64/kernel/machine_kexec.c~fix-null-pointer-dereference-in-ia64_machine_kexec
+++ a/arch/ia64/kernel/machine_kexec.c
@@ -95,6 +95,7 @@ static void ia64_machine_kexec(struct un
 	unsigned long vector;
 	int ii;
 
+	BUG_ON(!image);
 	if (image->type == KEXEC_TYPE_CRASH) {
 		crash_save_this_cpu();
 		current->thread.ksp = (__u64)info->sw - 16;
@@ -133,6 +134,7 @@ static void ia64_machine_kexec(struct un
 
 void machine_kexec(struct kimage *image)
 {
+	BUG_ON(!image);
 	unw_init_running(ia64_machine_kexec, image);
 	for(;;);
 }
_

Patches currently in -mm which might be from bwalle@suse.de are

origin.patch
spider-fix-gregkh-driver-network-device.patch
