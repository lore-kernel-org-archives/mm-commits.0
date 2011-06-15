From: akpm@linux-foundation.org
Subject: [folded] memcg-fix-init_page_cgroup-nid-with-sparsemem-fix.patch removed from -mm tree
Date: Wed, 15 Jun 2011 15:03:26 -0700
Message-ID: <201106152203.p5FM3Qoc022090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754557Ab1FOWD4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jun 2011 18:03:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg-fix-init_page_cgroup-nid-with-sparsemem-fix
has been removed from the -mm tree.  Its filename was
     memcg-fix-init_page_cgroup-nid-with-sparsemem-fix.patch

This patch was dropped because it was folded into memcg-fix-init_page_cgroup-nid-with-sparsemem.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-fix-init_page_cgroup-nid-with-sparsemem-fix
From: Andrew Morton <akpm@linux-foundation.org>

try to fix up comments, but I'm not sure I really understand them ;)

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN mm/page_cgroup.c~memcg-fix-init_page_cgroup-nid-with-sparsemem-fix mm/page_cgroup.c
--- a/mm/page_cgroup.c~memcg-fix-init_page_cgroup-nid-with-sparsemem-fix
+++ a/mm/page_cgroup.c
@@ -196,8 +196,8 @@ static int __meminit init_section_page_c
 		init_page_cgroup(pc, nr);
 	}
 	/*
-	 * Passed "pfn" may not be aligned to SECTION. For calculation,
-	 * nedd to apply a mask.
+	 * The passed "pfn" may not be aligned to SECTION.  For the calculation
+	 * we need to apply a mask.
 	 */
 	pfn &= PAGE_SECTION_MASK;
 	section->page_cgroup = base - pfn;
@@ -231,8 +231,8 @@ int __meminit online_page_cgroup(unsigne
 	if (nid == -1) {
 		/*
 		 * In this case, "nid" already exists and contains valid memory.
-		 * "start_pfn" passed for us is a pfn which is args for online_
-		 * _pages(), and start_pfn should exists.
+		 * "start_pfn" passed to us is a pfn which is an arg for
+		 * online__pages(), and start_pfn should exist.
 		 */
 		nid = pfn_to_nid(start_pfn);
 		VM_BUG_ON(!node_state(nid, N_ONLINE));
@@ -308,9 +308,9 @@ void __init page_cgroup_init(void)
 		start_pfn = node_start_pfn(nid);
 		end_pfn = node_end_pfn(nid);
 		/*
-		 * start_pfn and end_pfn may not be aligned to SECTION and
-		 * page->flags of out of node pages are not initialized. So,
-		 * we scan [start_pfn, the biggest section's pfn < end_pfn), here.
+		 * start_pfn and end_pfn may not be aligned to SECTION and the
+		 * page->flags of out of node pages are not initialized.  So we
+		 * scan [start_pfn, the biggest section's pfn < end_pfn) here.
 		 */
 		for (pfn = start_pfn;
 		     pfn < end_pfn;
@@ -319,8 +319,8 @@ void __init page_cgroup_init(void)
 			if (!pfn_valid(pfn))
 				continue;
 			/*
-			 * Nodes's pfn can be overlapped.
-			 * We know some arch can have nodes layout as
+			 * Nodes's pfns can be overlapping.
+			 * We know some arch can have a nodes layout such as
 			 * -------------pfn-------------->
 			 * N0 | N1 | N2 | N0 | N1 | N2|....
 			 */
@@ -332,8 +332,8 @@ void __init page_cgroup_init(void)
 	}
 	hotplug_memory_notifier(page_cgroup_callback, 0);
 	printk(KERN_INFO "allocated %ld bytes of page_cgroup\n", total_usage);
-	printk(KERN_INFO "please try 'cgroup_disable=memory' option if you don't"
-	" want memory cgroups\n");
+	printk(KERN_INFO "please try 'cgroup_disable=memory' option if you "
+			 "don't want memory cgroups\n");
 	return;
 oom:
 	printk(KERN_CRIT "try 'cgroup_disable=memory' boot option\n");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

backlight-add-backlight-type-fix.patch
vmscanmemcg-memcg-aware-swap-token.patch
memcg-add-documentation-for-the-memorynumastat-api.patch
mm-fix-negative-commitlimit-when-gigantic-hugepages-are-allocated.patch
memcg-fix-init_page_cgroup-nid-with-sparsemem.patch
memcg-clear-mm-owner-when-last-possible-owner-leaves-fix.patch
memcg-fix-percpu-cached-charge-draining-frequency.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
pci-enumerate-the-pci-device-only-removed-out-pci-hierarchy-of-os-when-re-scanning-pci-fix.patch
slab-use-numa_no_node.patch
mm.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix.patch
pagewalk-add-locking-rule-comments-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
init-calibratec-calibrate_delay-tidy-up-the-pr_info-messages.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

