From: akpm@linux-foundation.org
Subject: + vmscan-unevictable-lru-scan-sysctl.patch added to -mm tree
Date: Wed, 11 Jun 2008 13:00:12 -0700
Message-ID: <200806112000.m5BK0DPe015264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757759AbYFKUAg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jun 2008 16:00:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com


The patch titled
     vmscan: unevictable LRU scan sysctl
has been added to the -mm tree.  Its filename is
     vmscan-unevictable-lru-scan-sysctl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: unevictable LRU scan sysctl
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

This patch adds a function to scan individual or all zones' unevictable
lists and move any pages that have become evictable onto the respective
zone's inactive list, where shrink_inactive_list() will deal with them.

Adds sysctl to scan all nodes, and per node attributes to individual
nodes' zones.

Kosaki: If evictable page found in unevictable lru when write
/proc/sys/vm/scan_unevictable_pages, print filename and file offset of
these pages.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c  |    5 +
 include/linux/rmap.h |    3 
 include/linux/swap.h |   15 +++
 kernel/sysctl.c      |   10 ++
 mm/rmap.c            |    4 -
 mm/vmscan.c          |  163 +++++++++++++++++++++++++++++++++++++++++
 6 files changed, 198 insertions(+), 2 deletions(-)

diff -puN drivers/base/node.c~vmscan-unevictable-lru-scan-sysctl drivers/base/node.c
--- a/drivers/base/node.c~vmscan-unevictable-lru-scan-sysctl
+++ a/drivers/base/node.c
@@ -13,6 +13,7 @@
 #include <linux/nodemask.h>
 #include <linux/cpu.h>
 #include <linux/device.h>
+#include <linux/swap.h>
 
 static struct sysdev_class node_class = {
 	.name = "node",
@@ -186,6 +187,8 @@ int register_node(struct node *node, int
 		sysdev_create_file(&node->sysdev, &attr_meminfo);
 		sysdev_create_file(&node->sysdev, &attr_numastat);
 		sysdev_create_file(&node->sysdev, &attr_distance);
+
+		scan_unevictable_register_node(node);
 	}
 	return error;
 }
@@ -205,6 +208,8 @@ void unregister_node(struct node *node)
 	sysdev_remove_file(&node->sysdev, &attr_numastat);
 	sysdev_remove_file(&node->sysdev, &attr_distance);
 
+	scan_unevictable_unregister_node(node);
+
 	sysdev_unregister(&node->sysdev);
 }
 
