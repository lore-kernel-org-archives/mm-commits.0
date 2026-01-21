Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED5129CB24
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966069; cv=none; b=LMYszr53n+Uu4JfxlUbBhwWbYmhZROnh9rTMOa0bnUI9WOIHTkCIJVecjxVpSIAUBSNd+4AG+9pa10wozZ3aSajPK0KP4mmcdnxHtPSj/nUhuiK2NcOXLDEcfUR+/yOnW47LH5fwyDExFDmAJgstmCI4OXJKIUIbUmKE+2SYF04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966069; c=relaxed/simple;
	bh=E/VAAhY/f3OYJ1LdTQEByosc0FlkS1daMzTGnky+qa4=;
	h=Date:To:From:Subject:Message-Id; b=uhAm0xJ7HXA+tBOEE/0q5YCxPx9evv65hUxXPLmRnSw+BI8OFcvAweDbE+qi1reEPEyq438R+AsycENYx4t6pV7Yelj0rSnj/Ah8sdfuUhjdNnw7xmzCvLJvh5+t8QsVDM868/CnLPIFyCD1BAUk6haC5LxrWhUUwtdY9GEOUAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aca5xUPG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aca5xUPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D44BC16AAE;
	Wed, 21 Jan 2026 03:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966068;
	bh=E/VAAhY/f3OYJ1LdTQEByosc0FlkS1daMzTGnky+qa4=;
	h=Date:To:From:Subject:From;
	b=aca5xUPG32KDQ03QRBq661uYcJnzB0Eqj31mb2/UzL1Xj1WLhXtBrXEMtxF5xCmPm
	 u0dmVaKIjHPZc0yCngomXkvKfL+iCkz5fJPbvcCUQXy3SoZ66ojz6wrPNly3IcIC6o
	 rL4X94s/diohXmSrXUOO/AnIIt1bYQXuZY3UAtl0=
Date: Tue, 20 Jan 2026 19:27:48 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-introduce-nr_snapshots-damos-stat-file.patch removed from -mm tree
Message-Id: <20260121032748.9D44BC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: introduce nr_snapshots damos stat file
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-introduce-nr_snapshots-damos-stat-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: introduce nr_snapshots damos stat file
Date: Tue, 16 Dec 2025 00:01:15 -0800

Introduce a new DAMON sysfs interface file for exposing the newly added
DAMOS stat, nr_snapshots.  The file has the name same to the stat name
(nr_snapshots) and placed under the damos stat sysfs directory.

Link: https://lkml.kernel.org/r/20251216080128.42991-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-introduce-nr_snapshots-damos-stat-file
+++ a/mm/damon/sysfs-schemes.c
@@ -204,6 +204,7 @@ struct damon_sysfs_stats {
 	unsigned long sz_applied;
 	unsigned long sz_ops_filter_passed;
 	unsigned long qt_exceeds;
+	unsigned long nr_snapshots;
 };
 
 static struct damon_sysfs_stats *damon_sysfs_stats_alloc(void)
@@ -265,6 +266,15 @@ static ssize_t qt_exceeds_show(struct ko
 	return sysfs_emit(buf, "%lu\n", stats->qt_exceeds);
 }
 
+static ssize_t nr_snapshots_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_stats *stats = container_of(kobj,
+			struct damon_sysfs_stats, kobj);
+
+	return sysfs_emit(buf, "%lu\n", stats->nr_snapshots);
+}
+
 static void damon_sysfs_stats_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_stats, kobj));
@@ -288,6 +298,9 @@ static struct kobj_attribute damon_sysfs
 static struct kobj_attribute damon_sysfs_stats_qt_exceeds_attr =
 		__ATTR_RO_MODE(qt_exceeds, 0400);
 
