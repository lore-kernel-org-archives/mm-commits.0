Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4587217F55
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188503; cv=none; b=F0WApzwsXwP2twV8iKP6wb/fSCrJJoZ7KYMTAPZs7qYo6IC17/K6rnkr9fmnoUil7KiPc/DblNX9cBmOTBw0qUVZ68cETbTOI/X8RXsspqoW00c27yf6U+Lm5YAHbQi5/UuJkhDqHx9Srif/JLyZWxMXTYDrSEFU2OmKr1QzSvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188503; c=relaxed/simple;
	bh=zTEpHNnwyeRRG4+ZBrNoCUV/oJUemqP7NZgMVHbYnio=;
	h=Date:To:From:Subject:Message-Id; b=gaBn+ZCjsxyvl8OXlMdBRf78BGOebilJSa//NOXFSpYK5pKtNahxaaoi50gEyj5L7uUKvFG7LzuMmYUN2nQFFweuP12AqTbiomdrHrrfnIfMV5GJ6dS9ir9kTICD6uuEuV2szPNzF1mGDcdg1m3QCEl175t5CyimCgvuQdHcsjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fghByVXz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fghByVXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BC5C4CEEC;
	Mon, 17 Mar 2025 05:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188503;
	bh=zTEpHNnwyeRRG4+ZBrNoCUV/oJUemqP7NZgMVHbYnio=;
	h=Date:To:From:Subject:From;
	b=fghByVXzqlZTsMssHGePDIrkR/Q5YgcDzVRiM5/pzXuZTqy2Oyw3VYlSh4urA3qiT
	 QD0fdNmmGck2v64q1X3c1/wIC5NZ9TjsdcuJIOS1EaKc0T2O/tb0xAylkiaZh1zQ+0
	 1ghnaLgMjyK6zOVCa37RJ1Kynfpy5vGW+gAoGMks=
Date: Sun, 16 Mar 2025 22:15:03 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-implement-a-command-to-update-auto-tuned-monitoring-intervals.patch removed from -mm tree
Message-Id: <20250317051503.A8BC5C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: implement a command to update auto-tuned monitoring intervals
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-implement-a-command-to-update-auto-tuned-monitoring-intervals.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

