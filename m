Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1811A08DF
	for <mm-commits@vger.kernel.org>; Mon, 24 Jun 2024 23:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719271607; cv=none; b=rjEycuOrKNL7oIb9WA1NaR9YWS4LVUFzNwUXZTUN+J25GWhzJ4Z7Kr6fNAUgAXf0JXT5tYO32ESdT5pE8c1yuZFMGnpAGjZ188lid6HT9uaanBAXnJ4KqsuL89h+k6Exp7l9PWQ3cdXqZT/MZkonIOgFV1lIkwFx2BvRdgIxmVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719271607; c=relaxed/simple;
	bh=9jzMgs4hZnhtAGAwQLPCrUjE6Xk1D/745HFFGwu32nE=;
	h=Date:To:From:Subject:Message-Id; b=TYDmAUxgusQo/so5cUd4qOtvyTHrvmkpdgLDpWzhxhRKwC5liWpTNxP8wRKDuWKaO7fAmNGIhd8lDMOmwuc86cBWcBM7APYVaEX15K8/8r7JW6+USjpaPcIXgb2e/jz4qtXBvdLgj7bMmSf3oPUNmCupqBktXHRNiMpgkFXMXwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q7KJ0U7s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q7KJ0U7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E99C2BBFC;
	Mon, 24 Jun 2024 23:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719271606;
	bh=9jzMgs4hZnhtAGAwQLPCrUjE6Xk1D/745HFFGwu32nE=;
	h=Date:To:From:Subject:From;
	b=q7KJ0U7sPNYCOzyACXhTCuUj1aSIg3b9wUxqqX+l4FVT6nC80/FGiXVgr6I30y+s7
	 +CznbAquWbtF2P0jtAIWi9/R78pSpMYB7FaUAY+kR9krHMsrPoiSxErzDwXnzI7T9p
	 6ieT9UhwZ12Jf3NmqY29rmKD3YXCIqSqGb33yBoU=
Date: Mon, 24 Jun 2024 16:26:46 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanshuai@oppo.com,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,surenb@google.com,shy828301@gmail.com,ryan.roberts@arm.com,mhocko@suse.com,lkp@intel.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix-3.patch added to mm-unstable branch
Message-Id: <20240624232646.D7E99C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: enhence doc for extend rmap flags arguments for folio_add_new_anon_rmap
has been added to the -mm mm-unstable branch.  Its filename is
     mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix-3.patch

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
Subject: mm: enhence doc for extend rmap flags arguments for folio_add_new_anon_rmap
Date: Sat, 22 Jun 2024 14:51:38 +1200

Link: https://lkml.kernel.org/r/20240622030256.43775-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuai Yuan <yuanshuai@oppo.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/rmap.c~mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix-3
+++ a/mm/rmap.c
@@ -1405,7 +1405,9 @@ void folio_add_anon_rmap_pmd(struct foli
  *
  * Like folio_add_anon_rmap_*() but must only be called on *new* folios.
  * This means the inc-and-test can be bypassed.
- * The folio does not have to be locked.
+ * The folio doesn't necessarily need to be locked while it's exclusive
+ * unless two threads map it concurrently. However, the folio must be
+ * locked if it's shared.
  *
  * If the folio is pmd-mappable, it is accounted as a THP.
  */
@@ -1417,6 +1419,7 @@ void folio_add_new_anon_rmap(struct foli
 	int nr_pmdmapped = 0;
 
 	VM_WARN_ON_FOLIO(folio_test_hugetlb(folio), folio);
+	VM_WARN_ON_FOLIO(!exclusive && !folio_test_locked(folio), folio);
 	VM_BUG_ON_VMA(address < vma->vm_start ||
 			address + (nr << PAGE_SHIFT) > vma->vm_end, vma);
 	__folio_set_swapbacked(folio);
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-remove-the-implementation-of-swap_free-and-always-use-swap_free_nr.patch
mm-introduce-pte_move_swp_offset-helper-which-can-move-offset-bidirectionally.patch
mm-introduce-arch_do_swap_page_nr-which-allows-restore-metadata-for-nr-pages.patch
mm-swap-reuse-exclusive-folio-directly-instead-of-wp-page-faults.patch
mm-introduce-pmdpte_needs_soft_dirty_wp-helpers-for-softdirty-write-protect.patch
mm-set-pte-writable-while-pte_soft_dirty-is-true-in-do_swap_page.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix-2.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix-3.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix-2.patch
mm-remove-folio_test_anonfolio==false-path-in-__folio_add_anon_rmap.patch
tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout.patch

