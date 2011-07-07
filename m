From: akpm@linux-foundation.org
Subject: + memcg-consolidates-memory-cgroup-lru-stat-functions-fix.patch added to -mm tree
Date: Thu, 07 Jul 2011 13:51:45 -0700
Message-ID: <201107072129.p67LTVYZ014992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752628Ab1GGV3u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jul 2011 17:29:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp, yinghan@google.com


The patch titled
     memcg-consolidates-memory-cgroup-lru-stat-functions-fix
has been added to the -mm tree.  Its filename is
     memcg-consolidates-memory-cgroup-lru-stat-functions-fix.patch

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
Subject: memcg-consolidates-memory-cgroup-lru-stat-functions-fix
From: Andrew Morton <akpm@linux-foundation.org>

mm/vmscan.c: In function 'zone_nr_lru_pages':
mm/vmscan.c:175: warning: passing argument 2 of 'mem_cgroup_zone_nr_lru_pages' makes pointer from integer without a cast
include/linux/memcontrol.h:307: note: expected 'struct zone *' but argument is of type 'int'
mm/vmscan.c:175: error: too many arguments to function 'mem_cgroup_zone_nr_lru_pages'

Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-consolidates-memory-cgroup-lru-stat-functions-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-consolidates-memory-cgroup-lru-stat-functions-fix
+++ a/include/linux/memcontrol.h
@@ -304,8 +304,8 @@ mem_cgroup_inactive_file_is_low(struct m
 }
 
 static inline unsigned long
-mem_cgroup_zone_nr_lru_pages(struct mem_cgroup *memcg, struct zone *zone,
-			     enum lru_list lru)
+mem_cgroup_zone_nr_lru_pages(struct mem_cgroup *memcg, int nid, int zid,
+				unsigned int lru_mask)
 {
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memcg-fix-reclaimable-lru-check-in-memcg-checkpatch-fixes.patch
memcg-fix-reclaimable-lru-check-in-memcg-fix.patch
memcg-fix-numa-scan-information-update-to-be-triggered-by-memory-event-fix.patch
mm-preallocate-page-before-lock_page-at-filemap-cow-fix.patch
w1-ds1wm-add-a-reset-recovery-parameter-checkpatch-fixes.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver-fix.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-net-skgec-support-dlink-dge-530t-rev-c1.patch
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

