From: akpm@linux-foundation.org
Subject: + ksm-numa-awareness-sysfs-knob.patch added to -mm tree
Date: Mon, 24 Sep 2012 15:23:23 -0700
Message-ID: <20120924222323.D27671E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:62172 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab2IXWXZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Sep 2012 18:23:25 -0400
Received: by ghbz15 with SMTP id z15so829423ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 24 Sep 2012 15:23:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pholasek@redhat.com, aarcange@redhat.com, anton@redhat.com, chrisw@sous-sol.org, hughd@google.com, izik.eidus@ravellosystems.com, riel@redhat.com, rientjes@google.com


The patch titled
     Subject: KSM: numa awareness sysfs knob
has been added to the -mm tree.  Its filename is
     ksm-numa-awareness-sysfs-knob.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Petr Holasek <pholasek@redhat.com>
Subject: KSM: numa awareness sysfs knob

Introduces new sysfs boolean knob /sys/kernel/mm/ksm/merge_across_nodes
which control merging pages across different numa nodes.  When it is set
to zero only pages from the same node are merged, otherwise pages from all
nodes can be merged together (default behavior).

Typical use-case could be a lot of KVM guests on NUMA machine and cpus
from more distant nodes would have significant increase of access latency
to the merged ksm page.  Sysfs knob was choosen for higher variability
when some users still prefers higher amount of saved physical memory
regardless of access latency.

Every numa node has its own stable & unstable trees because of faster
searching and inserting.  Changing of merge_nodes value is possible only
when there are not any ksm shared pages in system.

I've tested this patch on numa machines with 2, 4 and 8 nodes and measured
speed of memory access inside of KVM guests with memory pinned to one of
nodes with this benchmark:

http://pholasek.fedorapeople.org/alloc_pg.c

Population standard deviations of access times in percentage of average
were following:

merge_nodes=1
2 nodes 1.4%
4 nodes 1.6%
8 nodes	1.7%

merge_nodes=0
2 nodes	1%
4 nodes	0.32%
8 nodes	0.018%

RFC: https://lkml.org/lkml/2011/11/30/91
v1: https://lkml.org/lkml/2012/1/23/46
v2: https://lkml.org/lkml/2012/6/29/105
v3: https://lkml.org/lkml/2012/9/14/550

Signed-off-by: Petr Holasek <pholasek@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Anton Arapov <anton@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/ksm.txt |    7 +
 mm/ksm.c                 |  135 +++++++++++++++++++++++++++++++------
 2 files changed, 122 insertions(+), 20 deletions(-)

diff -puN Documentation/vm/ksm.txt~ksm-numa-awareness-sysfs-knob Documentation/vm/ksm.txt
--- a/Documentation/vm/ksm.txt~ksm-numa-awareness-sysfs-knob
+++ a/Documentation/vm/ksm.txt
@@ -58,6 +58,13 @@ sleep_millisecs  - how many milliseconds
                    e.g. "echo 20 > /sys/kernel/mm/ksm/sleep_millisecs"
                    Default: 20 (chosen for demonstration purposes)
 
+merge_nodes      - specifies if pages from different numa nodes can be merged.
+                   When set to 0, ksm merges only pages which physically
+                   reside in the memory area of same NUMA node. It brings
+                   lower latency to access to shared page. Value can be
+                   changed only when there is no ksm shared pages in system.
+                   Default: 1
+
 run              - set 0 to stop ksmd from running but keep merged pages,
                    set 1 to run ksmd e.g. "echo 1 > /sys/kernel/mm/ksm/run",
                    set 2 to stop ksmd and unmerge all pages currently merged,
diff -puN mm/ksm.c~ksm-numa-awareness-sysfs-knob mm/ksm.c
--- a/mm/ksm.c~ksm-numa-awareness-sysfs-knob
+++ a/mm/ksm.c
@@ -36,6 +36,7 @@
 #include <linux/hash.h>
 #include <linux/freezer.h>
 #include <linux/oom.h>
+#include <linux/numa.h>
 
 #include <asm/tlbflush.h>
 #include "internal.h"
