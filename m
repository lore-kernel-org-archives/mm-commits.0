Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7C48634E
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188536; cv=none; b=Ptb98Bwanz7vIYLgTQBNx6txoH47sYPOVlUjJ8X/WS5ytE7WHpqUFxCmYr4h5PoPybss5v5mFILLY64WNGiDxhoclYtfpfiw8Q/SgMvq9gzZ0z0JwG7L2yUIBf60REd9xSubBByw6vceikhlslnsAOE1hUOCoft4clHt2CyyIwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188536; c=relaxed/simple;
	bh=he8BsGBgxVr0zK8iIo77K3xbdoZ3FpftpPMuUcW1ylQ=;
	h=Date:To:From:Subject:Message-Id; b=DXfuKTb+dKUZSDHPQhfG49LFMCijCC2n8p2eS09MBthyrdPeu0+J87UQCR91vXp6JHuSP4/YZTj5EM6OXnMRijQPekMJN2M8Cyy0T60ptMMu+WfTHZbtCaBkQ3bLYsTcQLks7dbl9MUiBBINlPkl+PxEZmzOb8xbp6HSCExSTR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ytnjsfoR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ytnjsfoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CBCC4CEEC;
	Mon, 17 Mar 2025 05:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188536;
	bh=he8BsGBgxVr0zK8iIo77K3xbdoZ3FpftpPMuUcW1ylQ=;
	h=Date:To:From:Subject:From;
	b=ytnjsfoR/2bKdgUAKjkEhasaKTFPT7x6PymYA2laYY83UGVtxkLQWgvIITWjFCmPt
	 x81GkiH20kewtoIkSzKQt6evJtHaVxe4wOeGnDKAEp+a5N+Oloq/Tq/y9T0BohHUJO
	 wY5/9XZXubscCPD0LgF2JdNkI8kB1A+vCloKzoRU=
Date: Sun, 16 Mar 2025 22:15:35 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-introduce-damos-ops_filters.patch removed from -mm tree
Message-Id: <20250317051536.71CBCC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: introduce damos->ops_filters
has been removed from the -mm tree.  Its filename was
     mm-damon-core-introduce-damos-ops_filters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: introduce damos->ops_filters
Date: Tue, 4 Mar 2025 13:19:05 -0800

Patch series "mm/damon: make allow filters after reject filters useful and
intuitive".

DAMOS filters do allow or reject elements of memory for given DAMOS scheme
only if those match the filter criterias.  For elements that don't match
any DAMOS filter, 'allowing' is the default behavior.  This makes
allow-filters that don't have any reject-filter after them meaningless
sources of overhead.  The decision was made to keep the behavior
consistent with that before the introduction of allow-filters.  This,
however, makes usage of DAMOS filters confusing and inefficient.  It is
more intuitive and still consistent behavior to reject by default unless
there is no filter at all or the last filter is a reject filter.  Update
the filtering logic in the way and update documents to clarify the
behavior.

Note that this is changing the old behavior.  But the old behavior for the
problematic filter combination was definitely confusing, inefficient and
anyway useless.  Also, the behavior has relatively recently introduced. 
It is difficult to anticipate any user that depends on the behavior. 
Hence this is not a user-breaking behavior change but an obvious
improvement.


This patch (of 9):

DAMOS filters can be categorized into two groups depending on which layer
they are handled, namely core layer and ops layer.  The groups are
important because the filtering behavior depends on evaluation sequence of
filters, and core layer-handled filters are evaluated before operations
layer-handled ones.

The behavior is clearly documented, but the implementation is bit
inefficient and complicated.  All filters are maintained in a single list
(damos->filters) in mix.  Filters evaluation logics in core layer and
operations layer iterates all the filters on the list, while skipping
filters that should be not handled by the layer of the logic.  It is
inefficient.  Making future extensions having differentiations for filters
of different handling layers will also be complicated.

Add a new list that will be used for having all operations layer-handled
DAMOS filters to DAMOS scheme data structure.  Also add the support of its
initialization and basic traversal functions.

