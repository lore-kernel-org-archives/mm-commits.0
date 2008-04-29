From: akpm@linux-foundation.org
Subject: - ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 28 Apr 2008 22:52:08 -0700
Message-ID: <200804290552.m3T5q8e4003902@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53453 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752412AbYD2Fxy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 01:53:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cminyard@mvista.com, rocky.craig@hp.com, schulz@schwaar.com, mm-commits@vger.kernel.org


The patch titled
     ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch

This patch was dropped because it was folded into ipmi-style-fixes-in-the-system-interface-code.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: printk() should include KERN_ facility level
#201: FILE: drivers/char/ipmi/ipmi_bt_sm.c:384:
+			printk(" %02x", bt->read_data[i]);

ERROR: no space before that '++' (ctx:WxB)
#475: FILE: drivers/char/ipmi/ipmi_kcs_sm.c:295:
+		for (i = 0; i < size; i ++)
 		                        ^

ERROR: need space after that ',' (ctx:VxO)
#1703: FILE: drivers/char/ipmi/ipmi_si_sm.h:70:
+	SI_SM_CALL_WITH_TICK_DELAY,/* Delay >=1 tick before calling again. */
 	                          ^

total: 2 errors, 1 warnings, 1977 lines checked

./patches/ipmi-style-fixes-in-the-system-interface-code.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Corey Minyard <cminyard@mvista.com>
Cc: Hannes Schulz <schulz@schwaar.com>
Cc: Rocky Craig <rocky.craig@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_bt_sm.c  |    4 ++--
 drivers/char/ipmi/ipmi_kcs_sm.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/char/ipmi/ipmi_bt_sm.c~ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes drivers/char/ipmi/ipmi_bt_sm.c
--- a/drivers/char/ipmi/ipmi_bt_sm.c~ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes
+++ a/drivers/char/ipmi/ipmi_bt_sm.c
@@ -381,8 +381,8 @@ static inline int read_all_bytes(struct 
 		if (max > 16)
 			max = 16;
 		for (i = 0; i < max; i++)
-			printk(" %02x", bt->read_data[i]);
-		printk("%s\n", bt->read_count == max ? "" : " ...");
+			printk(KERN_CONT " %02x", bt->read_data[i]);
+		printk(KERN_CONT "%s\n", bt->read_count == max ? "" : " ...");
 	}
 
 	/* per the spec, the (NetFn[1], Seq[2], Cmd[3]) tuples must match */
diff -puN drivers/char/ipmi/ipmi_kcs_sm.c~ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes drivers/char/ipmi/ipmi_kcs_sm.c
--- a/drivers/char/ipmi/ipmi_kcs_sm.c~ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes
+++ a/drivers/char/ipmi/ipmi_kcs_sm.c
@@ -292,7 +292,7 @@ static int start_kcs_transaction(struct 
 
 	if (kcs_debug & KCS_DEBUG_MSG) {
 		printk(KERN_DEBUG "start_kcs_transaction -");
-		for (i = 0; i < size; i ++)
+		for (i = 0; i < size; i++)
 			printk(" %02x", (unsigned char) (data [i]));
 		printk("\n");
 	}
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

