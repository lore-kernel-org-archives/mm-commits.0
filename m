From: akpm@linux-foundation.org
Subject: + ksm-pages_unshared-and-pages_volatile.patch added to -mm tree
Date: Tue, 04 Aug 2009 15:01:04 -0700
Message-ID: <200908042201.n74M14lj013459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57645 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933185AbZHDWPC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2009 18:15:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, ieidus@redhat.com


The patch titled
     ksm: pages_unshared and pages_volatile
has been added to the -mm tree.  Its filename is
     ksm-pages_unshared-and-pages_volatile.patch

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
Subject: ksm: pages_unshared and pages_volatile
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

The pages_shared and pages_sharing counts give a good picture of how
successful KSM is at sharing; but no clue to how much wasted work it's
doing to get there.  Add pages_unshared (count of unique pages waiting
in the unstable tree, hoping to find a mate) and pages_volatile.

pages_volatile is harder to define.  It includes those pages changing
too fast to get into the unstable tree, but also whatever other edge
conditions prevent a page getting into the trees: a high value may
deserve investigation.  Don't try to calculate it from the various
conditions: it's the total of rmap_items less those accounted for.

Also show full_scans: the number of completed scans of everything
registered in the mm list.

The locking for all these counts is simply ksm_thread_mutex.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 51 insertions(+), 1 deletion(-)

diff -puN mm/ksm.c~ksm-pages_unshared-and-pages_volatile mm/ksm.c
--- a/mm/ksm.c~ksm-pages_unshared-and-pages_volatile
+++ a/mm/ksm.c
@@ -155,6 +155,12 @@ static unsigned long ksm_pages_shared;
 /* The number of page slots additionally sharing those nodes */
 static unsigned long ksm_pages_sharing;
 
+/* The number of nodes in the unstable tree */
+static unsigned long ksm_pages_unshared;
+
+/* The number of rmap_items in use: to calculate pages_volatile */
+static unsigned long ksm_rmap_items;
+
 /* Limit on the number of unswappable pages used */
 static unsigned long ksm_max_kernel_pages;
 
@@ -204,11 +210,17 @@ static void __init ksm_slab_free(void)
 
 static inline struct rmap_item *alloc_rmap_item(void)
 {
-	return kmem_cache_zalloc(rmap_item_cache, GFP_KERNEL);
+	struct rmap_item *rmap_item;
+
+	rmap_item = kmem_cache_zalloc(rmap_item_cache, GFP_KERNEL);
+	if (rmap_item)
+		ksm_rmap_items++;
+	return rmap_item;
 }
 
 static inline void free_rmap_item(struct rmap_item *rmap_item)
 {
+	ksm_rmap_items--;
 	rmap_item->mm = NULL;	/* debug safety */
 	kmem_cache_free(rmap_item_cache, rmap_item);
 }
@@ -419,6 +431,7 @@ static void remove_rmap_item_from_tree(s
 		BUG_ON(age > 2);
 		if (!age)
 			rb_erase(&rmap_item->node, &root_unstable_tree);
+		ksm_pages_unshared--;
 	}
 
 	rmap_item->address &= PAGE_MASK;
@@ -1002,6 +1015,7 @@ static struct rmap_item *unstable_tree_s
 	rb_link_node(&rmap_item->node, parent, new);
 	rb_insert_color(&rmap_item->node, &root_unstable_tree);
 
+	ksm_pages_unshared++;
 	return NULL;
 }
 
@@ -1098,6 +1112,8 @@ static void cmp_and_merge_page(struct pa
 		if (!err) {
 			rb_erase(&tree_rmap_item->node, &root_unstable_tree);
 			tree_rmap_item->address &= ~NODE_FLAG;
+			ksm_pages_unshared--;
+
 			/*
 			 * If we fail to insert the page into the stable tree,
 			 * we will have 2 virtual addresses that are pointing
@@ -1481,6 +1497,37 @@ static ssize_t pages_sharing_show(struct
 }
 KSM_ATTR_RO(pages_sharing);
 
+static ssize_t pages_unshared_show(struct kobject *kobj,
+				   struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%lu\n", ksm_pages_unshared);
+}
+KSM_ATTR_RO(pages_unshared);
+
+static ssize_t pages_volatile_show(struct kobject *kobj,
+				   struct kobj_attribute *attr, char *buf)
+{
+	long ksm_pages_volatile;
+
+	ksm_pages_volatile = ksm_rmap_items - ksm_pages_shared
+				- ksm_pages_sharing - ksm_pages_unshared;
+	/*
+	 * It was not worth any locking to calculate that statistic,
+	 * but it might therefore sometimes be negative: conceal that.
+	 */
+	if (ksm_pages_volatile < 0)
+		ksm_pages_volatile = 0;
+	return sprintf(buf, "%ld\n", ksm_pages_volatile);
+}
+KSM_ATTR_RO(pages_volatile);
+
+static ssize_t full_scans_show(struct kobject *kobj,
+			       struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%lu\n", ksm_scan.seqnr);
+}
+KSM_ATTR_RO(full_scans);
+
 static struct attribute *ksm_attrs[] = {
 	&sleep_millisecs_attr.attr,
 	&pages_to_scan_attr.attr,
@@ -1488,6 +1535,9 @@ static struct attribute *ksm_attrs[] = {
 	&max_kernel_pages_attr.attr,
 	&pages_shared_attr.attr,
 	&pages_sharing_attr.attr,
+	&pages_unshared_attr.attr,
+	&pages_volatile_attr.attr,
+	&full_scans_attr.attr,
 	NULL,
 };
 
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

acpi-fix-null-bug-for-hid-uid-string.patch
mm-oom-analysis-add-shmem-vmstat.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
ksm-rename-kernel_pages_allocated.patch
ksm-move-pages_sharing-updates.patch
ksm-pages_unshared-and-pages_volatile.patch
ksm-break-cow-once-unshared.patch
ksm-keep-quiet-while-list-empty.patch
ksm-five-little-cleanups.patch
ksm-fix-endless-loop-on-oom.patch
ksm-distribute-remove_mm_from_lists.patch
ksm-fix-oom-deadlock.patch
ksm-sysfs-and-defaults.patch
ksm-add-some-documentation.patch
ksm-remove-vm_mergeable_flags.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch

