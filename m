Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF4D198A2F
	for <mm-commits@vger.kernel.org>; Mon,  3 Mar 2025 22:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741041121; cv=none; b=ALoABXNDIPIiTqIX/qFQhHZIEXjmufgQG5ynpg46PLlo/lziadPS8q95yB1atIJKrlUXDmOB/6LwiBcj/Ryxzdw1lt9zufJ0jVG96cfeKZSgy3/JRW1pguxpnhF3J5pchmy4NMaLL0mFUidOZ5vwCGC20YeSroworQaFcQd8tKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741041121; c=relaxed/simple;
	bh=s8iLeZ/FZUlsi1ucaTd/6VA9SNIk2S8czV/std5FEe4=;
	h=Date:To:From:Subject:Message-Id; b=LBq+gCreOzwLHzYdW1sZ92sgln98KfY74h2dOSvjTIpWMtqisGiean6FSVtbp/uPKB4ojgrFq2pZGVYrjmdDezzkneZv0LncsbWVKjPRr2j66B6NlSVYGrV5AqX3Srew+kkqImJXG+imLgpTVN4/lyAhE/8avcAQDcNIV9SV4+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=INKlKsvM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="INKlKsvM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1132C4CED6;
	Mon,  3 Mar 2025 22:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741041120;
	bh=s8iLeZ/FZUlsi1ucaTd/6VA9SNIk2S8czV/std5FEe4=;
	h=Date:To:From:Subject:From;
	b=INKlKsvMQ9WIIBE1HIowkSTiVeoCZ7XILoX5OxH6v+PFX9MKAy9lasJxFVMZDn6ju
	 HKBYX/f1FUIGOItmpVAK7qxNL0d61astyEmc432q0IAbDSJ/yp1u6SDJgeUH880YWJ
	 Z5XHHHQHeYP+I4H1Kzg0SuLWaXUytfSJhYzSNSOI=
Date: Mon, 03 Mar 2025 14:32:00 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-implement-a-command-to-update-auto-tuned-monitoring-intervals.patch added to mm-unstable branch
Message-Id: <20250303223200.C1132C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: implement a command to update auto-tuned monitoring intervals
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-implement-a-command-to-update-auto-tuned-monitoring-intervals.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-implement-a-command-to-update-auto-tuned-monitoring-intervals.patch

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
Subject: mm/damon/sysfs: implement a command to update auto-tuned monitoring intervals
Date: Mon, 3 Mar 2025 14:17:23 -0800

DAMON kernel API callers can show auto-tuned sampling and aggregation
intervals from the monmitoring attributes data structure.  That can be
useful for debugging or tuning of the feature.  DAMON user-space ABI users
has no way to see that, though.  Implement a new DAMON sysfs interface
command, namely 'update_tuned_intervals', for the purpose.  If the command
is written to the kdamond state file, the tuned sampling and aggregation
intervals will be updated to the corresponding sysfs interface files.

Link: https://lkml.kernel.org/r/20250303221726.484227-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-implement-a-command-to-update-auto-tuned-monitoring-intervals
+++ a/mm/damon/sysfs.c
@@ -1214,6 +1214,11 @@ enum damon_sysfs_cmd {
 	 */
 	DAMON_SYSFS_CMD_UPDATE_SCHEMES_EFFECTIVE_QUOTAS,
 	/*
+	 * @DAMON_SYSFS_CMD_UPDATE_TUNED_INTERVALS: Update the tuned monitoring
+	 * intevals.
+	 */
+	DAMON_SYSFS_CMD_UPDATE_TUNED_INTERVALS,
+	/*
 	 * @NR_DAMON_SYSFS_CMDS: Total number of DAMON sysfs commands.
 	 */
 	NR_DAMON_SYSFS_CMDS,
@@ -1230,6 +1235,7 @@ static const char * const damon_sysfs_cm
 	"update_schemes_tried_regions",
 	"clear_schemes_tried_regions",
 	"update_schemes_effective_quotas",
+	"update_tuned_intervals",
 };
 
 /*
@@ -1502,6 +1508,17 @@ static int damon_sysfs_upd_schemes_effec
 	return 0;
 }
 
+static int damon_sysfs_upd_tuned_intervals(void *data)
+{
+	struct damon_sysfs_kdamond *kdamond = data;
+	struct damon_ctx *ctx = kdamond->damon_ctx;
+
+	kdamond->contexts->contexts_arr[0]->attrs->intervals->sample_us =
+		ctx->attrs.sample_interval;
+	kdamond->contexts->contexts_arr[0]->attrs->intervals->aggr_us =
+		ctx->attrs.aggr_interval;
+	return 0;
+}
 
 /*
  * damon_sysfs_cmd_request_callback() - DAMON callback for handling requests.
@@ -1723,6 +1740,9 @@ static int damon_sysfs_handle_cmd(enum d
 		return damon_sysfs_damon_call(
 				damon_sysfs_upd_schemes_effective_quotas,
 				kdamond);
+	case DAMON_SYSFS_CMD_UPDATE_TUNED_INTERVALS:
+		return damon_sysfs_damon_call(
+				damon_sysfs_upd_tuned_intervals, kdamond);
 	default:
 		break;
 	}
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-damos_quota_goal-handle-minimum-quota-that-cannot-be-further-reduced.patch
selftests-damon-damos_quota-make-real-expectation-of-quota-exceeds.patch
selftests-damon-damon_nr_regions-set-ops-update-for-merge-results-check-to-100ms.patch
selftests-damon-damon_nr_regions-sort-collected-regiosn-before-checking-with-min-max-boundaries.patch
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

