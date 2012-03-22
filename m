From: akpm@linux-foundation.org
Subject: [merged] rmap-anon_vma_prepare-reduce-code-duplication-by-calling-anon_vma_chain_link.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:18:16 -0700
Message-ID: <20120322201816.80D39A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:41983 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758859Ab2CVUSR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:18:17 -0400
Received: by qabg24 with SMTP id g24so62189qab.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:18:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: consul.kautuk@gmail.com, a.p.zijlstra@chello.nl, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rmap: anon_vma_prepare: Reduce code duplication by calling anon_vma_chain_link
has been removed from the -mm tree.  Its filename was
     rmap-anon_vma_prepare-reduce-code-duplication-by-calling-anon_vma_chain_link.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Kautuk Consul <consul.kautuk@gmail.com>
Subject: rmap: anon_vma_prepare: Reduce code duplication by calling anon_vma_chain_link

Reduce code duplication by calling anon_vma_chain_link() from
anon_vma_prepare().

Also move anon_vmal_chain_link() to a more suitable location in the file.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hugh Dickins <hughd@google.com>
Reviewed-by: KAMEZWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff -puN mm/rmap.c~rmap-anon_vma_prepare-reduce-code-duplication-by-calling-anon_vma_chain_link mm/rmap.c
--- a/mm/rmap.c~rmap-anon_vma_prepare-reduce-code-duplication-by-calling-anon_vma_chain_link
+++ a/mm/rmap.c
@@ -120,6 +120,21 @@ static void anon_vma_chain_free(struct a
 	kmem_cache_free(anon_vma_chain_cachep, anon_vma_chain);
 }
 
+static void anon_vma_chain_link(struct vm_area_struct *vma,
+				struct anon_vma_chain *avc,
+				struct anon_vma *anon_vma)
+{
+	avc->vma = vma;
+	avc->anon_vma = anon_vma;
+	list_add(&avc->same_vma, &vma->anon_vma_chain);
+
+	/*
+	 * It's critical to add new vmas to the tail of the anon_vma,
+	 * see comment in huge_memory.c:__split_huge_page().
+	 */
+	list_add_tail(&avc->same_anon_vma, &anon_vma->head);
+}
+
 /**
  * anon_vma_prepare - attach an anon_vma to a memory region
  * @vma: the memory region in question
@@ -175,10 +190,7 @@ int anon_vma_prepare(struct vm_area_stru
 		spin_lock(&mm->page_table_lock);
 		if (likely(!vma->anon_vma)) {
 			vma->anon_vma = anon_vma;
-			avc->anon_vma = anon_vma;
-			avc->vma = vma;
-			list_add(&avc->same_vma, &vma->anon_vma_chain);
-			list_add_tail(&avc->same_anon_vma, &anon_vma->head);
+			anon_vma_chain_link(vma, avc, anon_vma);
 			allocated = NULL;
 			avc = NULL;
 		}
@@ -224,21 +236,6 @@ static inline void unlock_anon_vma_root(
 		mutex_unlock(&root->mutex);
 }
 
-static void anon_vma_chain_link(struct vm_area_struct *vma,
-				struct anon_vma_chain *avc,
-				struct anon_vma *anon_vma)
-{
-	avc->vma = vma;
-	avc->anon_vma = anon_vma;
-	list_add(&avc->same_vma, &vma->anon_vma_chain);
-
-	/*
-	 * It's critical to add new vmas to the tail of the anon_vma,
-	 * see comment in huge_memory.c:__split_huge_page().
-	 */
-	list_add_tail(&avc->same_anon_vma, &anon_vma->head);
-}
