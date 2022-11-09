Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 985EBC433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:40:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiKIBkV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbiKIBi4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:38:56 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124071F9D8
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:38:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5D02ACE1D2A
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A6BC433D7;
        Wed,  9 Nov 2022 01:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957930;
        bh=5UnPNF9mJAmiWMaEovGwfgNHR7+dPojnMg2tgWibPpY=;
        h=Date:To:From:Subject:From;
        b=BpG85WTFK29U/9oP6dHBso5IqtD0YOevkClTOg8ytfEvlpBsqqvMrDu/nqqFCUB0l
         jhg2YINKGgkox9rnIK42mXlAEGkQyfY0kUwu/kLjjrEu0OP4QSqZIZEQx4KtC8OV71
         DjqE9Ovw1MNhKcG9xFjLuuvhP8c5DHKwCJdIICvQ=
Date:   Tue, 08 Nov 2022 17:38:50 -0800
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        longman@redhat.com, lizefan.x@bytedance.com, david@redhat.com,
        cl@linux.com, liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memory-move-hotplug-memory-notifier-priority-to-same-file-for-easy-sorting.patch removed from -mm tree
Message-Id: <20221109013850.90A6BC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memory: move hotplug memory notifier priority to same file for easy sorting
has been removed from the -mm tree.  Its filename was
     memory-move-hotplug-memory-notifier-priority-to-same-file-for-easy-sorting.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: memory: move hotplug memory notifier priority to same file for easy sorting
Date: Fri, 23 Sep 2022 11:33:47 +0800

The priority of hotplug memory callback is defined in a different file. 
And there are some callers using numbers directly.  Collect them together
into include/linux/memory.h for easy reading.  This allows us to sort
their priorities more intuitively without additional comments.

Link: https://lkml.kernel.org/r/20220923033347.3935160-9-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Waiman Long <longman@redhat.com>
Cc: zefan li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/numa/hmat.c     |    2 +-
 fs/proc/kcore.c              |    2 +-
 include/linux/memory-tiers.h |    1 -
 include/linux/memory.h       |    9 +++++++--
 kernel/cgroup/cpuset.c       |    2 +-
 mm/kasan/shadow.c            |    2 +-
 mm/ksm.c                     |    2 +-
 mm/memory-tiers.c            |    2 +-
 mm/mm_init.c                 |    2 +-
 mm/mmap.c                    |    2 +-
 mm/page_ext.c                |    2 +-
 11 files changed, 16 insertions(+), 12 deletions(-)

--- a/drivers/acpi/numa/hmat.c~memory-move-hotplug-memory-notifier-priority-to-same-file-for-easy-sorting
+++ a/drivers/acpi/numa/hmat.c
@@ -849,7 +849,7 @@ static __init int hmat_init(void)
 	hmat_register_targets();
 
 	/* Keep the table and structures if the notifier may use them */
-	if (!hotplug_memory_notifier(hmat_callback, 2))
+	if (!hotplug_memory_notifier(hmat_callback, HMAT_CALLBACK_PRI))
 		return 0;
 out_put:
 	hmat_free_structures();
--- a/fs/proc/kcore.c~memory-move-hotplug-memory-notifier-priority-to-same-file-for-easy-sorting
+++ a/fs/proc/kcore.c
@@ -689,7 +689,7 @@ static int __init proc_kcore_init(void)
 	add_modules_range();
 	/* Store direct-map area from physical memory map */
 	kcore_update_ram();
-	hotplug_memory_notifier(kcore_callback, 0);
+	hotplug_memory_notifier(kcore_callback, DEFAULT_CALLBACK_PRI);
 
 	return 0;
 }
--- a/include/linux/memory.h~memory-move-hotplug-memory-notifier-priority-to-same-file-for-easy-sorting
+++ a/include/linux/memory.h
@@ -112,8 +112,13 @@ struct mem_section;
  * Priorities for the hotplug memory callback routines (stored in decreasing
  * order in the callback chain)
  */
-#define SLAB_CALLBACK_PRI       1
-#define IPC_CALLBACK_PRI        10
+#define DEFAULT_CALLBACK_PRI	0
+#define SLAB_CALLBACK_PRI	1
+#define HMAT_CALLBACK_PRI	2
+#define MM_COMPUTE_BATCH_PRI	10
+#define CPUSET_CALLBACK_PRI	10
+#define MEMTIER_HOTPLUG_PRI	100
+#define KSM_CALLBACK_PRI	100
 
 #ifndef CONFIG_MEMORY_HOTPLUG
 static inline void memory_dev_init(void)
