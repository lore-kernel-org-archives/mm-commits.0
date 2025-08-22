Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F68B19E7E2
	for <mm-commits@vger.kernel.org>; Fri, 22 Aug 2025 23:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755905825; cv=none; b=izBovWO5js0oG83szS/aBUfS0UHzcPNdo2ITWq7MjKE4NTujEUIn+trezOWnE9LyasNd4wj2+S1nvdTaXNEf59tCE0U8K85qJoKUpdhZ4CEULMFMcwo8ckGr6sBdyjardLEse1UayemHGIo6KHBz4sWGGh4BZJ86Mg/sld5pGP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755905825; c=relaxed/simple;
	bh=N9jJ9ZvA/bBzbfDhXeyQNGViiMP6af+q2NCAZcb+2aM=;
	h=Date:To:From:Subject:Message-Id; b=f1nvWKzdZ0aGj7Gc04nNKILG/Xl74dGuCz6UcyCl+KNxBs49rbhmdv+NtkDdnaTxMRYSUS/N2H2oxr4AIefqBPjdGDQo/gU/JXaEWpy2B1VoHXLEhFQ90wT+VVbdgudH5DqafhNX8UkaC61x4Cy+mkR8OqrwzU2S4iOrZmj9jVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p7u9cgL9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p7u9cgL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43A9C4CEED;
	Fri, 22 Aug 2025 23:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755905824;
	bh=N9jJ9ZvA/bBzbfDhXeyQNGViiMP6af+q2NCAZcb+2aM=;
	h=Date:To:From:Subject:From;
	b=p7u9cgL9cskbHa+GHirbeKQlkOWjQ6JM3YpVUBQsDRO8Zvp01xxeIgH5CN+xu2mPf
	 Nd9sWjLgqto2iuD+fa2zlD1lm0YjxRPiqJX6mEgkxsFE27lmnuPjf/8PlCv4/4NiP0
	 9XraZ0fMoz/2rRTQdQs1lZHGi+PUNS6xhotRJSNs=
Date: Fri, 22 Aug 2025 16:37:04 -0700
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,yanquanmin1@huawei.com,wangkefeng.wang@huawei.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-support-addr_unit-for-damos_pageout.patch added to mm-new branch
Message-Id: <20250822233704.C43A9C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/paddr: support addr_unit for DAMOS_PAGEOUT
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-paddr-support-addr_unit-for-damos_pageout.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-support-addr_unit-for-damos_pageout.patch

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
Subject: mm/damon/paddr: support addr_unit for DAMOS_PAGEOUT
Date: Fri, 22 Aug 2025 17:34:11 +0800

Add support of addr_unit for DAMOS_PAGEOUT action handling from the DAMOS
operation implementation for the physical address space.

Link: https://lkml.kernel.org/r/20250822093420.2103803-4-yanquanmin1@huawei.com
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: ze zuo <zuoze1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-support-addr_unit-for-damos_pageout
+++ a/mm/damon/paddr.c
@@ -135,10 +135,11 @@ static bool damon_pa_invalid_damos_folio
 	return false;
 }
 
-static unsigned long damon_pa_pageout(struct damon_region *r, struct damos *s,
+static unsigned long damon_pa_pageout(struct damon_region *r,
+		unsigned long addr_unit, struct damos *s,
 		unsigned long *sz_filter_passed)
 {
-	unsigned long addr, applied;
+	phys_addr_t addr, applied;
 	LIST_HEAD(folio_list);
 	bool install_young_filter = true;
 	struct damos_filter *filter;
@@ -159,8 +160,8 @@ static unsigned long damon_pa_pageout(st
 		damos_add_filter(s, filter);
 	}
 
-	addr = r->ar.start;
-	while (addr < r->ar.end) {
+	addr = damon_pa_phys_addr(r->ar.start, addr_unit);
+	while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
 		folio = damon_get_folio(PHYS_PFN(addr));
 		if (damon_pa_invalid_damos_folio(folio, s)) {
 			addr += PAGE_SIZE;
@@ -170,7 +171,7 @@ static unsigned long damon_pa_pageout(st
 		if (damos_pa_filter_out(s, folio))
 			goto put_folio;
 		else
-			*sz_filter_passed += folio_size(folio);
+			*sz_filter_passed += folio_size(folio) / addr_unit;
 
 		folio_clear_referenced(folio);
 		folio_test_clear_young(folio);
@@ -189,7 +190,7 @@ put_folio:
 	applied = reclaim_pages(&folio_list);
 	cond_resched();
 	s->last_applied = folio;
-	return applied * PAGE_SIZE;
+	return applied * PAGE_SIZE / addr_unit;
 }
 
 static inline unsigned long damon_pa_mark_accessed_or_deactivate(
@@ -302,9 +303,11 @@ static unsigned long damon_pa_apply_sche
 		struct damon_target *t, struct damon_region *r,
 		struct damos *scheme, unsigned long *sz_filter_passed)
 {
+	unsigned long aunit = ctx->addr_unit;
+
 	switch (scheme->action) {
 	case DAMOS_PAGEOUT:
-		return damon_pa_pageout(r, scheme, sz_filter_passed);
+		return damon_pa_pageout(r, aunit, scheme, sz_filter_passed);
 	case DAMOS_LRU_PRIO:
 		return damon_pa_mark_accessed(r, scheme, sz_filter_passed);
 	case DAMOS_LRU_DEPRIO:
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

