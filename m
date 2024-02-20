Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD559152E1A;
	Tue, 20 Feb 2024 22:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708467743; cv=none; b=HErutQ2+TKAijeiefdEXChQJTOznVsU2oda3yzC2NKk7m9O9SY4+Lf1yXTB1q68jNc3FVzjbTqfo4nAcXeaIpxVUxAN+0FV/bcY4xFN5YqZLf2YhD45PEpSAarudcqX7VI8YbE9PJ94r5PqRgngxI9Tz8c0T89QxpW85JR3f80E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708467743; c=relaxed/simple;
	bh=WV3q+A+JkO5e73Du6Gm4B+sLWQZVJP7qyWrhD+39YHU=;
	h=Date:To:From:Subject:Message-Id; b=klmYCX65PulDm+szqiGUVx1YWHe45+4mRR3CtLAZuv3zCIieDHullm3ypU3EcFGzC8Eb2v3ukFlgsLJqThkfZHTvT1f3CCG6D0w3QU+PU0gLsJxvojODqtVQ8qCTU+VsCh0uplakvAVn7DBDoF/Vp+1udxTsgwjYuzCij3u/Sl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ayN/h9W8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ayN/h9W8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ABDCC433F1;
	Tue, 20 Feb 2024 22:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708467743;
	bh=WV3q+A+JkO5e73Du6Gm4B+sLWQZVJP7qyWrhD+39YHU=;
	h=Date:To:From:Subject:From;
	b=ayN/h9W8he+9wUeaSkL7J3HZHgGunhhuy48zJrA9TQiyyPrkTuGM+RCCakwIxt0s5
	 zbI/or0bFlikPE5s9G4VDRKrr+piecJABXuitCljdJPL0bdiou7JyFemF+U4zAjxuw
	 CPwV+b5XUDIsA3cEHGEFXmNhpgsZ/gq5gS2b9dsM=
Date: Tue, 20 Feb 2024 14:22:22 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-core-check-apply-interval-in-damon_do_apply_schemes.patch removed from -mm tree
Message-Id: <20240220222223.3ABDCC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: check apply interval in damon_do_apply_schemes()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-check-apply-interval-in-damon_do_apply_schemes.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: check apply interval in damon_do_apply_schemes()
Date: Mon, 5 Feb 2024 12:13:06 -0800

kdamond_apply_schemes() checks apply intervals of schemes and avoid
further applying any schemes if no scheme passed its apply interval. 
However, the following schemes applying function, damon_do_apply_schemes()
iterates all schemes without the apply interval check.  As a result, the
shortest apply interval is applied to all schemes.  Fix the problem by
checking the apply interval in damon_do_apply_schemes().

Link: https://lkml.kernel.org/r/20240205201306.88562-1-sj@kernel.org
Fixes: 42f994b71404 ("mm/damon/core: implement scheme-specific apply interval")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.7.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-check-apply-interval-in-damon_do_apply_schemes
+++ a/mm/damon/core.c
@@ -1026,6 +1026,9 @@ static void damon_do_apply_schemes(struc
 	damon_for_each_scheme(s, c) {
 		struct damos_quota *quota = &s->quota;
 
+		if (c->passed_sample_intervals != s->next_apply_sis)
+			continue;
+
 		if (!s->wmarks.activated)
 			continue;
 
@@ -1176,10 +1179,6 @@ static void kdamond_apply_schemes(struct
 		if (c->passed_sample_intervals != s->next_apply_sis)
 			continue;
 
-		s->next_apply_sis +=
-			(s->apply_interval_us ? s->apply_interval_us :
-			 c->attrs.aggr_interval) / sample_interval;
-
 		if (!s->wmarks.activated)
 			continue;
 
@@ -1195,6 +1194,14 @@ static void kdamond_apply_schemes(struct
 		damon_for_each_region_safe(r, next_r, t)
 			damon_do_apply_schemes(c, t, r);
 	}
+
+	damon_for_each_scheme(s, c) {
+		if (c->passed_sample_intervals != s->next_apply_sis)
+			continue;
+		s->next_apply_sis +=
+			(s->apply_interval_us ? s->apply_interval_us :
+			 c->attrs.aggr_interval) / sample_interval;
+	}
 }
 
 /*
_

Patches currently in -mm which might be from sj@kernel.org are

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

