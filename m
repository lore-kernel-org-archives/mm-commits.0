Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12237E5
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 00:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708387704; cv=none; b=GAaNZQYMAPmLusU1X8jYW4LHQmf+2As9noVssD7BmWiKtGtPBLTsw3PMCJnfzypMWZpbXDP8KA6YXJWnYAiiDLkWzDBlwwhO9zwI/vjz+Fdh5miY9Aj2B5p+95LY9m482yocTRflwe9mtfVaCU1mrx/0yRQb/xDChpn+VLTfuIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708387704; c=relaxed/simple;
	bh=mv4hkg7us0BZHG59zJUhgoYWPBsPmv7rajJUTIImOYk=;
	h=Date:To:From:Subject:Message-Id; b=BXJvcADHWqaFfjIG2CSM7EZUg2s/aBMb7bgEPY+OW3RWH4G9PtZIdPyKCSh3N8BjMHHF1c/gU/AGu7k4F1CFDCbWAYmxZkFnRSs/ge4knsm2HXF1wbz2vc4YgHCHqYpr67eSR/OMbnuqTYUxOtDePnqanTSdZofR0EVGxf6cY20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c8+k2ksf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c8+k2ksf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B92CC433C7;
	Tue, 20 Feb 2024 00:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708387704;
	bh=mv4hkg7us0BZHG59zJUhgoYWPBsPmv7rajJUTIImOYk=;
	h=Date:To:From:Subject:From;
	b=c8+k2ksfxPAuseotfwhIbWbOuqJ2k6jkHbderkqrnxDsTNGvRrczOUCZbJvcTvOx/
	 N5to6Ka/T824hDlgLaVFKbkIi+sZfey44vYLXpkVErDddhPurFSEETeASbMHu+JL1U
	 GF2Ky1GXwkru1gfXm6mpAydLvd/bzsuEnKpDzzvU=
Date: Mon, 19 Feb 2024 16:08:23 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-implement-a-kdamond-command-for-updating-schemes-effective-quotas.patch added to mm-unstable branch
Message-Id: <20240220000824.6B92CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: implement a kdamond command for updating schemes' effective quotas
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-implement-a-kdamond-command-for-updating-schemes-effective-quotas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-implement-a-kdamond-command-for-updating-schemes-effective-quotas.patch

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
Subject: mm/damon/sysfs: implement a kdamond command for updating schemes' effective quotas
Date: Mon, 19 Feb 2024 11:44:14 -0800

Implement yet another kdamond 'state' file input command, namely
'update_schemes_effective_quotas'.  If it is written, the
'effective_bytes' files of the kdamond will be updated to provide the
current effective size quota of each scheme in bytes.

