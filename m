From: akpm@linux-foundation.org
Subject: + mm-vmstatc-proper-externs.patch added to -mm tree
Date: Tue, 06 May 2008 11:37:00 -0700
Message-ID: <200805061837.m46Ib044021261@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755418AbYEFShN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 14:37:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org


The patch titled
     mm/vmstat.c: proper externs
has been added to the -mm tree.  Its filename is
     mm-vmstatc-proper-externs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 mm/vmstat.c            |    2 ++
 4 files changed, 9 insertions(+), 5 deletions(-)

diff -puN fs/proc/proc_misc.c~mm-vmstatc-proper-externs fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~mm-vmstatc-proper-externs
+++ a/fs/proc/proc_misc.c
@@ -225,7 +225,6 @@ static int meminfo_read_proc(char *page,
 #undef K
 }
 
-extern const struct seq_operations fragmentation_op;
 static int fragmentation_open(struct inode *inode, struct file *file)
 {
 	(void)inode;
@@ -239,7 +238,6 @@ static const struct file_operations frag
 	.release	= seq_release,
 };
 
-extern const struct seq_operations pagetypeinfo_op;
 static int pagetypeinfo_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &pagetypeinfo_op);
@@ -252,7 +250,6 @@ static const struct file_operations page
 	.release	= seq_release,
 };
 
-extern const struct seq_operations zoneinfo_op;
 static int zoneinfo_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &zoneinfo_op);
@@ -349,7 +346,6 @@ static const struct file_operations proc
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
@@ -44,6 +44,7 @@
 #include <linux/limits.h>
 #include <linux/dcache.h>
 #include <linux/syscalls.h>
+#include <linux/vmstat.h>
 #include <linux/nfs_fs.h>
 #include <linux/acpi.h>
 #include <linux/reboot.h>
@@ -81,7 +82,6 @@ extern int sysctl_drop_caches;
 extern int percpu_pagelist_fraction;
 extern int compat_log;
 extern int maps_protect;
-extern int sysctl_stat_interval;
 extern int latencytop_enabled;
 
 /* Constants used for minimum and  maximum */
diff -puN mm/vmstat.c~mm-vmstatc-proper-externs mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstatc-proper-externs
+++ a/mm/vmstat.c
@@ -13,7 +13,9 @@
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/cpu.h>
+#include <linux/vmstat.h>
 #include <linux/sched.h>
+
 #include "internal.h"
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
md-make-dm_dirty_log_initexit-static.patch
drm-make-drm_minors_cleanup-static.patch
git-udf.patch
nfs-make-nfs4_drop_state_owner-static.patch
show_schedstat-fix-memleak.patch
if-0-ses_match_host.patch
git-watchdog.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
reiser4.patch
remove-is_tty.patch
make-cgroup_seqfile_release-static.patch
make-kprobe_blacklist-static.patch
make-pnp_add_card_id-static.patch
mfd-sm501c-if-0-unused-functions.patch
pcmcia-kill-in_card_services.patch
video-sis-remove-compat-code.patch
make-struct-mpt_proc_root_dir-static.patch
make-parport_cs_release-static.patch
parport-sharec-proper-externs.patch
remove-include-asm-h8300-keyboardh.patch
proper-spawn_ksoftirqd-prototype.patch
proper-pidhashmap_init-prototypes.patch
mm-migratec-should-include-linux-syscallsh.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
minix-remove-no_truncate-code.patch
remove-the-v850-port.patch
mm-vmstatc-proper-externs.patch
mm-hugetlbc-fix-duplicate-variable.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
init-do_mountsc-should-include-linux-initrdh.patch
proper-prototype-for-acpi_processor_tstate_has_changed.patch
if-0-hpet_unregister.patch
tpm_biosc-make-2-structs-static.patch
proper-extern-for-mwave_s_mdd.patch
xtensa-remove-the-nonexisting-highmem-support.patch
serial-8250_gscc-add-module_license.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
unexport-proc_clear_tty.patch
unexport-uts_sem.patch

