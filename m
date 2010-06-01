From: akpm@linux-foundation.org
Subject: + mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function.patch added to -mm tree
Date: Tue, 01 Jun 2010 15:10:21 -0700
Message-ID: <201006012210.o51MALc8021799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44658 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754551Ab0FAWK7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jun 2010 18:10:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, lwoodman@redhat.com, mel@csn.ul.ie, minchan.kim@gmail.com, torvalds@linux-foundation.org


The patch titled
     mm: change direct call of spin_lock(anon_vma->lock) to inline function
has been added to the -mm tree.  Its filename is
     mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function.patch

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
Subject: mm: change direct call of spin_lock(anon_vma->lock) to inline function
From: Rik van Riel <riel@redhat.com>

Subsitute a direct call of spin_lock(anon_vma->lock) with an inline
function doing exactly the same.

This makes it easier to do the substitution to the root anon_vma lock in a
following patch.

We will deal with the handful of special locks (nested, dec_and_lock, etc)
separately.

Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Tested-by: Larry Woodman <lwoodman@redhat.com>
Acked-by: Larry Woodman <lwoodman@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |   10 ++++++++++
 mm/ksm.c             |   18 +++++++++---------
 mm/migrate.c         |    2 +-
 mm/mmap.c            |    2 +-
 mm/rmap.c            |   22 +++++++++++-----------
 5 files changed, 32 insertions(+), 22 deletions(-)

diff -puN include/linux/rmap.h~mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function include/linux/rmap.h
--- a/include/linux/rmap.h~mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function
+++ a/include/linux/rmap.h
@@ -113,6 +113,16 @@ static inline void vma_unlock_anon_vma(s
 		spin_unlock(&anon_vma->lock);
 }
 
+static inline void anon_vma_lock(struct anon_vma *anon_vma)
+{
+	spin_lock(&anon_vma->lock);
+}
+
+static inline void anon_vma_unlock(struct anon_vma *anon_vma)
+{
+	spin_unlock(&anon_vma->lock);
+}
+
 /*
  * anon_vma helper functions.
  */
diff -puN mm/ksm.c~mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function mm/ksm.c
--- a/mm/ksm.c~mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function
+++ a/mm/ksm.c
@@ -327,7 +327,7 @@ static void drop_anon_vma(struct rmap_it
 
 	if (atomic_dec_and_lock(&anon_vma->external_refcount, &anon_vma->lock)) {
 		int empty = list_empty(&anon_vma->head);
-		spin_unlock(&anon_vma->lock);
+		anon_vma_unlock(anon_vma);
 		if (empty)
 			anon_vma_free(anon_vma);
 	}
@@ -1566,7 +1566,7 @@ again:
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
 
-		spin_lock(&anon_vma->lock);
+		anon_vma_lock(anon_vma);
 		list_for_each_entry(vmac, &anon_vma->head, same_anon_vma) {
 			vma = vmac->vma;
 			if (rmap_item->address < vma->vm_start ||
@@ -1589,7 +1589,7 @@ again:
 			if (!search_new_forks || !mapcount)
 				break;
 		}
-		spin_unlock(&anon_vma->lock);
+		anon_vma_unlock(anon_vma);
 		if (!mapcount)
 			goto out;
 	}
@@ -1619,7 +1619,7 @@ again:
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
 
-		spin_lock(&anon_vma->lock);
+		anon_vma_lock(anon_vma);
 		list_for_each_entry(vmac, &anon_vma->head, same_anon_vma) {
 			vma = vmac->vma;
 			if (rmap_item->address < vma->vm_start ||
@@ -1637,11 +1637,11 @@ again:
 			ret = try_to_unmap_one(page, vma,
 					rmap_item->address, flags);
 			if (ret != SWAP_AGAIN || !page_mapped(page)) {
-				spin_unlock(&anon_vma->lock);
+				anon_vma_unlock(anon_vma);
 				goto out;
 			}
 		}
-		spin_unlock(&anon_vma->lock);
+		anon_vma_unlock(anon_vma);
 	}
 	if (!search_new_forks++)
 		goto again;
@@ -1671,7 +1671,7 @@ again:
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
 
-		spin_lock(&anon_vma->lock);
+		anon_vma_lock(anon_vma);
 		list_for_each_entry(vmac, &anon_vma->head, same_anon_vma) {
 			vma = vmac->vma;
 			if (rmap_item->address < vma->vm_start ||
@@ -1688,11 +1688,11 @@ again:
 
 			ret = rmap_one(page, vma, rmap_item->address, arg);
 			if (ret != SWAP_AGAIN) {
-				spin_unlock(&anon_vma->lock);
+				anon_vma_unlock(anon_vma);
 				goto out;
 			}
 		}
-		spin_unlock(&anon_vma->lock);
+		anon_vma_unlock(anon_vma);
 	}
 	if (!search_new_forks++)
 		goto again;
diff -puN mm/migrate.c~mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function mm/migrate.c
--- a/mm/migrate.c~mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function
+++ a/mm/migrate.c
@@ -684,7 +684,7 @@ rcu_unlock:
 	/* Drop an anon_vma reference if we took one */
 	if (anon_vma && atomic_dec_and_lock(&anon_vma->external_refcount, &anon_vma->lock)) {
 		int empty = list_empty(&anon_vma->head);
-		spin_unlock(&anon_vma->lock);
+		anon_vma_unlock(anon_vma);
 		if (empty)
 			anon_vma_free(anon_vma);
 	}
diff -puN mm/mmap.c~mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function mm/mmap.c
--- a/mm/mmap.c~mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function
+++ a/mm/mmap.c
@@ -2589,7 +2589,7 @@ static void vm_unlock_anon_vma(struct an
 		if (!__test_and_clear_bit(0, (unsigned long *)
 					  &anon_vma->head.next))
 			BUG();
-		spin_unlock(&anon_vma->lock);
+		anon_vma_unlock(anon_vma);
 	}
 }
 
