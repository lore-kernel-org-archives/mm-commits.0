From: akpm@linux-foundation.org
Subject: + mm-track-the-root-oldest-anon_vma.patch added to -mm tree
Date: Tue, 01 Jun 2010 15:10:23 -0700
Message-ID: <201006012210.o51MANQn021802@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50205 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753718Ab0FAWK7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jun 2010 18:10:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, lwoodman@redhat.com, mel@csn.ul.ie, minchan.kim@gmail.com, torvalds@linux-foundation.org


The patch titled
     mm: track the root (oldest) anon_vma
has been added to the -mm tree.  Its filename is
     mm-track-the-root-oldest-anon_vma.patch

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
Subject: mm: track the root (oldest) anon_vma
From: Rik van Riel <riel@redhat.com>

Track the root (oldest) anon_vma in each anon_vma tree.  Because we only
take the lock on the root anon_vma, we cannot use the lock on higher-up
anon_vmas to lock anything.  This makes it impossible to do an indirect
lookup of the root anon_vma, since the data structures could go away from
under us.

However, a direct pointer is safe because the root anon_vma is always the
last one that gets freed on munmap or exit, by virtue of the same_vma list
order and unlink_anon_vmas walking the list forward.

Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Tested-by: Larry Woodman <lwoodman@redhat.com>
Acked-by: Larry Woodman <lwoodman@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    1 +
 mm/rmap.c            |   18 ++++++++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff -puN include/linux/rmap.h~mm-track-the-root-oldest-anon_vma include/linux/rmap.h
--- a/include/linux/rmap.h~mm-track-the-root-oldest-anon_vma
+++ a/include/linux/rmap.h
@@ -26,6 +26,7 @@
  */
 struct anon_vma {
 	spinlock_t lock;	/* Serialize access to vma list */
+	struct anon_vma *root;	/* Root of this anon_vma tree */
 #if defined(CONFIG_KSM) || defined(CONFIG_MIGRATION)
 
 	/*
diff -puN mm/rmap.c~mm-track-the-root-oldest-anon_vma mm/rmap.c
--- a/mm/rmap.c~mm-track-the-root-oldest-anon_vma
+++ a/mm/rmap.c
@@ -132,6 +132,11 @@ int anon_vma_prepare(struct vm_area_stru
 			if (unlikely(!anon_vma))
 				goto out_enomem_free_avc;
 			allocated = anon_vma;
+			/*
+			 * This VMA had no anon_vma yet.  This anon_vma is
+			 * the root of any anon_vma tree that might form.
+			 */
+			anon_vma->root = anon_vma;
 		}
 
 		anon_vma_lock(anon_vma);
@@ -224,9 +229,15 @@ int anon_vma_fork(struct vm_area_struct 
 	avc = anon_vma_chain_alloc();
 	if (!avc)
 		goto out_error_free_anon_vma;
-	anon_vma_chain_link(vma, avc, anon_vma);
+
+	/*
+	 * The root anon_vm's spinlock is the lock actually used when we
+	 * lock any of the anon_vmas in this anon_vma tree.
+	 */
+	anon_vma->root = pvma->anon_vma->root;
 	/* Mark this anon_vma as the one where our new (COWed) pages go. */
 	vma->anon_vma = anon_vma;
+	anon_vma_chain_link(vma, avc, anon_vma);
 
 	return 0;
 
@@ -261,7 +272,10 @@ void unlink_anon_vmas(struct vm_area_str
 {
 	struct anon_vma_chain *avc, *next;
 
-	/* Unlink each anon_vma chained to the VMA. */
+	/*
+	 * Unlink each anon_vma chained to the VMA.  This list is ordered
+	 * from newest to oldest, ensuring the root anon_vma gets freed last.
+	 */
 	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
 		anon_vma_unlink(avc);
 		list_del(&avc->same_vma);
_

Patches currently in -mm which might be from riel@redhat.com are

mm-revalidate-anon_vma-in-page_lock_anon_vma.patch
mm-rename-anon_vma_lock-to-vma_lock_anon_vma.patch
mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function.patch
mm-track-the-root-oldest-anon_vma.patch
mm-track-the-root-oldest-anon_vma-fix.patch
mm-always-lock-the-root-oldest-anon_vma.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root.patch