--- a/include/linux/memory-tiers.h~memory-move-hotplug-memory-notifier-priority-to-same-file-for-easy-sorting
+++ a/include/linux/memory-tiers.h
@@ -18,7 +18,6 @@
  * the same memory tier.
  */
 #define MEMTIER_ADISTANCE_DRAM	((4 * MEMTIER_CHUNK_SIZE) + (MEMTIER_CHUNK_SIZE >> 1))
-#define MEMTIER_HOTPLUG_PRIO	100
 
 struct memory_tier;
 struct memory_dev_type {
--- a/kernel/cgroup/cpuset.c~memory-move-hotplug-memory-notifier-priority-to-same-file-for-easy-sorting
+++ a/kernel/cgroup/cpuset.c
@@ -3647,7 +3647,7 @@ void __init cpuset_init_smp(void)
 	cpumask_copy(top_cpuset.effective_cpus, cpu_active_mask);
 	top_cpuset.effective_mems = node_states[N_MEMORY];
 
-	hotplug_memory_notifier(cpuset_track_online_nodes, 10);
+	hotplug_memory_notifier(cpuset_track_online_nodes, CPUSET_CALLBACK_PRI);
 
 	cpuset_migrate_mm_wq = alloc_ordered_workqueue("cpuset_migrate_mm", 0);
 	BUG_ON(!cpuset_migrate_mm_wq);
--- a/mm/kasan/shadow.c~memory-move-hotplug-memory-notifier-priority-to-same-file-for-easy-sorting
+++ a/mm/kasan/shadow.c
@@ -244,7 +244,7 @@ static int __meminit kasan_mem_notifier(
 
 static int __init kasan_memhotplug_init(void)
 {
-	hotplug_memory_notifier(kasan_mem_notifier, 0);
+	hotplug_memory_notifier(kasan_mem_notifier, DEFAULT_CALLBACK_PRI);
 
 	return 0;
 }
--- a/mm/ksm.c~memory-move-hotplug-memory-notifier-priority-to-same-file-for-easy-sorting
+++ a/mm/ksm.c
@@ -3211,7 +3211,7 @@ static int __init ksm_init(void)
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
 	/* There is no significance to this priority 100 */
-	hotplug_memory_notifier(ksm_memory_callback, 100);
+	hotplug_memory_notifier(ksm_memory_callback, KSM_CALLBACK_PRI);
 #endif
 	return 0;
 
--- a/mm/memory-tiers.c~memory-move-hotplug-memory-notifier-priority-to-same-file-for-easy-sorting
+++ a/mm/memory-tiers.c
@@ -664,7 +664,7 @@ static int __init memory_tier_init(void)
 	establish_demotion_targets();
 	mutex_unlock(&memory_tier_lock);
 
-	hotplug_memory_notifier(memtier_hotplug_callback, MEMTIER_HOTPLUG_PRIO);
+	hotplug_memory_notifier(memtier_hotplug_callback, MEMTIER_HOTPLUG_PRI);
 	return 0;
 }
 subsys_initcall(memory_tier_init);
--- a/mm/mmap.c~memory-move-hotplug-memory-notifier-priority-to-same-file-for-easy-sorting
+++ a/mm/mmap.c
@@ -3751,7 +3751,7 @@ static int reserve_mem_notifier(struct n
 
 static int __meminit init_reserve_notifier(void)
 {
-	if (hotplug_memory_notifier(reserve_mem_notifier, 0))
+	if (hotplug_memory_notifier(reserve_mem_notifier, DEFAULT_CALLBACK_PRI))
 		pr_err("Failed registering memory add/remove notifier for admin reserve\n");
 
 	return 0;
--- a/mm/mm_init.c~memory-move-hotplug-memory-notifier-priority-to-same-file-for-easy-sorting
+++ a/mm/mm_init.c
@@ -181,7 +181,7 @@ static int __meminit mm_compute_batch_no
 static int __init mm_compute_batch_init(void)
 {
 	mm_compute_batch(sysctl_overcommit_memory);
-	hotplug_memory_notifier(mm_compute_batch_notifier, IPC_CALLBACK_PRI);
+	hotplug_memory_notifier(mm_compute_batch_notifier, MM_COMPUTE_BATCH_PRI);
 	return 0;
 }
 
--- a/mm/page_ext.c~memory-move-hotplug-memory-notifier-priority-to-same-file-for-easy-sorting
+++ a/mm/page_ext.c
@@ -513,7 +513,7 @@ void __init page_ext_init(void)
 			cond_resched();
 		}
 	}
-	hotplug_memory_notifier(page_ext_callback, 0);
+	hotplug_memory_notifier(page_ext_callback, DEFAULT_CALLBACK_PRI);
 	pr_info("allocated %ld bytes of page_ext\n", total_usage);
 	invoke_init_callbacks();
 	return;
_

Patches currently in -mm which might be from liushixin2@huawei.com are


