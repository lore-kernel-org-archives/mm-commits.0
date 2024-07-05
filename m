Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96962AE6A
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 20:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720210437; cv=none; b=PqMdfF93yOiilutXiVQeg6y5CYifSdQq+01xTbKCQP1qkNA2NACncakuZDxz67LWevk3FGf6FnrSi1dY1JN5xkzaul9ogTU5h16UpMAdNCsfMVqTQPWir8s675UBj5OF+MzJu4IJ6WjM8BycjFQrqyxTGcu4PGF/I9B/tFEU5jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720210437; c=relaxed/simple;
	bh=eL17R/Tx9LMLLI6tF+KD70KWVN+o3zaui+mOsFsZwOg=;
	h=Date:To:From:Subject:Message-Id; b=i86gwKuw5ZVJfBj2Hkglv8hQcQlKiXg9R2dtVLSTTqMtKn2gSyN+8zPkXeztHAVC7ERJHaQmgNgzXHCz19r5DhTYxRPGNR6TgY6tyRIJ/fbip6y1hLHpqI8nls49ZSswtQ4skKQHEt4HSHy2BDwaiuyg+0+h2I2LxIRMTxuPd2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1UxPXaFy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1UxPXaFy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2830FC116B1;
	Fri,  5 Jul 2024 20:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720210437;
	bh=eL17R/Tx9LMLLI6tF+KD70KWVN+o3zaui+mOsFsZwOg=;
	h=Date:To:From:Subject:From;
	b=1UxPXaFyvcU+uGYRLurrpJSBzg1sBQGoz+/EcPiIOj11MgteiuLSPKWVoAgq4VnIp
	 TLKvp0CvsAwKh3/+ljauG4LWmDZkUSyRh1z4FisW0lv5dAWz6xEDRBm57djmKpixy2
	 /aEnji20rZHpGDjhJE2mj1L9K2OzLmgP3hD5lmXg=
Date: Fri, 05 Jul 2024 13:13:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,usama.anjum@collabora.com,svetly.todorov@memverge.com,ryan.roberts@arm.com,david@redhat.com,corbet@lwn.net,avagin@google.com,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kpageflags-detect-isolated-kpf_thp-folios.patch added to mm-unstable branch
Message-Id: <20240705201357.2830FC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kpageflags: detect isolated KPF_THP folios
has been added to the -mm mm-unstable branch.  Its filename is
     kpageflags-detect-isolated-kpf_thp-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kpageflags-detect-isolated-kpf_thp-folios.patch

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
+	} else if (is_zero_pfn(page_to_pfn(page))) {
 		u |= 1 << KPF_ZERO_PAGE;
+	}
 
 	/*
 	 * Caveats on high order pages: PG_buddy and PG_slab will only be set
_

Patches currently in -mm which might be from ran.xiaokai@zte.com.cn are

kpageflags-detect-isolated-kpf_thp-folios.patch

