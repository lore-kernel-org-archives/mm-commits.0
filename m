From: akpm@linux-foundation.org
Subject: [merged] devmem-check-vmalloc-address-on-kmem-read-write.patch removed from -mm tree
Date: Wed, 03 Feb 2010 09:54:49 -0800
Message-ID: <201002031754.o13HsnR5008927@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932761Ab0BCSBJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 13:01:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, fengguang.wu@intel.com, gregkh@suse.de, hugh.dickins@tiscali.co.uk, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     devmem: check vmalloc address on kmem read/write
has been removed from the -mm tree.  Its filename was
     devmem-check-vmalloc-address-on-kmem-read-write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devmem: check vmalloc address on kmem read/write
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Otherwise vmalloc_to_page() will BUG().

This also makes the kmem read/write implementation aligned with mem(4):
"References to nonexistent locations cause errors to be returned." Here we
return -ENXIO (inspired by Hugh) if no bytes have been transfered to/from
user space, otherwise return partial read/write results.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff -puN drivers/char/mem.c~devmem-check-vmalloc-address-on-kmem-read-write drivers/char/mem.c
--- a/drivers/char/mem.c~devmem-check-vmalloc-address-on-kmem-read-write
+++ a/drivers/char/mem.c
@@ -395,6 +395,7 @@ static ssize_t read_kmem(struct file *fi
 	unsigned long p = *ppos;
 	ssize_t low_count, read, sz;
 	char * kbuf; /* k-addr because vread() takes vmlist_lock rwlock */
+	int err = 0;
 
 	read = 0;
 	if (p < (unsigned long) high_memory) {
@@ -441,12 +442,16 @@ static ssize_t read_kmem(struct file *fi
 			return -ENOMEM;
 		while (count > 0) {
 			sz = size_inside_page(p, count);
+			if (!is_vmalloc_or_module_addr((void *)p)) {
+				err = -ENXIO;
+				break;
+			}
 			sz = vread(kbuf, (char *)p, sz);
 			if (!sz)
 				break;
 			if (copy_to_user(buf, kbuf, sz)) {
-				free_page((unsigned long)kbuf);
-				return -EFAULT;
+				err = -EFAULT;
+				break;
 			}
 			count -= sz;
 			buf += sz;
@@ -455,8 +460,8 @@ static ssize_t read_kmem(struct file *fi
 		}
 		free_page((unsigned long)kbuf);
 	}
- 	*ppos = p;
- 	return read;
+	*ppos = p;
+	return read ? read : err;
 }
 
 
@@ -520,6 +525,7 @@ static ssize_t write_kmem(struct file * 
 	ssize_t wrote = 0;
 	ssize_t virtr = 0;
 	char * kbuf; /* k-addr because vwrite() takes vmlist_lock rwlock */
+	int err = 0;
 
 	if (p < (unsigned long) high_memory) {
 		unsigned long to_write = min_t(unsigned long, count,
@@ -540,12 +546,14 @@ static ssize_t write_kmem(struct file * 
 			unsigned long sz = size_inside_page(p, count);
 			unsigned long n;
 
+			if (!is_vmalloc_or_module_addr((void *)p)) {
+				err = -ENXIO;
+				break;
+			}
 			n = copy_from_user(kbuf, buf, sz);
 			if (n) {
-				if (wrote + virtr)
-					break;
-				free_page((unsigned long)kbuf);
-				return -EFAULT;
+				err = -EFAULT;
+				break;
 			}
 			sz = vwrite(kbuf, (char *)p, sz);
 			count -= sz;
@@ -556,8 +564,8 @@ static ssize_t write_kmem(struct file * 
 		free_page((unsigned long)kbuf);
 	}
 
- 	*ppos = p;
- 	return virtr + wrote;
+	*ppos = p;
+	return virtr + wrote ? : err;
 }
 #endif
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
mm-clean-up-mm_counter.patch
mm-avoid-false-sharing-of-mm_counter.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
vmscan-get_scan_ratio-cleanup.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix-2.patch
mm-migratec-kill-anon-local-variable-from-migrate_page_copy.patch
nodemaskh-remove-macro-any_online_node.patch
resources-introduce-generic-page_is_ram.patch
x86-remove-bios-data-range-from-e820.patch
x86-use-the-generic-page_is_ram.patch
cgroup-introduce-cancel_attach.patch
cgroup-introduce-coalesce-css_get-and-css_put.patch
cgroups-revamp-subsys-array.patch
cgroups-subsystem-module-loading-interface.patch
cgroups-subsystem-module-loading-interface-fix.patch
cgroups-subsystem-module-unloading.patch
cgroups-net_cls-as-module.patch
cgroups-blkio-subsystem-as-module.patch
cgroups-clean-up-cgroup_pidlist_find-a-bit.patch
memcg-add-interface-to-move-charge-at-task-migration.patch
memcg-move-charges-of-anonymous-page.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-improve-performance-in-moving-charge.patch
memcg-avoid-oom-during-moving-charge.patch
memcg-move-charges-of-anonymous-swap.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-fixes.patch
memcg-extract-mem_group_usage-from-mem_cgroup_read.patch
memcg-rework-usage-of-stats-by-soft-limit.patch
memcg-implement-memory-thresholds.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
memcg-implement-memory-thresholds-checkpatch-fixes-fix.patch
memcg-typo-in-comment-to-mem_cgroup_print_oom_info.patch

