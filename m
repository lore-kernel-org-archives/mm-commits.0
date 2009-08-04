From: akpm@linux-foundation.org
Subject: + ksm-rename-kernel_pages_allocated.patch added to -mm tree
Date: Tue, 04 Aug 2009 15:00:59 -0700
Message-ID: <200908042201.n74M0xXT013207@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933193AbZHDWCA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2009 18:02:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, ieidus@redhat.com


The patch titled
     ksm: rename kernel_pages_allocated
has been added to the -mm tree.  Its filename is
     ksm-rename-kernel_pages_allocated.patch

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
Subject: ksm: rename kernel_pages_allocated
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

We're not implementing swapping of KSM pages in its first release;
but when that follows, "kernel_pages_allocated" will be a very poor
name for the sysfs file showing number of nodes in the stable tree:
rename that to "pages_shared" throughout.

But we already have a "pages_shared", counting those page slots
sharing the shared pages: first rename that to... "pages_sharing".

What will become of "max_kernel_pages" when the pages shared can
be swapped?  I guess it will just be removed, so keep that name.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Izik Eidus <ieidus@redhat.com>
Acked-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   57 ++++++++++++++++++++++++++---------------------------
 1 file changed, 28 insertions(+), 29 deletions(-)

diff -puN mm/ksm.c~ksm-rename-kernel_pages_allocated mm/ksm.c
--- a/mm/ksm.c~ksm-rename-kernel_pages_allocated
+++ a/mm/ksm.c
@@ -150,10 +150,10 @@ static struct kmem_cache *rmap_item_cach
 static struct kmem_cache *mm_slot_cache;
 
 /* The number of nodes in the stable tree */
-static unsigned long ksm_kernel_pages_allocated;
+static unsigned long ksm_pages_shared;
 
 /* The number of page slots sharing those nodes */
-static unsigned long ksm_pages_shared;
+static unsigned long ksm_pages_sharing;
 
 /* Limit on the number of unswappable pages used */
 static unsigned long ksm_max_kernel_pages;
@@ -384,7 +384,7 @@ static void remove_rmap_item_from_tree(s
 				next_item->address |= NODE_FLAG;
 			} else {
 				rb_erase(&rmap_item->node, &root_stable_tree);
-				ksm_kernel_pages_allocated--;
+				ksm_pages_shared--;
 			}
 		} else {
 			struct rmap_item *prev_item = rmap_item->prev;
@@ -398,7 +398,7 @@ static void remove_rmap_item_from_tree(s
 		}
 
 		rmap_item->next = NULL;
-		ksm_pages_shared--;
+		ksm_pages_sharing--;
 
 	} else if (rmap_item->address & NODE_FLAG) {
 		unsigned char age;
@@ -748,7 +748,7 @@ static int try_to_merge_two_pages(struct
 	 * is the number of kernel pages that we hold.
 	 */
 	if (ksm_max_kernel_pages &&
-	    ksm_max_kernel_pages <= ksm_kernel_pages_allocated)
+	    ksm_max_kernel_pages <= ksm_pages_shared)
 		return err;
 
 	kpage = alloc_page(GFP_HIGHUSER);
@@ -787,7 +787,7 @@ static int try_to_merge_two_pages(struct
 		if (err)
 			break_cow(mm1, addr1);
 		else
-			ksm_pages_shared += 2;
+			ksm_pages_sharing += 2;
 	}
 
 	put_page(kpage);
@@ -817,7 +817,7 @@ static int try_to_merge_with_ksm_page(st
 	up_read(&mm1->mmap_sem);
 
 	if (!err)
-		ksm_pages_shared++;
+		ksm_pages_sharing++;
 
 	return err;
 }
@@ -935,7 +935,7 @@ static struct rmap_item *stable_tree_ins
 		}
 	}
 
-	ksm_kernel_pages_allocated++;
+	ksm_pages_shared++;
 
 	rmap_item->address |= NODE_FLAG | STABLE_FLAG;
 	rmap_item->next = NULL;
@@ -1051,7 +1051,7 @@ static void cmp_and_merge_page(struct pa
 	tree_rmap_item = stable_tree_search(page, page2, rmap_item);
 	if (tree_rmap_item) {
 		if (page == page2[0]) {			/* forked */
-			ksm_pages_shared++;
+			ksm_pages_sharing++;
 			err = 0;
 		} else
 			err = try_to_merge_with_ksm_page(rmap_item->mm,
@@ -1114,7 +1114,7 @@ static void cmp_and_merge_page(struct pa
 				break_cow(tree_rmap_item->mm,
 						tree_rmap_item->address);
 				break_cow(rmap_item->mm, rmap_item->address);
-				ksm_pages_shared -= 2;
+				ksm_pages_sharing -= 2;
 			}
 		}
 
@@ -1430,7 +1430,7 @@ static ssize_t run_store(struct kobject 
 	/*
 	 * KSM_RUN_MERGE sets ksmd running, and 0 stops it running.
 	 * KSM_RUN_UNMERGE stops it running and unmerges all rmap_items,
-	 * breaking COW to free the kernel_pages_allocated (but leaves
+	 * breaking COW to free the unswappable pages_shared (but leaves
 	 * mm_slots on the list for when ksmd may be set running again).
 	 */
 
@@ -1449,22 +1449,6 @@ static ssize_t run_store(struct kobject 
 }
 KSM_ATTR(run);
 
-static ssize_t pages_shared_show(struct kobject *kobj,
-				 struct kobj_attribute *attr, char *buf)
-{
-	return sprintf(buf, "%lu\n",
-			ksm_pages_shared - ksm_kernel_pages_allocated);
-}
-KSM_ATTR_RO(pages_shared);
-
-static ssize_t kernel_pages_allocated_show(struct kobject *kobj,
-					   struct kobj_attribute *attr,
-					   char *buf)
-{
-	return sprintf(buf, "%lu\n", ksm_kernel_pages_allocated);
-}
-KSM_ATTR_RO(kernel_pages_allocated);
-
 static ssize_t max_kernel_pages_store(struct kobject *kobj,
 				      struct kobj_attribute *attr,
 				      const char *buf, size_t count)
@@ -1488,13 +1472,28 @@ static ssize_t max_kernel_pages_show(str
 }
 KSM_ATTR(max_kernel_pages);
 
+static ssize_t pages_shared_show(struct kobject *kobj,
+				 struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%lu\n", ksm_pages_shared);
+}
+KSM_ATTR_RO(pages_shared);
+
+static ssize_t pages_sharing_show(struct kobject *kobj,
+				  struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%lu\n",
+			ksm_pages_sharing - ksm_pages_shared);
+}
+KSM_ATTR_RO(pages_sharing);
+
 static struct attribute *ksm_attrs[] = {
 	&sleep_millisecs_attr.attr,
 	&pages_to_scan_attr.attr,
 	&run_attr.attr,
-	&pages_shared_attr.attr,
-	&kernel_pages_allocated_attr.attr,
 	&max_kernel_pages_attr.attr,
+	&pages_shared_attr.attr,
+	&pages_sharing_attr.attr,
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

