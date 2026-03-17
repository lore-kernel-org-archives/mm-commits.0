Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB30334688
	for <mm-commits@vger.kernel.org>; Tue, 17 Mar 2026 21:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773782283; cv=none; b=FT4reyqbdi0qAaRl3FZZkEITtLHo5odd7ckLKnnh4hMpZLyp/r4EqVciGPMf55pMNPmCmocus+5Aw0gc3RCqNWJFCrchTVNV0OjqxQFdiUe6+1+slBQC0zTgehWZKP2InTTSPN1F5qN0VYDGC1nF5RwjY6769LkDzuVNSIa9y5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773782283; c=relaxed/simple;
	bh=RNfXYqUtBpy/gfzaHvT9Eaanx82ofs8hMGqjftDRgeY=;
	h=Date:To:From:Subject:Message-Id; b=d2uVNLtHmfjW9P0AcjuyaWH3wVo7YX+XFr7hM3o/YZzrjnpELkNagk97mkDfqn77oF6rlW3HRmWWciuoC+3y0dXJj1XnV7Xi7EOsnLAT3Mjs+xgjyHYlhDAvi5j4qQL9x0EY5Jo48wIkZ+Uoj+By/HRNlkwK/vdEBb2Qp9qsiOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l7VHmtRw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l7VHmtRw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F98C4CEF7;
	Tue, 17 Mar 2026 21:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773782282;
	bh=RNfXYqUtBpy/gfzaHvT9Eaanx82ofs8hMGqjftDRgeY=;
	h=Date:To:From:Subject:From;
	b=l7VHmtRwm4MLKrI+QHd62TLKP9zK6vJc+jwu/ZZA6aRMPbHr5ff0pNzfaGg+NoaZr
	 x1maUW/iXFdstZ/83jqdDBXghtLffBE7PdSOvsv8OIoymQ/PgZz27FmUS/MhqDKoZS
	 cpHNP6cvv60M3HsmTqUslxFWytG0xcEUeUUC3zNE=
Date: Tue, 17 Mar 2026 14:18:02 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-stat-monitor-all-system-ram-resources-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20260317211802.B5F98C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/stat: return error if monitoring target region is invalid
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-stat-monitor-all-system-ram-resources-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-stat-monitor-all-system-ram-resources-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm/damon/stat: return error if monitoring target region is invalid
Date: Mon, 16 Mar 2026 22:11:22 -0700

On 32bit systems with LPAE, the end address might be overflowed or
truncated, resulting in invalid range (the end address is equal or smaller
than the start address).  Return an error for the case.

Link: https://lkml.kernel.org/r/20260317053631.87907-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/stat.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/stat.c~mm-damon-stat-monitor-all-system-ram-resources-fix
+++ a/mm/damon/stat.c
@@ -188,6 +188,8 @@ static int damon_stat_set_monitoring_reg
 			arg.res.start, addr_unit);
 	addr_range.end = damon_stat_res_to_core_addr(
 			arg.res.end + 1, addr_unit);
+	if (addr_range.end <= addr_range.start)
+		return -EINVAL;
 	return damon_set_regions(t, &addr_range, 1, min_region_sz);
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-stat-monitor-all-system-ram-resources.patch
mm-damon-stat-monitor-all-system-ram-resources-fix.patch
mm-damon-core-set-quota-score-histogram-with-core-filters.patch
mm-damon-core-do-non-safe-region-walk-on-kdamond_apply_schemes.patch
mm-damon-core-split-regions-for-min_nr_regions.patch
mm-damon-vaddr-do-not-split-regions-for-min_nr_regions.patch
mm-damon-test-core-kunit-add-damon_apply_min_nr_regions-test.patch
mm-damon-add-config_damon_debug_sanity.patch
mm-damon-core-add-damon_new_region-debug_sanity-check.patch
mm-damon-core-add-damon_del_region-debug_sanity-check.patch
mm-damon-core-add-damon_nr_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_two_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_regions_of-debug_sanity-check.patch
mm-damon-core-add-damon_split_region_at-debug_sanity-check.patch
mm-damon-core-add-damon_reset_aggregated-debug_sanity-check.patch
mm-damon-tests-kunitconifg-enable-damon_debug_sanity.patch
selftests-damon-config-enable-damon_debug_sanity.patch
mm-damon-tests-core-kunit-add-a-test-for-damon_commit_ctx.patch
docs-mm-damon-design-document-the-power-of-two-limitation-for-addr_unit.patch
mm-damon-core-remove-damos_set_next_apply_sis-duplicates.patch
mm-damon-core-use-time_before-for-next_apply_sis.patch
mm-damon-core-use-time_after_eq-in-kdamond_fn.patch
mm-damon-core-use-mult_frac.patch
mm-damon-tests-core-kunit-add-a-test-for-damon_is_last_region.patch
mm-damon-core-clarify-damon_set_attrs-usages.patch
mm-damon-document-non-zero-length-damon_region-assumption.patch
docs-admin-guide-mm-damn-lru_sort-fix-intervals-autotune-parameter-name.patch
docs-mm-damon-maintainer-profile-use-flexible-review-cadence.patch
docs-mm-damon-index-fix-typo-autoamted-automated.patch
mm-damon-core-introduce-damos_quota_goal_tuner.patch
mm-damon-core-allow-quota-goals-set-zero-effective-size-quota.patch
mm-damon-core-introduce-damos_quota_goal_tuner_temporal.patch
mm-damon-sysfs-schemes-implement-quotas-goal_tuner-file.patch
docs-mm-damon-design-document-the-goal-based-quota-tuner-selections.patch
docs-admin-guide-mm-damon-usage-document-goal_tuner-sysfs-file.patch
docs-abi-damon-update-for-goal_tuner.patch
mm-damon-tests-core-kunit-test-goal_tuner-commit.patch
selftests-damon-_damon_sysfs-support-goal_tuner-setup.patch
selftests-damon-drgn_dump_damon_status-support-quota-goal_tuner-dumping.patch
selftests-damon-sysfspy-test-goal_tuner-commit.patch
mm-damon-core-fix-wrong-end-address-assignment-on-walk_system_ram.patch
mm-damon-core-support-addr_unit-on-damon_find_biggest_system_ram.patch
mm-damon-core-support-addr_unit-on-damon_find_biggest_system_ram-fix.patch
mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default.patch
mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default-fix.patch
mm-damon-reclaim-respect-addr_unit-on-default-monitoring-region-setup.patch
mm-damon-lru_sort-respect-addr_unit-on-default-monitoring-region-setup.patch

