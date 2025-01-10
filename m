Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152B24C92
	for <mm-commits@vger.kernel.org>; Fri, 10 Jan 2025 00:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736467845; cv=none; b=f6/E32rAuS7cAs8T1iy/6KUVA1fnlXPyY6KJk3HPSlOon0YBtvOx1j2OsH8sYG7LL2B2LVWvOK1xmQnYkORD6VU001w1TX9hLLTmA4c7TlD6YN9tUDiEuhOOt/AUyEYzbsXKEZTTq2AWJl2zPyjXWb1FpRLqRLaWsIAk+Dqbn5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736467845; c=relaxed/simple;
	bh=Nhtl+hj+S/FWXl1m/JpSpMncDjS0PhpzZpG/fi6cl2o=;
	h=Date:To:From:Subject:Message-Id; b=lpR44kFms8N5ZXXb417jBaO4F1kkF8qje2rA8hT9cF1RFJBtvFFgYHbUavzVQj79J44moow4TkWpgkoxBug5/0j2XHNapqtvrJQPlSYNvx12CJ2JcmWNpWmo8RuqbqEKAttW6JcRf1nwD8hz6i2dNa7+AbskPmIiBr/2/h4KCC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E2V/gPBR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E2V/gPBR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1659C4CED2;
	Fri, 10 Jan 2025 00:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736467844;
	bh=Nhtl+hj+S/FWXl1m/JpSpMncDjS0PhpzZpG/fi6cl2o=;
	h=Date:To:From:Subject:From;
	b=E2V/gPBRUZUHr2vUlWy7D9mNCGyiRhKLEmMd9jLa9opd97ctURPMSxwTig895ZxTA
	 GJUwNUKOb1OBPgPh1bl0hdeLaNpwQe0Hus34wE/ReG8zVQcqUgs+4BJToswNUduDom
	 N3+I1NmE/HsQDfPn9x1Y5cC/inWR0/LldBqSj3eY=
Date: Thu, 09 Jan 2025 16:10:44 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-add-damos_filter-allow-field.patch added to mm-unstable branch
Message-Id: <20250110001044.B1659C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: add damos_filter->allow field
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-add-damos_filter-allow-field.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-add-damos_filter-allow-field.patch

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
Subject: mm/damon/core: add damos_filter->allow field
Date: Thu, 9 Jan 2025 09:51:18 -0800

DAMOS filters work as only exclusive (reject) filters.  This makes it easy
to be confused, and restrictive at combining multiple filters for covering
various types of memory.

Add a field named 'allow' to damos_filter.  The field will be used to
indicate whether the filter should work for inclusion or exclusion.  To
keep the old behavior, set it as 'false' (work as exclusive filter) by
default, from damos_new_filter().

Following two commits will make the core and operations set layers, which
handles damos_filter objects, respect the field, respectively.

Link: https://lkml.kernel.org/r/20250109175126.57878-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    4 +++-
 mm/damon/core.c       |    1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/damon.h~mm-damon-core-add-damos_filter-allow-field
+++ a/include/linux/damon.h
@@ -348,7 +348,8 @@ enum damos_filter_type {
 /**
  * struct damos_filter - DAMOS action target memory filter.
  * @type:	Type of the target memory.
- * @matching:	If the @type-matching memory should be filtered out.
+ * @matching:	Whether this is for @type-matching memory.
+ * @allow:	Whether to include or exclude the @matching memory.
  * @memcg_id:	Memcg id of the question if @type is DAMOS_FILTER_MEMCG.
  * @addr_range:	Address range if @type is DAMOS_FILTER_TYPE_ADDR.
  * @target_idx:	Index of the &struct damon_target of
@@ -365,6 +366,7 @@ enum damos_filter_type {
 struct damos_filter {
 	enum damos_filter_type type;
 	bool matching;
+	bool allow;
 	union {
 		unsigned short memcg_id;
 		struct damon_addr_range addr_range;
--- a/mm/damon/core.c~mm-damon-core-add-damos_filter-allow-field
+++ a/mm/damon/core.c
@@ -275,6 +275,7 @@ struct damos_filter *damos_new_filter(en
 		return NULL;
 	filter->type = type;
 	filter->matching = matching;
+	filter->allow = false;
 	INIT_LIST_HEAD(&filter->list);
 	return filter;
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

