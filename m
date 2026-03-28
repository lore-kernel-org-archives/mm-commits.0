Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8169443;
	Sat, 28 Mar 2026 00:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774658353; cv=none; b=F2vU0NEW21ovHB6TuCnwik4tgQqkKctP+1bDxPBhB4qSkWskKr158DusJZIDMbQr6JbcEfDUP5Lo4PtufeFzsw7j7VDSBHCv9qbUWz5no9oWSWBtre2Z2x6OHy/+g8yHDlSyYb+u4VuVzsWP/vrA+jCq52TdsU4JxfV63R0HBdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774658353; c=relaxed/simple;
	bh=vcjF600pRG7x0wolnpzCXSmGNGNg+2ONE6kOjXrOAnI=;
	h=Date:To:From:Subject:Message-Id; b=Rurx0HVfns0AbewhP6Vz152E258sbgD6U1e3V06cpdj9M/SHszfeeaO83WUh+RqjO5EJSlN61lC5s2wht2Egno3+ogGkDF2uOk9CrdyDHmz5c+8T5dQZiRfqTwc3e3taVgLQLaxIpNwqy9a/K9EbTvif41BndAEqj8IrwboN+sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KPwSexdZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KPwSexdZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D555CC19423;
	Sat, 28 Mar 2026 00:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774658352;
	bh=vcjF600pRG7x0wolnpzCXSmGNGNg+2ONE6kOjXrOAnI=;
	h=Date:To:From:Subject:From;
	b=KPwSexdZVWMDap7gH8HwJmERGHYBUK7fUC8TU0LhiB1WKPaHBLKbZKj/4zryehzCW
	 QNsgfYpD25iV2UR/2WxjFyXtAWm7Aq1bE2OPUc14rO2Fz9ygtueW9niL0wc9qYE1NT
	 rOYPxoVnLEP+0YhQjg3My0T4aYLDUvKJybA1/01E=
Date: Fri, 27 Mar 2026 17:39:12 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,vbabka@kernel.org,surenb@google.com,sunnanyong@huawei.com,stable@vger.kernel.org,ryan.roberts@arm.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,baohua@kernel.org,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-huge_memory-fix-folio-isnt-locked-in-softleaf_to_folio.patch removed from -mm tree
Message-Id: <20260328003912.D555CC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: fix folio isn't locked in softleaf_to_folio()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-fix-folio-isnt-locked-in-softleaf_to_folio.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

This issue will trigger VM_WARN_ON_ONCE() in pfn_swap_entry_folio()
because of the race between folio split and zap_nonpresent_ptes()
leading to a folio incorrectly undergoing modification without a folio
lock being held.

This is a BUG_ON() before commit 93976a20345b ("mm: eliminate further
swapops predicates"), which in merged in v6.19-rc1.

To fix it, add missing smp_rmb() if the softleaf entry is migration entry
in softleaf_to_folio() and softleaf_to_page().

[tujinjiang@huawei.com: update function name and comments]
  Link: https://lkml.kernel.org/r/20260321075214.3305564-1-tujinjiang@huawei.com
Link: https://lkml.kernel.org/r/20260319012541.4158561-1-tujinjiang@huawei.com
Fixes: e9b61f19858a ("thp: reintroduce split_huge_page()")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/leafops.h |   32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

--- a/include/linux/leafops.h~mm-huge_memory-fix-folio-isnt-locked-in-softleaf_to_folio
+++ a/include/linux/leafops.h
@@ -363,6 +363,23 @@ static inline unsigned long softleaf_to_
 	return swp_offset(entry) & SWP_PFN_MASK;
 }
 
+static inline void softleaf_migration_sync(softleaf_t entry,
+		struct folio *folio)
+{
+	/*
+	 * Ensure we do not race with split, which might alter tail pages into new
+	 * folios and thus result in observing an unlocked folio.
+	 * This matches the write barrier in __split_folio_to_order().
+	 */
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
@@ -374,11 +391,8 @@ static inline struct page *softleaf_to_p
 	struct page *page = pfn_to_page(softleaf_to_pfn(entry));
 
 	VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
-	/*
-	 * Any use of migration entries may only occur while the
-	 * corresponding page is locked
-	 */
-	VM_WARN_ON_ONCE(softleaf_is_migration(entry) && !PageLocked(page));
+	if (softleaf_is_migration(entry))
+		softleaf_migration_sync(entry, page_folio(page));
 
 	return page;
 }
@@ -394,12 +408,8 @@ static inline struct folio *softleaf_to_
 	struct folio *folio = pfn_folio(softleaf_to_pfn(entry));
 
 	VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
-	/*
-	 * Any use of migration entries may only occur while the
-	 * corresponding folio is locked.
-	 */
-	VM_WARN_ON_ONCE(softleaf_is_migration(entry) &&
-			!folio_test_locked(folio));
+	if (softleaf_is_migration(entry))
+		softleaf_migration_sync(entry, folio);
 
 	return folio;
 }
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-hugetlb-fix-memory-offline-failure-due-to-hwpoisoned-file-hugetlb.patch

