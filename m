Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1DB3191B9
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486712; cv=none; b=iF51OvBO9LGuH3/wPU90ScukAYioGTYgkGwbd6Kn2wJzH0FUaH27sosglW4QYYubd8ZqxQIg7XhqSTmAEfiNL6AYac8VBw90LY2t5flkkYwZCS49ahztqrL/dAGnoqw6RoWpDO4/osCQhNw5J/PclOLs2VkiqfPSbHn99qFirFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486712; c=relaxed/simple;
	bh=gqetljaDBusGnSdyfwmJOlM5pw/syNJyp9b1cvSW5h8=;
	h=Date:To:From:Subject:Message-Id; b=FcZlhYwzfQJuhWN3JHH0CMBgnIhzwrLKb4dc0oCg0EyMNAR4fBE91lSXsRZ1qGzsS/zV9ypSU7jR0XuWrBlHZ0UUmwDBSPbkViORSGWfzoTuCNzFjfiwInsv9xLE+8TDmkegelS4g8g82g4LN06dnVoO4sbI6Wv9BfZ50m7P9KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2syUIxdX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2syUIxdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9234EC116C6;
	Tue, 27 Jan 2026 04:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486712;
	bh=gqetljaDBusGnSdyfwmJOlM5pw/syNJyp9b1cvSW5h8=;
	h=Date:To:From:Subject:From;
	b=2syUIxdX6wDLEwfT7Vr7bILZ8P5IAw2IKzqQzWM5jiraQsNZ8JZHi9a5kN6b1+Ug9
	 yeVkN6YQmXkU5HtwaOJbpMCoPu37+IsQNx5rSUceUB255uPtST30cXkf1EqIoIA7GH
	 GFsXxZpd9V3cDEigzmaQCxcGmF/fg8tDSJNPg/HM=
Date: Mon, 26 Jan 2026 20:05:12 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-activate-damos_lru_prio-targets-instead-of-marking-accessed.patch removed from -mm tree
Message-Id: <20260127040512.9234EC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/paddr: activate DAMOS_LRU_PRIO targets instead of marking accessed
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-activate-damos_lru_prio-targets-instead-of-marking-accessed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/paddr: activate DAMOS_LRU_PRIO targets instead of marking accessed
Date: Tue, 13 Jan 2026 07:27:09 -0800

DAMOS_LRU_DEPRIOD directly deactivates the pages, while DAMOS_LRU_PRIO
calls folio_mark_accessed(), which does incremental activation.  The
incremental activation was assumed to be useful for making sure the pages
of the hot memory region are really hot.  After the introduction of
DAMOS_LRU_PRIO, the young page filter has added.  Users can use the young
page filter to make sure the page is eligible to be activated.  Meanwhile,
the asymmetric behavior of DAMOS_LRU_[DE]PRIO can confuse users.

Directly activate given pages for DAMOS_LRU_PRIO, to eliminate the
unnecessary incremental activation steps, and be symmetric with
DAMOS_LRU_DEPRIO for easier usages.

Link: https://lkml.kernel.org/r/20260113152717.70459-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-activate-damos_lru_prio-targets-instead-of-marking-accessed
+++ a/mm/damon/paddr.c
@@ -206,9 +206,9 @@ put_folio:
 	return damon_pa_core_addr(applied * PAGE_SIZE, addr_unit);
 }
 
-static inline unsigned long damon_pa_mark_accessed_or_deactivate(
+static inline unsigned long damon_pa_de_activate(
 		struct damon_region *r, unsigned long addr_unit,
-		struct damos *s, bool mark_accessed,
+		struct damos *s, bool activate,
 		unsigned long *sz_filter_passed)
 {
 	phys_addr_t addr, applied = 0;
@@ -227,8 +227,8 @@ static inline unsigned long damon_pa_mar
 		else
 			*sz_filter_passed += folio_size(folio) / addr_unit;
 
-		if (mark_accessed)
-			folio_mark_accessed(folio);
+		if (activate)
+			folio_activate(folio);
 		else
 			folio_deactivate(folio);
 		applied += folio_nr_pages(folio);
@@ -240,20 +240,18 @@ put_folio:
 	return damon_pa_core_addr(applied * PAGE_SIZE, addr_unit);
 }
 
-static unsigned long damon_pa_mark_accessed(struct damon_region *r,
+static unsigned long damon_pa_activate_pages(struct damon_region *r,
 		unsigned long addr_unit, struct damos *s,
 		unsigned long *sz_filter_passed)
 {
-	return damon_pa_mark_accessed_or_deactivate(r, addr_unit, s, true,
-			sz_filter_passed);
+	return damon_pa_de_activate(r, addr_unit, s, true, sz_filter_passed);
 }
 
 static unsigned long damon_pa_deactivate_pages(struct damon_region *r,
 		unsigned long addr_unit, struct damos *s,
 		unsigned long *sz_filter_passed)
 {
-	return damon_pa_mark_accessed_or_deactivate(r, addr_unit, s, false,
-			sz_filter_passed);
+	return damon_pa_de_activate(r, addr_unit, s, false, sz_filter_passed);
 }
 
 static unsigned long damon_pa_migrate(struct damon_region *r,
@@ -327,7 +325,7 @@ static unsigned long damon_pa_apply_sche
 	case DAMOS_PAGEOUT:
 		return damon_pa_pageout(r, aunit, scheme, sz_filter_passed);
 	case DAMOS_LRU_PRIO:
-		return damon_pa_mark_accessed(r, aunit, scheme,
+		return damon_pa_activate_pages(r, aunit, scheme,
 				sz_filter_passed);
 	case DAMOS_LRU_DEPRIO:
 		return damon_pa_deactivate_pages(r, aunit, scheme,
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-sysfs_memcg_path_leaksh-use-kmemleak.patch
selftests-damon-wss_estimation-test-for-up-to-160-mib-working-set-size.patch
selftests-damon-access_memory-add-repeat-mode.patch
selftests-damon-wss_estimation-ensure-number-of-collected-wss.patch
selftests-damon-wss_estimation-deduplicate-failed-samples-output.patch
mm-damon-remove-damon_operations-cleanup.patch
mm-damon-core-cleanup-targets-and-regions-at-once-on-kdamond-termination.patch
mm-damon-core-cancel-damos_walk-before-damon_ctx-kdamond-reset.patch
mm-damon-core-process-damon_call_control-requests-on-a-local-list.patch
mm-damon-document-damon_call_control-dealloc_on_cancel-repeat-behavior.patch
mm-damon-core-rename-damos_filter_out-to-damos_core_filter_out.patch
mm-damon-rename-damon_min_region-to-damon_min_region_sz.patch
mm-damon-rename-min_sz_region-of-damon_ctx-to-min_region_sz.patch
docs-mm-damon-index-simplify-the-intro.patch
docs-mm-damon-design-link-repology-instead-of-fedora-package.patch
docs-mm-damon-design-document-damon-sample-modules.patch
docs-mm-damon-design-add-reference-to-damon_stat-usage.patch
docs-admin-guide-mm-damon-usage-introduce-damon-modules-at-the-beginning.patch
docs-admin-guide-mm-damon-usage-update-stats-update-process-for-refresh_ms.patch
docs-mm-damon-maintainer-profile-fix-wrong-maitnainers-section-name.patch
docs-mm-damon-maintainer-profile-remove-damon-tests-perf-suggestion.patch
maple_tree-start-using-maple-copy-node-for-destination-fix.patch

