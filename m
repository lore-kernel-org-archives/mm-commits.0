Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7FA1EF38E
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450038; cv=none; b=YyblhanJpo9LxlKQPcc8X8GuvtIGozaHMOMBRvmFs/k+iXC06+naMsXbiYrvgX9G+ETTjq3zZGV7PDIjFMWFb4mU1HsnqC/Ne74QtEGHmrOgxgoqpq/v/wiA3nLE+sibjiPoNfRFY72TPshKOIhnn6Zeb1JCnmZRccFLtnNcp+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450038; c=relaxed/simple;
	bh=u+g19/0kRRU2DS/9xQ2ehY7Qrgck+plCA1Aa0GGna0Q=;
	h=Date:To:From:Subject:Message-Id; b=s5YhMUvwH565rLBMv2VEdgwYmkXkilrOE1r14gD9Fy6vPUrdhNA4Z17kfdSaXsgLQeB4qKq4ru7rmFvPbOiHAhOjwFvT9UngB7/kHAJ5LJOaGD7tfMxyqIYxLB/p+veiHlO8AzGw9OaTDxk/5oaHMp1IVzSJ8MOC5k7vM4HfPUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tIELK20Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tIELK20Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216D8C4CEE3;
	Sun, 13 Jul 2025 23:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450038;
	bh=u+g19/0kRRU2DS/9xQ2ehY7Qrgck+plCA1Aa0GGna0Q=;
	h=Date:To:From:Subject:From;
	b=tIELK20Y0dCIL0aidG/dzpWUMU3dOlOkhMQevHjhv+FVvatLyQygwMvRDeDi/H8i/
	 jKrBDWtwsdyk/KkU+pa8XXdVMbz/a/iokc8Lc+2ZSA29NTUKjx6aC/OqGgO9gJREm6
	 hvCL+YAUUSoNRJFmkc4SW2/Rbgv6MrPIOXpvk1lk=
Date: Sun, 13 Jul 2025 16:40:37 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,muchun.song@linux.dev,gavinguo@igalia.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmhugetlb-sort-out-folio-locking-in-the-faulting-path.patch removed from -mm tree
Message-Id: <20250713234038.216D8C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm,hugetlb: sort out folio locking in the faulting path
has been removed from the -mm tree.  Its filename was
     mmhugetlb-sort-out-folio-locking-in-the-faulting-path.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hugetlb: sort out folio locking in the faulting path
Date: Mon, 30 Jun 2025 16:42:09 +0200

Recent conversations showed that there was a misunderstanding about why we
were locking the folio prior to call in hugetlb_wp().  In fact, as soon as
we have the folio mapped into the pagetables, we no longer need to hold it
locked, because we know that no concurrent truncation could have happened.

There is only one case where the folio needs to be locked, and that is
when we are handling an anonymous folio, because hugetlb_wp() will check
whether it can re-use it exclusively for the process that is faulting it
in.

So, pass the folio locked to hugetlb_wp() when that is the case.

Link: https://lkml.kernel.org/r/20250627102904.107202-3-osalvador@suse.de
Link: https://lkml.kernel.org/r/20250630144212.156938-3-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Gavin Guo <gavinguo@igalia.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mmhugetlb-sort-out-folio-locking-in-the-faulting-path
+++ a/mm/hugetlb.c
@@ -6416,6 +6416,7 @@ static vm_fault_t hugetlb_no_page(struct
 	pte_t new_pte;
 	bool new_folio, new_pagecache_folio = false;
 	u32 hash = hugetlb_fault_mutex_hash(mapping, vmf->pgoff);
+	bool folio_locked = true;
 
 	/*
 	 * Currently, we are forced to kill the process in the event the
@@ -6581,6 +6582,14 @@ static vm_fault_t hugetlb_no_page(struct
 
 	hugetlb_count_add(pages_per_huge_page(h), mm);
 	if ((vmf->flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED)) {
+		/*
+		 * No need to keep file folios locked. See comment in
+		 * hugetlb_fault().
+		 */
+		if (!anon_rmap) {
+			folio_locked = false;
+			folio_unlock(folio);
+		}
 		/* Optimization, do the COW without a second fault */
 		ret = hugetlb_wp(vmf);
 	}
@@ -6595,7 +6604,8 @@ static vm_fault_t hugetlb_no_page(struct
 	if (new_folio)
 		folio_set_hugetlb_migratable(folio);
 
-	folio_unlock(folio);
+	if (folio_locked)
+		folio_unlock(folio);
 out:
 	hugetlb_vma_unlock_read(vma);
 
@@ -6783,15 +6793,20 @@ vm_fault_t hugetlb_fault(struct mm_struc
 
 	if (flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)) {
 		if (!huge_pte_write(vmf.orig_pte)) {
-			/* hugetlb_wp() requires page locks of pte_page(vmf.orig_pte) */
+			/*
+			 * Anonymous folios need to be lock since hugetlb_wp()
+			 * checks whether we can re-use the folio exclusively
+			 * for us in case we are the only user of it.
+			 */
 			folio = page_folio(pte_page(vmf.orig_pte));
-			if (!folio_trylock(folio)) {
+			if (folio_test_anon(folio) && !folio_trylock(folio)) {
 				need_wait_lock = true;
 				goto out_ptl;
 			}
 			folio_get(folio);
 			ret = hugetlb_wp(&vmf);
-			folio_unlock(folio);
+			if (folio_test_anon(folio))
+				folio_unlock(folio);
 			folio_put(folio);
 			goto out_ptl;
 		} else if (likely(flags & FAULT_FLAG_WRITE)) {
_

Patches currently in -mm which might be from osalvador@suse.de are


