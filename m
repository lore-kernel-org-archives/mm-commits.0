From: akpm@linux-foundation.org
Subject: [withdrawn]
 mm-memory_hotplugc-register_memory_resource-fixes.patch removed from -mm
 tree
Date: Tue, 14 Jan 2014 17:16:56 -0800
Message-ID: <52d5e188.Aa4Ekr/EdKS5fa2c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35792 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaAOBQ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jan 2014 20:16:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wency@cn.fujitsu.com, travis@sgi.com, tangchen@cn.fujitsu.com, rientjes@google.com, rafael.j.wysocki@intel.com, nzimmer@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, hedi@sgi.com, akpm@linux-foundation.org

Subject: [withdrawn] mm-memory_hotplugc-register_memory_resource-fixes.patch removed from -mm tree
To: akpm@linux-foundation.org,hedi@sgi.com,isimatu.yasuaki@jp.fujitsu.com,kamezawa.hiroyu@jp.fujitsu.com,nzimmer@sgi.com,rafael.j.wysocki@intel.com,rientjes@google.com,tangchen@cn.fujitsu.com,travis@sgi.com,wency@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 14 Jan 2014 17:16:56 -0800


The patch titled
     Subject: mm/memory_hotplug.c: register_memory_resource() fixes
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplugc-register_memory_resource-fixes.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/memory_hotplug.c: register_memory_resource() fixes

- register_memory_resource() should not go BUG on ENOMEM.  That's
  appropriate at system boot time, but not at memory-hotplug time.  Fix.

- register_memory_resource()'s caller is incorrectly replacing
  request_resource()'s -EBUSY with -EEXIST.  Fix this by propagating
  errors appropriately.

Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Hedi <hedi@sgi.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplugc-register_memory_resource-fixes mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplugc-register_memory_resource-fixes
+++ a/mm/memory_hotplug.c
@@ -64,17 +64,21 @@ void unlock_memory_hotplug(void)
 static struct resource *register_memory_resource(u64 start, u64 size)
 {
 	struct resource *res;
+	int err;
+
 	res = kzalloc(sizeof(struct resource), GFP_KERNEL);
-	BUG_ON(!res);
+	if (!res)
+		return ERR_PTR(-ENOMEM);
 
 	res->name = "System RAM";
 	res->start = start;
 	res->end = start + size - 1;
 	res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
-	if (request_resource(&iomem_resource, res) < 0) {
+	err = request_resource(&iomem_resource, res);
+	if (err) {
 		pr_debug("System RAM resource %pR cannot be added\n", res);
 		kfree(res);
-		res = NULL;
+		res = ERR_PTR(err);
 	}
 	return res;
 }
@@ -1108,9 +1112,8 @@ int __ref add_memory(int nid, u64 start,
 		return ret;
 
 	res = register_memory_resource(start, size);
-	ret = -EEXIST;
-	if (!res)
-		return ret;
+	if (IS_ERR(res))
+		return PTR_ERR(res);
 
 	{	/* Stupid hack to suppress address-never-null warning */
 		void *p = NODE_DATA(nid);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
posix_acl-uninlining.patch
mm.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path-fix-2.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch
mm-show_mem-remove-show_mem_filter_page_count-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes.patch
mm-add-overcommit_kbytes-sysctl-variable-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-fix-2.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions-checkpatch-fixes.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock-checkpatch-fixes.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed-checkpatch-fixes.patch
mm-memblock-add-memblock-memory-allocation-apis-fix.patch
sched-add-tracepoints-related-to-numa-task-migration-fix.patch
mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch
mm-print-more-details-for-bad_page-fix.patch
mm-munlock-fix-potential-race-with-thp-page-split-fix.patch
mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path-fix.patch
numa-add-a-sysctl-for-numa_balancing-fix.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
printk-flush-conflicting-continuation-line-fix.patch
drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
ipcmsg-document-barriers-fix.patch
ipcmsg-document-barriers-fix-fix.patch
linux-next.patch
net-ipv6-ip6_vtic-fix-build.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

