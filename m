Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DCD26D4CD
	for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2025 22:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756420827; cv=none; b=TrFfc8fp7uZqTh0r0l9sTsQFXreVj8gpdRZzZUP6amOfWRZDTCdJivyPSHRaMLiq9oxEpUGFJ3+WNSB+HLNN1qGYLsZu1sKMBcu+CLb3PBEfKArVmJ+GotBYnbRcMQM+4Wk9Fh3QbVERBJFZxJIgQozVy1JRoLtYQ3jVGhkCVtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756420827; c=relaxed/simple;
	bh=ZgpkYIoSoZ9SlPSnN68HJGVTyOo/GtZ8sTHR+0PwH6A=;
	h=Date:To:From:Subject:Message-Id; b=OATTvWDvqvuvsjbobiqsVPlu/J8O53hllsfOlDxhNScxM64R1GPTU06+qz/JAoWoIyB5Qu6KO1UJVKY9/out3rWuJ40XmAaOxVwJDl9UoQuFGr38tdXcjXWcb7dRzO1vucSJL8eABfjuO15eJgpJ4OO5VO1ee8c9RwTHLTM2seU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KzyBJDNP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KzyBJDNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37CDDC4CEEB;
	Thu, 28 Aug 2025 22:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756420827;
	bh=ZgpkYIoSoZ9SlPSnN68HJGVTyOo/GtZ8sTHR+0PwH6A=;
	h=Date:To:From:Subject:From;
	b=KzyBJDNPEmllbND2vD5bCSvuNjF4Wjpkvaca372qZlmJmAP6LQ2opauBDKxZUavFa
	 Rp50TcG+Jgwhs3Lvscqrc1li024ynSz40OflKE+OCWng+0imo41WSJVOJMkoTf6LMR
	 PFfzEYoQC9f3PhT/rqUdll93defj9vtuW7oQsmcI=
Date: Thu, 28 Aug 2025 15:40:26 -0700
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,yanquanmin1@huawei.com,wangkefeng.wang@huawei.com,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-support-addr_unit-for-migrate_hotcold.patch added to mm-new branch
Message-Id: <20250828224027.37CDDC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/paddr: support addr_unit for MIGRATE_{HOT,COLD}
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-paddr-support-addr_unit-for-migrate_hotcold.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-support-addr_unit-for-migrate_hotcold.patch

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
Subject: mm/damon/paddr: support addr_unit for MIGRATE_{HOT,COLD}
Date: Thu, 28 Aug 2025 10:12:36 -0700

Add support of addr_unit for DAMOS_MIGRATE_HOT and DAMOS_MIGRATE_COLD
action handling from the DAMOS operation implementation for the physical
address space.

Link: https://lkml.kernel.org/r/20250828171242.59810-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: ze zuo <zuoze1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-support-addr_unit-for-migrate_hotcold
+++ a/mm/damon/paddr.c
@@ -256,15 +256,16 @@ static unsigned long damon_pa_deactivate
 			sz_filter_passed);
 }
 
-static unsigned long damon_pa_migrate(struct damon_region *r, struct damos *s,
+static unsigned long damon_pa_migrate(struct damon_region *r,
+		unsigned long addr_unit, struct damos *s,
 		unsigned long *sz_filter_passed)
 {
-	unsigned long addr, applied;
+	phys_addr_t addr, applied;
 	LIST_HEAD(folio_list);
 	struct folio *folio;
 
-	addr = r->ar.start;
-	while (addr < r->ar.end) {
+	addr = damon_pa_phys_addr(r->ar.start, addr_unit);
+	while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
 		folio = damon_get_folio(PHYS_PFN(addr));
 		if (damon_pa_invalid_damos_folio(folio, s)) {
 			addr += PAGE_SIZE;
@@ -274,7 +275,7 @@ static unsigned long damon_pa_migrate(st
 		if (damos_pa_filter_out(s, folio))
 			goto put_folio;
 		else
-			*sz_filter_passed += folio_size(folio);
+			*sz_filter_passed += folio_size(folio) / addr_unit;
 
 		if (!folio_isolate_lru(folio))
 			goto put_folio;
@@ -286,7 +287,7 @@ put_folio:
 	applied = damon_migrate_pages(&folio_list, s->target_nid);
 	cond_resched();
 	s->last_applied = folio;
-	return applied * PAGE_SIZE;
+	return damon_pa_core_addr(applied * PAGE_SIZE, addr_unit);
 }
 
 static unsigned long damon_pa_stat(struct damon_region *r, struct damos *s,
@@ -332,7 +333,7 @@ static unsigned long damon_pa_apply_sche
 				sz_filter_passed);
 	case DAMOS_MIGRATE_HOT:
 	case DAMOS_MIGRATE_COLD:
-		return damon_pa_migrate(r, scheme, sz_filter_passed);
+		return damon_pa_migrate(r, aunit, scheme, sz_filter_passed);
 	case DAMOS_STAT:
 		return damon_pa_stat(r, scheme, sz_filter_passed);
 	default:
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

