From: akpm@linux-foundation.org
Subject: [merged] mm-memory_hotplugc-online_pages-add-memory-hotplug-locking.patch removed from -mm tree
Date: Wed, 12 Jan 2011 13:43:50 -0800
Message-ID: <201101122146.p0CLkNX1005457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755601Ab1ALVqf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Jan 2011 16:46:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, bvanassche@acm.org, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mm/memory_hotplug.c:online_pages(): add memory-hotplug locking
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplugc-online_pages-add-memory-hotplug-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/memory_hotplug.c:online_pages(): add memory-hotplug locking
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

memory_hotplug_(un)lock() is used for add/remove/offline pages for
avoiding races with hibernation.  But this should be held in
online_pages(), too.  It seems asymmetric.

There are cases where one has to avoid a race with memory hotplug notifier
and his own local code, and hotplug v.s.  hotplug.  This will add a
generic solution for avoiding races.  In other view, having lock here has
no big impacts.  online pages is tend to be done by udev script at el
against each memory section one by one.

Then, it's better to have lock here, too.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    6 ++++++
 mm/memory_hotplug.c            |    4 ++++
 2 files changed, 10 insertions(+)

diff -puN include/linux/memory_hotplug.h~mm-memory_hotplugc-online_pages-add-memory-hotplug-locking include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~mm-memory_hotplugc-online_pages-add-memory-hotplug-locking
+++ a/include/linux/memory_hotplug.h
@@ -165,6 +165,12 @@ extern void register_page_bootmem_info_n
 extern void put_page_bootmem(struct page *page);
 #endif
 
+/*
+ * Lock for memory hotplug guarantees 1) all callbacks for memory hotplug
+ * notifier will be called under this. 2) offline/online/add/remove memory
+ * will not run simultaneously.
+ */
+
 void lock_memory_hotplug(void);
 void unlock_memory_hotplug(void);
 
diff -puN mm/memory_hotplug.c~mm-memory_hotplugc-online_pages-add-memory-hotplug-locking mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplugc-online_pages-add-memory-hotplug-locking
+++ a/mm/memory_hotplug.c
@@ -409,6 +409,7 @@ int online_pages(unsigned long pfn, unsi
 	int ret;
 	struct memory_notify arg;
 
+	lock_memory_hotplug();
 	arg.start_pfn = pfn;
 	arg.nr_pages = nr_pages;
 	arg.status_change_nid = -1;
@@ -421,6 +422,7 @@ int online_pages(unsigned long pfn, unsi
 	ret = notifier_to_errno(ret);
 	if (ret) {
 		memory_notify(MEM_CANCEL_ONLINE, &arg);
+		unlock_memory_hotplug();
 		return ret;
 	}
 	/*
@@ -445,6 +447,7 @@ int online_pages(unsigned long pfn, unsi
 		printk(KERN_DEBUG "online_pages %lx at %lx failed\n",
 			nr_pages, pfn);
 		memory_notify(MEM_CANCEL_ONLINE, &arg);
+		unlock_memory_hotplug();
 		return ret;
 	}
 
@@ -467,6 +470,7 @@ int online_pages(unsigned long pfn, unsi
 
 	if (onlined_pages)
 		memory_notify(MEM_ONLINE, &arg);
+	unlock_memory_hotplug();
 
 	return 0;
 }
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

linux-next.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-update.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix-set_pgdat_percpu_threshold-dont-use-for_each_online_cpu.patch
oom-allow-a-non-cap_sys_resource-proces-to-oom_score_adj-down.patch
mm-kswapd-stop-high-order-balancing-when-any-suitable-zone-is-balanced.patch
mm-kswapd-keep-kswapd-awake-for-high-order-allocations-until-a-percentage-of-the-node-is-balanced.patch
mm-kswapd-use-the-order-that-kswapd-was-reclaiming-at-for-sleeping_prematurely.patch
mm-kswapd-reset-kswapd_max_order-and-classzone_idx-after-reading.patch
mm-kswapd-treat-zone-all_unreclaimable-in-sleeping_prematurely-similar-to-balance_pgdat.patch
mm-kswapd-use-the-classzone-idx-that-kswapd-was-using-for-sleeping_prematurely.patch
mm-set-correct-numa_zonelist_order-string-when-configured-on-the-kernel-command-line.patch
thp-compound_trans_order-fix.patch
mm-migration-use-rcu_dereference_protected-when-dereferencing-the-radix-tree-slot-during-file-page-migration.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
memcg-create-extensible-page-stat-update-routines.patch
memcg-add-lock-to-synchronize-page-accounting-and-migration.patch
memcg-fix-unit-mismatch-in-memcg-oom-limit-calculation.patch
memcg-remove-unnecessary-return-from-void-returning-mem_cgroup_del_lru_list.patch
memcg-use-zalloc-rather-than-mallocmemset.patch
memcg-fix-memory-migration-of-shmem-swapcache.patch

