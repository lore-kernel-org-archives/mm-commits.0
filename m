From: akpm@linux-foundation.org
Subject: + rmap-anon_vma_prepare-reduce-code-duplication-by-calling-anon_vma_chain_link.patch added to -mm tree
Date: Fri, 17 Feb 2012 12:55:08 -0800
Message-ID: <20120217205509.78063A01CB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:62427 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab2BQUzM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 17 Feb 2012 15:55:12 -0500
Received: by yhgm50 with SMTP id m50so488743yhg.1
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2012 12:55:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: consul.kautuk@gmail.com, a.p.zijlstra@chello.nl, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de


The patch titled
     Subject: rmap: anon_vma_prepare: Reduce code duplication by calling anon_vma_chain_link
has been added to the -mm tree.  Its filename is
     rmap-anon_vma_prepare-reduce-code-duplication-by-calling-anon_vma_chain_link.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kautuk Consul <consul.kautuk@gmail.com>
Subject: rmap: anon_vma_prepare: Reduce code duplication by calling anon_vma_chain_link

Reduce code duplication by calling anon_vma_chain_link() from
anon_vma_prepare().

Also move anon_vmal_chain_link() to a more suitable location in the file.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hugh Dickins <hughd@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
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
