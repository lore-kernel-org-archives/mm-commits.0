From: akpm@linux-foundation.org
Subject: + memcg-fix-reclaimable-lru-check-in-memcg-checkpatch-fixes.patch added to -mm tree
Date: Tue, 28 Jun 2011 17:15:48 -0700
Message-ID: <201106290015.p5T0FnTm016728@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752627Ab1F2AQC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jun 2011 20:16:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp, yinghan@google.com


The patch titled
     memcg-fix-reclaimable-lru-check-in-memcg-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     memcg-fix-reclaimable-lru-check-in-memcg-checkpatch-fixes.patch

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
Subject: memcg-fix-reclaimable-lru-check-in-memcg-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#130: FILE: mm/memcontrol.c:1567:
+        if (noswap || !total_swap_pages)$

WARNING: please, no spaces at the start of a line
#130: FILE: mm/memcontrol.c:1567:
+        if (noswap || !total_swap_pages)$

ERROR: code indent should use tabs where possible
#131: FILE: mm/memcontrol.c:1568:
+                return false;$

WARNING: please, no spaces at the start of a line
#131: FILE: mm/memcontrol.c:1568:
+                return false;$

ERROR: code indent should use tabs where possible
#132: FILE: mm/memcontrol.c:1569:
+        if (mem_cgroup_node_nr_anon_lru_pages(mem, nid))$

WARNING: please, no spaces at the start of a line
#132: FILE: mm/memcontrol.c:1569:
+        if (mem_cgroup_node_nr_anon_lru_pages(mem, nid))$

ERROR: code indent should use tabs where possible
#133: FILE: mm/memcontrol.c:1570:
+                return true;$

WARNING: please, no spaces at the start of a line
#133: FILE: mm/memcontrol.c:1570:
+                return true;$

ERROR: code indent should use tabs where possible
#134: FILE: mm/memcontrol.c:1571:
+        return false;$

WARNING: please, no spaces at the start of a line
#134: FILE: mm/memcontrol.c:1571:
+        return false;$

ERROR: code indent should use tabs where possible
#186: FILE: mm/memcontrol.c:1659:
+ ^I * Check rest of nodes.$

WARNING: please, no space before tabs
#186: FILE: mm/memcontrol.c:1659:
+ ^I * Check rest of nodes.$

ERROR: code indent should use tabs where possible
#187: FILE: mm/memcontrol.c:1660:
+ ^I */$

WARNING: please, no space before tabs
#187: FILE: mm/memcontrol.c:1660:
+ ^I */$

ERROR: trailing whitespace
#192: FILE: mm/memcontrol.c:1665:
+^I^I^Ireturn true;^I$

total: 8 errors, 7 warnings, 118 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/memcg-fix-reclaimable-lru-check-in-memcg.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-reclaimable-lru-check-in-memcg-checkpatch-fixes mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-reclaimable-lru-check-in-memcg-checkpatch-fixes
+++ a/mm/memcontrol.c
@@ -1564,11 +1564,11 @@ static bool test_mem_cgroup_node_reclaim
 {
 	if (mem_cgroup_node_nr_file_lru_pages(mem, nid))
 		return true;
-        if (noswap || !total_swap_pages)
-                return false;
-        if (mem_cgroup_node_nr_anon_lru_pages(mem, nid))
-                return true;
-        return false;
+	if (noswap || !total_swap_pages)
+		return false;
+	if (mem_cgroup_node_nr_anon_lru_pages(mem, nid))
+		return true;
+	return false;
 
 }
 #if MAX_NUMNODES > 1
@@ -1656,13 +1656,13 @@ bool mem_cgroup_reclaimable(struct mem_c
 		}
 	}
 	/*
- 	 * Check rest of nodes.
- 	 */
+	 * Check rest of nodes.
+	 */
 	for_each_node_state(nid, N_HIGH_MEMORY) {
 		if (node_isset(nid, mem->scan_nodes))
 			continue;
 		if (test_mem_cgroup_node_reclaimable(mem, nid, noswap))
-			return true;	
+			return true;
 	}
 	return false;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memcg-fix-reclaimable-lru-check-in-memcg-checkpatch-fixes.patch
memcg-fix-reclaimable-lru-check-in-memcg-fix.patch
memcg-fix-numa-scan-information-update-to-be-triggered-by-memory-event-fix.patch
mm-preallocate-page-before-lock_page-at-filemap-cow-fix.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
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
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
checkpatch-add-a-prefer-__aligned-check.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
h8300-m68k-xtensa-__fd_isset-should-return-0-1.patch
proc-pid-fdinfo-add-cloexec-information-fix.patch
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

