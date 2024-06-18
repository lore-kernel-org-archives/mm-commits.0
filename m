Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D9516D4E4
	for <mm-commits@vger.kernel.org>; Tue, 18 Jun 2024 21:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718744934; cv=none; b=tWUB07+q69FPSohV6YTk8o+bntKHnurWEOs9Ux4cU/0o3p6MAcBdsaShoPRiNmHHKfucF6OT5pGNZ/pg+lOpLrH9WfwYiVaDLxfYmHsfXZVqssLOamVFfj2IyXspmyAhdj0WxsliJ3M0qnf+SpcNaj3CIPANtbPH/CDOcvS6Eek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718744934; c=relaxed/simple;
	bh=t81lf3/GZGUnRHsUnykahnarELr9wbXYd5wZzhZNRLA=;
	h=Date:To:From:Subject:Message-Id; b=Beau0vhqSVALBSVFcdtMpmF5jMepgcL68FnkjLd1PyJ/WZrnnGFguYt95/bY1NSnYYZ+uN1dEU8Wl2BD+CU7Y1hMUzXLT0QEO11HGpJogys9Z+ahIGzGvvHa1XiXhhFU4ObjLG5aoegtts/nLA46x+I6ebhTHFEZU6Txfb/5DR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H33DeknT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H33DeknT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D732C3277B;
	Tue, 18 Jun 2024 21:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718744934;
	bh=t81lf3/GZGUnRHsUnykahnarELr9wbXYd5wZzhZNRLA=;
	h=Date:To:From:Subject:From;
	b=H33DeknT+D8U8ggC4uuhfvmXQpZEr0BO0j445PYlPswxe65Ytid/FMECiI0iPz0hY
	 C5WAfzxs/Adjb/z8LWbHfHtN0t1x+aI83UT4VjS3HgmStWCEYZQUvIeUetKrRjCh/q
	 +NKMSEqQdD54oRTL9AH85Dxb0SYAN4y3Cu2xeQ8I=
Date: Tue, 18 Jun 2024 14:08:53 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanshuai@oppo.com,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,surenb@google.com,shy828301@gmail.com,ryan.roberts@arm.com,mhocko@suse.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-folio_test_anonfolio==false-path-in-__folio_add_anon_rmap.patch added to mm-unstable branch
Message-Id: <20240618210854.3D732C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove folio_test_anon(folio)==false path in __folio_add_anon_rmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-folio_test_anonfolio==false-path-in-__folio_add_anon_rmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-folio_test_anonfolio==false-path-in-__folio_add_anon_rmap.patch

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
Subject: mm: remove folio_test_anon(folio)==false path in __folio_add_anon_rmap()
Date: Tue, 18 Jun 2024 11:11:37 +1200

The folio_test_anon(folio)==false cases has been relocated to
folio_add_new_anon_rmap().  Additionally, four other callers consistently
pass anonymous folios.

stack 1:
remove_migration_pmd
   -> folio_add_anon_rmap_pmd
     -> __folio_add_anon_rmap

stack 2:
__split_huge_pmd_locked
   -> folio_add_anon_rmap_ptes
      -> __folio_add_anon_rmap

stack 3:
remove_migration_pmd
   -> folio_add_anon_rmap_pmd
      -> __folio_add_anon_rmap (RMAP_LEVEL_PMD)

stack 4:
try_to_merge_one_page
   -> replace_page
     -> folio_add_anon_rmap_pte
       -> __folio_add_anon_rmap

__folio_add_anon_rmap() only needs to handle the cases
folio_test_anon(folio)==true now.
We can remove the !folio_test_anon(folio)) path within
__folio_add_anon_rmap() now.

Link: https://lkml.kernel.org/r/20240617231137.80726-4-21cnbao@gmail.com
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

 mm/rmap.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

--- a/mm/rmap.c~mm-remove-folio_test_anonfolio==false-path-in-__folio_add_anon_rmap
+++ a/mm/rmap.c
@@ -1297,23 +1297,12 @@ static __always_inline void __folio_add_
 {
 	int i, nr, nr_pmdmapped = 0;
 
+	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
+
 	nr = __folio_add_rmap(folio, page, nr_pages, level, &nr_pmdmapped);
 
-	if (unlikely(!folio_test_anon(folio))) {
-		VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
-		/*
-		 * For a PTE-mapped large folio, we only know that the single
-		 * PTE is exclusive. Further, __folio_set_anon() might not get
-		 * folio->index right when not given the address of the head
-		 * page.
-		 */
-		VM_WARN_ON_FOLIO(folio_test_large(folio) &&
-				 level != RMAP_LEVEL_PMD, folio);
-		__folio_set_anon(folio, vma, address,
-				 !!(flags & RMAP_EXCLUSIVE));
-	} else if (likely(!folio_test_ksm(folio))) {
+	if (likely(!folio_test_ksm(folio)))
 		__page_check_anon_rmap(folio, page, vma, address);
-	}
 
 	__folio_mod_stat(folio, nr, nr_pmdmapped);
 
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

