Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FB4816
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719627660; cv=none; b=erOfQlXYggcK059f3xhaIOKfsnefG/1RIXULmlBOwYmD+inbFwUQGwbTO1h1dQ/wLSLh5TwrpSeMxO3E+9fTuQv0kUIDVfSpYHlmx6L9JOOFUqnG22m/XUjx943xXoJ5jCgnaPMgupyiy8dHEo+Z54EyfQ9rVmt5AJukZ5+nwGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719627660; c=relaxed/simple;
	bh=2H5MG3zqB7Cv8oydgG0On88W0WOu3rZ1jIyb+35HwhE=;
	h=Date:To:From:Subject:Message-Id; b=u9C7ep8qnwJhBSp9JzD1clKsY3Ekf/L1HqfyG+ydjoQAl2pqje+alTIJE5L4TapqfH0ObEVp2Ve+XTrZZ+8ZO66/Yv36Dh6wJAfon8kPguejTUmJx6CTP2i0xspxrcXBo0Ogs8CV3rypY5NsvvyXbY3eVFqi1IhUnAHiFUsPNgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2AFEevEQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2AFEevEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE65CC116B1;
	Sat, 29 Jun 2024 02:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719627660;
	bh=2H5MG3zqB7Cv8oydgG0On88W0WOu3rZ1jIyb+35HwhE=;
	h=Date:To:From:Subject:From;
	b=2AFEevEQuS06NCZWCLSZSJ1lNSVj1f6tExuial1C3Q9x72gYdhQ42phk+tE/7+J2P
	 32SIEdJbdMu7Zy96nPGlhYl29VIGZ6D9ut4lqZ4HNxJdjI53y8u6OISukltk6OzDyn
	 1MwDMrX8jgwiOH6e3W2QuNrByio/4HlJSgIoRiNw=
Date: Fri, 28 Jun 2024 19:20:59 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanshuai@oppo.com,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,surenb@google.com,shy828301@gmail.com,ryan.roberts@arm.com,mhocko@suse.com,lkp@intel.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix-3.patch removed from -mm tree
Message-Id: <20240629022059.EE65CC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: enhence doc for extend rmap flags arguments for folio_add_new_anon_rmap
has been removed from the -mm tree.  Its filename was
     mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix-3.patch

This patch was dropped because it was folded into mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap.patch

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

mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix-2.patch
mm-remove-folio_test_anonfolio==false-path-in-__folio_add_anon_rmap.patch
tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout.patch

