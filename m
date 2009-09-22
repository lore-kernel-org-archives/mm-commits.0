From: akpm@linux-foundation.org
Subject: [merged] ksm-move-pages_sharing-updates.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:39:45 -0700
Message-ID: <200909222039.n8MKdjWi004094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53218 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752570AbZIVUkV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:40:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, ieidus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ksm: move pages_sharing updates
has been removed from the -mm tree.  Its filename was
     ksm-move-pages_sharing-updates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 
@@ -928,13 +924,12 @@ static struct rmap_item *stable_tree_ins
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
 
@@ -1019,6 +1014,8 @@ static void stable_tree_append(struct rm
 
 	tree_rmap_item->next = rmap_item;
 	rmap_item->address |= STABLE_FLAG;
+
+	ksm_pages_sharing++;
 }
 
 /*
@@ -1043,10 +1040,9 @@ static void cmp_and_merge_page(struct pa
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
@@ -1107,7 +1103,6 @@ static void cmp_and_merge_page(struct pa
 				break_cow(tree_rmap_item->mm,
 						tree_rmap_item->address);
 				break_cow(rmap_item->mm, rmap_item->address);
-				ksm_pages_sharing -= 2;
 			}
 		}
 
@@ -1475,8 +1470,7 @@ KSM_ATTR_RO(pages_shared);
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

origin.patch
linux-next.patch
vfs-optimize-touch_time-too.patch
vfs-seq_file-add-helpers-for-data-filling.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
getrusage-fill-ru_maxrss-value.patch
walk-system-ram-range-fix.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch

