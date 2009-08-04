From: akpm@linux-foundation.org
Subject: + ksm-move-pages_sharing-updates.patch added to -mm tree
Date: Tue, 04 Aug 2009 15:01:01 -0700
Message-ID: <200908042201.n74M11JG013351@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755163AbZHDWOY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2009 18:14:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, ieidus@redhat.com


The patch titled
     ksm: move pages_sharing updates
has been added to the -mm tree.  Its filename is
     ksm-move-pages_sharing-updates.patch

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
Subject: ksm: move pages_sharing updates
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

The pages_shared count is incremented and decremented when adding a node
to and removing a node from the stable tree: easy to understand.  But the
pages_sharing count was hard to follow, being adjusted in various places:
increment and decrement it when adding to and removing from the stable tree.

And the pages_sharing variable used to include the pages_shared, then those
were subtracted when shown in the pages_sharing sysfs file: now keep it as
an exclusive count of leaves hanging off the stable tree nodes, throughout.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Izik Eidus <ieidus@redhat.com>
Acked-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff -puN mm/ksm.c~ksm-move-pages_sharing-updates mm/ksm.c
--- a/mm/ksm.c~ksm-move-pages_sharing-updates
+++ a/mm/ksm.c
@@ -152,7 +152,7 @@ static struct kmem_cache *mm_slot_cache;
 /* The number of nodes in the stable tree */
 static unsigned long ksm_pages_shared;
 
-/* The number of page slots sharing those nodes */
+/* The number of page slots additionally sharing those nodes */
 static unsigned long ksm_pages_sharing;
 
 /* Limit on the number of unswappable pages used */
@@ -382,6 +382,7 @@ static void remove_rmap_item_from_tree(s
 						&next_item->node,
 						&root_stable_tree);
 				next_item->address |= NODE_FLAG;
+				ksm_pages_sharing--;
 			} else {
 				rb_erase(&rmap_item->node, &root_stable_tree);
 				ksm_pages_shared--;
@@ -395,10 +396,10 @@ static void remove_rmap_item_from_tree(s
 				BUG_ON(next_item->prev != rmap_item);
 				next_item->prev = rmap_item->prev;
 			}
+			ksm_pages_sharing--;
 		}
 
 		rmap_item->next = NULL;
-		ksm_pages_sharing--;
 
 	} else if (rmap_item->address & NODE_FLAG) {
 		unsigned char age;
@@ -786,8 +787,6 @@ static int try_to_merge_two_pages(struct
 		 */
 		if (err)
 			break_cow(mm1, addr1);
-		else
-			ksm_pages_sharing += 2;
 	}
 
 	put_page(kpage);
@@ -816,9 +815,6 @@ static int try_to_merge_with_ksm_page(st
 	err = try_to_merge_one_page(vma, page1, kpage);
 	up_read(&mm1->mmap_sem);
 
-	if (!err)
-		ksm_pages_sharing++;
-
 	return err;
 }
 
@@ -935,13 +931,12 @@ static struct rmap_item *stable_tree_ins
 		}
 	}
 
-	ksm_pages_shared++;
-
 	rmap_item->address |= NODE_FLAG | STABLE_FLAG;
 	rmap_item->next = NULL;
 	rb_link_node(&rmap_item->node, parent, new);
 	rb_insert_color(&rmap_item->node, &root_stable_tree);
 
+	ksm_pages_shared++;
 	return rmap_item;
 }
 
@@ -1026,6 +1021,8 @@ static void stable_tree_append(struct rm
 
 	tree_rmap_item->next = rmap_item;
 	rmap_item->address |= STABLE_FLAG;
+
+	ksm_pages_sharing++;
 }
 
 /*
@@ -1050,10 +1047,9 @@ static void cmp_and_merge_page(struct pa
 	/* We first start with searching the page inside the stable tree */
 	tree_rmap_item = stable_tree_search(page, page2, rmap_item);
 	if (tree_rmap_item) {
-		if (page == page2[0]) {			/* forked */
-			ksm_pages_sharing++;
+		if (page == page2[0])			/* forked */
 			err = 0;
-		} else
+		else
 			err = try_to_merge_with_ksm_page(rmap_item->mm,
 							 rmap_item->address,
 							 page, page2[0]);
@@ -1114,7 +1110,6 @@ static void cmp_and_merge_page(struct pa
 				break_cow(tree_rmap_item->mm,
 						tree_rmap_item->address);
 				break_cow(rmap_item->mm, rmap_item->address);
-				ksm_pages_sharing -= 2;
 			}
 		}
 
@@ -1482,8 +1477,7 @@ KSM_ATTR_RO(pages_shared);
 static ssize_t pages_sharing_show(struct kobject *kobj,
 				  struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%lu\n",
-			ksm_pages_sharing - ksm_pages_shared);
+	return sprintf(buf, "%lu\n", ksm_pages_sharing);
 }
 KSM_ATTR_RO(pages_sharing);
 
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

