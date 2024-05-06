Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4601B3A1CA
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957170; cv=none; b=s4o25KNHrHeBmTVexddBj1k7xuo9j8GmNsOPdM43WJzyg7PDLhk5FgnjeqrWFArUhJhjAghVP3Q9M0/viNjn7BHzmHu1Xm2lLqDK8wI3lUKf1C9XYH3gSdtVdVYen7lvVO80lS6QC11Kbzmqb+GNm90V5eRW7e0S9nnoWu1dlVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957170; c=relaxed/simple;
	bh=bT6a297++HnCRrcSggvHmSRymgdZMXBrjb3kkKUB5Es=;
	h=Date:To:From:Subject:Message-Id; b=UaDxn8oul5umEZOhtzClXdgvPN51zD4YmM1lG5C9fjfSEmvaniYmelNs6qeCGl+TuCkkugsbBhB+yOevw/xBSBwHcxmi1Dbv9OwVNXti/xvaySV0gG58FeR+UM4B8Fkx7booLaQZePsrrOd/exF+6SYtnsNduBoVC1772aZFHtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WnFoUUf8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WnFoUUf8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC39C113CC;
	Mon,  6 May 2024 00:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957170;
	bh=bT6a297++HnCRrcSggvHmSRymgdZMXBrjb3kkKUB5Es=;
	h=Date:To:From:Subject:From;
	b=WnFoUUf85ux62Z1EhPnlAz1jkDr+eI2j/uBN0xLS0zXTR9qanTZrfCaT2G3fwWXc3
	 8g4scnKpWaoBCLbFVCA6ajPblAR/4l/9GxXE2BSoRvNCAdIfS1NuwTuxugjAUM+Pl2
	 mRL5f2sEudu7k6vRckKNfd7WYeJ3TBWUSb9E5RKk=
Date: Sun, 05 May 2024 17:59:29 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-do-page-level-access-check-for-pageout-damos-action-on-its-own.patch removed from -mm tree
Message-Id: <20240506005930.1AC39C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/paddr: do page level access check for pageout DAMOS action on its own
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-do-page-level-access-check-for-pageout-damos-action-on-its-own.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/paddr: do page level access check for pageout DAMOS action on its own
Date: Mon, 29 Apr 2024 15:44:49 -0700

'pageout' DAMOS action implementation of 'paddr' DAMON operations set asks
reclaim_pages() to do page level access check if the user is not asking
DAMOS to do that on its own.  Simplify the logic by making the check
always be done by 'paddr'.

Link: https://lkml.kernel.org/r/20240429224451.67081-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-do-page-level-access-check-for-pageout-damos-action-on-its-own
+++ a/mm/damon/paddr.c
@@ -244,16 +244,22 @@ static unsigned long damon_pa_pageout(st
 {
 	unsigned long addr, applied;
 	LIST_HEAD(folio_list);
-	bool ignore_references = false;
+	bool install_young_filter = true;
 	struct damos_filter *filter;
 
-	/* respect user's page level reference check handling request */
+	/* check access in page level again by default */
 	damos_for_each_filter(filter, s) {
 		if (filter->type == DAMOS_FILTER_TYPE_YOUNG) {
-			ignore_references = true;
+			install_young_filter = false;
 			break;
 		}
 	}
+	if (install_young_filter) {
+		filter = damos_new_filter(DAMOS_FILTER_TYPE_YOUNG, true);
+		if (!filter)
+			return 0;
+		damos_add_filter(s, filter);
+	}
 
 	for (addr = r->ar.start; addr < r->ar.end; addr += PAGE_SIZE) {
 		struct folio *folio = damon_get_folio(PHYS_PFN(addr));
@@ -275,7 +281,9 @@ static unsigned long damon_pa_pageout(st
 put_folio:
 		folio_put(folio);
 	}
-	applied = reclaim_pages(&folio_list, ignore_references);
+	if (install_young_filter)
+		damos_destroy_filter(filter);
+	applied = reclaim_pages(&folio_list, true);
 	cond_resched();
 	return applied * PAGE_SIZE;
 }
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-_damon_sysfs-support-quota-goals.patch
selftests-damon-add-a-test-for-damos-quota-goal.patch
mm-damon-core-initialize-esz_bp-from-damos_quota_init_priv.patch
selftests-damon-_damon_sysfs-check-errors-from-nr_schemes-file-reads.patch
selftests-damon-_damon_sysfs-find-sysfs-mount-point-from-proc-mounts.patch
selftests-damon-_damon_sysfs-use-is-instead-of-==-for-none.patch
selftests-damon-classify-tests-for-functionalities-and-regressions.patch
docs-admin-guide-mm-damon-usage-fix-wrong-example-of-damos-filter-matching-sysfs-file.patch
docs-admin-guide-mm-damon-usage-fix-wrong-schemes-effective-quota-update-command.patch
docs-mm-damon-design-use-a-list-for-supported-filters.patch
docs-mm-damon-maintainer-profile-change-the-maintainers-timezone-from-pst-to-pt.patch
docs-mm-damon-maintainer-profile-allow-posting-patches-based-on-damon-next-tree.patch

