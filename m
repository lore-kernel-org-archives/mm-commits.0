Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2750218ABA
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188539; cv=none; b=D63yDxBMUGJCcdVdsV/OGhujm/rtx2eY7lVF2iJVgmumxIQnnMqIO5z7amYxaTRi0+hPQfuGUdfoTfzKyOtPkwvkz2b/jUJy45FZzUURGX/Puby5e4mbSUzlfa2fuoF0iYg7bv56OXDEFjdcnWLFq+jW6x3+wis9Zb17uenZpI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188539; c=relaxed/simple;
	bh=TfoU+KJWRTQWNiojqdyxZbqgZm9liOevcxDJA3G94CI=;
	h=Date:To:From:Subject:Message-Id; b=Fzgcs+LF7CjUeZsuEOQvGhicSObCW5eL2jELveilTI43CxNcnWwdsqpbyYEKydEWuHPsQ9JMiyh8qtTyNTkmF3Hk2ehEkk4rzkxxCWep4YZBzxNDlwp0kWqFKl46IVq6VmsAD7v0YPc/N2O+pe7cp7kiof8WghwDS2Uo0FO4fVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DlBzB88c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DlBzB88c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971DAC4CEED;
	Mon, 17 Mar 2025 05:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188539;
	bh=TfoU+KJWRTQWNiojqdyxZbqgZm9liOevcxDJA3G94CI=;
	h=Date:To:From:Subject:From;
	b=DlBzB88cZN521XpZONQ9iVnf777CcOTAt9yrZYOhWVT5EBAPEEuD6X7J9UCvJFa6i
	 kG5a2Xs0BcdvhJyueP5/aXUXs1tpDuZRtJFQCNnphjA1no1tMdChJxOdE+Wbn96SnO
	 U6Dj3l+478QF27TqfUSu7nBjdhmHib0hCZ69N0ZQ=
Date: Sun, 16 Mar 2025 22:15:39 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-put-ops-handled-filters-to-damos-ops_filters.patch removed from -mm tree
Message-Id: <20250317051539.971DAC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: put ops-handled filters to damos->ops_filters
has been removed from the -mm tree.  Its filename was
     mm-damon-core-put-ops-handled-filters-to-damos-ops_filters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: put ops-handled filters to damos->ops_filters
Date: Tue, 4 Mar 2025 13:19:08 -0800

damos->ops_filters has introduced to be used for all operations layer
handled filters.  But DAMON kernel API callers can put any type of DAMOS
filters to any of damos->filters and damos->ops_filters.  DAMON user-space
ABI users have no way to use ->ops_filters at all.  Update
damos_add_filter(), which should be used by API callers to install DAMOS
filters, to add filters to ->filters and ->ops_filters depending on their
handling layer.  The change forces both API callers and ABI users to use
proper lists since ABI users use the API internally.

Link: https://lkml.kernel.org/r/20250304211913.53574-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-put-ops-handled-filters-to-damos-ops_filters
+++ a/mm/damon/core.c
@@ -281,9 +281,24 @@ struct damos_filter *damos_new_filter(en
 	return filter;
 }
 
+static bool damos_filter_for_ops(enum damos_filter_type type)
+{
+	switch (type) {
+	case DAMOS_FILTER_TYPE_ADDR:
+	case DAMOS_FILTER_TYPE_TARGET:
+		return false;
+	default:
+		break;
+	}
+	return true;
+}
+
 void damos_add_filter(struct damos *s, struct damos_filter *f)
 {
-	list_add_tail(&f->list, &s->filters);
+	if (damos_filter_for_ops(f->type))
+		list_add_tail(&f->list, &s->ops_filters);
+	else
+		list_add_tail(&f->list, &s->filters);
 }
 
 static void damos_del_filter(struct damos_filter *f)
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

