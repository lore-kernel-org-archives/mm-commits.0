From: akpm@linux-foundation.org
Subject: - add-warn_on_secs-macro-simplification-fix-fix.patch removed from -mm tree
Date: Mon, 28 Apr 2008 22:20:12 -0700
Message-ID: <200804290520.m3T5KCwx002750@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753605AbYD2FVN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 01:21:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@saeurebad.de, hidave.darkstar@gmail.com, paulmck@linux.vnet.ibm.com, tremyfr@yahoo.fr, mm-commits@vger.kernel.org


The patch titled
     add-warn_on_secs-macro-simplification-fix-fix
has been removed from the -mm tree.  Its filename was
     add-warn_on_secs-macro-simplification-fix-fix.patch

This patch was dropped because it was folded into add-warn_on_secs-macro.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: add-warn_on_secs-macro-simplification-fix-fix
From: Andrew Morton <akpm@linux-foundation.org>

We still need the param.h include.

> From: Reynes Philippe <tremyfr@yahoo.fr>
> To: Andrew Morton <akpm@linux-foundation.org>
> Subject: [PATCH] [MM] include param.h in rcupreempt.h if CONFIG_NO_HZ is set
> Date: Sun, 30 Mar 2008 18:55:39 +0200 (CEST)
> 
> The file rcupreempt.h needs HZ if CONFIG_NO_HZ is set. But HZ is defined
> in include/linux/param.h, and this file isn't included. So the compilation fails with
> this error :
> 
>   CC      init/main.o
> In file included from include/linux/rcupdate.h:57,
>                  from include/linux/rculist.h:10,
>                  from include/linux/dcache.h:6,
>                  from include/linux/fs.h:278,
>                  from include/linux/proc_fs.h:5,
>                  from init/main.c:14:
> include/linux/rcupreempt.h: In function rcu_enter_nohz:
> include/linux/rcupreempt.h:90: erreur: HZ undeclared (first use in this function)
> include/linux/rcupreempt.h:90: erreur: (Each undeclared identifier is reported only once
> include/linux/rcupreempt.h:90: erreur: for each function it appears in.)
> include/linux/rcupreempt.h: In function rcu_exit_nohz:
> include/linux/rcupreempt.h:97: erreur: HZ undeclared (first use in this function)

Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: Johannes Weiner <hannes@saeurebad.de>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Reynes Philippe <tremyfr@yahoo.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bug.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/asm-generic/bug.h~add-warn_on_secs-macro-simplification-fix-fix include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~add-warn_on_secs-macro-simplification-fix-fix
+++ a/include/asm-generic/bug.h
@@ -2,6 +2,7 @@
 #define _ASM_GENERIC_BUG_H
 
 #include <linux/compiler.h>
+#include <linux/param.h>
 
 #ifdef CONFIG_BUG
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
make-dev-kmem-a-config-option.patch
misc-phantom-add-compat-ioctl.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
codafs-fix-build-warning.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations.patch
lib-swiotlbc-cleanups.patch
fs-inodec-use-hlist_for_each_entry.patch
add-warn_on_secs-macro.patch
add-warn_on_secs-macro-simplification-fix-fix.patch
ecryptfs-make-key-module-subsystem-respect-namespaces-fix-refs-to-pid-and-user_ns-fix.patch
x86-olpc-add-one-laptop-per-child-architecture-support-fix.patch
x86-olpc-add-one-laptop-per-child-architecture-support-fix-2.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
revert-part-of-sched-cpuset-customize-sched-domains-core.patch
reapply-sched-cpuset-customize-sched-domains-core-bits.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
cgroups-implement-device-whitelist-v6-cleanups.patch
cgroups-implement-device-whitelist-v6-fix.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
memcgroup-implement-failcounter-reset-checkpatch-fixes.patch
use-vmalloc-for-mem_cgroup-allocation-v3-simplification.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipc-add-definitions-of-ushort_max-and-others-checkpatch-fixes.patch
ipc-sysvsem-refuse-cloneclone_sysvsemclone_newipc-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
sxc-fix-printk-warnings-on-sparc32.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
isicom-bring-into-coding-style-fix.patch
tty-the-big-operations-rework-fix-2.patch
tty-the-big-operations-rework-isicom-fix.patch
tty-the-big-operations-rework-simserial-fix.patch
tty-the-big-operations-rework-vs-git-kgdb-light.patch
tty-the-big-operations-rework-vs-kgdb-2.patch
devpts-factor-out-pty-index-allocation-fix.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
procfs-task-exe-symlink-fix.patch
proc-switch-to-proc_create.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
fuse-fix-race-in-llseek-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
add-macros-similar-to-min-max-min_t-max_t.patch
rename-div64_64-to-div64_u64-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix-fix.patch
edac-add-e752x-parameter-for-sysbus_parity-selection-checkpatch-fixes.patch
ncpfs-use-get-put_unaligned_-helpers-checkpatch-fixes.patch
relayfs-support-larger-relay-buffer-take-3-cleanup.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