diff -puN include/linux/rmap.h~vmscan-unevictable-lru-scan-sysctl include/linux/rmap.h
--- a/include/linux/rmap.h~vmscan-unevictable-lru-scan-sysctl
+++ a/include/linux/rmap.h
@@ -67,6 +67,9 @@ void anon_vma_unlink(struct vm_area_stru
 void anon_vma_link(struct vm_area_struct *);
 void __anon_vma_link(struct vm_area_struct *);
 
+extern struct anon_vma *page_lock_anon_vma(struct page *page);
+extern void page_unlock_anon_vma(struct anon_vma *anon_vma);
+
 /*
  * rmap interfaces called when adding or removing pte of page
  */
diff -puN include/linux/swap.h~vmscan-unevictable-lru-scan-sysctl include/linux/swap.h
--- a/include/linux/swap.h~vmscan-unevictable-lru-scan-sysctl
+++ a/include/linux/swap.h
@@ -7,6 +7,7 @@
 #include <linux/list.h>
 #include <linux/memcontrol.h>
 #include <linux/sched.h>
+#include <linux/node.h>
 
 #include <asm/atomic.h>
 #include <asm/page.h>
@@ -235,15 +236,29 @@ static inline int zone_reclaim(struct zo
 #ifdef CONFIG_UNEVICTABLE_LRU
 extern int page_evictable(struct page *page, struct vm_area_struct *vma);
 extern void scan_mapping_unevictable_pages(struct address_space *);
+
+extern unsigned long scan_unevictable_pages;
+extern int scan_unevictable_handler(struct ctl_table *, int, struct file *,
+					void __user *, size_t *, loff_t *);
+extern int scan_unevictable_register_node(struct node *node);
+extern void scan_unevictable_unregister_node(struct node *node);
 #else
 static inline int page_evictable(struct page *page,
 						struct vm_area_struct *vma)
 {
 	return 1;
 }
+
 static inline void scan_mapping_unevictable_pages(struct address_space *mapping)
 {
 }
+
+static inline int scan_unevictable_register_node(struct node *node)
+{
+	return 0;
+}
+
+static inline void scan_unevictable_unregister_node(struct node *node) { }
 #endif
 
 extern int kswapd_run(int nid);
diff -puN kernel/sysctl.c~vmscan-unevictable-lru-scan-sysctl kernel/sysctl.c
--- a/kernel/sysctl.c~vmscan-unevictable-lru-scan-sysctl
+++ a/kernel/sysctl.c
@@ -1141,6 +1141,16 @@ static struct ctl_table vm_table[] = {
 		.extra2		= &one,
 	},
 #endif
+#ifdef CONFIG_UNEVICTABLE_LRU
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "scan_unevictable_pages",
+		.data		= &scan_unevictable_pages,
+		.maxlen		= sizeof(scan_unevictable_pages),
+		.mode		= 0644,
+		.proc_handler	= &scan_unevictable_handler,
+	},
+#endif
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt
diff -puN mm/rmap.c~vmscan-unevictable-lru-scan-sysctl mm/rmap.c
--- a/mm/rmap.c~vmscan-unevictable-lru-scan-sysctl
+++ a/mm/rmap.c
@@ -158,7 +158,7 @@ void __init anon_vma_init(void)
  * Getting a lock on a stable anon_vma from a page off the LRU is
  * tricky: page_lock_anon_vma rely on RCU to guard against the races.
  */
-static struct anon_vma *page_lock_anon_vma(struct page *page)
+struct anon_vma *page_lock_anon_vma(struct page *page)
 {
 	struct anon_vma *anon_vma;
 	unsigned long anon_mapping;
@@ -178,7 +178,7 @@ out:
 	return NULL;
 }
 
-static void page_unlock_anon_vma(struct anon_vma *anon_vma)
+void page_unlock_anon_vma(struct anon_vma *anon_vma)
 {
 	spin_unlock(&anon_vma->lock);
 	rcu_read_unlock();
diff -puN mm/vmscan.c~vmscan-unevictable-lru-scan-sysctl mm/vmscan.c
--- a/mm/vmscan.c~vmscan-unevictable-lru-scan-sysctl
+++ a/mm/vmscan.c
@@ -39,6 +39,7 @@
 #include <linux/freezer.h>
 #include <linux/memcontrol.h>
 #include <linux/delayacct.h>
+#include <linux/sysctl.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -2396,6 +2397,39 @@ int page_evictable(struct page *page, st
 	return 1;
 }
 
+static void show_page_path(struct page *page)
+{
+	char buf[256];
+	if (page_is_file_cache(page)) {
+		struct address_space *mapping = page->mapping;
+		struct dentry *dentry;
+		pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+
+		spin_lock(&mapping->i_mmap_lock);
+		dentry = d_find_alias(mapping->host);
+		printk(KERN_INFO "rescued: %s %lu\n",
+		       dentry_path(dentry, buf, 256), pgoff);
+		spin_unlock(&mapping->i_mmap_lock);
+	} else {
+#ifdef CONFIG_MM_OWNER
+		struct anon_vma *anon_vma;
+		struct vm_area_struct *vma;
+
+		anon_vma = page_lock_anon_vma(page);
+		if (!anon_vma)
+			return;
+
+		list_for_each_entry(vma, &anon_vma->head, anon_vma_node) {
+			printk(KERN_INFO "rescued: anon %s\n",
+			       vma->vm_mm->owner->comm);
+			break;
+		}
+		page_unlock_anon_vma(anon_vma);
+#endif
+	}
+}
+
+
 /**
  * check_move_unevictable_page - check page for evictability and move to appropriate zone lru list
  * @page: page to check evictability and move to appropriate lru list
@@ -2413,6 +2447,9 @@ static void check_move_unevictable_page(
 	ClearPageUnevictable(page); /* for page_evictable() */
 	if (page_evictable(page, NULL)) {
 		enum lru_list l = LRU_INACTIVE_ANON + page_is_file_cache(page);
+
+		show_page_path(page);
+
 		__dec_zone_state(zone, NR_UNEVICTABLE);
 		list_move(&page->lru, &zone->lru[l].list);
 		__inc_zone_state(zone, NR_INACTIVE_ANON + l);
@@ -2493,4 +2530,130 @@ void scan_mapping_unevictable_pages(stru
 	}
 
 }
+
+/**
+ * scan_zone_unevictable_pages - check unevictable list for evictable pages
+ * @zone - zone of which to scan the unevictable list
+ *
+ * Scan @zone's unevictable LRU lists to check for pages that have become
+ * evictable.  Move those that have to @zone's inactive list where they
+ * become candidates for reclaim, unless shrink_inactive_zone() decides
+ * to reactivate them.  Pages that are still unevictable are rotated
+ * back onto @zone's unevictable list.
+ */
+#define SCAN_UNEVICTABLE_BATCH_SIZE 16UL /* arbitrary lock hold batch size */
+void scan_zone_unevictable_pages(struct zone *zone)
+{
+	struct list_head *l_unevictable = &zone->lru[LRU_UNEVICTABLE].list;
+	unsigned long scan;
+	unsigned long nr_to_scan = zone_page_state(zone, NR_UNEVICTABLE);
+
+	while (nr_to_scan > 0) {
+		unsigned long batch_size = min(nr_to_scan,
+						SCAN_UNEVICTABLE_BATCH_SIZE);
+
+		spin_lock_irq(&zone->lru_lock);
+		for (scan = 0;  scan < batch_size; scan++) {
+			struct page *page = lru_to_page(l_unevictable);
+
+			if (TestSetPageLocked(page))
+				continue;
+
+			prefetchw_prev_lru_page(page, l_unevictable, flags);
+
+			if (likely(PageLRU(page) && PageUnevictable(page)))
+				check_move_unevictable_page(page, zone);
+
+			unlock_page(page);
+		}
+		spin_unlock_irq(&zone->lru_lock);
+
+		nr_to_scan -= batch_size;
+	}
+}
+
+
+/**
+ * scan_all_zones_unevictable_pages - scan all unevictable lists for evictable pages
+ *
+ * A really big hammer:  scan all zones' unevictable LRU lists to check for
+ * pages that have become evictable.  Move those back to the zones'
+ * inactive list where they become candidates for reclaim.
+ * This occurs when, e.g., we have unswappable pages on the unevictable lists,
+ * and we add swap to the system.  As such, it runs in the context of a task
+ * that has possibly/probably made some previously unevictable pages
+ * evictable.
+ */
+void scan_all_zones_unevictable_pages(void)
+{
+	struct zone *zone;
+
+	for_each_zone(zone) {
+		scan_zone_unevictable_pages(zone);
+	}
+}
+
+/*
+ * scan_unevictable_pages [vm] sysctl handler.  On demand re-scan of
+ * all nodes' unevictable lists for evictable pages
+ */
+unsigned long scan_unevictable_pages;
+
+int scan_unevictable_handler(struct ctl_table *table, int write,
+			   struct file *file, void __user *buffer,
+			   size_t *length, loff_t *ppos)
+{
+	proc_doulongvec_minmax(table, write, file, buffer, length, ppos);
+
+	if (write && *(unsigned long *)table->data)
+		scan_all_zones_unevictable_pages();
+
+	scan_unevictable_pages = 0;
+	return 0;
+}
+
+/*
+ * per node 'scan_unevictable_pages' attribute.  On demand re-scan of
+ * a specified node's per zone unevictable lists for evictable pages.
+ */
+
+static ssize_t read_scan_unevictable_node(struct sys_device *dev, char *buf)
+{
+	return sprintf(buf, "0\n");	/* always zero; should fit... */
+}
+
+static ssize_t write_scan_unevictable_node(struct sys_device *dev,
+					const char *buf, size_t count)
+{
+	struct zone *node_zones = NODE_DATA(dev->id)->node_zones;
+	struct zone *zone;
+	unsigned long res;
+	unsigned long req = strict_strtoul(buf, 10, &res);
+
+	if (!req)
+		return 1;	/* zero is no-op */
+
+	for (zone = node_zones; zone - node_zones < MAX_NR_ZONES; ++zone) {
+		if (!populated_zone(zone))
+			continue;
+		scan_zone_unevictable_pages(zone);
+	}
+	return 1;
+}
+
+
+static SYSDEV_ATTR(scan_unevictable_pages, S_IRUGO | S_IWUSR,
+			read_scan_unevictable_node,
+			write_scan_unevictable_node);
+
+int scan_unevictable_register_node(struct node *node)
+{
+	return sysdev_create_file(&node->sysdev, &attr_scan_unevictable_pages);
+}
+
+void scan_unevictable_unregister_node(struct node *node)
+{
+	sysdev_remove_file(&node->sysdev, &attr_scan_unevictable_pages);
+}
+
 #endif
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

page-allocator-inlnie-some-__alloc_pages-wrappers.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
define-page_file_cache-function.patch
pageflag-helpers-for-configed-out-flags.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
ramfs-and-ram-disk-pages-are-unevictable.patch
shm_locked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-downgrade-mmap-sem-while-populating-mlocked-regions.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmstat-mlocked-pages-statistics.patch
swap-cull-unevictable-pages-in-fault-path.patch
vmstat-unevictable-and-mlocked-pages-vm-events.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-count-attempts-to-free-mlocked-page.patch
doc-unevictable-lru-and-mlocked-pages-documentation.patch

