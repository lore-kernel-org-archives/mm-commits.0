Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0E416D4E4
	for <mm-commits@vger.kernel.org>; Tue, 18 Jun 2024 21:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718744930; cv=none; b=aLVo2oVB4O4AUpDYS2Wa8KsikcR2JWMbhWNNMkMez3/NCzburR5N4p5F18tviAb4XjS+Wgn4jOmOBwpbseqhegLGC8KRcCt9bdWzNkAFzUeaZ0a7pa35hTk0zDdWYpyNncooVoJbdNyILoMr85rO3xZ/3eFz9GT05BngambW/qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718744930; c=relaxed/simple;
	bh=2qzLjd2Ysj8CiGFyqHc0KSpeuOq8eSwSgSJFUia1QeY=;
	h=Date:To:From:Subject:Message-Id; b=TmWMRLqe0BuLEBFUyMvohZHAcwZE2u4gtmYyx0alM2HPeABFty704gqSws/AUOOXbd8A1CP2x/l6pZP1kOPwmVgJRjgpP1EYrpNKDop0p2ySW+2KhN9zL35L3az+IJpUnKYKESfRDTzbWGCcRN3oKDuuI9mU0Mzr78BfXfSFY60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ll7Y5B3b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ll7Y5B3b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B640CC3277B;
	Tue, 18 Jun 2024 21:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718744929;
	bh=2qzLjd2Ysj8CiGFyqHc0KSpeuOq8eSwSgSJFUia1QeY=;
	h=Date:To:From:Subject:From;
	b=ll7Y5B3b1WrO61tbMtGL9Tpiiqisv3wZ8kCuofhxVyPS9BNBPQz5t+t5QagW8MswH
	 CPs6ftWyrJoJWufYvxb9lOSpfX1RzFTexeTpYfcM5+jAuXYnRnMCxJ5pEwtcjUv0wV
	 T4YQid93ckC7gzcxy+WDyaNEyj5ClzicVxmiSjes=
Date: Tue, 18 Jun 2024 14:08:49 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanshuai@oppo.com,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,surenb@google.com,shy828301@gmail.com,ryan.roberts@arm.com,mhocko@suse.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false.patch added to mm-unstable branch
Message-Id: <20240618210849.B640CC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use folio_add_new_anon_rmap() if folio_test_anon(folio)==false
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

Link: https://lkml.kernel.org/r/20240617231137.80726-3-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
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

 mm/memory.c   |    8 ++++++++
 mm/swapfile.c |   13 +++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false
+++ a/mm/memory.c
@@ -4339,6 +4339,14 @@ check_folio:
 	if (unlikely(folio != swapcache && swapcache)) {
 		folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
 		folio_add_lru_vma(folio, vma);
+	} else if (!folio_test_anon(folio)) {
+		/*
+		 * We currently only expect small !anon folios, for which we now
+		 * that they are either fully exclusive or fully shared. If we
+		 * ever get large folios here, we have to be careful.
+		 */
+		VM_WARN_ON_ONCE(folio_test_large(folio));
+		folio_add_new_anon_rmap(folio, vma, address, rmap_flags);
 	} else {
 		folio_add_anon_rmap_ptes(folio, page, nr_pages, vma, address,
 					rmap_flags);
--- a/mm/swapfile.c~mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false
+++ a/mm/swapfile.c
@@ -1916,8 +1916,17 @@ static int unuse_pte(struct vm_area_stru
 		VM_BUG_ON_FOLIO(folio_test_writeback(folio), folio);
 		if (pte_swp_exclusive(old_pte))
 			rmap_flags |= RMAP_EXCLUSIVE;
-
-		folio_add_anon_rmap_pte(folio, page, vma, addr, rmap_flags);
+		/*
+		 * We currently only expect small !anon folios, for which we now that
+		 * they are either fully exclusive or fully shared. If we ever get
+		 * large folios here, we have to be careful.
+		 */
+		if (!folio_test_anon(folio)) {
+			VM_WARN_ON_ONCE(folio_test_large(folio));
+			folio_add_new_anon_rmap(folio, vma, addr, rmap_flags);
+		} else {
+			folio_add_anon_rmap_pte(folio, page, vma, addr, rmap_flags);
+		}
 	} else { /* ksm created a completely new copy */
 		folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
 		folio_add_lru_vma(folio, vma);
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

cifs-drop-the-incorrect-assertion-in-cifs_swap_rw.patch
mm-remove-the-implementation-of-swap_free-and-always-use-swap_free_nr.patch
mm-introduce-pte_move_swp_offset-helper-which-can-move-offset-bidirectionally.patch
mm-introduce-arch_do_swap_page_nr-which-allows-restore-metadata-for-nr-pages.patch
mm-swap-reuse-exclusive-folio-directly-instead-of-wp-page-faults.patch
mm-introduce-pmdpte_needs_soft_dirty_wp-helpers-for-softdirty-write-protect.patch
mm-set-pte-writable-while-pte_soft_dirty-is-true-in-do_swap_page.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false.patch
mm-remove-folio_test_anonfolio==false-path-in-__folio_add_anon_rmap.patch

