Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56B113C9C4
	for <mm-commits@vger.kernel.org>; Sun,  3 May 2026 13:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777814162; cv=none; b=i/8K2FoI1DPbQde3NLnfQAKQcS8wrpDCdV1iKnQDKJbETVNcE+QNzKGQsYx0JM68s/14mSlUbqCVVpyhuhaf6IM/2t9xNIwwcJqvYjxsUMXJbbLd2jZ4a7fJXSuTizYMEubMZLriwLKYTH2j8wMKlc7D74JVAjX0JtZRqHR6Id4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777814162; c=relaxed/simple;
	bh=lrQiPgbSnjz82j8AIFeSVulP8S/jWN/FGlt2hZXNvJY=;
	h=Date:To:From:Subject:Message-Id; b=G7cET0z0cxZwzHC5p//qQ317/Psp/U6CNCk6d/Re4sW2BrLsfmZ/had0YCWNkK/94OG8gyzouDoJvfLad+c5mRY/hwTPAzp+Ms4jesvOWKH+YdUbv3Uf4h9LTt2MlUEX/yx5XpJ4xbLmxTZ+VkmLRtBsotIMR9KqbVwXDj/c49Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D3c4S6k9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D3c4S6k9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE75C2BCB4;
	Sun,  3 May 2026 13:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777814162;
	bh=lrQiPgbSnjz82j8AIFeSVulP8S/jWN/FGlt2hZXNvJY=;
	h=Date:To:From:Subject:From;
	b=D3c4S6k9DSehyXWRyd7OCBwsH9tZTP4Xdvyv+1W7nxN7OfqPh18KFIewHbGLnWUUb
	 wMO86BKsE3Qpw9mmC8h81srmP5BsXHCCpxIf67qhLeceCClvGD2JUiTEjVDmX/ZtF1
	 XW9hk8gBpgNhkr4pCFbejgnbjTkzln3hC4VFMWqs=
Date: Sun, 03 May 2026 06:15:58 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-stat-add-a-parameter-for-reading-kdamond-pid.patch added to mm-new branch
Message-Id: <20260503131601.CFE75C2BCB4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/stat: add a parameter for reading kdamond pid
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-stat-add-a-parameter-for-reading-kdamond-pid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-stat-add-a-parameter-for-reading-kdamond-pid.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/stat: add a parameter for reading kdamond pid
Date: Fri, 1 May 2026 19:05:03 -0700

Patch series "mm/damon/stat: add kdamond_pid parameter".

DAMON_STAT doesn't provide the pid of its kdamond, unlike DAMON_RECLAIM
and DAMON_LRU_SORT.  This makes user-space management of DAMON_STAT
unnecessarily complicated.  Provide the information via a new parameter,
namely kdamond_pid, and document it.


This patch (of 2):

Knowing the pid of the kdamonds can help user-space management including
monitoring of DAMON's system resource consumption.  To make it easier,
DAMON_SYSFS, DAMON_RECLAIM and DAMON_LRU_SORT provide the pid information.
DAMON_STAT is not providing it, though.  Expose the pid of DAMON_STAT
kdamond via a new read-only module parameter, namely kdamond_pid.  This
also makes DAMON modules usage more standardized, because DAMON_RECLAIM
and DAMON_LRU_SORT also provide the information via their read-only
parameters of the same name.

Link: https://lore.kernel.org/20260502020505.80822-1-sj@kernel.org
Link: https://lore.kernel.org/20260502020505.80822-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/stat.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

--- a/mm/damon/stat.c~mm-damon-stat-add-a-parameter-for-reading-kdamond-pid
+++ a/mm/damon/stat.c
@@ -266,6 +266,45 @@ static int damon_stat_enabled_load(char
 	return sprintf(buffer, "%c\n", damon_stat_enabled() ? 'Y' : 'N');
 }
 
