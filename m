Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB8E19E7E2
	for <mm-commits@vger.kernel.org>; Fri, 22 Aug 2025 23:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755905827; cv=none; b=n0xzKNqjvVetDa0gbTE+31NI5rzu9UdZ8M9gmpxT2SXoSOc2hFfD7To3ET0fmJxtwRcV+FGMhpa33tPyVZvIr0wZP+lB0qIdjvlyQEdFxf/2IYGZZwDTRUzk7h87eHYM5cRamLMQgu4HqDo72XSm/vcqpPtNPrRu/hJcWdLtSlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755905827; c=relaxed/simple;
	bh=lpy2ttL1fAk2fHZT7V5KwjsqrXJFetkNRLeqFl0AGYE=;
	h=Date:To:From:Subject:Message-Id; b=R3SLYbqMlKRK98ApUT2GrU44Z0VlUsjDLigrTXDNx/0dyIBg90jSKuMdCnmBpjt1m8VuHLsVp2iP4Z63DFgwave0DSY42/JCoKRsOfu9PNk5HCjyna4bNzu465eI0YosblTsjMEo/2M19aQNdpDv5/S6rZXwFydC3iEpI3r2BjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y0EaIDZ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y0EaIDZ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE9BC4CEED;
	Fri, 22 Aug 2025 23:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755905826;
	bh=lpy2ttL1fAk2fHZT7V5KwjsqrXJFetkNRLeqFl0AGYE=;
	h=Date:To:From:Subject:From;
	b=y0EaIDZ2dATD1xvfBFMFTufzBtEa70bW3HQKLPZ4NlpIiZAZl/dzTq9SG8eycBzfD
	 +6f75OW3TZgu7ydccH/xjl2r5P77yTg+aAkVVOXjL5gr3s5GDzhw1Dbz/ebUlGyaaK
	 uMYiPtK2vRrPyHfBfDeZj91StFine+Qu6XxTvi8c=
Date: Fri, 22 Aug 2025 16:37:06 -0700
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,yanquanmin1@huawei.com,wangkefeng.wang@huawei.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-support-addr_unit-for-damos_lru_prio.patch added to mm-new branch
Message-Id: <20250822233706.BCE9BC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/paddr: support addr_unit for DAMOS_LRU_[DE]PRIO
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-paddr-support-addr_unit-for-damos_lru_prio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-support-addr_unit-for-damos_lru_prio.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/paddr: support addr_unit for DAMOS_LRU_[DE]PRIO
Date: Fri, 22 Aug 2025 17:34:12 +0800

Add support of addr_unit for DAMOS_LRU_PRIO and DAMOS_LRU_DEPRIO action
handling from the DAMOS operation implementation for the physical address
space.

Link: https://lkml.kernel.org/r/20250822093420.2103803-5-yanquanmin1@huawei.com
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: ze zuo <zuoze1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-support-addr_unit-for-damos_lru_prio
+++ a/mm/damon/paddr.c
@@ -194,14 +194,15 @@ put_folio:
 }
 
 static inline unsigned long damon_pa_mark_accessed_or_deactivate(
-		struct damon_region *r, struct damos *s, bool mark_accessed,
+		struct damon_region *r, unsigned long addr_unit,
+		struct damos *s, bool mark_accessed,
 		unsigned long *sz_filter_passed)
 {
-	unsigned long addr, applied = 0;
+	phys_addr_t addr, applied = 0;
 	struct folio *folio;
 
-	addr = r->ar.start;
-	while (addr < r->ar.end) {
+	addr = damon_pa_phys_addr(r->ar.start, addr_unit);
+	while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
 		folio = damon_get_folio(PHYS_PFN(addr));
 		if (damon_pa_invalid_damos_folio(folio, s)) {
 			addr += PAGE_SIZE;
@@ -211,7 +212,7 @@ static inline unsigned long damon_pa_mar
 		if (damos_pa_filter_out(s, folio))
 			goto put_folio;
 		else
-			*sz_filter_passed += folio_size(folio);
+			*sz_filter_passed += folio_size(folio) / addr_unit;
 
 		if (mark_accessed)
 			folio_mark_accessed(folio);
@@ -223,20 +224,22 @@ put_folio:
 		folio_put(folio);
 	}
 	s->last_applied = folio;
-	return applied * PAGE_SIZE;
+	return applied * PAGE_SIZE / addr_unit;
 }
 
 static unsigned long damon_pa_mark_accessed(struct damon_region *r,
-	struct damos *s, unsigned long *sz_filter_passed)
+		unsigned long addr_unit, struct damos *s,
+		unsigned long *sz_filter_passed)
 {
-	return damon_pa_mark_accessed_or_deactivate(r, s, true,
+	return damon_pa_mark_accessed_or_deactivate(r, addr_unit, s, true,
 			sz_filter_passed);
 }
 
 static unsigned long damon_pa_deactivate_pages(struct damon_region *r,
-	struct damos *s, unsigned long *sz_filter_passed)
+		unsigned long addr_unit, struct damos *s,
+		unsigned long *sz_filter_passed)
 {
-	return damon_pa_mark_accessed_or_deactivate(r, s, false,
+	return damon_pa_mark_accessed_or_deactivate(r, addr_unit, s, false,
 			sz_filter_passed);
 }
 
@@ -309,9 +312,11 @@ static unsigned long damon_pa_apply_sche
 	case DAMOS_PAGEOUT:
 		return damon_pa_pageout(r, aunit, scheme, sz_filter_passed);
 	case DAMOS_LRU_PRIO:
-		return damon_pa_mark_accessed(r, scheme, sz_filter_passed);
+		return damon_pa_mark_accessed(r, aunit, scheme,
+				sz_filter_passed);
 	case DAMOS_LRU_DEPRIO:
-		return damon_pa_deactivate_pages(r, scheme, sz_filter_passed);
+		return damon_pa_deactivate_pages(r, aunit, scheme,
+				sz_filter_passed);
 	case DAMOS_MIGRATE_HOT:
 	case DAMOS_MIGRATE_COLD:
 		return damon_pa_migrate(r, scheme, sz_filter_passed);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-zswap-store-page_size-compression-failed-page-as-is.patch
mm-zswap-store-page_size-compression-failed-page-as-is-fix.patch
mm-zswap-store-page_size-compression-failed-page-as-is-v5.patch
mm-damon-core-add-damon_ctx-addr_unit.patch
mm-damon-paddr-support-addr_unit-for-access-monitoring.patch
mm-damon-paddr-support-addr_unit-for-damos_pageout.patch
mm-damon-paddr-support-addr_unit-for-damos_lru_prio.patch
mm-damon-paddr-support-addr_unit-for-migrate_hotcold.patch
mm-damon-paddr-support-addr_unit-for-damos_stat.patch
mm-damon-sysfs-implement-addr_unit-file-under-context-dir.patch
docs-mm-damon-design-document-address-unit-parameter.patch
docs-admin-guide-mm-damon-usage-document-addr_unit-file.patch
docs-abi-damon-document-addr_unit-file.patch

