Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8542816
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719627657; cv=none; b=h8J+sB4zjWkt9H6c+O9TEVi7vG+bLvrUGsShU8e/XZb/obW3gOt4dDW4V7epxsLRhtCe/Dw/949kdaHq8SwBF7/T7Wm9ZO2KvAqw8Jplgf3+jhe9kGHLdBBzRQgW3KEqFkmTMm3OqSWFTzmqARyGxjLlK0uRq3zvWdPep2sXGTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719627657; c=relaxed/simple;
	bh=xhAD0/IkVKFBKTwbJaixUTGx67uejVIdYH/gOd+aYHg=;
	h=Date:To:From:Subject:Message-Id; b=QJmE4y3PE2w6aSrCohmsKr4pmwXWIn5SBtqKrl+4YI9vMiCgnD5LVJAF6kMto5UNIqmtqMsURg8IN6Y9LwIVRCuq6jZMSepe611Jvr26i5tFi4YppZ58j7c7NE3DDextOI7zKA/d7P/CwW38L10/8EQv9s8PqDenKC2h6eAXrKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QImLI0yi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QImLI0yi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E217C116B1;
	Sat, 29 Jun 2024 02:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719627657;
	bh=xhAD0/IkVKFBKTwbJaixUTGx67uejVIdYH/gOd+aYHg=;
	h=Date:To:From:Subject:From;
	b=QImLI0yiZ2pCGO8bAZ4g4osb7sRpGdU8ouM0SIBuHTlbHDjVtJQpcnsLC1mFwaFVQ
	 yLoGeJPMQggZMjU2psyqKnJmcbMPSG1rGgyFwCfkYIkG8S+Ju1xUn74wY7hPynhlXK
	 TRUH1zTDUhkv0whCymFwvhmjhbVCdsHiaQsqJOT8=
Date: Fri, 28 Jun 2024 19:20:56 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanshuai@oppo.com,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,v-songbaohua@oppo.com,surenb@google.com,shy828301@gmail.com,ryan.roberts@arm.com,mhocko@suse.com,lkp@intel.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix.patch removed from -mm tree
Message-Id: <20240629022057.4E217C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix
has been removed from the -mm tree.  Its filename was
     mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix.patch

This patch was dropped because it was folded into mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix
Date: Tue Jun 18 02:03:56 PM PDT 2024

cleanup and constifications per David and akpm

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuai Yuan <yuanshuai@oppo.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/rmap.c~mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix
+++ a/mm/rmap.c
@@ -1411,9 +1411,9 @@ void folio_add_anon_rmap_pmd(struct foli
 void folio_add_new_anon_rmap(struct folio *folio, struct vm_area_struct *vma,
 		unsigned long address, rmap_t flags)
 {
-	int nr = folio_nr_pages(folio);
+	const int nr = folio_nr_pages(folio);
+	const bool exclusive = flags & RMAP_EXCLUSIVE;
 	int nr_pmdmapped = 0;
-	bool exclusive = flags & RMAP_EXCLUSIVE;
 
 	VM_WARN_ON_FOLIO(folio_test_hugetlb(folio), folio);
 	VM_BUG_ON_VMA(address < vma->vm_start ||
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-huge_memoryc-fix-used-uninitialized.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix.patch
mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v7-fix.patch
tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout-fix.patch
mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix.patch