Link: https://lkml.kernel.org/r/20250304211913.53574-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250304211913.53574-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    8 ++++++++
 mm/damon/core.c       |    1 +
 2 files changed, 9 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-introduce-damos-ops_filters
+++ a/include/linux/damon.h
@@ -448,6 +448,7 @@ struct damos_access_pattern {
  * @wmarks:		Watermarks for automated (in)activation of this scheme.
  * @target_nid:		Destination node if @action is "migrate_{hot,cold}".
  * @filters:		Additional set of &struct damos_filter for &action.
+ * @ops_filters:	ops layer handling &struct damos_filter objects list.
  * @last_applied:	Last @action applied ops-managing entity.
  * @stat:		Statistics of this scheme.
  * @list:		List head for siblings.
@@ -508,6 +509,7 @@ struct damos {
 		int target_nid;
 	};
 	struct list_head filters;
+	struct list_head ops_filters;
 	void *last_applied;
 	struct damos_stat stat;
 	struct list_head list;
@@ -858,6 +860,12 @@ static inline unsigned long damon_sz_reg
 #define damos_for_each_filter_safe(f, next, scheme) \
 	list_for_each_entry_safe(f, next, &(scheme)->filters, list)
 
+#define damos_for_each_ops_filter(f, scheme) \
+	list_for_each_entry(f, &(scheme)->ops_filters, list)
+
+#define damos_for_each_ops_filter_safe(f, next, scheme) \
+	list_for_each_entry_safe(f, next, &(scheme)->ops_filters, list)
+
 #ifdef CONFIG_DAMON
 
 struct damon_region *damon_new_region(unsigned long start, unsigned long end);
--- a/mm/damon/core.c~mm-damon-core-introduce-damos-ops_filters
+++ a/mm/damon/core.c
@@ -375,6 +375,7 @@ struct damos *damon_new_scheme(struct da
 	scheme->next_apply_sis = 0;
 	scheme->walk_completed = false;
 	INIT_LIST_HEAD(&scheme->filters);
+	INIT_LIST_HEAD(&scheme->ops_filters);
 	scheme->stat = (struct damos_stat){};
 	INIT_LIST_HEAD(&scheme->list);
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories.patch
mm-damon-sysfs-schemes-implement-core_filters-and-ops_filters-directories.patch
mm-damon-sysfs-schemes-commit-filters-in-coreops_filters-directories.patch
mm-damon-core-expose-damos_filter_for_ops-to-damon-kernel-api-callers.patch
mm-damon-sysfs-schemes-record-filters-of-which-layer-should-be-added-to-the-given-filters-directory.patch
mm-damon-sysfs-schemes-return-error-when-for-attempts-to-install-filters-on-wrong-sysfs-directory.patch
docs-abi-damon-document-coreops_filters-directories.patch
docs-admin-guide-mm-damon-usage-update-for-coreops_filters-directories.patch
mm-damon-sysfs-validate-user-inputs-from-damon_sysfs_commit_input.patch
mm-damon-core-invoke-kdamond_call-after-merging-is-done-if-possible.patch
mm-damon-core-make-damon_set_attrs-be-safe-to-be-called-from-damon_call.patch
mm-damon-sysfs-handle-commit-command-using-damon_call.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request-code-from-damon_sysfs_handle_cmd.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request_callback-and-its-callers.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request-and-its-readers.patch
mm-damon-sysfs-schemes-remove-obsolete-comment-for-damon_sysfs_schemes_clear_regions.patch
mm-damon-remove-damon_callback-private.patch
mm-damon-remove-before_start-of-damon_callback.patch
mm-damon-remove-damon_callback-after_sampling.patch
mm-damon-remove-damon_callback-before_damos_apply.patch
mm-damon-remove-damon_operations-reset_aggregated.patch
mm-damon-sysfs-schemes-avoid-wformat-security-warning-on-damon_sysfs_access_pattern_add_range_dir.patch
mm-madvise-use-is_memory_failure-from-madvise_do_behavior.patch
mm-madvise-split-out-populate-behavior-check-logic.patch
mm-madvise-deduplicate-madvise_do_behavior-skip-case-handlings.patch
mm-madvise-remove-len-parameter-of-madvise_do_behavior.patch

