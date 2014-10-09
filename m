From: akpm@linux-foundation.org
Subject: [folded-merged]
 memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2.patch removed from -mm tree
Date: Thu, 09 Oct 2014 13:32:38 -0700
Message-ID: <5436f0e6.CyJJK3gozyDLjYUw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35441 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaJIUci (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 16:32:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, rdunlap@infradead.org, zhenzhang.zhang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2
has been removed from the -mm tree.  Its filename was
     memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2.patch

This patch was dropped because it was folded into memory-hotplug-add-sysfs-zones_online_to-attribute.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2

fix build with CONFIG_MEMORY_HOTREMOVE=n

Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Zhang Zhen <zhenzhang.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/base/memory.c~memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2 drivers/base/memory.c
--- a/drivers/base/memory.c~memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2
+++ a/drivers/base/memory.c
@@ -373,6 +373,7 @@ static ssize_t show_phys_device(struct d
 	return sprintf(buf, "%d\n", mem->phys_device);
 }
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
 static int __zones_online_to(unsigned long end_pfn,
 				struct page *first_page, unsigned long nr_pages)
 {
@@ -432,12 +433,13 @@ static ssize_t show_zones_online_to(stru
 
 	return sprintf(buf, "%s\n", zone->name);
 }
+static DEVICE_ATTR(zones_online_to, 0444, show_zones_online_to, NULL);
+#endif
 
 static DEVICE_ATTR(phys_index, 0444, show_mem_start_phys_index, NULL);
 static DEVICE_ATTR(state, 0644, show_mem_state, store_mem_state);
 static DEVICE_ATTR(phys_device, 0444, show_phys_device, NULL);
 static DEVICE_ATTR(removable, 0444, show_mem_removable, NULL);
-static DEVICE_ATTR(zones_online_to, 0444, show_zones_online_to, NULL);
 
 /*
  * Block size attribute stuff
@@ -584,7 +586,9 @@ static struct attribute *memory_memblk_a
 	&dev_attr_state.attr,
 	&dev_attr_phys_device.attr,
 	&dev_attr_removable.attr,
+#ifdef CONFIG_MEMORY_HOTREMOVE
 	&dev_attr_zones_online_to.attr,
+#endif
 	NULL
 };
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fs-notify-groupc-make-fsnotify_final_destroy_group-static.patch
fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic.patch
fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range.patch
mm-slab_commonc-suppress-warning.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header.patch
memory-hotplug-add-sysfs-zones_online_to-attribute.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-3-fix.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3-fix.patch
include-linux-migrateh-remove-migratepage-define.patch
introduce-dump_vma-fix.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma-checkpatch-fixes.patch
mm-mmapc-clean-up-config_debug_vm_rb-checks.patch
mm-introduce-vm_bug_on_mm-checkpatch-fixes.patch
mm-debug-mm-introduce-vm_bug_on_mm-fix-fixpatch-fix.patch
mm-debugc-use-pr_emerg.patch
mm-ksm-use-pr_err-instead-of-printk-fix.patch
mm-introduce-a-general-rcu-get_user_pages_fast-fix.patch
arm64-mm-enable-rcu-fast_gup-checkpatch-fixes.patch
zram-zram-memory-size-limitation-fix.patch
zram-zram-memory-size-limitation-fix-fix.patch
acct-eliminate-compile-warning-fix.patch