diff -puN mm/rmap.c~mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function mm/rmap.c
--- a/mm/rmap.c~mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function
+++ a/mm/rmap.c
@@ -134,7 +134,7 @@ int anon_vma_prepare(struct vm_area_stru
 			allocated = anon_vma;
 		}
 
-		spin_lock(&anon_vma->lock);
+		anon_vma_lock(anon_vma);
 		/* page_table_lock to protect against threads */
 		spin_lock(&mm->page_table_lock);
 		if (likely(!vma->anon_vma)) {
@@ -147,7 +147,7 @@ int anon_vma_prepare(struct vm_area_stru
 			avc = NULL;
 		}
 		spin_unlock(&mm->page_table_lock);
-		spin_unlock(&anon_vma->lock);
+		anon_vma_unlock(anon_vma);
 
 		if (unlikely(allocated))
 			anon_vma_free(allocated);
@@ -170,9 +170,9 @@ static void anon_vma_chain_link(struct v
 	avc->anon_vma = anon_vma;
 	list_add(&avc->same_vma, &vma->anon_vma_chain);
 
-	spin_lock(&anon_vma->lock);
+	anon_vma_lock(anon_vma);
 	list_add_tail(&avc->same_anon_vma, &anon_vma->head);
-	spin_unlock(&anon_vma->lock);
+	anon_vma_unlock(anon_vma);
 }
 
 /*
@@ -246,12 +246,12 @@ static void anon_vma_unlink(struct anon_
 	if (!anon_vma)
 		return;
 
-	spin_lock(&anon_vma->lock);
+	anon_vma_lock(anon_vma);
 	list_del(&anon_vma_chain->same_anon_vma);
 
 	/* We must garbage collect the anon_vma if it's empty */
 	empty = list_empty(&anon_vma->head) && !anonvma_external_refcount(anon_vma);
-	spin_unlock(&anon_vma->lock);
+	anon_vma_unlock(anon_vma);
 
 	if (empty)
 		anon_vma_free(anon_vma);
@@ -303,10 +303,10 @@ again:
 		goto out;
 
 	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
-	spin_lock(&anon_vma->lock);
+	anon_vma_lock(anon_vma);
 
 	if (page_rmapping(page) != anon_vma) {
-		spin_unlock(&anon_vma->lock);
+		anon_vma_unlock(anon_vma);
 		goto again;
 	}
 
@@ -318,7 +318,7 @@ out:
 
 void page_unlock_anon_vma(struct anon_vma *anon_vma)
 {
-	spin_unlock(&anon_vma->lock);
+	anon_vma_unlock(anon_vma);
 	rcu_read_unlock();
 }
 
@@ -1396,7 +1396,7 @@ static int rmap_walk_anon(struct page *p
 	anon_vma = page_anon_vma(page);
 	if (!anon_vma)
 		return ret;
-	spin_lock(&anon_vma->lock);
+	anon_vma_lock(anon_vma);
 	list_for_each_entry(avc, &anon_vma->head, same_anon_vma) {
 		struct vm_area_struct *vma = avc->vma;
 		unsigned long address = vma_address(page, vma);
@@ -1406,7 +1406,7 @@ static int rmap_walk_anon(struct page *p
 		if (ret != SWAP_AGAIN)
 			break;
 	}
-	spin_unlock(&anon_vma->lock);
+	anon_vma_unlock(anon_vma);
 	return ret;
 }
 
_

Patches currently in -mm which might be from riel@redhat.com are

mm-revalidate-anon_vma-in-page_lock_anon_vma.patch
mm-rename-anon_vma_lock-to-vma_lock_anon_vma.patch
mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function.patch
mm-track-the-root-oldest-anon_vma.patch
mm-track-the-root-oldest-anon_vma-fix.patch
mm-always-lock-the-root-oldest-anon_vma.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root.patch

