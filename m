Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56862A945
	for <mm-commits@vger.kernel.org>; Sat, 24 Jan 2026 01:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769218428; cv=none; b=YWSHHCY0SgwzRKQVMVGHZIQAevO0NNCpqCeXrF5kPsCQb7z4rj3q5DHb9/m5sGgUHX3RKqvi30dJiVtedfha1U3Jf0QWw2KlOjP9Wm08qTT2a+IqghLNhCD2sIKjbX2CWF2kRYBUWQlxX1a9ZMx/OQ4IG5MhKQCDBLncD6bBwFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769218428; c=relaxed/simple;
	bh=M7vdeIQLqEGAO1dqQ0Gjyhn2/DC3RM0U0m0aciFHxLc=;
	h=Date:To:From:Subject:Message-Id; b=Ubgbi1YYI2cp14gV4D+drbnQTJ6XcVBChaaeYSL2a+9lPeZh92HRmK7inbWY9CvGdC6RkXQcpHaQ/ZZ3YJ8jmxtmHyrAUE2PaO76RgFowCWdF1+L15V1nY8hKHkWTlvCQ9+4VTb7oD5DdYW7GOBDa1hjc4v75duTj2xvsEIEzn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ONs/Ppq/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ONs/Ppq/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A850C4CEF1;
	Sat, 24 Jan 2026 01:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769218428;
	bh=M7vdeIQLqEGAO1dqQ0Gjyhn2/DC3RM0U0m0aciFHxLc=;
	h=Date:To:From:Subject:From;
	b=ONs/Ppq/KRlFckMySWl2K2DWOuhOMIDBLJfYusnlH/cd/S+9Y0FWrp9OKZBA50sDX
	 RRINK1pgJpPIZm7jU9QYaPjSEDvRs6a0VCXXQp3s6H54idOVGJGi9UftBYA+nRRInJ
	 +jsbQQUE7S+sfvTwPHMdvx6u4tC8ZJvi/2Ak2RJQ=
Date: Fri, 23 Jan 2026 17:33:47 -0800
To: mm-commits@vger.kernel.org,lkp@intel.com,Liam.Howlett@oracle.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-start-using-maple-copy-node-for-destination-fix.patch added to mm-unstable branch
Message-Id: <20260124013348.0A850C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree-start-using-maple-copy-node-for-destination-fix
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-start-using-maple-copy-node-for-destination-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-start-using-maple-copy-node-for-destination-fix.patch

This patch will later appear in the mm-unstable branch at
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
Subject: maple_tree-start-using-maple-copy-node-for-destination-fix
Date: Wed, 21 Jan 2026 21:24:08 -0800

fix build on older compiler versions

Link: https://lore.kernel.org/202601220811.ac3t5OuP-lkp@intel.com
Link: https://lkml.kernel.org/r/20260122055516.69335-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601220811.ac3t5OuP-lkp@intel.com/
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-start-using-maple-copy-node-for-destination-fix
+++ a/lib/maple_tree.c
@@ -3152,7 +3152,7 @@ static inline void cp_dst_to_slots(struc
 		 * read-side operations that can view them until they are
 		 * inserted into the tree after an rcu_assign_pointer() call.
 		 */
-		RCU_INIT_POINTER(cp->slot[d], mt_mk_node(mn, mt));
+		RCU_INIT_POINTER(cp->slot[d], (void *)mt_mk_node(mn, mt));
 		cp->pivot[d] = slot_max;
 		if (mt_is_alloc(mas->tree)) {
 			if (ma_is_leaf(mt)) {
@@ -3375,7 +3375,8 @@ static bool spanning_ascend(struct maple
 			 * the tree after an rcu_assign_pointer() call.
 			 */
 			RCU_INIT_POINTER(cp->slot[0],
-					 mt_mk_node(cp->dst[0].node, mt));
+					 (void *)mt_mk_node(
+						 cp->dst[0].node, mt));
 			cp->height++;
 		}
 		WARN_ON_ONCE(cp->dst[0].node != mte_to_node(
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
maple_tree-start-using-maple-copy-node-for-destination-fix.patch

