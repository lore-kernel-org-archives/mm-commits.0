Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8725623B0
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 03:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741057232; cv=none; b=hStWNVvdWqI7wCbdM1DwsWU5e+6qYEwGh99bxgTAL3f3Nc7RbeYCHxJMmmdfrPDGagGDlzGnllEp8FV0a50HcKQ5vi/ibuwnaUnqNmvnqsUXRSWiIKtI2z39oaFzPETrnDVpLS/0t3f0i5y25/pZdo710WKHf8XNAMtGh40wKCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741057232; c=relaxed/simple;
	bh=ETLUglWpOla+0VFNp5M5O5v8dZ8N3mrkgekH/uM+vVg=;
	h=Date:To:From:Subject:Message-Id; b=VbgkMMAsuCHpsXwPkThdr8sNZbfxHnbVGMoVPJCuU6pFX/AJ/D2RjylcaiQQYMew2HmKTvv0TiS5xQMCPHzro2YYcUBtBtwz60mNKU9Wd/t+7FmmYGj34P2Hhj+xh84WUZ+LlFCqgLjNALF6IG40bCFYLfhRwF88nURyA7yYY/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Pcm/Ngh/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pcm/Ngh/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE59C4CEE4;
	Tue,  4 Mar 2025 03:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741057232;
	bh=ETLUglWpOla+0VFNp5M5O5v8dZ8N3mrkgekH/uM+vVg=;
	h=Date:To:From:Subject:From;
	b=Pcm/Ngh/HfRJsiDpxaiDuVlzVDoR6tUxtL+L8Z8UkD1xIFgP+4nSR42nQ4hbYhb7S
	 TruI+MAoTecpsgIqnPDhpCw5mwDuaW38OZaaQZy1IX5hC6yccMhuYz9smGxVqsD9O8
	 sRoxyVoB9KMN1sdPvBObI7CQVFdD9vpw56ShqGag=
Date: Mon, 03 Mar 2025 19:00:31 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-initialize-damos-walk_completed-in-damon_new_scheme.patch added to mm-hotfixes-unstable branch
Message-Id: <20250304030031.DCE59C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: initialize damos->walk_completed in damon_new_scheme()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-initialize-damos-walk_completed-in-damon_new_scheme.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-initialize-damos-walk_completed-in-damon_new_scheme.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm/damon/core: initialize damos->walk_completed in damon_new_scheme()
Date: Fri, 28 Feb 2025 09:44:50 -0800

The function for allocating and initialize a 'struct damos' object,
damon_new_scheme(), is not initializing damos->walk_completed field.  Only
damos_walk_complete() is setting the field.  Hence the field will be
eventually set and used correctly from second damos_walk() call for the
scheme.  But the first damos_walk() could mistakenly not walk on the
regions.  Actually, a common usage of DAMOS for taking an access pattern
snapshot is installing a monitoring-purpose DAMOS scheme, doing
damos_walk() to retrieve the snapshot, and then removing the scheme. 
DAMON user-space tool (damo) also gets runtime snapshot in the way.  Hence
the problem can continuously happen in such use cases.  Initialize it
properly in the allocation function.

Link: https://lkml.kernel.org/r/20250228174450.41472-1-sj@kernel.org
Fixes: bf0eaba0ff9c ("mm/damon/core: implement damos_walk()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/core.c~mm-damon-core-initialize-damos-walk_completed-in-damon_new_scheme
+++ a/mm/damon/core.c
@@ -373,6 +373,7 @@ struct damos *damon_new_scheme(struct da
 	 * or damon_attrs are updated.
 	 */
 	scheme->next_apply_sis = 0;
+	scheme->walk_completed = false;
 	INIT_LIST_HEAD(&scheme->filters);
 	scheme->stat = (struct damos_stat){};
 	INIT_LIST_HEAD(&scheme->list);
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-damos_quota_goal-handle-minimum-quota-that-cannot-be-further-reduced.patch
selftests-damon-damos_quota-make-real-expectation-of-quota-exceeds.patch
selftests-damon-damon_nr_regions-set-ops-update-for-merge-results-check-to-100ms.patch
selftests-damon-damon_nr_regions-sort-collected-regiosn-before-checking-with-min-max-boundaries.patch
mm-damon-respect-core-layer-filters-allowance-decision-on-ops-layer.patch
mm-damon-core-initialize-damos-walk_completed-in-damon_new_scheme.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise.patch
mm-madvise-split-out-madvise-input-validity-check.patch
mm-madvise-split-out-madvise-behavior-execution.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise.patch
mm-damon-avoid-applying-damos-action-to-same-entity-multiple-times.patch
mm-damon-core-unset-damos-walk_completed-after-confimed-set.patch
mm-damon-core-do-not-call-damos_walk_control-walk-if-walk-is-completed.patch
mm-damon-core-do-damos-walking-in-entire-regions-granularity.patch
mm-damon-introduce-damos-filter-type-hugepage_size-fix.patch
docs-mm-damon-design-fix-typo-on-damos-filters-usage-doc-link.patch
docs-mm-damon-design-document-hugepage_size-filter.patch
docs-damon-move-damos-filter-type-names-and-meaning-to-design-doc.patch
docs-mm-damon-design-clarify-handling-layer-based-filters-evaluation-sequence.patch
docs-mm-damon-design-categorize-damos-filter-types-based-on-handling-layer.patch
mm-damon-implement-a-new-damos-filter-type-for-unmapped-pages.patch
docs-mm-damon-design-document-unmapped-damos-filter-type.patch
mm-damon-add-data-structure-for-monitoring-intervals-auto-tuning.patch
mm-damon-core-implement-intervals-auto-tuning.patch
mm-damon-sysfs-implement-intervals-tuning-goal-directory.patch
mm-damon-sysfs-commit-intervals-tuning-goal.patch
mm-damon-sysfs-implement-a-command-to-update-auto-tuned-monitoring-intervals.patch
docs-mm-damon-design-document-for-intervals-auto-tuning.patch
docs-abi-damon-document-intervals-auto-tuning-abi.patch
docs-admin-guide-mm-damon-usage-add-intervals_goal-directory-on-the-hierarchy.patch

