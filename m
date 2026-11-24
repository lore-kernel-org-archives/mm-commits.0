Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795541014;
	b=0mGCB/jNucC4mE1Q6BJcrfBluKa3jAWPdfMlBppin2dtI/vNZsj7J056ED5fwCQZl6Ed
	 hGFCQ+b+3JsIsi7QH9RmP6Wmfmd6B67ZVH2yUQh6CuRXr/AmUK39MWW/l/EsVfXsUa8I3
	 LBlzY0PMQNUYjXXwT6A4TRD9+vUB+4RWVZM74zjXtenZxWwYiVFq2++QeYTnP8QsMXGim
	 MrUHf1C0k6UHekNjryd3RioJfeb4nCEWbm/kC7sgslEA63z70AU4FKumm2yo2weBe9Rvd
	 RfgeTTP4N14MJwwAlcAHhY1Dq5qZrquJezb9XGmYancAIJlncDsvevzozMZM9fo2Kww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795541014;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=nSfOtE8fwZLmPstMRmsRS1s4vN6KPHlVbKsOQ/PuqVg=;
	b=ASQeDgCBHZk8JZFeK6O/b06Y4CrjY5Zb3l/LE09SIEiKobwaTbpxzbXBlM9nCRbJ6G4n
	 wXBfkWcw+ku3dKMJdlFQ2ZBQ5tiM0zY2rqGWGF4P2/KKdXj17i2hPvfJj4ppJIeau9FkD
	 whG7ODczx2VFK1r6Ft5suTTgXkAW8NiOPY24s22BdboA23fjQnvfuyLTgBE0pUpkwE7M6
	 FULbqPHHSuY9tNr/67ApWWbzEA2Hd/mvbgAfJ+JrPsdlt0nvtOnAtGf3sapeeeS3I6Ybs
	 q1x7G2YDc0Hgu0l+oaHukzeekc1a0mthM4eAH5Ak66kcujov5sI9EIXTbjTJZ3y392g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=kqT3FQyy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31128606A32A
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 17:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=kqT3FQyy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4061F000C4;
	Tue, 24 Nov 2026 17:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795541013;
	bh=nSfOtE8fwZLmPstMRmsRS1s4vN6KPHlVbKsOQ/PuqVg=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=kqT3FQyyIc25DeT5uTN+WwwZrWuAWYfuhzlJEQVcg8Q1b7kfKp16S4WmQfZtp1MzN
	 77FOrjX7aW+1UdYJrKVAkGEXRLnFAdZFa9Svx2Lw+Giuwl3+KiuvVqf0W9lqI2SX5I
	 yoI7wHWnF9JWj3IMvi+neM3zWw2vQt94AKUQRDaY=
Date: Tue, 24 Nov 2026 09:23:32 -0800
To: mm-commits@vger.kernel.org,lianux.mm@gmail.com,jm5905938@gmail.com,
	sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124153636.91854-15-sj@kernel.org>
References: <20261124153636.91854-15-sj@kernel.org>
Subject: + mm-damon-paddr-support-report_made-type-probe-filter.patch added to mm-new branch
Message-Id: <20261124172333.4B4061F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/paddr: support REPORT_MADE type probe filter
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-paddr-support-report_made-type-probe-filter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-support-report_made-type-probe-filter.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: SJ Park <sj@kernel.org>
Subject: mm/damon/paddr: support REPORT_MADE type probe filter
Date: Tue, 24 Nov 2026 07:36:20 -0800

Add a support of DAMON_FILTER_TYPE_REPORT_MADE type probe filter to the
physical address space operation set.  Use the DAMON core API function,
damon_report_exist() for the core report search functionality.  Set the
time range as the last sampling interval.  Pass damon_ctx to the filter
matching function for getting the sampling interval.

Link: https://patch.msgid.link/20261124153636.91854-15-sj@kernel.org
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Lian Wang <lianux.mm@gmail.com>
Cc: Aveline Noir <jm5905938@gmail.com>

 mm/damon/paddr.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-support-report_made-type-probe-filter
