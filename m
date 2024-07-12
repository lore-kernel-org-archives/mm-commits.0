Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E514127E0F
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824893; cv=none; b=S0B58N6nkYfGeO07mcJMS1iS21G3JE88aSVJp1ZmqG1tRbMyvD7q0DKXUQn4qWG41NZ9MpuVak76tz4CC0oPYk2icae8zlnn9T1hX1cL9mFV03HsEJ7bkVkevt/Xv2QHbAf+PmXV4TELAP1XyovIjKOnnE95RVfBniVa37t24ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824893; c=relaxed/simple;
	bh=LFx+WoJFagp5yaZiDODhcu3rzYPmliohiXulnealY+0=;
	h=Date:To:From:Subject:Message-Id; b=gDKiA5hroisNrFCiyV5wGSP+cYlvm8uUz8onmr63k8zDE5JQXyrGaPsL64ErmJi4BKptfxod+6/ocFcAx3Po8RvmaM5DMHaOmPykRzXu/77kyShpikgW6E5Vu9JKL+BAGeW/tE51wbGmsi6P/Bd6Du9YNW5KL4+7Ai5nkPeAKhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JQ3X/v5S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JQ3X/v5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F68C32782;
	Fri, 12 Jul 2024 22:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824893;
	bh=LFx+WoJFagp5yaZiDODhcu3rzYPmliohiXulnealY+0=;
	h=Date:To:From:Subject:From;
	b=JQ3X/v5S1IKZjcenZn3P4Ar2lhw8lbGvna8HCrw271gtugeeulXppp/CVLqnuLxaL
	 7XHZ04W78v+gibHsvkJWBautiB0G/DHA31ycPp75y5FUwfUc07jl24HNd0i0OD5h/V
	 7tDxICVxL5eiyx2XLWsIkF03euu0AvX7cZ9fcfq8=
Date: Fri, 12 Jul 2024 15:54:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,usama.anjum@collabora.com,svetly.todorov@memverge.com,ryan.roberts@arm.com,david@redhat.com,corbet@lwn.net,avagin@google.com,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kpageflags-detect-isolated-kpf_thp-folios.patch removed from -mm tree
Message-Id: <20240712225453.21F68C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kpageflags: detect isolated KPF_THP folios
has been removed from the -mm tree.  Its filename was
     kpageflags-detect-isolated-kpf_thp-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: kpageflags: detect isolated KPF_THP folios
Date: Fri, 5 Jul 2024 10:43:43 +0000

When folio is isolated, the PG_lru bit is cleared.  So the PG_lru check in
stable_page_flags() will miss this kind of isolated folios.  Use
folio_test_large_rmappable() instead to also include isolated folios.

Since pagecache supports large folios and the introduction of mTHP, the
semantics of KPF_THP have been expanded, now it indicates not only
PMD-sized THP.  Update related documentation to clearly state that KPF_THP
indicates multiple order THPs.

[ran.xiaokai@zte.com.cn: directly use is_zero_folio(), per David]
  Link: https://lkml.kernel.org/r/20240708062601.165215-1-ranxiaokai627@163.com
Link: https://lkml.kernel.org/r/20240705104343.112680-1-ranxiaokai627@163.com
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andrei Vagin <avagin@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Svetly Todorov <svetly.todorov@memverge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/pagemap.rst |    4 ++--
 fs/proc/page.c                           |   21 +++++++++------------
 2 files changed, 11 insertions(+), 14 deletions(-)

--- a/Documentation/admin-guide/mm/pagemap.rst~kpageflags-detect-isolated-kpf_thp-folios
+++ a/Documentation/admin-guide/mm/pagemap.rst
@@ -118,7 +118,7 @@ Short descriptions to the page flags
 21 - KSM
     Identical memory pages dynamically shared between one or more processes.
 22 - THP
-    Contiguous pages which construct transparent hugepages.
+    Contiguous pages which construct THP of any size and mapped by any granularity.
 23 - OFFLINE
     The page is logically offline.
 24 - ZERO_PAGE
@@ -231,7 +231,7 @@ Following flags about pages are currentl
 - ``PAGE_IS_PRESENT`` - Page is present in the memory
 - ``PAGE_IS_SWAPPED`` - Page is in swapped
 - ``PAGE_IS_PFNZERO`` - Page has zero PFN
-- ``PAGE_IS_HUGE`` - Page is THP or Hugetlb backed
+- ``PAGE_IS_HUGE`` - Page is PMD-mapped THP or Hugetlb backed
 - ``PAGE_IS_SOFT_DIRTY`` - Page is soft-dirty
 
 The ``struct pm_scan_arg`` is used as the argument of the IOCTL.
--- a/fs/proc/page.c~kpageflags-detect-isolated-kpf_thp-folios
+++ a/fs/proc/page.c
@@ -147,19 +147,16 @@ u64 stable_page_flags(const struct page
 		u |= 1 << KPF_COMPOUND_TAIL;
 	if (folio_test_hugetlb(folio))
 		u |= 1 << KPF_HUGE;
-	/*
-	 * We need to check PageLRU/PageAnon
-	 * to make sure a given page is a thp, not a non-huge compound page.
-	 */
-	else if (folio_test_large(folio)) {
-		if ((k & (1 << PG_lru)) || is_anon)
-			u |= 1 << KPF_THP;
-		else if (is_huge_zero_folio(folio)) {
-			u |= 1 << KPF_ZERO_PAGE;
-			u |= 1 << KPF_THP;
-		}
-	} else if (is_zero_pfn(page_to_pfn(page)))
+	else if (folio_test_large(folio) &&
+	         folio_test_large_rmappable(folio)) {
+		/* Note: we indicate any THPs here, not just PMD-sized ones */
+		u |= 1 << KPF_THP;
+	} else if (is_huge_zero_folio(folio)) {
+		u |= 1 << KPF_ZERO_PAGE;
+		u |= 1 << KPF_THP;
+	} else if (is_zero_folio(folio)) {
 		u |= 1 << KPF_ZERO_PAGE;
+	}
 
 	/*
 	 * Caveats on high order pages: PG_buddy and PG_slab will only be set
_

Patches currently in -mm which might be from ran.xiaokai@zte.com.cn are


