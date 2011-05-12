From: akpm@linux-foundation.org
Subject: + documentation-configfs-examples-crash-fix-checkpatch-fixes.patch added to -mm tree
Date: Thu, 12 May 2011 12:54:04 -0700
Message-ID: <201105121954.p4CJs5TC029845@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757868Ab1ELTym (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 May 2011 15:54:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jslaby@suse.cz


The patch titled
     documentation-configfs-examples-crash-fix-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     documentation-configfs-examples-crash-fix-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: documentation-configfs-examples-crash-fix-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: braces {} are not necessary for single statement blocks
#24: FILE: Documentation/filesystems/configfs/configfs_example_explicit.c:467:
+	for (i--; i >= 0; i--) {
 		configfs_unregister_subsystem(example_subsys[i]);
 	}

WARNING: braces {} are not necessary for single statement blocks
#36: FILE: Documentation/filesystems/configfs/configfs_example_macros.c:430:
+	for (i--; i >= 0; i--) {
 		configfs_unregister_subsystem(example_subsys[i]);
 	}

total: 0 errors, 2 warnings, 16 lines checked

./patches/documentation-configfs-examples-crash-fix.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/configfs/configfs_example_explicit.c |    6 ++----
 Documentation/filesystems/configfs/configfs_example_macros.c   |    6 ++----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff -puN Documentation/filesystems/configfs/configfs_example_explicit.c~documentation-configfs-examples-crash-fix-checkpatch-fixes Documentation/filesystems/configfs/configfs_example_explicit.c
--- a/Documentation/filesystems/configfs/configfs_example_explicit.c~documentation-configfs-examples-crash-fix-checkpatch-fixes
+++ a/Documentation/filesystems/configfs/configfs_example_explicit.c
@@ -464,9 +464,8 @@ static int __init configfs_example_init(
 	return 0;
 
 out_unregister:
-	for (i--; i >= 0; i--) {
+	for (i--; i >= 0; i--)
 		configfs_unregister_subsystem(example_subsys[i]);
-	}
 
 	return ret;
 }
@@ -475,9 +474,8 @@ static void __exit configfs_example_exit
 {
 	int i;
 
-	for (i = 0; example_subsys[i]; i++) {
+	for (i = 0; example_subsys[i]; i++)
 		configfs_unregister_subsystem(example_subsys[i]);
-	}
 }
 
 module_init(configfs_example_init);
diff -puN Documentation/filesystems/configfs/configfs_example_macros.c~documentation-configfs-examples-crash-fix-checkpatch-fixes Documentation/filesystems/configfs/configfs_example_macros.c
--- a/Documentation/filesystems/configfs/configfs_example_macros.c~documentation-configfs-examples-crash-fix-checkpatch-fixes
+++ a/Documentation/filesystems/configfs/configfs_example_macros.c
@@ -427,9 +427,8 @@ static int __init configfs_example_init(
 	return 0;
 
 out_unregister:
-	for (i--; i >= 0; i--) {
+	for (i--; i >= 0; i--)
 		configfs_unregister_subsystem(example_subsys[i]);
-	}
 
 	return ret;
 }
@@ -438,9 +437,8 @@ static void __exit configfs_example_exit
 {
 	int i;
 
-	for (i = 0; example_subsys[i]; i++) {
+	for (i = 0; example_subsys[i]; i++)
 		configfs_unregister_subsystem(example_subsys[i]);
-	}
 }
 
 module_init(configfs_example_init);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fix-block-remove-extra-discard_alignment-from-hd_struct.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-provide-helper-to-register-leds-gpio-devices.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
osst-wrong-index-used-in-inner-loop-checkpatch-fixes.patch
drivers-scsi-osstc-fix-warning.patch
drbd-fix-warning.patch
slab-use-numa_no_node.patch
mm.patch
mm-nommu-sort-mm-mmap-list-properly-fix.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur-fix.patch
mm-mmu_gather-rework-fix.patch
mm-uninline-large-generic-tlbh-functions.patch
mm-thp-optimize-memcg-charge-in-khugepaged-fix.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-fix.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-checkpatch-fixes.patch
writeback-sync-expired-inodes-first-in-background-writeback-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-2.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
nommu-add-page-alignment-to-mmap-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
cris-convert-old-cpumask-api-into-new-one-checkpatch-fixes.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix.patch
printk-allocate-kernel-log-buffer-earlier-v2-checkpatch-fixes.patch
printk-allocate-kernel-log-buffer-earlier-v2-fix.patch
lru_cache-use-correct-type-in-sizeof-for-allocation-fix.patch
percpu_counter-change-return-value-and-add-comments-fix.patch
compat-fixes-to-allow-working-with-tile-arch-checkpatch-fixes.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
fs-ncpfs-inodec-suppress-used-uninitialised-warning.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch-fix.patch
documentation-accounting-getdelaysc-handle-sendto-failures.patch
documentation-configfs-examples-crash-fix-checkpatch-fixes.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-add-stats-to-monitor-soft_limit-reclaim-v2-fix.patch
memcg-add-stats-to-monitor-soft_limit-reclaim-v2-fix-2.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops-fix.patch
kernel-profilec-remove-some-duplicate-code-from-profile_hits-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

