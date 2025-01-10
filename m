Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9E93C14
	for <mm-commits@vger.kernel.org>; Fri, 10 Jan 2025 00:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736467849; cv=none; b=sx4ZiqtFHn6LGRCmlP8/ltyszixLWv6C+H1LH3YDxDRX39zNb37qNFIJmQV3TGdcrWCQyqH1OiY3xVQv0oZHDPoCpft2KlqX9OaGlO4T8OPGDxb2p/ypf/eEfrPKVpKbC2l/+/RwU7OPh3etiTNk7EtNU5kkz8+FylGtlFJDfGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736467849; c=relaxed/simple;
	bh=5kYs6jTk6CnWK1VvCJr2heEaPLJmPYj2OhrxKQ8tnuQ=;
	h=Date:To:From:Subject:Message-Id; b=sbRlousDsB84v4VZu0xcZohLGeFD/Lru3oDTWChVjQransjLCTbvKt1HdBVwzK3WqM++UwSoEA1OCQ2xgbzPLoNoVWH4DG8wcs4+YAEuO9Pg5GiCltKLaw0UwyKUBi2qYR+B15mbcCjz24MuUYsyKX5Acvs6vU/65y/vFMerRP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WfpwChHM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WfpwChHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53233C4CED2;
	Fri, 10 Jan 2025 00:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736467849;
	bh=5kYs6jTk6CnWK1VvCJr2heEaPLJmPYj2OhrxKQ8tnuQ=;
	h=Date:To:From:Subject:From;
	b=WfpwChHMT7PmuEbec3fLWcraHOd864o4b1+/+v9054NBe6h1uDiaq/PKpS5rkYkKn
	 CJt22i4Q3+jCwx1fzvETxDAwAnyz4EBXjD/HEfRSOutB0VRBZJVgcbA8fIbzX+O8Ku
	 RTx0TtcKoRKMEVHjKyOty6RSEDPl3vMaxSsYZBzs=
Date: Thu, 09 Jan 2025 16:10:48 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-support-damos_filter-allow.patch added to mm-unstable branch
Message-Id: <20250110001049.53233C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/paddr: support damos_filter->allow
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-paddr-support-damos_filter-allow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-support-damos_filter-allow.patch

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
Subject: mm/damon/paddr: support damos_filter->allow
Date: Thu, 9 Jan 2025 09:51:20 -0800

Respect damos_filter->allow from 'paddr', which is a DAMON operations set
implementation for the physical address space and supports a few types of
region-internal DAMOS filters (anon, memcg and young).  The change is
similar to that of the previous commit for core layer update.

Link: https://lkml.kernel.org/r/20250109175126.57878-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-support-damos_filter-allow
+++ a/mm/damon/paddr.c
@@ -198,7 +198,7 @@ static unsigned int damon_pa_check_acces
 	return max_nr_accesses;
 }
 
-static bool __damos_pa_filter_out(struct damos_filter *filter,
+static bool damos_pa_filter_match(struct damos_filter *filter,
 		struct folio *folio)
 {
 	bool matched = false;
@@ -237,8 +237,8 @@ static bool damos_pa_filter_out(struct d
 	struct damos_filter *filter;
 
 	damos_for_each_filter(filter, scheme) {
-		if (__damos_pa_filter_out(filter, folio))
-			return true;
+		if (damos_pa_filter_match(filter, folio))
+			return !filter->allow;
 	}
 	return false;
 }
_

Patches currently in -mm which might be from sj@kernel.org are

samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch
samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch
samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch
samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch
samples-damon-prcl-implement-schemes-setup.patch
replace-free-hugepage-folios-after-migration-fix-2.patch
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
docs-translations-admin-guide-mm-damon-usage-remove-damon-debugfs-interface-documentation.patch
docs-admin-guide-mm-damon-usage-remove-damon-debugfs-interface-documentation.patch
docs-mm-damon-design-update-for-removal-of-damon-debugfs-interface.patch
selftests-damon-config-remove-configs-for-damon-debugfs-interface-selftests.patch
selftests-damon-remove-tests-for-damon-debugfs-interface.patch
kunit-configs-remove-configs-for-damon-debugfs-interface-tests.patch
mm-damon-remove-damon-debugfs-interface-kunit-tests.patch
mm-damon-remove-damon-debugfs-interface.patch
mm-damon-fixup-damos_filter-kernel-doc.patch
mm-damon-core-add-damos_filter-allow-field.patch
mm-damon-core-support-damos_filter-allow.patch
mm-damon-paddr-support-damos_filter-allow.patch
mm-damon-add-allow-argument-to-damos_new_filter.patch
mm-damon-sysfs-schemes-add-a-file-for-setting-damos_filter-allow.patch
docs-mm-damon-design-document-allow-reject-damos-filter-behaviors.patch
docs-abi-damon-document-damos-filter-allow-sysfs-file.patch
docs-admin-guide-mm-damon-usage-omit-damos-filter-details-in-favor-of-design-doc.patch
docs-admin-guide-mm-damon-usage-document-damos-filter-allow-sysfs-file.patch

