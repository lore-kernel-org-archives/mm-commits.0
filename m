Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB67E28E3
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628215; cv=none; b=HMtZTUkqCsX8wNdvpgoWWFwxncZ0zGv9KIjh+yGgMvKgOq22BdbpiJwL1byer4Bq3c0tJFW/j8uDODPI2NcbmjeCY2rcmFAJ6aeuIx8PkwfakyYPW2VHA+v9rG4kC3Ip+JEjBDHMyAQnjz989CufocCmMBpA8vf6Iko7NcMa9zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628215; c=relaxed/simple;
	bh=TUlUPUuCf7SX8TuzKbSHimEr9Woy4WdWQ7md+1kUdSA=;
	h=Date:To:From:Subject:Message-Id; b=gBc/uO8Go8U0hfWVEndOku7R9qxKUo0e6DJ+zaEZsVTv+Yd8QGhpUiWZWGA5be/hEwB9i0bqsQB/iQkBd6iGdvWHyteVKUanT0q0VMJIs0xtzGBvIQ5LBoOUbbt7I5IhoHt/zwvnDYHvIB3gnJzl+rKNMTaoccqIlSQyR9DhUiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oYK3eYCC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oYK3eYCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46123C116B1;
	Sat, 29 Jun 2024 02:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628215;
	bh=TUlUPUuCf7SX8TuzKbSHimEr9Woy4WdWQ7md+1kUdSA=;
	h=Date:To:From:Subject:From;
	b=oYK3eYCCSqBB6Hn7gi2xI+vw0t7Zlc4xzs+uamiSwxIn3IdFvcBexmDkHqUoyEnTx
	 7KkyqMQ3IfqnSlspskwUbKmWl+7vvKpY1KBKdDjGolj3XtwOBgj/N7oTAz2AHXsOun
	 /EQSNUuYRPt5NGsswVexHIu5Q7preAOTeOID5av8=
Date: Fri, 28 Jun 2024 19:30:14 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanshuai@oppo.com,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,surenb@google.com,shy828301@gmail.com,ryan.roberts@arm.com,mhocko@suse.com,hughd@google.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false.patch removed from -mm tree
Message-Id: <20240629023015.46123C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use folio_add_new_anon_rmap() if folio_test_anon(folio)==false
has been removed from the -mm tree.  Its filename was
     mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: use folio_add_new_anon_rmap() if folio_test_anon(folio)==false
Date: Tue, 18 Jun 2024 11:11:36 +1200

For the !folio_test_anon(folio) case, we can now invoke
folio_add_new_anon_rmap() with the rmap flags set to either EXCLUSIVE or
non-EXCLUSIVE.  This action will suppress the VM_WARN_ON_FOLIO check
within __folio_add_anon_rmap() while initiating the process of bringing up
mTHP swapin.

 static __always_inline void __folio_add_anon_rmap(struct folio *folio,
                 struct page *page, int nr_pages, struct vm_area_struct *vma,
                 unsigned long address, rmap_t flags, enum rmap_level level)
 {
         ...
         if (unlikely(!folio_test_anon(folio))) {
                 VM_WARN_ON_FOLIO(folio_test_large(folio) &&
                                  level != RMAP_LEVEL_PMD, folio);
         }
         ...
 }

It also improves the code's readability.  Currently, all new anonymous
folios calling folio_add_anon_rmap_ptes() are order-0.  This ensures that
new folios cannot be partially exclusive; they are either entirely
exclusive or entirely shared.

A useful comment from Hugh's fix:

: Commit "mm: use folio_add_new_anon_rmap() if folio_test_anon(folio)==
: false" has extended folio_add_new_anon_rmap() to use on non-exclusive
: folios, already visible to others in swap cache and on LRU.
: 
: That renders its non-atomic __folio_set_swapbacked() unsafe: it risks
: overwriting concurrent atomic operations on folio->flags, losing bits
: added or restoring bits cleared.  Since it's only used in this risky way
: when folio_test_locked and !folio_test_anon, many such races are excluded;
: but, for example, isolations by folio_test_clear_lru() are vulnerable, and
: setting or clearing active.
: 
: It could just use the atomic folio_set_swapbacked(); but this function
: does try to avoid atomics where it can, so use a branch instead: just
: avoid setting swapbacked when it is already set, that is good enough. 
: (Swapbacked is normally stable once set: lazyfree can undo it, but only
: later, when found anon in a page table.)
: 
: This fixes a lot of instability under compaction and swapping loads:
: assorted "Bad page"s, VM_BUG_ON_FOLIO()s, apparently even page double
: frees - though I've not worked out what races could lead to the latter.

[akpm@linux-foundation.org: comment fixes, per David and akpm]
[v-songbaohua@oppo.com: lock the folio to avoid race]
  Link: https://lkml.kernel.org/r/20240622032002.53033-1-21cnbao@gmail.com
[hughd@google.com: folio_add_new_anon_rmap() careful __folio_set_swapbacked()]
  Link: https://lkml.kernel.org/r/f3599b1d-8323-0dc5-e9e0-fdb3cfc3dd5a@google.com
Link: https://lkml.kernel.org/r/20240617231137.80726-3-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Tested-by: Shuai Yuan <yuanshuai@oppo.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c   |    9 +++++++++
 mm/rmap.c     |    4 +++-
 mm/swapfile.c |   14 ++++++++++++--
 3 files changed, 24 insertions(+), 3 deletions(-)

--- a/mm/memory.c~mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false
+++ a/mm/memory.c
@@ -4341,6 +4341,15 @@ check_folio:
 	if (unlikely(folio != swapcache && swapcache)) {
 		folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
 		folio_add_lru_vma(folio, vma);
+	} else if (!folio_test_anon(folio)) {
+		/*
+		 * We currently only expect small !anon folios, which are either
+		 * fully exclusive or fully shared. If we ever get large folios
+		 * here, we have to be careful.
+		 */
+		VM_WARN_ON_ONCE(folio_test_large(folio));
+		VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
+		folio_add_new_anon_rmap(folio, vma, address, rmap_flags);
 	} else {
 		folio_add_anon_rmap_ptes(folio, page, nr_pages, vma, address,
 					rmap_flags);
--- a/mm/rmap.c~mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false
+++ a/mm/rmap.c
@@ -1422,7 +1422,9 @@ void folio_add_new_anon_rmap(struct foli
 	VM_WARN_ON_FOLIO(!exclusive && !folio_test_locked(folio), folio);
 	VM_BUG_ON_VMA(address < vma->vm_start ||
 			address + (nr << PAGE_SHIFT) > vma->vm_end, vma);
-	__folio_set_swapbacked(folio);
+
+	if (!folio_test_swapbacked(folio))
+		__folio_set_swapbacked(folio);
 	__folio_set_anon(folio, vma, address, exclusive);
 
 	if (likely(!folio_test_large(folio))) {
--- a/mm/swapfile.c~mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false
+++ a/mm/swapfile.c
@@ -1908,8 +1908,18 @@ static int unuse_pte(struct vm_area_stru
 		VM_BUG_ON_FOLIO(folio_test_writeback(folio), folio);
 		if (pte_swp_exclusive(old_pte))
 			rmap_flags |= RMAP_EXCLUSIVE;
-
-		folio_add_anon_rmap_pte(folio, page, vma, addr, rmap_flags);
+		/*
+		 * We currently only expect small !anon folios, which are either
+		 * fully exclusive or fully shared. If we ever get large folios
+		 * here, we have to be careful.
+		 */
+		if (!folio_test_anon(folio)) {
+			VM_WARN_ON_ONCE(folio_test_large(folio));
+			VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
+			folio_add_new_anon_rmap(folio, vma, addr, rmap_flags);
+		} else {
+			folio_add_anon_rmap_pte(folio, page, vma, addr, rmap_flags);
+		}
 	} else { /* ksm created a completely new copy */
 		folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
 		folio_add_lru_vma(folio, vma);
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout.patch