@@ -140,7 +141,10 @@ struct rmap_item {
 	unsigned long address;		/* + low bits used for flags below */
 	unsigned int oldchecksum;	/* when unstable */
 	union {
-		struct rb_node node;	/* when node of unstable tree */
+		struct {
+			struct rb_node node;	/* when node of unstable tree */
+			struct rb_root *root;
+		};
 		struct {		/* when listed from stable tree */
 			struct stable_node *head;
 			struct hlist_node hlist;
@@ -153,8 +157,8 @@ struct rmap_item {
 #define STABLE_FLAG	0x200	/* is listed from the stable tree */
 
 /* The stable and unstable tree heads */
-static struct rb_root root_stable_tree = RB_ROOT;
-static struct rb_root root_unstable_tree = RB_ROOT;
+static struct rb_root root_unstable_tree[MAX_NUMNODES] = { RB_ROOT, };
+static struct rb_root root_stable_tree[MAX_NUMNODES] = { RB_ROOT, };
 
 #define MM_SLOTS_HASH_SHIFT 10
 #define MM_SLOTS_HASH_HEADS (1 << MM_SLOTS_HASH_SHIFT)
@@ -189,6 +193,9 @@ static unsigned int ksm_thread_pages_to_
 /* Milliseconds ksmd should sleep between batches */
 static unsigned int ksm_thread_sleep_millisecs = 20;
 
+/* Zeroed when merging across nodes is not allowed */
+static unsigned int ksm_merge_across_nodes = 1;
+
 #define KSM_RUN_STOP	0
 #define KSM_RUN_MERGE	1
 #define KSM_RUN_UNMERGE	2
@@ -447,10 +454,25 @@ out:		page = NULL;
 	return page;
 }
 
+/*
+ * This helper is used for getting right index into array of tree roots.
+ * When merge_across_nodes knob is set to 1, there are only two rb-trees for
+ * stable and unstable pages from all nodes with roots in index 0. Otherwise,
+ * every node has its own stable and unstable tree.
+ */
+static inline int get_kpfn_nid(unsigned long kpfn)
+{
+	if (ksm_merge_across_nodes)
+		return 0;
+	else
+		return pfn_to_nid(kpfn);
+}
+
 static void remove_node_from_stable_tree(struct stable_node *stable_node)
 {
 	struct rmap_item *rmap_item;
 	struct hlist_node *hlist;
+	int nid;
 
 	hlist_for_each_entry(rmap_item, hlist, &stable_node->hlist, hlist) {
 		if (rmap_item->hlist.next)
@@ -462,7 +484,10 @@ static void remove_node_from_stable_tree
 		cond_resched();
 	}
 
-	rb_erase(&stable_node->node, &root_stable_tree);
+	nid = get_kpfn_nid(stable_node->kpfn);
+
+	rb_erase(&stable_node->node,
+			&root_stable_tree[nid]);
 	free_stable_node(stable_node);
 }
 
@@ -560,7 +585,7 @@ static void remove_rmap_item_from_tree(s
 		age = (unsigned char)(ksm_scan.seqnr - rmap_item->address);
 		BUG_ON(age > 1);
 		if (!age)
-			rb_erase(&rmap_item->node, &root_unstable_tree);
+			rb_erase(&rmap_item->node, rmap_item->root);
 
 		ksm_pages_unshared--;
 		rmap_item->address &= PAGE_MASK;
@@ -1006,8 +1031,9 @@ static struct page *try_to_merge_two_pag
  */
 static struct page *stable_tree_search(struct page *page)
 {
-	struct rb_node *node = root_stable_tree.rb_node;
+	struct rb_node *node;
 	struct stable_node *stable_node;
+	int nid;
 
 	stable_node = page_stable_node(page);
 	if (stable_node) {			/* ksm page forked */
@@ -1015,6 +1041,9 @@ static struct page *stable_tree_search(s
 		return page;
 	}
 
+	nid = get_kpfn_nid(page_to_pfn(page));
+	node = root_stable_tree[nid].rb_node;
+
 	while (node) {
 		struct page *tree_page;
 		int ret;
@@ -1049,10 +1078,14 @@ static struct page *stable_tree_search(s
  */
 static struct stable_node *stable_tree_insert(struct page *kpage)
 {
-	struct rb_node **new = &root_stable_tree.rb_node;
+	int nid;
+	struct rb_node **new = NULL;
 	struct rb_node *parent = NULL;
 	struct stable_node *stable_node;
 
+	nid = get_kpfn_nid(page_to_nid(kpage));
+	new = &root_stable_tree[nid].rb_node;
+
 	while (*new) {
 		struct page *tree_page;
 		int ret;
@@ -1086,7 +1119,7 @@ static struct stable_node *stable_tree_i
 		return NULL;
 
 	rb_link_node(&stable_node->node, parent, new);
-	rb_insert_color(&stable_node->node, &root_stable_tree);
+	rb_insert_color(&stable_node->node, &root_stable_tree[nid]);
 
 	INIT_HLIST_HEAD(&stable_node->hlist);
 
@@ -1114,10 +1147,16 @@ static
 struct rmap_item *unstable_tree_search_insert(struct rmap_item *rmap_item,
 					      struct page *page,
 					      struct page **tree_pagep)
-
 {
-	struct rb_node **new = &root_unstable_tree.rb_node;
+	struct rb_node **new = NULL;
+	struct rb_root *root;
 	struct rb_node *parent = NULL;
+	int nid;
+
+	nid = get_kpfn_nid(page_to_pfn(page));
+	root = &root_unstable_tree[nid];
+
+	new = &root->rb_node;
 
 	while (*new) {
 		struct rmap_item *tree_rmap_item;
@@ -1155,8 +1194,9 @@ struct rmap_item *unstable_tree_search_i
 
 	rmap_item->address |= UNSTABLE_FLAG;
 	rmap_item->address |= (ksm_scan.seqnr & SEQNR_MASK);
+	rmap_item->root = root;
 	rb_link_node(&rmap_item->node, parent, new);
-	rb_insert_color(&rmap_item->node, &root_unstable_tree);
+	rb_insert_color(&rmap_item->node, root);
 
 	ksm_pages_unshared++;
 	return NULL;
@@ -1299,6 +1339,7 @@ static struct rmap_item *scan_get_next_r
 	struct mm_slot *slot;
 	struct vm_area_struct *vma;
 	struct rmap_item *rmap_item;
+	int i;
 
 	if (list_empty(&ksm_mm_head.mm_list))
 		return NULL;
@@ -1317,7 +1358,8 @@ static struct rmap_item *scan_get_next_r
 		 */
 		lru_add_drain_all();
 
-		root_unstable_tree = RB_ROOT;
+		for (i = 0; i < MAX_NUMNODES; i++)
+			root_unstable_tree[i] = RB_ROOT;
 
 		spin_lock(&ksm_mmlist_lock);
 		slot = list_entry(slot->mm_list.next, struct mm_slot, mm_list);
@@ -1782,7 +1824,12 @@ void ksm_migrate_page(struct page *newpa
 	stable_node = page_stable_node(newpage);
 	if (stable_node) {
 		VM_BUG_ON(stable_node->kpfn != page_to_pfn(oldpage));
-		stable_node->kpfn = page_to_pfn(newpage);
+
+		if (ksm_merge_across_nodes ||
+				page_to_nid(oldpage) == page_to_nid(newpage))
+			stable_node->kpfn = page_to_pfn(newpage);
+		else
+			remove_node_from_stable_tree(stable_node);
 	}
 }
 #endif /* CONFIG_MIGRATION */
@@ -1792,15 +1839,19 @@ static struct stable_node *ksm_check_sta
 						 unsigned long end_pfn)
 {
 	struct rb_node *node;
+	int i;
 
-	for (node = rb_first(&root_stable_tree); node; node = rb_next(node)) {
-		struct stable_node *stable_node;
+	for (i = 0; i < MAX_NUMNODES; i++)
+		for (node = rb_first(&root_stable_tree[i]); node;
+				node = rb_next(node)) {
+			struct stable_node *stable_node;
+
+			stable_node = rb_entry(node, struct stable_node, node);
+			if (stable_node->kpfn >= start_pfn &&
+			    stable_node->kpfn < end_pfn)
+				return stable_node;
+		}
 
-		stable_node = rb_entry(node, struct stable_node, node);
-		if (stable_node->kpfn >= start_pfn &&
-		    stable_node->kpfn < end_pfn)
-			return stable_node;
-	}
 	return NULL;
 }
 
@@ -1950,6 +2001,47 @@ static ssize_t run_store(struct kobject 
 }
 KSM_ATTR(run);
 
+#ifdef CONFIG_NUMA
+static ssize_t merge_across_nodes_show(struct kobject *kobj,
+				struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%u\n", ksm_merge_across_nodes);
+}
+
+static ssize_t merge_across_nodes_store(struct kobject *kobj,
+				   struct kobj_attribute *attr,
+				   const char *buf, size_t count)
+{
+	int err;
+	unsigned long knob;
+
+	err = kstrtoul(buf, 10, &knob);
+	if (err)
+		return err;
+	if (knob > 1)
+		return -EINVAL;
+
+	mutex_lock(&ksm_thread_mutex);
+	if (ksm_run & KSM_RUN_MERGE) {
+		err = -EBUSY;
+	} else {
+		if (ksm_merge_across_nodes != knob) {
+			if (ksm_pages_shared > 0)
+				err = -EBUSY;
+			else
+				ksm_merge_across_nodes = knob;
+		}
+	}
+
+	if (err)
+		count = err;
+	mutex_unlock(&ksm_thread_mutex);
+
+	return count;
+}
+KSM_ATTR(merge_across_nodes);
+#endif
+
 static ssize_t pages_shared_show(struct kobject *kobj,
 				 struct kobj_attribute *attr, char *buf)
 {
@@ -2004,6 +2096,9 @@ static struct attribute *ksm_attrs[] = {
 	&pages_unshared_attr.attr,
 	&pages_volatile_attr.attr,
 	&full_scans_attr.attr,
+#ifdef CONFIG_NUMA
+	&merge_across_nodes_attr.attr,
+#endif
 	NULL,
 };
 
_

Patches currently in -mm which might be from pholasek@redhat.com are

ksm-numa-awareness-sysfs-knob.patch