+++ a/mm/damon/paddr.c
@@ -140,9 +140,10 @@ static void damon_pa_prep_probes(struct
 }
 
 static bool damon_pa_filter_match(struct damon_filter *filter,
-		struct folio *folio)
+		struct folio *folio, phys_addr_t pa, struct damon_ctx *ctx)
 {
 	bool matched = false;
+	struct damon_addr_range addr_range;
 
 	switch (filter->type) {
 	case DAMON_FILTER_TYPE_PGIDLE_UNSET:
@@ -157,19 +158,27 @@ static bool damon_pa_filter_match(struct
 		else
 			matched = damon_folio_young(folio) == false;
 		break;
+	case DAMON_FILTER_TYPE_REPORT_MADE:
+		addr_range.start = damon_pa_core_addr(pa, ctx->addr_unit);
+		addr_range.end = addr_range.start + 1;
+		matched = damon_report_exist(filter->report_type, &addr_range,
+				jiffies -
+				usecs_to_jiffies(ctx->attrs.sample_interval));
+		break;
 	default:
 		return damon_ops_filter_match(filter, folio);
 	}
 	return matched == filter->matching;
 }
 
-static bool damon_pa_filter_pass(struct folio *folio, struct damon_probe *p)
+static bool damon_pa_filter_pass(struct folio *folio, struct damon_probe *p,
+		phys_addr_t pa, struct damon_ctx *ctx)
 {
 	struct damon_filter *f;
 	bool pass = true;
 
 	damon_for_each_filter(f, p) {
-		if (damon_pa_filter_match(f, folio)) {
+		if (damon_pa_filter_match(f, folio, pa, ctx)) {
 			pass = f->allow;
 			break;
 		}
@@ -199,7 +208,7 @@ static unsigned int damon_pa_apply_probe
 					ctx->addr_unit);
 			folio = damon_get_folio(PHYS_PFN(pa));
 			damon_for_each_probe(p, ctx) {
-				if (damon_pa_filter_pass(folio, p))
+				if (damon_pa_filter_pass(folio, p, pa, ctx))
 					r->probe_hits[i]++;
 				i++;
 			}
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-copy-only-installed-probe-in-damon_split_region_at.patch
mm-damon-core-add-damos_filter_type_age_ms.patch
mm-damon-sysfs-schemes-support-damos_filter_type_age_ms.patch
docs-mm-damon-design-update-for-age_ms-damos-core-filter-type.patch
docs-admin-guide-mm-damon-usage-update-for-age_ms-damos-core-filter.patch
mm-damon-api-define-damon_filter_type_active.patch
mm-damon-ops-common-implement-damon_filter_type_active-operation.patch
mm-damon-sysfs-support-lru-activeness-based-damon-filter-setup.patch
docs-mm-damon-design-update-for-damon_filter_type_active.patch
maintainers-change-damon-scm-tree-to-mm-damongit.patch
docs-mm-damon-maintainer-profile-use-damongit-for-patch-baselines.patch
docs-mm-damon-maintainer-profile-drop-scm-trees-section.patch
docs-mm-damon-maintainer-profile-update-key-cycle-dates-for-damongit.patch
mm-damon-api-introduce-struct-damon_report.patch
mm-damon-core-implement-data-attribute-report-queue.patch
mm-damon-core-introduce-damon_submit_report.patch
mm-damon-sysfs-add-admin-reports-directory.patch
mm-damon-sysfs-add-reports-producers-directory.patch
mm-damon-sysfs-add-producers-nr_producers-file.patch
mm-damon-sysfs-implement-report-producer-directory.patch
mm-damon-sysfs-implement-report-producer-type-and-state-files.patch
docs-mm-damon-design-update-for-report-system.patch
docs-admin-guide-mm-damon-usage-update-for-report-producer-sysfs.patch
docs-abi-damon-update-for-report-producer-sysfs-files.patch
mm-damon-core-introduce-damon_filter_type_report_made.patch
mm-damon-core-introduce-damon_report_exist.patch
mm-damon-paddr-support-report_made-type-probe-filter.patch
mm-damon-sysfs-add-filter_report_type-file-under-probe-filter-directory.patch
mm-damon-sysfs-support-report_made-type-probe-filter-setup.patch
docs-mm-damon-design-update-for-report_made-probe-filter-type.patch
docs-admin-guide-mm-damon-usage-update-for-report_made-probe-filter.patch
docs-abi-damon-update-for-report_made-probe-filter.patch
mm-damon-api-introduce-user_report-report-type.patch
mm-damon-sysfs-add-user_report-support-for-report-type-input.patch
mm-damon-sysfs-implement-report-producer-addr_startend-files.patch
mm-damon-sysfs-implement-submit-command-for-report-producer.patch
selftests-damon-sysfssh-add-basic-tests-for-admin-reports.patch
docs-mm-damon-design-update-for-user-report-support.patch
docs-admin-guide-mm-damon-usage-update-for-user_report-report-support.patch
docs-abi-damon-update-for-user_report-report-support.patch

