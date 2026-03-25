Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B664314B72
	for <mm-commits@vger.kernel.org>; Wed, 25 Mar 2026 18:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774463419; cv=none; b=sSJV09bUZP24FmPwmj7zMf9IOCv/BLSCwEm6oqaFtDjWGnqASRFx8YLtahTueTIut4ggmg9pztpOEEn+kR5djcvebQWMw79VZA0HL3uitVlcNU64+oah0BkfBX5VAaFBGsW2UM0QdhswpCSbBzymPHKDlx7K98hSuKXtJp6BCL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774463419; c=relaxed/simple;
	bh=6RmAauGWFO3mk6A+4sB8jHGof3uQ3ZvAyc+6dydXZmY=;
	h=Date:To:From:Subject:Message-Id; b=F3mVDuYA9agEtaEXSwvyf+6+RM7r/nM8SGV78z/NR1XIRYBQIpOZagn3SZowofp0U5K01jehZy2Y22IrcXsYLcttFxKzK1WscucGymoYF5crYPyvdclMu97f27qdCUmMCOLPnm/pnpsc1RV+ba+yvglDul2rmNmqeDDVUfYkS+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KGmC1jXu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KGmC1jXu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7624C4CEF7;
	Wed, 25 Mar 2026 18:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774463418;
	bh=6RmAauGWFO3mk6A+4sB8jHGof3uQ3ZvAyc+6dydXZmY=;
	h=Date:To:From:Subject:From;
	b=KGmC1jXuUkoA+CxS6bEtoWwA16umSZcDa9D51gIpjNnU8WLIP91KDc6BnJ7kRoklx
	 GwohLe7Of/3tPVa50vF58BQQIk+RV+FiADtGaQfX/3ioXe7sO7DRInCbmUPMDD2ANG
	 e8vRblckiPGomEac/RqEO5hP59hKMtcyu3OEvgtw=
Date: Wed, 25 Mar 2026 11:30:18 -0700
To: mm-commits@vger.kernel.org,yangyingliang@huawei.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-core-support-addr_unit-on-damon_find_biggest_system_ram-fix.patch removed from -mm tree
Message-Id: <20260325183018.D7624C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: verify found biggest system ram
has been removed from the -mm tree.  Its filename was
     mm-damon-core-support-addr_unit-on-damon_find_biggest_system_ram-fix.patch

This patch was dropped because it was folded into mm-damon-core-support-addr_unit-on-damon_find_biggest_system_ram.patch

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: verify found biggest system ram
Date: Mon, 16 Mar 2026 23:32:48 -0700

On 32 bit systems having PAE (>4 GiB physical memory address sapce), the
final start and end address could overflow, resulting in returning an
invalid address range.  Verify the returning region.  Also remove the
resource validation after walk_system_ram_res(), since the validation
means not a lot.

Link: https://lkml.kernel.org/r/20260317144725.88524-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Yang yingliang <yangyingliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-support-addr_unit-on-damon_find_biggest_system_ram-fix
+++ a/mm/damon/core.c
@@ -3097,11 +3097,10 @@ static bool damon_find_biggest_system_ra
 	struct resource res = {};
 
 	walk_system_ram_res(0, -1, &res, walk_system_ram);
-	if (res.end < res.start)
-		return false;
-
 	*start = damon_res_to_core_addr(res.start, addr_unit);
 	*end = damon_res_to_core_addr(res.end + 1, addr_unit);
+	if (*end <= *start)
+		return false;
 	return true;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

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
mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default.patch
mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default-fix.patch
mm-damon-reclaim-respect-addr_unit-on-default-monitoring-region-setup.patch
mm-damon-lru_sort-respect-addr_unit-on-default-monitoring-region-setup.patch