+static int damon_stat_kdamond_pid_store(
+		const char *val, const struct kernel_param *kp)
+{
+	/*
+	 * kdamond_pid is read-only, but kernel command line could write it.
+	 * Do nothing here.
+	 */
+	return 0;
+}
+
+static int damon_stat_kdamond_pid_load(
+		char *buffer, const struct kernel_param *kp)
+{
+	int pid;
+
+	if (!damon_stat_context) {
+		pid = -1;
+	} else {
+		pid = damon_kdamond_pid(damon_stat_context);
+		if (pid < 1)
+			pid = -1;
+	}
+	return sprintf(buffer, "%d\n", pid);
+}
+
+static const struct kernel_param_ops kdamond_pid_param_ops = {
+	.set = damon_stat_kdamond_pid_store,
+	.get = damon_stat_kdamond_pid_load,
+};
+
+/*
+ * PID of the DAMON thread
+ *
+ * If DAMON_STAT is enabled, this becomes the PID of the worker thread.
+ * Else, -1.
+ */
+module_param_cb(kdamond_pid, &kdamond_pid_param_ops, NULL, 0400);
+MODULE_PARM_DESC(kdamond_pid, "pid of the kdamond");
+
 static int __init damon_stat_init(void)
 {
 	int err = 0;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-call-missing-mem_cgroup_iter_break.patch
mm-damon-fix-damos_stat-tracepoint-format-for-sz_applied.patch
mm-damon-core-make-charge_addr_from-aware-of-end-address-exclusivity.patch
mm-damon-core-handle-min_region_sz-remaining-quota-as-empty.patch
mm-damon-core-merge-regions-after-applying-damos-schemes.patch
mm-damon-core-introduce-failed-region-quota-charge-ratio.patch
mm-damon-sysfs-schemes-implement-fail_charge_numdenom-files.patch
docs-mm-damon-design-document-fail_charge_numdenom.patch
docs-admin-guide-mm-damon-usage-document-fail_charge_numdenom-files.patch
docs-abi-damon-document-fail_charge_numdenom.patch
mm-damon-tests-core-kunit-test-fail_charge_numdenom-committing.patch
selftests-damon-_damon_sysfs-support-failed-region-quota-charge-ratio.patch
selftests-damon-drgn_dump_damon_status-support-failed-region-quota-charge-ratio.patch
selftests-damon-sysfspy-test-failed-region-quota-charge-ratio.patch
docs-mm-damon-maintainer-profile-add-ai-review-usage-guideline.patch
mm-damon-core-introduce-damon_ctx-paused.patch
mm-damon-sysfs-add-pause-file-under-context-dir.patch
docs-mm-damon-design-update-for-context-pause-resume-feature.patch
docs-admin-guide-mm-damon-usage-update-for-pause-file.patch
docs-abi-damon-update-for-pause-sysfs-file.patch
mm-damon-tests-core-kunit-test-pause-commitment.patch
selftests-damon-_damon_sysfs-support-pause-file-staging.patch
selftests-damon-drgn_dump_damon_status-dump-pause.patch
selftests-damon-sysfspy-check-pause-on-assert_ctx_committed.patch
selftests-damon-sysfspy-pause-damon-before-dumping-status.patch
mm-damon-introduce-damon_set_region_system_rams_default.patch
mm-damon-reclaim-cover-all-system-rams.patch
mm-damon-lru_sort-cover-all-system-rams.patch
mm-damon-core-remove-damon_set_region_biggest_system_ram_default.patch
mm-damon-stat-use-damon_set_region_system_rams_default.patch
docs-admin-guide-mm-damon-reclaim-update-for-entire-memory-monitoring.patch
docs-admin-guide-mm-damon-lru_sort-update-for-entire-memory-monitoring.patch
docs-admin-guide-mm-damon-usage-mark-scheme-filters-sysfs-dir-as-deprecated.patch
docs-abi-damon-mark-schemes-s-filters-deprecated.patch
mm-damon-reclaim-add-autotune_monitoring_intervals-parameter.patch
docs-admin-guide-mm-damon-reclaim-update-for-autotune_monitoring_intervals.patch
mm-damon-stat-add-a-parameter-for-reading-kdamond-pid.patch
docs-admin-guide-mm-damon-stat-document-kdamond_pid-parameter.patch

