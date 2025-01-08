Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C5019DFA7
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 03:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736308487; cv=none; b=e7W+HY6I8FhnSKi0kin2eY/D+TLAHbr/MlIXbWNVw7Uk9EfyMlJuocZHbRIFPrSuQF5snio/XrNFizZL+RpRapNQn42tVXW+fQ6LWtW6E0Qpac+1IzQjtkrc8SkXB69a5igXmHKDThwNXYmW064EXTD13/e5Pz1YhmAY/hpVSM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736308487; c=relaxed/simple;
	bh=SsDXolDC6+3sfptg0YJbQ1ZZSXiUn+T0Xdh2njZH7iQ=;
	h=Date:To:From:Subject:Message-Id; b=D7xds5+KhHHe+sUWoxWrcufnt3OpuInsoMkbIpreQbsi4OM9qQ71DOEZxwFmc9DR/V9CwcoiPyqxYgKFjdW/4OyxRT6uM+iokbZHqgWOUnCtzchM4d6nf9U/BV4dZrWWfXMCCJpxKeGetoqkCBve1o2c+LaTI63nvOqltiyKe2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HFfFi7gy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HFfFi7gy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0C6C4CED0;
	Wed,  8 Jan 2025 03:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736308487;
	bh=SsDXolDC6+3sfptg0YJbQ1ZZSXiUn+T0Xdh2njZH7iQ=;
	h=Date:To:From:Subject:From;
	b=HFfFi7gy2VibUeqon0eZsUzOZOk1uPLwfsdxA+5ycOCxTw9ZCeaW8k7YRpp1yTj71
	 /WymIj8olGbgSoEbDEdu4noooBHB9il6CQaruNzgJYuDSMoyNi7T7vVU7wfsKWhUWo
	 EGnx20zbRmkqaRKtZlnOY8NF0XU0IgCn0KS+I+cU=
Date: Tue, 07 Jan 2025 19:54:47 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-fixup-damos_filter-kernel-doc.patch added to mm-unstable branch
Message-Id: <20250108035447.9F0C6C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: fixup damos_filter kernel-doc
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-fixup-damos_filter-kernel-doc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-fixup-damos_filter-kernel-doc.patch

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
Subject: mm/damon: fixup damos_filter kernel-doc
Date: Tue, 7 Jan 2025 12:17:30 -0800

Patch series "mm/damon: extend DAMOS filters for inclusion".

DAMOS fitlers are exclusive filters.  It only excludes memory of given
criterias from the DAMOS action targets.  This has below limitations.

First, the name is not explicitly explaining the behavior.  This actually
resulted in users' confusions[1].  Secondly, combined uses of multiple
filters provide restriced coverages.  For example, building a DAMOS scheme
that applies the action to memory that belongs to cgroup A "or" cgroup B
is impossible.  A workaround would be using two schemes that fitlers out
memory that not belong to cgroup A and cgroup B, respectively.  It is
cumbersome, and difficult to control quota-like per-scheme features in
orchastration.  Monitoring of filter-passed memory statistic will also be
complicated.

Extend DAMOS filters to support not only exclusion (blocking), but also
inclusion (pass-through) behavior.  For this, add a new damos_filter
struct field called 'pass' for DAMON kernel API users.  The filter works
as an inclusion filter or an exclusion filter when it is set or unset,
respectively.  For DAMON user-space ABI users, add a DAMON sysfs file of
same name under DAMOS filter sysfs directory.  To prevent exposing a
behavioral change to old users, set the blocking as the default behavior.

Note that pass filters work for only inclusion, not exclusion of memory
that not satisfying the criteria.  And the default behavior of DAMOS for
memory that no filter has involved is that the action can be applied to
those.  This means that installing pass filters without block filters
after them is not useful for some usecases.  Read the design document
update part of this patch series for more details.

[1] https://lore.kernel.org/20240320165619.71478-1-sj@kernel.org


This patch (of 10):

The comment is slightly wrong.  DAMOS filters are not only for pages, but
general bytes of memory.  Also the description of 'matching' is bit
confusing, since DAMOS filters do only filtering out.  Update the comments
to be less confusing.

Link: https://lkml.kernel.org/r/20250107201739.79484-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250107201739.79484-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/include/linux/damon.h~mm-damon-fixup-damos_filter-kernel-doc
+++ a/include/linux/damon.h
@@ -347,8 +347,8 @@ enum damos_filter_type {
 
 /**
  * struct damos_filter - DAMOS action target memory filter.
- * @type:	Type of the page.
- * @matching:	If the matching page should filtered out or in.
+ * @type:	Type of the target memory.
+ * @matching:	If the @type-matching memory should be filtered out.
  * @memcg_id:	Memcg id of the question if @type is DAMOS_FILTER_MEMCG.
  * @addr_range:	Address range if @type is DAMOS_FILTER_TYPE_ADDR.
  * @target_idx:	Index of the &struct damon_target of
@@ -357,9 +357,10 @@ enum damos_filter_type {
  * @list:	List head for siblings.
  *
  * Before applying the &damos->action to a memory region, DAMOS checks if each
- * page of the region matches to this and avoid applying the action if so.
- * Support of each filter type depends on the running &struct damon_operations
- * and the type.  Refer to &enum damos_filter_type for more detai.
+ * byte of the region matches to this given condition and avoid applying the
+ * action if so.  Support of each filter type depends on the running &struct
+ * damon_operations and the type.  Refer to &enum damos_filter_type for more
+ * details.
  */
 struct damos_filter {
 	enum damos_filter_type type;
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

