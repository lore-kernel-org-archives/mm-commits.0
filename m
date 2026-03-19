Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DFA374746
	for <mm-commits@vger.kernel.org>; Thu, 19 Mar 2026 22:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773960724; cv=none; b=h9PKyLK5Pz5gtJKaXB3gG9hy7XlqbvMhgXHtiVrYawpIuwZdJzf1GpT3gxo6H346Rcz40vEJ5LYWB2mxNOHNpt/bh4YknSejoAUjk7N8sAQRM5MGfBqHYlSISoANLROLU1879z70roV/2oSSQ0WGZer8fRhHOyxtTQxwAiSVL5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773960724; c=relaxed/simple;
	bh=0GddCqLmIpLIbtPzUGlUu1UxcWmwUFuYeU4Kq2PFaKc=;
	h=Date:To:From:Subject:Message-Id; b=PuQtcPd00pcz9MOTP6m9Jvh8VPwbMZmAWpJpuaekXj6eZDkCBI7FXNrZRFkcX4ec0XFhMYCL4iygz4i34DVwApC4z7GYXB3S9YLz5ZbRArZKWbSLX58Az7M7Azh8RoO8uQZ2CbhVOvTmA2yv9w4PQuJzX7RQojiPDBS+1oBzFtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e+m3rYAD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e+m3rYAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF671C19424;
	Thu, 19 Mar 2026 22:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773960724;
	bh=0GddCqLmIpLIbtPzUGlUu1UxcWmwUFuYeU4Kq2PFaKc=;
	h=Date:To:From:Subject:From;
	b=e+m3rYADjYwnr6s99QZn0j4YKedqY0vuNajaYWbeLcPUGO20enr0jPyYeYHuGnL0+
	 mAVbmjn1z21+qvxjzxdO1ejQaMJ8rOr9UbUuSzlCFg9YUhNWw4i41NaRLJoKlonyVK
	 FaHTn2MVjLlJTK9C02X5GvZGSlMLtuk4rxCbS+1U=
Date: Thu, 19 Mar 2026 15:52:03 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,vbabka@kernel.org,surenb@google.com,sunnanyong@huawei.com,ryan.roberts@arm.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,baohua@kernel.org,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-fix-folio-isnt-locked-in-softleaf_to_folio.patch added to mm-hotfixes-unstable branch
Message-Id: <20260319225203.EF671C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: fix folio isn't locked in softleaf_to_folio()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-huge_memory-fix-folio-isnt-locked-in-softleaf_to_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-fix-folio-isnt-locked-in-softleaf_to_folio.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm/huge_memory: fix folio isn't locked in softleaf_to_folio()
Date: Thu, 19 Mar 2026 09:25:41 +0800

On arm64 server, we found folio that get from migration entry isn't locked
in softleaf_to_folio().  This issue triggers when mTHP splitting and
zap_nonpresent_ptes() races, and the root cause is lack of memory barrier
in softleaf_to_folio().  The race is as follows:

	CPU0                                             CPU1

deferred_split_scan()                              zap_nonpresent_ptes()
  lock folio
  split_folio()
    unmap_folio()
      change ptes to migration entries
    __split_folio_to_order()                         softleaf_to_folio()
      set flags(including PG_locked) for tail pages    folio = pfn_folio(softleaf_to_pfn(entry))
      smp_wmb()                                        VM_WARN_ON_ONCE(!folio_test_locked(folio))
      prep_compound_page() for tail pages

In __split_folio_to_order(), smp_wmb() guarantees page flags of tail pages
are visible before the tail page becomes non-compound.  smp_wmb() should
be paired with smp_rmb() in softleaf_to_folio(), which is missed.  As a
result, if zap_nonpresent_ptes() accesses migration entry that stores tail
pfn, softleaf_to_folio() may see the updated compound_head of tail page
before page->flags.

To fix it, add missing smp_rmb() if the softleaf entry is migration entry
in softleaf_to_folio() and softleaf_to_page().

Link: https://lkml.kernel.org/r/20260319012541.4158561-1-tujinjiang@huawei.com
Fixes: e9b61f19858a ("thp: reintroduce split_huge_page()")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/leafops.h |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

--- a/include/linux/leafops.h~mm-huge_memory-fix-folio-isnt-locked-in-softleaf_to_folio
+++ a/include/linux/leafops.h
@@ -363,6 +363,19 @@ static inline unsigned long softleaf_to_
 	return swp_offset(entry) & SWP_PFN_MASK;
 }
 
+static inline void softleaf_migration_entry_check(softleaf_t entry,
+			struct folio *folio)
+{
+	/* See __split_folio_to_order() comment */
+	smp_rmb();
+
+	/*
+	 * Any use of migration entries may only occur while the
+	 * corresponding page is locked
+	 */
+	VM_WARN_ON_ONCE(!folio_test_locked(folio));
+}
+
 /**
  * softleaf_to_page() - Obtains struct page for PFN encoded within leaf entry.
  * @entry: Leaf entry, softleaf_has_pfn(@entry) must return true.
@@ -374,11 +387,8 @@ static inline struct page *softleaf_to_p
 	struct page *page = pfn_to_page(softleaf_to_pfn(entry));
 
 	VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
-	/*
-	 * Any use of migration entries may only occur while the
-	 * corresponding page is locked
-	 */
-	VM_WARN_ON_ONCE(softleaf_is_migration(entry) && !PageLocked(page));
+	if (softleaf_is_migration(entry))
+		softleaf_migration_entry_check(entry, page_folio(page));
 
 	return page;
 }
@@ -394,12 +404,8 @@ static inline struct folio *softleaf_to_
 	struct folio *folio = pfn_folio(softleaf_to_pfn(entry));
 
 	VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
-	/*
-	 * Any use of migration entries may only occur while the
-	 * corresponding folio is locked.
-	 */
-	VM_WARN_ON_ONCE(softleaf_is_migration(entry) &&
-			!folio_test_locked(folio));
+	if (softleaf_is_migration(entry))
+		softleaf_migration_entry_check(entry, folio);
 
 	return folio;
 }
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-huge_memory-fix-folio-isnt-locked-in-softleaf_to_folio.patch
mm-hugetlb-fix-memory-offline-failure-due-to-hwpoisoned-file-hugetlb.patch

