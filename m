Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EA71C3BEB
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837161; cv=none; b=onYmNb6EaBCAOOV3YeQzrHbmFZ8n2XpenIj8K/MQC4l9nxxZT/wNLCcMTGWylmpJ7OwTaQhkBWSaO0KbAaRDexrTqmj5nEeorkjMSszEfuYPoWQxDDNEaRXB5ak7dMcFNNpNKIGKBaRaiQuCfg5v//RB+HpHIceztFEMsbkHFFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837161; c=relaxed/simple;
	bh=1RCDNCrhZ9rSwxKF8gSWo41b9tvu8Fc1Mb5ODFh4CNs=;
	h=Date:To:From:Subject:Message-Id; b=dvzRlJ7cobL77dLpvtij/NeJ37yYtlfdkY3Jg4Q1E7obOyTruLdEtpX10bTh8k2Ipi8q2seBZIfRJMN1kqgtad1lx03cC3FFHwIc0Fw6bkcgS3xKSVVTKf3AAyaCVN1d050YXTrUqvXRj5i1+x88I1QQ9Huf7IOLAmgK4EmorEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b9W2JcWM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b9W2JcWM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 286FEC4CEDD;
	Tue, 14 Jan 2025 06:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837161;
	bh=1RCDNCrhZ9rSwxKF8gSWo41b9tvu8Fc1Mb5ODFh4CNs=;
	h=Date:To:From:Subject:From;
	b=b9W2JcWMx1of3brmEGq1JtGoB7mC/SsXnO7uLUOM2AySabRHnoE8Vf0YFk6+EaGk/
	 jKwRGTs0xFTv+2Dhtey23lq6TE4AvbmmW5ucIGNiSBJo6XoCfU1KCdSUxtuENiGam0
	 1ff3pMAwsd/011MhC0Pre9IfPBoEsQuGP+JYzQwE=
Date: Mon, 13 Jan 2025 22:46:00 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-report-filter-passed-bytes-back-for-normal-actions.patch removed from -mm tree
Message-Id: <20250114064601.286FEC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/paddr: report filter-passed bytes back for normal actions
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-report-filter-passed-bytes-back-for-normal-actions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

