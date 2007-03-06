From: akpm@linux-foundation.org
Subject: - safer-nr_node_ids-and-nr_node_ids-determination-and-initial-up-fix.patch removed from -mm tree
Date: Mon, 05 Mar 2007 16:22:26 -0800
Message-ID: <200703060022.l260MR3p005911@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42658 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671AbXCFAWd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 19:22:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     safer-nr_node_ids-and-nr_node_ids-determination-and-initial-up-fix
has been removed from the -mm tree.  Its filename was
     safer-nr_node_ids-and-nr_node_ids-determination-and-initial-up-fix.patch

This patch was dropped because it was folded into safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch

------------------------------------------------------
Subject: safer-nr_node_ids-and-nr_node_ids-determination-and-initial-up-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN kernel/sched.c~safer-nr_node_ids-and-nr_node_ids-determination-and-initial-up-fix kernel/sched.c
--- a/kernel/sched.c~safer-nr_node_ids-and-nr_node_ids-determination-and-initial-up-fix
+++ a/kernel/sched.c
@@ -5279,6 +5279,11 @@ int __init migration_init(void)
 #endif
 
 #ifdef CONFIG_SMP
+
+/* Number of possible processor ids */
+int nr_cpu_ids = NR_CPUS;
+EXPORT_SYMBOL(nr_cpu_ids);
+
 #undef SCHED_DOMAIN_DEBUG
 #ifdef SCHED_DOMAIN_DEBUG
 static void sched_domain_debug(struct sched_domain *sd, int cpu)
@@ -6758,10 +6763,6 @@ int in_sched_functions(unsigned long add
 		&& addr < (unsigned long)__sched_text_end);
 }
 
-/* Number of possible processor ids */
-int nr_cpu_ids = NR_CPUS;
-EXPORT_SYMBOL(nr_cpu_ids);
-
 void __init sched_init(void)
 {
 	int i, j, k;
@@ -6802,11 +6803,11 @@ void __init sched_init(void)
 		}
 		highest_cpu = i;
 	}
-	nr_cpu_ids = highest_cpu + 1;
 
 	set_load_weight(&init_task);
 
 #ifdef CONFIG_SMP
+	nr_cpu_ids = highest_cpu + 1;
 	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains, NULL);
 #endif
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-alsa-oops-fix.patch
git-drm.patch
git-dvb.patch
ia64-kexec-use-efi_loader_data-for-elf-core-header-tidy.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-md-accel-fixup.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
git-ubi.patch
git-netdev-all.patch
git-netdev-all-ipw2200-fix.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
div64_64-common-code-fix.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
after-before-x86_64-mm-mmconfig-share.patch
linux-sysdevh-needs-to-include-linux-moduleh-up-fix.patch
linux-sysdevh-needs-to-include-linux-moduleh-up-fix-2.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial-up-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial-tweak.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-2.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler-up-fix.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
fbdev-hecuba-framebuffer-driver-fix.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
