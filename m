From: akpm@linux-foundation.org
Subject: + safer-nr_node_ids-and-nr_node_ids-determination-and-initial-up-fix.patch added to -mm tree
Date: Thu, 01 Mar 2007 21:51:39 -0800
Message-ID: <200703020553.l225rDjU001660@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43984 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422922AbXCBFxS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:53:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, clameter@sgi.com


The patch titled
     safer-nr_node_ids-and-nr_node_ids-determination-and-initial-up-fix
has been added to the -mm tree.  Its filename is
     safer-nr_node_ids-and-nr_node_ids-determination-and-initial-up-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
cyclades-return-closing_wait.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-drm.patch
git-dvb.patch
git-dvb-fixup.patch
pvrusb-warning-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-kvm.patch
git-leds-fixup.patch
git-leds-make-it-compile.patch
git-md-accel-fixup.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
git-ubi.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
cisco_ioctl-initialise-header_cache_update.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-block-another-md-fix.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
after-before-x86_64-mm-mmconfig-share.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial-up-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial-tweak.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
