Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A382C139
	for <mm-commits@vger.kernel.org>; Tue,  7 Jan 2025 02:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215470; cv=none; b=UtMKxvuMbGoJ+jG5Jk/5f5XWTXf18sGiz8BvanItWJMctDUh7xC4u1xPnFVCKFpNDdWvcWjn3zilT1QiwMUOla0FLswDxRS8Amgyky0n2NPGpnMU2j+UicfK7KPRhwKQggLelDdq8OCaYXfrfkVX3SIw527ywQp3NoD5VmI+Ong=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215470; c=relaxed/simple;
	bh=Lrrxb6w2zZKGM1Aa/YPvH7I2PErQivsJ3ToGzl6pbZA=;
	h=Date:To:From:Subject:Message-Id; b=uSvYmVG11Ko/YGobgIWNR5v155YMaLaO4kYx67QMg6nqeLDtOJGaFPTCZ1vN2Ypz3DEerZ+e0sWB9RYL71XUxrFT9mdAvyZQu48R+MHjP2UOXFcOWsjFoY6rDYqFyWnEPE4nEMbCSOk7l2tCxQGnPInotLaxz1SWeofWc5TiBMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WMOjI0Bt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WMOjI0Bt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66FDC4CED2;
	Tue,  7 Jan 2025 02:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736215469;
	bh=Lrrxb6w2zZKGM1Aa/YPvH7I2PErQivsJ3ToGzl6pbZA=;
	h=Date:To:From:Subject:From;
	b=WMOjI0BtPKO6m7Pb1FhOyrF6LtWQJLGkWzSyKklkDk7zv1jtxXexSRSXP3xTnfowA
	 cpqQ5vXlfxM6yTYN/QXMYId0W3jGSMk8JofXvDjX0NwRxY4VkNncvCfXYxSti36e0j
	 s2GxB5yJRf5u+m4phIzqMQAr26t3ifKFfZMPHabg=
Date: Mon, 06 Jan 2025 18:04:29 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-report-filter-passed-bytes-back-for-normal-actions.patch added to mm-unstable branch
Message-Id: <20250107020429.A66FDC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/paddr: report filter-passed bytes back for normal actions
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-paddr-report-filter-passed-bytes-back-for-normal-actions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-report-filter-passed-bytes-back-for-normal-actions.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/paddr: report filter-passed bytes back for normal actions
Date: Mon, 6 Jan 2025 11:33:50 -0800

damon_operations->apply_scheme() implementations are requested to report
back how many bytes of the given region has passed DAMOS filter.  'paddr'
operations set implementation supports some of region-internal DAMOS
filter handling for normal DAMOS actions except DAMOS_STAT action.  But,
those are not respecting the request.  Report the region-internal DAMOS
filter-passed bytes back for the actions.

Link: https://lkml.kernel.org/r/20250106193401.109161-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |   33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-report-filter-passed-bytes-back-for-normal-actions
+++ a/mm/damon/paddr.c
@@ -243,7 +243,8 @@ static bool damos_pa_filter_out(struct d
 	return false;
 }
 
-static unsigned long damon_pa_pageout(struct damon_region *r, struct damos *s)
+static unsigned long damon_pa_pageout(struct damon_region *r, struct damos *s,
+		unsigned long *sz_filter_passed)
 {
 	unsigned long addr, applied;
 	LIST_HEAD(folio_list);
@@ -272,6 +273,8 @@ static unsigned long damon_pa_pageout(st
 
 		if (damos_pa_filter_out(s, folio))
 			goto put_folio;
+		else
+			*sz_filter_passed += folio_size(folio);
 
 		folio_clear_referenced(folio);
 		folio_test_clear_young(folio);
@@ -292,7 +295,8 @@ put_folio:
 }
 
 static inline unsigned long damon_pa_mark_accessed_or_deactivate(
-		struct damon_region *r, struct damos *s, bool mark_accessed)
+		struct damon_region *r, struct damos *s, bool mark_accessed,
+		unsigned long *sz_filter_passed)
 {
 	unsigned long addr, applied = 0;
 
@@ -304,6 +308,8 @@ static inline unsigned long damon_pa_mar
 
 		if (damos_pa_filter_out(s, folio))
 			goto put_folio;
+		else
+			*sz_filter_passed += folio_size(folio);
 
 		if (mark_accessed)
 			folio_mark_accessed(folio);
@@ -317,15 +323,17 @@ put_folio:
 }
 
 static unsigned long damon_pa_mark_accessed(struct damon_region *r,
-	struct damos *s)
+	struct damos *s, unsigned long *sz_filter_passed)
 {
-	return damon_pa_mark_accessed_or_deactivate(r, s, true);
+	return damon_pa_mark_accessed_or_deactivate(r, s, true,
+			sz_filter_passed);
 }
 
 static unsigned long damon_pa_deactivate_pages(struct damon_region *r,
-	struct damos *s)
+	struct damos *s, unsigned long *sz_filter_passed)
 {
-	return damon_pa_mark_accessed_or_deactivate(r, s, false);
+	return damon_pa_mark_accessed_or_deactivate(r, s, false,
+			sz_filter_passed);
 }
 
 static unsigned int __damon_pa_migrate_folio_list(
@@ -449,7 +457,8 @@ static unsigned long damon_pa_migrate_pa
 	return nr_migrated;
 }
 