Link: https://lkml.kernel.org/r/20240219194431.159606-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-common.h  |    4 ++++
 mm/damon/sysfs-schemes.c |   20 ++++++++++++++++++++
 mm/damon/sysfs.c         |   32 ++++++++++++++++++++++++++++++++
 3 files changed, 56 insertions(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-implement-a-kdamond-command-for-updating-schemes-effective-quotas
+++ a/mm/damon/sysfs.c
@@ -1020,6 +1020,11 @@ enum damon_sysfs_cmd {
 	 */
 	DAMON_SYSFS_CMD_CLEAR_SCHEMES_TRIED_REGIONS,
 	/*
+	 * @DAMON_SYSFS_CMD_UPDATE_SCHEMES_EFFECTIVE_QUOTAS: Update the
+	 * effective size quota of the scheme in bytes.
+	 */
+	DAMON_SYSFS_CMD_UPDATE_SCHEMES_EFFECTIVE_QUOTAS,
+	/*
 	 * @NR_DAMON_SYSFS_CMDS: Total number of DAMON sysfs commands.
 	 */
 	NR_DAMON_SYSFS_CMDS,
@@ -1035,6 +1040,7 @@ static const char * const damon_sysfs_cm
 	"update_schemes_tried_bytes",
 	"update_schemes_tried_regions",
 	"clear_schemes_tried_regions",
+	"update_schemes_effective_quotas",
 };
 
 /*
@@ -1376,6 +1382,29 @@ static int damon_sysfs_commit_schemes_qu
 }
 
 /*
+ * damon_sysfs_upd_schemes_effective_quotas() - Update schemes effective quotas
+ * sysfs files.
+ * @kdamond:	The kobject wrapper that associated to the kdamond thread.
+ *
+ * This function reads the schemes' effective quotas of specific kdamond and
+ * update the related values for sysfs files.  This function should be called
+ * from DAMON callbacks while holding ``damon_syfs_lock``, to safely access the
+ * DAMON contexts-internal data and DAMON sysfs variables.
+ */
+static int damon_sysfs_upd_schemes_effective_quotas(
+		struct damon_sysfs_kdamond *kdamond)
+{
+	struct damon_ctx *ctx = kdamond->damon_ctx;
+
+	if (!ctx)
+		return -EINVAL;
+	damos_sysfs_update_effective_quotas(
+			kdamond->contexts->contexts_arr[0]->schemes, ctx);
+	return 0;
+}
+
+
+/*
  * damon_sysfs_cmd_request_callback() - DAMON callback for handling requests.
  * @c:		The DAMON context of the callback.
  * @active:	Whether @c is not deactivated due to watermarks.
@@ -1437,6 +1466,9 @@ static int damon_sysfs_cmd_request_callb
 	case DAMON_SYSFS_CMD_CLEAR_SCHEMES_TRIED_REGIONS:
 		err = damon_sysfs_clear_schemes_regions(kdamond);
 		break;
+	case DAMON_SYSFS_CMD_UPDATE_SCHEMES_EFFECTIVE_QUOTAS:
+		err = damon_sysfs_upd_schemes_effective_quotas(kdamond);
+		break;
 	default:
 		break;
 	}
--- a/mm/damon/sysfs-common.h~mm-damon-sysfs-implement-a-kdamond-command-for-updating-schemes-effective-quotas
+++ a/mm/damon/sysfs-common.h
@@ -61,3 +61,7 @@ int damon_sysfs_schemes_clear_regions(
 
 void damos_sysfs_set_quota_scores(struct damon_sysfs_schemes *sysfs_schemes,
 		struct damon_ctx *ctx);
+
+void damos_sysfs_update_effective_quotas(
+		struct damon_sysfs_schemes *sysfs_schemes,
+		struct damon_ctx *ctx);
--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-implement-a-kdamond-command-for-updating-schemes-effective-quotas
+++ a/mm/damon/sysfs-schemes.c
@@ -1930,6 +1930,26 @@ void damos_sysfs_set_quota_scores(struct
 	}
 }
 
+void damos_sysfs_update_effective_quotas(
+		struct damon_sysfs_schemes *sysfs_schemes,
+		struct damon_ctx *ctx)
+{
+	struct damos *scheme;
+	int schemes_idx = 0;
+
+	damon_for_each_scheme(scheme, ctx) {
+		struct damon_sysfs_quotas *sysfs_quotas;
+
+		/* user could have removed the scheme sysfs dir */
+		if (schemes_idx >= sysfs_schemes->nr)
+			break;
+
+		sysfs_quotas =
+			sysfs_schemes->schemes_arr[schemes_idx++]->quotas;
+		sysfs_quotas->effective_sz = scheme->quota.esz;
+	}
+}
+
 static struct damos *damon_sysfs_mk_scheme(
 		struct damon_sysfs_scheme *sysfs_scheme)
 {
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-check-apply-interval-in-damon_do_apply_schemes.patch
mm-damon-sysfs-schemes-handle-schemes-sysfs-dir-removal-before-commit_schemes_quota_goals.patch
mm-damon-reclaim-fix-quota-stauts-loss-due-to-online-tunings.patch
mm-damon-lru_sort-fix-quota-status-loss-due-to-online-tunings.patch
docs-admin-guide-mm-damon-usage-use-sysfs-interface-for-tracepoints-example.patch
mm-damon-rename-config_damon_dbgfs-to-damon_dbgfs_deprecated.patch
mm-damon-dbgfs-implement-deprecation-notice-file.patch
mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro.patch
docs-admin-guide-mm-damon-usage-document-deprecated-file-of-damon-debugfs-interface.patch
selftets-damon-prepare-for-monitor_on-file-renaming.patch
mm-damon-dbgfs-rename-monitor_on-file-to-monitor_on_deprecated.patch
docs-admin-guide-mm-damon-usage-update-for-monitor_on-renaming.patch
docs-translations-damon-usage-update-for-monitor_on-renaming.patch
mm-damon-sysfs-handle-state-file-inputs-for-every-sampling-interval-if-possible.patch
selftests-damon-_damon_sysfs-support-damos-quota.patch
selftests-damon-_damon_sysfs-support-damos-stats.patch
selftests-damon-_damon_sysfs-support-damos-apply-interval.patch
selftests-damon-add-a-test-for-damos-quota.patch
selftests-damon-add-a-test-for-damos-apply-intervals.patch
selftests-damon-add-a-test-for-a-race-between-target_ids_read-and-dbgfs_before_terminate.patch
selftests-damon-add-a-test-for-the-pid-leak-of-dbgfs_target_ids_write.patch
selftests-damon-_chk_dependency-get-debugfs-mount-point-from-proc-mounts.patch
docs-mm-damon-maintainer-profile-fix-reference-links-for-mm-stable-tree.patch
docs-mm-damon-move-the-list-of-damos-actions-to-design-doc.patch
docs-mm-damon-move-damon-operation-sets-list-from-the-usage-to-the-design-document.patch
docs-mm-damon-move-monitoring-target-regions-setup-detail-from-the-usage-to-the-design-document.patch
docs-admin-guide-mm-damon-usage-fix-wrong-quotas-diabling-condition.patch
mm-damon-core-set-damos_quota-esz-as-public-field-and-document.patch
mm-damon-sysfs-schemes-implement-quota-effective_bytes-file.patch
mm-damon-sysfs-implement-a-kdamond-command-for-updating-schemes-effective-quotas.patch
docs-abi-damon-document-effective_bytes-sysfs-file.patch
docs-admin-guide-mm-damon-usage-document-effective_bytes-file.patch
mm-damon-move-comments-and-fields-for-damos-quota-prioritization-to-the-end.patch
mm-damon-core-split-out-quota-goal-related-fields-to-a-struct.patch
mm-damon-core-add-multiple-goals-per-damos_quota-and-helpers-for-those.patch
mm-damon-sysfs-use-only-quota-goals.patch
mm-damon-core-remove-goal-field-of-damos_quota.patch
mm-damon-core-let-goal-specified-with-only-target-and-current-values.patch
mm-damon-core-support-multiple-metrics-for-quota-goal.patch
mm-damon-core-implement-psi-metric-damos-quota-goal.patch
mm-damon-sysfs-schemes-support-psi-based-quota-auto-tune.patch
docs-mm-damon-design-document-quota-goal-self-tuning.patch
docs-abi-damon-document-quota-goal-metric-file.patch
docs-admin-guide-mm-damon-usage-document-quota-goal-metric-file.patch
mm-damon-reclaim-implement-user-feedback-driven-quota-auto-tuning.patch
mm-damon-reclaim-implement-memory-psi-driven-quota-self-tuning.patch
docs-admin-guide-mm-damon-reclaim-document-auto-tuning-parameters.patch

