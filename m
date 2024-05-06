Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF2A3A1CD
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957169; cv=none; b=EpZnZpexYOLjUVrQ6S834+ZKFeZmNXeqcpJnBoKnIMqkyNlyLWfm5PDl6VQri6GVYuIoVCgnPHjERKXHGABfmHIWw1jWnNw9a3rXh403zg0dXruPlT9FocPpySVBidqHEAuAeMJeQfccYsWxV1/J/Zn1pisK+ffsbJ7IYUyX6xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957169; c=relaxed/simple;
	bh=Z5R1i3bcqYX3b8AkfRduxD6rR5s0PjEt+FDtKWsrkQU=;
	h=Date:To:From:Subject:Message-Id; b=e73VhckOvMfd1kuQFP+K7kEOPjpmkauS/U6B8WA0+E15I7gzGirMEz8dr2gYilb26gTysKwdjw0/PXDM3u96FkBELfFX5iYXQGnTZijfVVQuPtR0Vl1yEKdBRGtbmT1gB7xJCLJNtOgDAqLgsUJSjVoZL6uSsbvE4CHqbGyt7BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vqgr3z4x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vqgr3z4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1861CC4AF68;
	Mon,  6 May 2024 00:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957169;
	bh=Z5R1i3bcqYX3b8AkfRduxD6rR5s0PjEt+FDtKWsrkQU=;
	h=Date:To:From:Subject:From;
	b=vqgr3z4xevfIZvAxNelcdFLxMd4KwtAYuCFFeI2F6RFZjsL4wWqZoe/eWdgUtEuAS
	 wizBcI3kwUMrjtiaOkTk9zPvOfJISD2XcmDy4zi3jSF/yZ4GFvpcB1sJvdmNdSMCY4
	 ZbBvuYTxqjjQCilIrpwg2MWBggYktWJxiMsDQo6U=
Date: Sun, 05 May 2024 17:59:28 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-avoid-unnecessary-page-level-access-check-for-pageout-damos-action.patch removed from -mm tree
Message-Id: <20240506005929.1861CC4AF68@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/paddr: avoid unnecessary page level access check for pageout DAMOS action
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-avoid-unnecessary-page-level-access-check-for-pageout-damos-action.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/paddr: avoid unnecessary page level access check for pageout DAMOS action
Date: Mon, 29 Apr 2024 15:44:48 -0700

Patch series "mm/damon/paddr: simplify page level access re-check for
pageout.

The 'pageout' DAMOS action implementation of 'paddr' asks reclaim_pages()
to do page level access check again.  But the user can ask 'paddr' to do
the page level access check on its own, using DAMOS filter of 'young page'
type.  Meanwhile, 'paddr' is the only user of reclaim_pages() that asks
the page level access check.

Make 'paddr' does the page level access check on its own always, and
simplify reclaim_pages() by removing the page level access check request
handling logic.  As a result of the change for reclaim_pages(),
reclaim_folio_list(), which is called by reclaim_pages(), also no more
need to do the page level access check.  Simplify the function, too.


This patch (of 4):

'pageout' DAMOS action implementation of 'paddr' asks reclaim_pages() to
do the page level access check.  User could ask DAMOS to do the page level
access check on its own using 'young page' type DAMOS filter.  In the
case, pageout DAMOS action unnecessarily asks reclaim_pages() to do the
check again.  Ask the page level access check only if the scheme is not
having the filter.

Link: https://lkml.kernel.org/r/20240429224451.67081-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20240429224451.67081-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-avoid-unnecessary-page-level-access-check-for-pageout-damos-action
+++ a/mm/damon/paddr.c
@@ -244,6 +244,16 @@ static unsigned long damon_pa_pageout(st
 {
 	unsigned long addr, applied;
 	LIST_HEAD(folio_list);
+	bool ignore_references = false;
+	struct damos_filter *filter;
+
+	/* respect user's page level reference check handling request */
+	damos_for_each_filter(filter, s) {
+		if (filter->type == DAMOS_FILTER_TYPE_YOUNG) {
+			ignore_references = true;
+			break;
+		}
+	}
 
 	for (addr = r->ar.start; addr < r->ar.end; addr += PAGE_SIZE) {
 		struct folio *folio = damon_get_folio(PHYS_PFN(addr));
@@ -265,7 +275,7 @@ static unsigned long damon_pa_pageout(st
 put_folio:
 		folio_put(folio);
 	}
-	applied = reclaim_pages(&folio_list, false);
+	applied = reclaim_pages(&folio_list, ignore_references);
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

