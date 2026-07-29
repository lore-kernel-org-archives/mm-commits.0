Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23FB14ABE
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 03:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785297182; cv=none; b=o2gRwa1eA8h3166gcSRX1o+YHemqyrIJ1j5JN+vZv0NfyTjRNFi1YDEKA+9ciJE1InfPWyutNFTherHKFjtGUCeebGyeqFoa5rELOvWemVdyR7ItmJmEivXaUGsnC3A6zeH/DhOLnWcSCbPgFcFBifuB6tTYTmxr2Kk237WME0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785297182; c=relaxed/simple;
	bh=3QhtsZJdQishSF04U6lwWtI5VgsFcUHqSDhrxK4k4xY=;
	h=Date:To:From:Subject:Message-Id; b=nw1VSv5kAqSwk9LLcE8bUjmoH9HY0EcdyKMoKHGV66FyI1t2eq1i1Tq20iI6x9us5a601sgfkFsPptImfiuu5ZoSA/P8g5UiKXK+IobUNAgeW4LEIdlql0qaJtlYdEh5d7tDnI9whPHKBFzGtconHHGkyZS8DyyY7cBNP6ApPhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jaGCKzxZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jaGCKzxZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AAAE1F000E9;
	Wed, 29 Jul 2026 03:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785297180;
	bh=EICF1suDyg3EwmKuTj6ZupwotEs7vPK7FE3Rw0XRx9k=;
	h=Date:To:From:Subject;
	b=jaGCKzxZABbM5u9U9TaZ5Hpono5TKK59yBp9g1amoYpRYRqaB7yIAUKeIu51zo7Np
	 Dn1VTeP5rjStLPslVBEg5ih7q888+CJoMgx3+CuMiVaGjn/GSEta3lufAv8EmYSi4Q
	 7Do+fTvqjROmThOpO6TQ4ocyDdKnNyFImF6XUoZk=
Date: Tue, 28 Jul 2026 20:53:00 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,wangxuewen@kylinos.cn,vbabka@kernel.org,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,pfalcato@suse.de,nphamcs@gmail.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,jannh@google.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,axelrasmussen@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-annotate-data-race-in-cpu_needs_drain-fix.patch removed from -mm tree
Message-Id: <20260729035300.8AAAE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-annotate-data-race-in-cpu_needs_drain-fix
has been removed from the -mm tree.  Its filename was
     mm-annotate-data-race-in-cpu_needs_drain-fix.patch

This patch was dropped because it was folded into mm-annotate-data-race-in-cpu_needs_drain.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-annotate-data-race-in-cpu_needs_drain-fix
Date: Mon Jun 29 09:26:20 AM PDT 2026

reindent cpu_needs_drain, per David & Lorenzo

Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Xuewen Wang <wangxuewen@kylinos.cn>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/swap.c~mm-annotate-data-race-in-cpu_needs_drain-fix
+++ a/mm/swap.c
@@ -832,12 +832,12 @@ static bool cpu_needs_drain(unsigned int
 
 	/* Check these in order of likelihood that they're not zero */
 	return data_race(folio_batch_count(&fbatches->lru_add) ||
-		folio_batch_count(&fbatches->lru_move_tail) ||
-		folio_batch_count(&fbatches->lru_deactivate_file) ||
-		folio_batch_count(&fbatches->lru_deactivate) ||
-		folio_batch_count(&fbatches->lru_lazyfree) ||
-		folio_batch_count(&fbatches->lru_activate) ||
-		need_mlock_drain(cpu)) ||
+			 folio_batch_count(&fbatches->lru_move_tail) ||
+			 folio_batch_count(&fbatches->lru_deactivate_file) ||
+			 folio_batch_count(&fbatches->lru_deactivate) ||
+			 folio_batch_count(&fbatches->lru_lazyfree) ||
+			 folio_batch_count(&fbatches->lru_activate) ||
+			 need_mlock_drain(cpu)) ||
 		has_bh_in_lru(cpu, NULL);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

csky-implement-flush_cache_vmap-in-c.patch
mm-annotate-data-race-in-cpu_needs_drain.patch
mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-fix.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one-checkpatch-fixes.patch
mm-mprotect-use-huge_ptep_get-for-hugetlb-fix.patch
mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix.patch
alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
mm-hmm-make-config_hmm_mirror-select-config_mmu_notifier.patch
mm-vma-add-and-use-vma__pgoff-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

