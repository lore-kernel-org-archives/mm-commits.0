From: akpm@linux-foundation.org
Subject: + mm-dont-expose-page-to-fast-gup-before-its-ready.patch added to -mm tree
Date: Mon, 08 Jan 2018 16:19:04 -0800
Message-ID: <5a540a78.nFilW7RD6glDOLbP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42354 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751398AbeAIATG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jan 2018 19:19:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yuzhao@google.com, hannes@cmpxchg.org, jack@suse.cz, minchan@kernel.org, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't expose page to fast gup before it's ready
has been added to the -mm tree.  Its filename is
     mm-dont-expose-page-to-fast-gup-before-its-ready.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dont-expose-page-to-fast-gup-before-its-ready.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-expose-page-to-fast-gup-before-its-ready.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm: don't expose page to fast gup before it's ready

We don't want to expose page before it's properly setup.  During page
setup, we may call page_add_new_anon_rmap() which uses non- atomic bit op.
If page is exposed before it's done, we could overwrite page flags that
are set by get_user_pages_fast() or its callers.  Here is a non-fatal
scenario (there might be other fatal problems that I didn't look into):

	CPU 1				CPU1
set_pte_at()			get_user_pages_fast()
page_add_new_anon_rmap()		gup_pte_range()
	__SetPageSwapBacked()			SetPageReferenced()

Fix the problem by delaying set_pte_at() until page is ready.

Link: http://lkml.kernel.org/r/20180108225632.16332-1-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c   |    2 +-
 mm/swapfile.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/memory.c~mm-dont-expose-page-to-fast-gup-before-its-ready mm/memory.c
--- a/mm/memory.c~mm-dont-expose-page-to-fast-gup-before-its-ready
+++ a/mm/memory.c
@@ -3042,7 +3042,6 @@ int do_swap_page(struct vm_fault *vmf)
 	flush_icache_page(vma, page);
 	if (pte_swp_soft_dirty(vmf->orig_pte))
 		pte = pte_mksoft_dirty(pte);
-	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, pte);
 	vmf->orig_pte = pte;
 
 	/* ksm created a completely new copy */
@@ -3055,6 +3054,7 @@ int do_swap_page(struct vm_fault *vmf)
 		mem_cgroup_commit_charge(page, memcg, true, false);
 		activate_page(page);
 	}
+	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, pte);
 
 	swap_free(entry);
 	if (mem_cgroup_swap_full(page) ||
diff -puN mm/swapfile.c~mm-dont-expose-page-to-fast-gup-before-its-ready mm/swapfile.c
--- a/mm/swapfile.c~mm-dont-expose-page-to-fast-gup-before-its-ready
+++ a/mm/swapfile.c
@@ -1800,8 +1800,6 @@ static int unuse_pte(struct vm_area_stru
 	dec_mm_counter(vma->vm_mm, MM_SWAPENTS);
 	inc_mm_counter(vma->vm_mm, MM_ANONPAGES);
 	get_page(page);
-	set_pte_at(vma->vm_mm, addr, pte,
-		   pte_mkold(mk_pte(page, vma->vm_page_prot)));
 	if (page == swapcache) {
 		page_add_anon_rmap(page, vma, addr, false);
 		mem_cgroup_commit_charge(page, memcg, true, false);
@@ -1810,6 +1808,8 @@ static int unuse_pte(struct vm_area_stru
 		mem_cgroup_commit_charge(page, memcg, false, false);
 		lru_cache_add_active_or_unevictable(page, vma);
 	}
+	set_pte_at(vma->vm_mm, addr, pte,
+		   pte_mkold(mk_pte(page, vma->vm_page_prot)));
 	swap_free(entry);
 	/*
 	 * Move the page to the active list so it is not
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-dont-expose-page-to-fast-gup-before-its-ready.patch

