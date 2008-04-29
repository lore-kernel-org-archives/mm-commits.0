From: akpm@linux-foundation.org
Subject: - idr-create-idr_layer_cache-at-boot-time-fix.patch removed from -mm tree
Date: Mon, 28 Apr 2008 23:04:20 -0700
Message-ID: <200804290604.m3T64Km6004401@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753285AbYD2GEX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 02:04:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     idr-create-idr_layer_cache-at-boot-time-fix
has been removed from the -mm tree.  Its filename was
     idr-create-idr_layer_cache-at-boot-time-fix.patch

This patch was dropped because it was folded into idr-create-idr_layer_cache-at-boot-time.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: idr-create-idr_layer_cache-at-boot-time-fix
From: Andrew Morton <akpm@linux-foundation.org>

Now init_id_cache() is global symbol it needs a better name.  Rename it to
idr_init_cache().

Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |    2 +-
 init/main.c         |    2 +-
 lib/idr.c           |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/idr.h~idr-create-idr_layer_cache-at-boot-time-fix include/linux/idr.h
--- a/include/linux/idr.h~idr-create-idr_layer_cache-at-boot-time-fix
+++ a/include/linux/idr.h
@@ -115,6 +115,6 @@ void ida_remove(struct ida *ida, int id)
 void ida_destroy(struct ida *ida);
 void ida_init(struct ida *ida);
 
-void __init init_id_cache(void);
+void __init idr_init_cache(void);
 
 #endif /* __IDR_H__ */
diff -puN init/main.c~idr-create-idr_layer_cache-at-boot-time-fix init/main.c
--- a/init/main.c~idr-create-idr_layer_cache-at-boot-time-fix
+++ a/init/main.c
@@ -636,7 +636,7 @@ asmlinkage void __init start_kernel(void
 	enable_debug_pagealloc();
 	cpu_hotplug_init();
 	kmem_cache_init();
-	init_id_cache();
+	idr_init_cache();
 	setup_per_cpu_pageset();
 	numa_policy_init();
 	if (late_time_init)
diff -puN lib/idr.c~idr-create-idr_layer_cache-at-boot-time-fix lib/idr.c
--- a/lib/idr.c~idr-create-idr_layer_cache-at-boot-time-fix
+++ a/lib/idr.c
@@ -585,7 +585,7 @@ static void idr_cache_ctor(struct kmem_c
 	memset(idr_layer, 0, sizeof(struct idr_layer));
 }
 
-void __init init_id_cache(void)
+void __init idr_init_cache(void)
 {
 	idr_layer_cache = kmem_cache_create("idr_layer_cache",
 				sizeof(struct idr_layer), 0, SLAB_PANIC,
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
ecryptfs-integrate-ecryptfs-device-handle-into-the-module.patch
ecryptfs-make-key-module-subsystem-respect-namespaces.patch
x86-olpc-add-one-laptop-per-child-architecture-support.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
cgroups-implement-device-whitelist-v6.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
memcgroup-implement-failcounter-reset.patch
use-vmalloc-for-mem_cgroup-allocation-v3.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies.patch
ipc-use-ipc_buildid-directly-from-ipc_addid.patch
ipc-add-definitions-of-ushort_max-and-others.patch
ipc-sysvsem-refuse-cloneclone_sysvsemclone_newipc.patch
ipmi-run-to-completion-fixes.patch
ipmi-style-fixes-in-the-system-interface-code.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
keys-add-keyctl-function-to-get-a-security-label.patch
procfs-task-exe-symlink.patch
proc-switch-to-proc_create.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff.patch
idr-create-idr_layer_cache-at-boot-time.patch
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

