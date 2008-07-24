From: akpm@linux-foundation.org
Subject: - mm-vmstatc-proper-externs.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:21:35 -0700
Message-ID: <200807242321.m6ONLZnD010404@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38039 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754019AbYGXXVr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:21:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm/vmstat.c: proper externs
has been removed from the -mm tree.  Its filename was
     mm-vmstatc-proper-externs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/vmstat.c: proper externs
From: Adrian Bunk <bunk@kernel.org>

This patch adds proper extern declarations for five variables in
include/linux/vmstat.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_misc.c    |    4 ----
 include/linux/vmstat.h |    6 ++++++
 kernel/sysctl.c        |    2 +-
 mm/vmstat.c            |    1 +
 4 files changed, 8 insertions(+), 5 deletions(-)

diff -puN fs/proc/proc_misc.c~mm-vmstatc-proper-externs fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~mm-vmstatc-proper-externs
+++ a/fs/proc/proc_misc.c
@@ -232,7 +232,6 @@ static int meminfo_read_proc(char *page,
 #undef K
 }
 
-extern const struct seq_operations fragmentation_op;
 static int fragmentation_open(struct inode *inode, struct file *file)
 {
 	(void)inode;
@@ -246,7 +245,6 @@ static const struct file_operations frag
 	.release	= seq_release,
 };
 
-extern const struct seq_operations pagetypeinfo_op;
 static int pagetypeinfo_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &pagetypeinfo_op);
@@ -259,7 +257,6 @@ static const struct file_operations page
 	.release	= seq_release,
 };
 
-extern const struct seq_operations zoneinfo_op;
 static int zoneinfo_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &zoneinfo_op);
@@ -356,7 +353,6 @@ static const struct file_operations proc
 	.release	= seq_release,
 };
 
-extern const struct seq_operations vmstat_op;
 static int vmstat_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &vmstat_op);
diff -puN include/linux/vmstat.h~mm-vmstatc-proper-externs include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-vmstatc-proper-externs
+++ a/include/linux/vmstat.h
@@ -44,6 +44,12 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		NR_VM_EVENT_ITEMS
 };
 
+extern const struct seq_operations fragmentation_op;
+extern const struct seq_operations pagetypeinfo_op;
+extern const struct seq_operations zoneinfo_op;
+extern const struct seq_operations vmstat_op;
+extern int sysctl_stat_interval;
+
 #ifdef CONFIG_VM_EVENT_COUNTERS
 /*
  * Light weight per cpu counter implementation.
diff -puN kernel/sysctl.c~mm-vmstatc-proper-externs kernel/sysctl.c
--- a/kernel/sysctl.c~mm-vmstatc-proper-externs
+++ a/kernel/sysctl.c
@@ -43,6 +43,7 @@
 #include <linux/limits.h>
 #include <linux/dcache.h>
 #include <linux/syscalls.h>
+#include <linux/vmstat.h>
 #include <linux/nfs_fs.h>
 #include <linux/acpi.h>
 #include <linux/reboot.h>
@@ -80,7 +81,6 @@ extern int sysctl_drop_caches;
 extern int percpu_pagelist_fraction;
 extern int compat_log;
 extern int maps_protect;
-extern int sysctl_stat_interval;
 extern int latencytop_enabled;
 extern int sysctl_nr_open_min, sysctl_nr_open_max;
 #ifdef CONFIG_RCU_TORTURE_TEST
diff -puN mm/vmstat.c~mm-vmstatc-proper-externs mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstatc-proper-externs
+++ a/mm/vmstat.c
@@ -13,6 +13,7 @@
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/cpu.h>
+#include <linux/vmstat.h>
 #include <linux/sched.h>
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
git-xtensa.patch
init-do_mountsc-should-include-linux-initrdh.patch
build-kernel-profileo-only-when-requested.patch
build-kernel-profileo-only-when-requested-cleanups.patch
asm-generic-int-ll64h-always-provide-__su64.patch
remove-some-more-tipar-bits.patch
include-linux-kernelh-userspace-header-cleanup.patch
minix-remove-no_truncate-code.patch
jbd-unexport-journal_update_superblock.patch
coda-remove-coda_fs_old_api.patch
fat-dirc-switch-to-struct-__fat_dirent.patch
remove-the-in-kernel-struct-dirent64.patch
remove-unused-include-linux-direnths.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
pty-remove-unused-unix98_pty_count-options.patch
proper-extern-for-mwave_s_mdd.patch
if-0-hpet_unregister.patch
unexport-proc_clear_tty.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
proper-pidhashmap_init-prototypes.patch
unexport-uts_sem.patch
parport-sharec-proper-externs.patch
tpm_biosc-make-2-structs-static.patch
drm-make-drm_minors_cleanup-static.patch
make-cgroup_seqfile_release-static.patch
make-pnp_add_card_id-static.patch
make-parport_cs_release-static.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
make-macfb_setup-static.patch
video-console-sticonrec-make-code-static.patch
video-console-sticonrec-make-code-static-checkpatch-fixes.patch
video-stifbc-make-2-functions-static.patch
reiser4.patch

