From: akpm@linux-foundation.org
Subject: [folded] memcg-fix-numa-scan-information-update-to-be-triggered-by-memory-event-fix.patch removed from -mm tree
Date: Fri, 08 Jul 2011 15:30:00 -0700
Message-ID: <201107082230.p68MU0Lr019063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751928Ab1GHWac (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2011 18:30:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg-fix-numa-scan-information-update-to-be-triggered-by-memory-event-fix
has been removed from the -mm tree.  Its filename was
     memcg-fix-numa-scan-information-update-to-be-triggered-by-memory-event-fix.patch

This patch was dropped because it was folded into memcg-fix-numa-scan-information-update-to-be-triggered-by-memory-event.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-fix-numa-scan-information-update-to-be-triggered-by-memory-event-fix
From: Andrew Morton <akpm@linux-foundation.org>

attempt to repair code layout

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-numa-scan-information-update-to-be-triggered-by-memory-event-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-numa-scan-information-update-to-be-triggered-by-memory-event-fix
+++ a/mm/memcontrol.c
@@ -704,10 +704,10 @@ static void memcg_check_events(struct me
 		mem_cgroup_threshold(mem);
 		__mem_cgroup_target_update(mem, MEM_CGROUP_TARGET_THRESH);
 		if (unlikely(__memcg_event_check(mem,
-			MEM_CGROUP_TARGET_SOFTLIMIT))){
+			     MEM_CGROUP_TARGET_SOFTLIMIT))) {
 			mem_cgroup_update_tree(mem, page);
 			__mem_cgroup_target_update(mem,
-				MEM_CGROUP_TARGET_SOFTLIMIT);
+						   MEM_CGROUP_TARGET_SOFTLIMIT);
 		}
 #if MAX_NUMNODES > 1
 		if (unlikely(__memcg_event_check(mem,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
headers_check-is-broken.patch
samples-hidraw-is-busted.patch
memcg-fix-reclaimable-lru-check-in-memcg.patch
memcg-fix-numa-scan-information-update-to-be-triggered-by-memory-event.patch
mm-preallocate-page-before-lock_page-at-filemap-cow-fix.patch
w1-ds1wm-add-a-reset-recovery-parameter-checkpatch-fixes.patch
xtensa-prevent-arbitrary-read-in-ptrace-fix.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver-fix.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-net-skgec-support-dlink-dge-530t-rev-c1.patch
drivers-video-backlight-aat2870_blc-make-it-buildable-as-a-module.patch
pci-enumerate-the-pci-device-only-removed-out-pci-hierarchy-of-os-when-re-scanning-pci-fix.patch
drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-correct-error.patch
drivers-staging-gma500-psb_intel_displayc-fix-build.patch
drivers-staging-dt3155v4l-dt3155v4lc-needs-slabh.patch
drivers-staging-solo6x10-corec-needs-slabh.patch
drivers-staging-solo6x10-p2mc-needs-slabh.patch
staging-more-missing-slabh-inclusions.patch
slab-use-numa_no_node.patch
mm.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix.patch
pagewalk-add-locking-rule-comments-fix.patch
mm-memoryc-remove-zap_block_size.patch
mm-memblockc-avoid-abuse-of-red_inactive.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
drivers-misc-add-support-the-fsa9480-usb-switch-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
checkpatch-add-a-prefer-__aligned-check.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
init-skip-calibration-delay-if-previously-done-4.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
memcg-consolidates-memory-cgroup-lru-stat-functions-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
h8300-m68k-xtensa-__fd_isset-should-return-0-1.patch
proc-pid-fdinfo-add-cloexec-information-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-fix-2.patch
ipc-introduce-shm_rmid_forced-sysctl-cleanup.patch
ipc-introduce-shm_rmid_forced-sysctl-comments-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

