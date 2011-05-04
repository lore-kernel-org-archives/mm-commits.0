From: akpm@linux-foundation.org
Subject: + memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch added to -mm tree
Date: Wed, 04 May 2011 14:05:25 -0700
Message-ID: <201105042105.p44L5PnD014195@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752918Ab1EDVFf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 May 2011 17:05:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, yinghan@google.com


The patch titled
     memcg-reclaim-memory-from-nodes-in-round-robin-fix
has been added to the -mm tree.  Its filename is
     memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch

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
Subject: memcg-reclaim-memory-from-nodes-in-round-robin-fix
From: Andrew Morton <akpm@linux-foundation.org>

comment editing

Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/memcontrol.c~memcg-reclaim-memory-from-nodes-in-round-robin-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-reclaim-memory-from-nodes-in-round-robin-fix
+++ a/mm/memcontrol.c
@@ -1493,15 +1493,15 @@ mem_cgroup_select_victim(struct mem_cgro
 }
 
 /*
- * Selecting a node where we start reclaim from. Because what we need is just
- * reducing usage counter, start from anywhere is O,K. When considering
- * memory reclaim from current node, there are pros. and cons.
- * Freeing memory from current node means freeing memory from a node which
- * we'll use or we've used. So, it may make LRU bad. And if several threads
- * hit limits, it will see a contention on a node. But freeing from remote
- * node mean more costs for memory reclaim because of memory latency.
+ * Select a node from whcih to start reclaim. Because what we need is just
+ * reducing the usage counter, starting from anywhere is OK. When considering
+ * memory reclaim from the current node there are pros and cons.
+ * Freeing memory from the current node means freeing memory from a node which
+ * we have used or will soon use, oo it may worsen LRU ordering.  And if several
+ * threads hit limits, it can cause contention on a node. But freeing from a
+ * remote node means higher costs for memory reclaim because of memory latency.
  *
- * Now, we use round-robin. Better algorithm is welcomed.
+ * Now, we use round-robin.  A better algorithm is welcomed.
  */
 int mem_cgroup_select_victim_node(struct mem_cgroup *mem)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-i2c-busses-i2c-designware-corec-needs-delayh.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
osst-wrong-index-used-in-inner-loop-checkpatch-fixes.patch
drivers-scsi-osstc-fix-warning.patch
drbd-fix-warning.patch
drivers-usb-misc-usbtestc-fix-warning.patch
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
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix.patch
printk-allocate-kernel-log-buffer-earlier-v2-checkpatch-fixes.patch
printk-allocate-kernel-log-buffer-earlier-v2-fix.patch
lru_cache-use-correct-type-in-sizeof-for-allocation-fix.patch
percpu_counter-change-return-value-and-add-comments-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
fs-ncpfs-inodec-suppress-used-uninitialised-warning.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
documentation-accounting-getdelaysc-handle-sendto-failures.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