+static struct kobj_attribute damon_sysfs_stats_nr_snapshots_attr =
+		__ATTR_RO_MODE(nr_snapshots, 0400);
+
 static struct attribute *damon_sysfs_stats_attrs[] = {
 	&damon_sysfs_stats_nr_tried_attr.attr,
 	&damon_sysfs_stats_sz_tried_attr.attr,
@@ -295,6 +308,7 @@ static struct attribute *damon_sysfs_sta
 	&damon_sysfs_stats_sz_applied_attr.attr,
 	&damon_sysfs_stats_sz_ops_filter_passed_attr.attr,
 	&damon_sysfs_stats_qt_exceeds_attr.attr,
+	&damon_sysfs_stats_nr_snapshots_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_stats);
@@ -2762,6 +2776,7 @@ void damon_sysfs_schemes_update_stats(
 		sysfs_stats->sz_ops_filter_passed =
 			scheme->stat.sz_ops_filter_passed;
 		sysfs_stats->qt_exceeds = scheme->stat.qt_exceeds;
+		sysfs_stats->nr_snapshots = scheme->stat.nr_snapshots;
 	}
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-active-memory-ratio-damos-quota-goal-metric.patch
mm-damon-sysfs-schemes-support-damos_quota_active_mem_bp.patch
docs-mm-damon-design-document-damos_quota_active_mem_bp.patch
mm-damon-paddr-activate-damos_lru_prio-targets-instead-of-marking-accessed.patch
mm-damon-lru_sort-consider-age-for-quota-prioritization.patch
mm-damon-lru_sort-support-young-page-filters.patch
docs-admin-guide-mm-damon-lru_sort-document-filter_young_pages.patch
mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning.patch
mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning-fix.patch
docs-admin-guide-mm-damon-lru_sort-document-active_mem_bp-parameter.patch
mm-damon-lru_sort-add-monitoring-intervals-auto-tuning-parameter.patch
docs-admin-guide-mm-damon-lru_sort-document-intervals-autotuning.patch
mm-damon-core-implement-damon_kdamond_pid.patch
mm-damon-sysfs-use-damon_kdamond_pid.patch
mm-damon-lru_sort-use-damon_kdamond_pid.patch
mm-damon-reclaim-use-damon_kdamond_pid.patch
mm-damon-hide-kdamond-and-kdamond_lock-of-damon_ctx.patch
mm-vma-temporary-build-fix.patch
selftests-damon-sysfs_memcg_path_leaksh-use-kmemleak.patch
selftests-damon-wss_estimation-test-for-up-to-160-mib-working-set-size.patch
selftests-damon-access_memory-add-repeat-mode.patch
selftests-damon-wss_estimation-ensure-number-of-collected-wss.patch
selftests-damon-wss_estimation-deduplicate-failed-samples-output.patch
mm-damon-remove-damon_operations-cleanup.patch
mm-damon-core-cleanup-targets-and-regions-at-once-on-kdamond-termination.patch
mm-damon-core-cancel-damos_walk-before-damon_ctx-kdamond-reset.patch
mm-damon-core-process-damon_call_control-requests-on-a-local-list.patch
mm-damon-document-damon_call_control-dealloc_on_cancel-repeat-behavior.patch
mm-damon-core-rename-damos_filter_out-to-damos_core_filter_out.patch
mm-damon-rename-damon_min_region-to-damon_min_region_sz.patch
mm-damon-rename-min_sz_region-of-damon_ctx-to-min_region_sz.patch
docs-mm-damon-index-simplify-the-intro.patch
docs-mm-damon-design-link-repology-instead-of-fedora-package.patch
docs-mm-damon-design-document-damon-sample-modules.patch
docs-mm-damon-design-add-reference-to-damon_stat-usage.patch
docs-admin-guide-mm-damon-usage-introduce-damon-modules-at-the-beginning.patch
docs-admin-guide-mm-damon-usage-update-stats-update-process-for-refresh_ms.patch
docs-mm-damon-maintainer-profile-fix-wrong-maitnainers-section-name.patch
docs-mm-damon-maintainer-profile-remove-damon-tests-perf-suggestion.patch

