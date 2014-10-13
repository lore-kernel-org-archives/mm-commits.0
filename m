From: akpm@linux-foundation.org
Subject: [merged]
 mm-remove-noisy-remainder-of-the-scan_unevictable-interface.patch removed
 from -mm tree
Date: Mon, 13 Oct 2014 11:20:01 -0700
Message-ID: <543c17d1.neALRl85ftVgz1SO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60477 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817AbaJMSUB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:20:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove noisy remainder of the scan_unevictable interface
has been removed from the -mm tree.  Its filename was
     mm-remove-noisy-remainder-of-the-scan_unevictable-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: remove noisy remainder of the scan_unevictable interface

The deprecation warnings for the scan_unevictable interface triggers by
scripts doing `sysctl -a | grep something else'.  This is annoying and not
helpful.

The interface has been defunct since 264e56d8247e ("mm: disable user
interface to manually rescue unevictable pages"), which was in 2011, and
there haven't been any reports of usecases for it, only reports that the
deprecation warnings are annying.  It's unlikely that anybody is using
this interface specifically at this point, so remove it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/stable/sysfs-devices-node |    8 --
 drivers/base/node.c                         |    3 
 include/linux/swap.h                        |   16 ----
 kernel/sysctl.c                             |    7 --
 mm/vmscan.c                                 |   63 ------------------
 5 files changed, 97 deletions(-)

diff -puN Documentation/ABI/stable/sysfs-devices-node~mm-remove-noisy-remainder-of-the-scan_unevictable-interface Documentation/ABI/stable/sysfs-devices-node
--- a/Documentation/ABI/stable/sysfs-devices-node~mm-remove-noisy-remainder-of-the-scan_unevictable-interface
+++ a/Documentation/ABI/stable/sysfs-devices-node
@@ -85,14 +85,6 @@ Description:
 		will be compacted. When it completes, memory will be freed
 		into blocks which have as many contiguous pages as possible
 
-What:		/sys/devices/system/node/nodeX/scan_unevictable_pages
-Date:		October 2008
-Contact:	Lee Schermerhorn <lee.schermerhorn@hp.com>
-Description:
-		When set, it triggers scanning the node's unevictable lists
-		and move any pages that have become evictable onto the respective
-		zone's inactive list. See mm/vmscan.c
-
 What:		/sys/devices/system/node/nodeX/hugepages/hugepages-<size>/
 Date:		December 2009
 Contact:	Lee Schermerhorn <lee.schermerhorn@hp.com>
diff -puN drivers/base/node.c~mm-remove-noisy-remainder-of-the-scan_unevictable-interface drivers/base/node.c
--- a/drivers/base/node.c~mm-remove-noisy-remainder-of-the-scan_unevictable-interface
+++ a/drivers/base/node.c
@@ -289,8 +289,6 @@ static int register_node(struct node *no
 		device_create_file(&node->dev, &dev_attr_distance);
 		device_create_file(&node->dev, &dev_attr_vmstat);
 
-		scan_unevictable_register_node(node);
-
 		hugetlb_register_node(node);
 
 		compaction_register_node(node);
@@ -314,7 +312,6 @@ void unregister_node(struct node *node)
 	device_remove_file(&node->dev, &dev_attr_distance);
 	device_remove_file(&node->dev, &dev_attr_vmstat);
 
-	scan_unevictable_unregister_node(node);
 	hugetlb_unregister_node(node);		/* no-op, if memoryless node */
 
 	device_unregister(&node->dev);
diff -puN include/linux/swap.h~mm-remove-noisy-remainder-of-the-scan_unevictable-interface include/linux/swap.h
--- a/include/linux/swap.h~mm-remove-noisy-remainder-of-the-scan_unevictable-interface
+++ a/include/linux/swap.h
@@ -354,22 +354,6 @@ static inline int zone_reclaim(struct zo
 extern int page_evictable(struct page *page);
 extern void check_move_unevictable_pages(struct page **, int nr_pages);
 
-extern unsigned long scan_unevictable_pages;
-extern int scan_unevictable_handler(struct ctl_table *, int,
-					void __user *, size_t *, loff_t *);
-#ifdef CONFIG_NUMA
-extern int scan_unevictable_register_node(struct node *node);
-extern void scan_unevictable_unregister_node(struct node *node);
-#else
-static inline int scan_unevictable_register_node(struct node *node)
-{
-	return 0;
-}
-static inline void scan_unevictable_unregister_node(struct node *node)
-{
-}
-#endif
-
 extern int kswapd_run(int nid);
 extern void kswapd_stop(int nid);
 #ifdef CONFIG_MEMCG
diff -puN kernel/sysctl.c~mm-remove-noisy-remainder-of-the-scan_unevictable-interface kernel/sysctl.c
--- a/kernel/sysctl.c~mm-remove-noisy-remainder-of-the-scan_unevictable-interface
+++ a/kernel/sysctl.c
@@ -1460,13 +1460,6 @@ static struct ctl_table vm_table[] = {
 		.extra2		= &one,
 	},
 #endif
-	{
-		.procname	= "scan_unevictable_pages",
-		.data		= &scan_unevictable_pages,
-		.maxlen		= sizeof(scan_unevictable_pages),
-		.mode		= 0644,
-		.proc_handler	= scan_unevictable_handler,
-	},
 #ifdef CONFIG_MEMORY_FAILURE
 	{
 		.procname	= "memory_failure_early_kill",
diff -puN mm/vmscan.c~mm-remove-noisy-remainder-of-the-scan_unevictable-interface mm/vmscan.c
--- a/mm/vmscan.c~mm-remove-noisy-remainder-of-the-scan_unevictable-interface
+++ a/mm/vmscan.c
@@ -3797,66 +3797,3 @@ void check_move_unevictable_pages(struct
 	}
 }
 #endif /* CONFIG_SHMEM */
-
-static void warn_scan_unevictable_pages(void)
-{
-	printk_once(KERN_WARNING
-		    "%s: The scan_unevictable_pages sysctl/node-interface has been "
-		    "disabled for lack of a legitimate use case.  If you have "
-		    "one, please send an email to linux-mm@kvack.org.\n",
-		    current->comm);
-}
-
-/*
- * scan_unevictable_pages [vm] sysctl handler.  On demand re-scan of
- * all nodes' unevictable lists for evictable pages
- */
-unsigned long scan_unevictable_pages;
-
-int scan_unevictable_handler(struct ctl_table *table, int write,
-			   void __user *buffer,
-			   size_t *length, loff_t *ppos)
-{
-	warn_scan_unevictable_pages();
-	proc_doulongvec_minmax(table, write, buffer, length, ppos);
-	scan_unevictable_pages = 0;
-	return 0;
-}
-
-#ifdef CONFIG_NUMA
-/*
- * per node 'scan_unevictable_pages' attribute.  On demand re-scan of
- * a specified node's per zone unevictable lists for evictable pages.
- */
-
-static ssize_t read_scan_unevictable_node(struct device *dev,
-					  struct device_attribute *attr,
-					  char *buf)
-{
-	warn_scan_unevictable_pages();
-	return sprintf(buf, "0\n");	/* always zero; should fit... */
-}
-
-static ssize_t write_scan_unevictable_node(struct device *dev,
-					   struct device_attribute *attr,
-					const char *buf, size_t count)
-{
-	warn_scan_unevictable_pages();
-	return 1;
-}
-
-
-static DEVICE_ATTR(scan_unevictable_pages, S_IRUGO | S_IWUSR,
-			read_scan_unevictable_node,
-			write_scan_unevictable_node);
-
-int scan_unevictable_register_node(struct node *node)
-{
-	return device_create_file(&node->dev, &dev_attr_scan_unevictable_pages);
-}
