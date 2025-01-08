Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1B319DFA7
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 03:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736308489; cv=none; b=rClX5fVGgNc3DT1FkLLm4Y1PW9rTvbhLtTfMWtopehZAsYV7VGFsqMxiIEaq5OpxJnD+dBLnv7Wwo8W3XT7l+PHaM4bMX6GDKPZupWYU+bXKY1/YepGM9BxV6HEsYHed+MTQ69FZ9Ws12rZcxOmkJ8LMQYcFclMANrdZCnFUsl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736308489; c=relaxed/simple;
	bh=xgKcM9dvv6IHWQdmW/PS2t1CPW6if+MRYJk0tlOPE0s=;
	h=Date:To:From:Subject:Message-Id; b=gOUE4HhA4Ll8oLF6s+UMiBo8ev/XW+Be19p2dXphl2XxJodr1cjH2FJH6B2SNO2pQXC4JcdrboIijJ8uxteCTTyLDf//nvYnEjUr+022Xthru/plR7RVaihoh9xGZkEpnmZl0VQcJPcKdYXUkjDxvPJeZgoV2eC4+H+FSiwAHw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JQE8damS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JQE8damS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B15C4CEDD;
	Wed,  8 Jan 2025 03:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736308489;
	bh=xgKcM9dvv6IHWQdmW/PS2t1CPW6if+MRYJk0tlOPE0s=;
	h=Date:To:From:Subject:From;
	b=JQE8damS+Rja17DZhHq++XpGVK7YQqudJLL+eyTwPwnZDWWofngeI9mq/HxRapo4P
	 cUwe6zZY02UY42MjRgwb8UDRcVt7FrSUw7vcGJmKciBe+VNg/6TvcUwpmTEZ6nkKQI
	 B1wjOYYlYtjbacbV4F0Zk2ULqIqyvQ4vLP9jVLsQ=
Date: Tue, 07 Jan 2025 19:54:48 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-add-damos_filter-pass-field.patch added to mm-unstable branch
Message-Id: <20250108035449.93B15C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: add damos_filter->pass field
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-add-damos_filter-pass-field.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-add-damos_filter-pass-field.patch

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
Subject: mm/damon/core: add damos_filter->pass field
Date: Tue, 7 Jan 2025 12:17:31 -0800

DAMOS filters work as only exclusive (block) filters.  This makes it easy
to be confused, and restrictive at combining multiple filters for various
types of memory.

Add a field anmed 'pass' to damos_filter.  The field will be used to
indicate whether the filter should work for inclusion or not.

Following two commits will make the core and operations set layer, which
handles the damos_filter object, respect the field, respectively.

Link: https://lkml.kernel.org/r/20250107201739.79484-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    4 +++-
 mm/damon/core.c       |    1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/damon.h~mm-damon-core-add-damos_filter-pass-field
+++ a/include/linux/damon.h
@@ -348,7 +348,8 @@ enum damos_filter_type {
 /**
  * struct damos_filter - DAMOS action target memory filter.
  * @type:	Type of the target memory.
- * @matching:	If the @type-matching memory should be filtered out.
+ * @matching:	Whether this is for @type-matching memory.
+ * @pass:	Whether the memory should pass-through the filter.
  * @memcg_id:	Memcg id of the question if @type is DAMOS_FILTER_MEMCG.
  * @addr_range:	Address range if @type is DAMOS_FILTER_TYPE_ADDR.
  * @target_idx:	Index of the &struct damon_target of
@@ -365,6 +366,7 @@ enum damos_filter_type {
 struct damos_filter {
 	enum damos_filter_type type;
 	bool matching;
+	bool pass;
 	union {
 		unsigned short memcg_id;
 		struct damon_addr_range addr_range;
--- a/mm/damon/core.c~mm-damon-core-add-damos_filter-pass-field
+++ a/mm/damon/core.c
@@ -275,6 +275,7 @@ struct damos_filter *damos_new_filter(en
 		return NULL;
 	filter->type = type;
 	filter->matching = matching;
+	filter->pass = false;
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
mm-damon-core-add-damos_filter-pass-field.patch
mm-damon-core-support-damos_filter-pass.patch
mm-damon-paddr-support-damos_filter-pass.patch
mm-damon-add-pass-argument-to-damos_new_filter.patch
mm-damon-sysfs-schemes-add-a-file-for-setting-damos_filter-pass.patch
docs-mm-damon-design-document-pass-block-filters-behaviors.patch
docs-abi-damon-document-damos-filter-pass-sysfs-file.patch
docs-admin-guide-mm-damon-usage-omit-damos-filter-details-in-favor-of-design-doc.patch
docs-admin-guide-mm-damon-usage-document-damos-filter-pass-sysfs-file.patch