-static unsigned long damon_pa_migrate(struct damon_region *r, struct damos *s)
+static unsigned long damon_pa_migrate(struct damon_region *r, struct damos *s,
+		unsigned long *sz_filter_passed)
 {
 	unsigned long addr, applied;
 	LIST_HEAD(folio_list);
@@ -462,6 +471,8 @@ static unsigned long damon_pa_migrate(st
 
 		if (damos_pa_filter_out(s, folio))
 			goto put_folio;
+		else
+			*sz_filter_passed += folio_size(folio);
 
 		if (!folio_isolate_lru(folio))
 			goto put_folio;
@@ -481,14 +492,14 @@ static unsigned long damon_pa_apply_sche
 {
 	switch (scheme->action) {
 	case DAMOS_PAGEOUT:
-		return damon_pa_pageout(r, scheme);
+		return damon_pa_pageout(r, scheme, sz_filter_passed);
 	case DAMOS_LRU_PRIO:
-		return damon_pa_mark_accessed(r, scheme);
+		return damon_pa_mark_accessed(r, scheme, sz_filter_passed);
 	case DAMOS_LRU_DEPRIO:
-		return damon_pa_deactivate_pages(r, scheme);
+		return damon_pa_deactivate_pages(r, scheme, sz_filter_passed);
 	case DAMOS_MIGRATE_HOT:
 	case DAMOS_MIGRATE_COLD:
-		return damon_pa_migrate(r, scheme);
+		return damon_pa_migrate(r, scheme, sz_filter_passed);
 	case DAMOS_STAT:
 		break;
 	default:
_

Patches currently in -mm which might be from sj@kernel.org are

samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch
samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch
samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch
samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch
samples-damon-prcl-implement-schemes-setup.patch
replace-free-hugepage-folios-after-migration-fix-2.patch
docs-admin-guide-mm-damon-usage-remove-damon-debugfs-interface-documentation.patch
docs-mm-damon-design-update-for-removal-of-damon-debugfs-interface.patch
selftests-damon-config-remove-configs-for-damon-debugfs-interface-selftests.patch
selftests-damon-remove-tests-for-damon-debugfs-interface.patch
kunit-configs-remove-configs-for-damon-debugfs-interface-tests.patch
mm-damon-remove-damon-debugfs-interface-kunit-tests.patch
mm-damon-remove-damon-debugfs-interface.patch
mm-damon-sysfs-schemes-remove-unnecessary-schemes-existence-check-in-damon_sysfs_schemes_clear_regions.patch
mm-damon-sysfs-handle-clear_schemes_tried_regions-from-damon-sysfs-context.patch
mm-damon-core-introduce-damon_call.patch
mm-damon-sysfs-use-damon_call-for-update_schemes_stats.patch
mm-damon-sysfs-use-damon_call-for-commit_schemes_quota_goals.patch
mm-damon-sysfs-use-damon_call-for-update_schemes_effective_quotas.patch
mm-damon-core-implement-damos_walk.patch
docs-mm-damon-design-document-damos-regions-walking.patch
mm-damon-sysfs-use-damos_walk-for-update_schemes_tried_bytesregions.patch
mm-damon-sysfs-remove-unused-code-for-schemes-tried-regions-update.patch
mm-damon-clarify-trying-vs-applying-on-damos_stat-kernel-doc-comment.patch
docs-mm-damon-design-add-statistics-section.patch
docs-admin-guide-mm-damon-usage-link-damos-stat-design-doc.patch
mm-damon-ask-apply_scheme-to-report-filter-passed-region-internal-bytes.patch
mm-damon-paddr-report-filter-passed-bytes-back-for-normal-actions.patch
mm-damon-paddr-report-filter-passed-bytes-back-for-damos_stat-action.patch
mm-damon-core-implement-per-scheme-ops-handled-filter-passed-bytes-stat.patch
mm-damon-syfs-schemes-implement-per-scheme-filter-passed-bytes-stat.patch
docs-mm-damon-design-document-sz_ops_filter_passed.patch
docs-admin-guide-mm-damon-usage-document-sz_ops_filter_passed.patch
docs-abi-damon-document-per-scheme-filter-passed-bytes-stat-file.patch
mm-damon-core-pass-per-region-filter-passed-bytes-to-damos_walk_control-walk_fn.patch
mm-damon-sysfs-schemes-expose-per-region-filter-passed-bytes.patch
docs-mm-damon-design-document-per-region-sz_filter_passed-stat.patch
docs-admin-guide-mm-damon-usage-document-sz_filtered_out-of-scheme-tried-region-directories.patch
docs-abi-damon-document-per-region-damos-filter-passed-bytes-stat-file.patch

