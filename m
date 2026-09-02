Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1196F30D407;
	Wed,  2 Sep 2026 02:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788317747; cv=none; b=nJoYOqxyvKTTF6DJMkUmqzzFlTv8YFIee2qEwQs/1FzE+0CA90plL6tuKKBWl0u1GgJ0AwhmLa1We4wvT1jaw7v7ECstczJozi4+1LbR4g4RXZMMorbQPmABpMBaLbWvhv8tliQ/LuAujBcG9rO7ZNPgPyDuweJolgU5Y6M6Ty8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788317747; c=relaxed/simple;
	bh=R9xUaicX/YWBHgJA0kBpQll1VTv2Ef66TSUI6DSRu8c=;
	h=Date:To:From:Subject:Message-Id; b=sw3OQacHllVRZgLYlb/4bcE2gRBN+VTLU4tZgBNcFZvNMKW93SOrgnI0dewV5NHRRNvCrWznRpxLYZXa8SrSRZyW35erF9jdvD11mk77IiwHEUvW75LyEp9HsPsP1i8jWHi+T30ppvZChJ3s4kAYH7DUMxswd/couXFrsjqdbOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M6BgDjbQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M6BgDjbQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD6661F000E9;
	Wed,  2 Sep 2026 02:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788317745;
	bh=joCdN6Ok79coiMA+NqGeza3bS04u3Y7k9GLoVTKfL5Y=;
	h=Date:To:From:Subject;
	b=M6BgDjbQKROYE6H/VVVO9j/cmU9jpTWCCl+jcoN5twGngTQzrkLtTJUhLdg+Erioi
	 Ald1Z4Ao+FNjjBfXdgYZykFyFKYhFH4JjdDaEofJ9q9CLCgL3V8eDJWAmNXggIi6qw
	 mLZppw3WDQ6qT2LbOYLw4KTP7tBnwLWE+thKbJeI=
Date: Tue, 01 Sep 2026 19:55:45 -0700
To: mm-commits@vger.kernel.org,yanquanmin1@huawei.com,stable@vger.kernel.org,davidgow@davidgow.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-copy-nid-for-eligible_mem_bp-damos-quota-goal-commit.patch added to mm-new branch
Message-Id: <20260902025545.AD6661F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: copy nid for eligible_mem_bp damos quota goal commit
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-copy-nid-for-eligible_mem_bp-damos-quota-goal-commit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-copy-nid-for-eligible_mem_bp-damos-quota-goal-commit.patch

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
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: copy nid for eligible_mem_bp damos quota goal commit
Date: Tue, 1 Sep 2026 17:27:22 -0700

damos_commit_quota_goal_union() is not updating the ->nid union field when
the goal metric is DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP.  Hence, if a DAMOS
quota goal of the type is online committed in a way that it will reuse
other quota goal's memory space, the new goal will work with a garbage nid
value.  As a result, the DAMOS scheme can show unexpected aggressiveness. 
Do the update.

The user impact is not catastrophic.  No leak or crash happens.  Doing the
quota goal online commit that can reproduce the issue is expected to be
not common.  This issue was not found by real users but the AI review. 
That said, the issue can reliably be reproduced.

This issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260902002725.108635-4-sj@kernel.org
Link: https://lore.kkernel.org/20260827045035.94611-1-sj@kernel.org [1]
Fixes: 9138e27a3bc3 ("mm/damon: add node_eligible_mem_bp goal metric")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: Quanmin Yan <yanquanmin1@huawei.com>
Cc: <stable@vger.kernel.org> # 7.2.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-copy-nid-for-eligible_mem_bp-damos-quota-goal-commit
+++ a/mm/damon/core.c
@@ -1204,6 +1204,9 @@ static void damos_commit_quota_goal_unio
 		dst->nid = src->nid;
 		dst->memcg_id = src->memcg_id;
 		break;
+	case DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:
+		dst->nid = src->nid;
+		break;
 	default:
 		break;
 	}
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-skip-applying-scheme-if-region-split-for-quota-fails.patch
mm-damon-paddr-respect-folio-end-for-damos_stat.patch
mm-damon-paddr-respect-folio-end-for-damos-actions-except-stat.patch
mm-damon-vaddr-respect-folio-end-for-damos_stat.patch
mm-damon-vaddr-respect-folio-end-for-damos_migrate_hotcold.patch
mm-damon-core-handle-extreme-memory-state-in-damon_get_node_mem_bp.patch
mm-damon-core-handle-extreme-memory-state-in-get_node_memcg_used_bp.patch
mm-damon-core-handle-extreme-memory-state-in-get_in_active_mem_bp.patch
mm-damon-core-introduce-damon_filter_type_pgidle_unset.patch
mm-damon-paddr-support-pgidle_unset-probe-filter-type.patch
mm-damon-sysfs-support-pgidle_unset-probe-filter-type.patch
docs-mm-damon-design-document-pgidle_unset-probe-filter-type.patch
mm-damon-core-introduce-damon_prep-struct.patch
mm-damon-core-commit-preps.patch
mm-damon-core-introduce-damon_operations-prep_probes.patch
mm-damon-paddr-support-damon_prep.patch
mm-damon-sysfs-implement-preps-directory.patch
mm-damon-sysfs-implement-preps-nr_preps-file.patch
mm-damon-sysfs-create-directories-for-nr_preps-writes.patch
mm-damon-sysfs-implement-prep_action-file.patch
mm-damon-sysfs-pass-preps-to-damon-core.patch
selftests-damon-sysfssh-test-probe-prep-sysfs-files.patch
docs-mm-damon-design-document-probe-preps.patch
docs-admin-guide-mm-damon-usage-document-probe-preps-sysfs-files.patch
docs-abi-damon-document-probe-prep-sysfs-files.patch
mm-damon-tests-core-kunit-test-committing-psi-goal-to-psi-goal.patch
mm-damon-core-handle-uninitialized-damos_quota_goal-last_psi_total.patch
mm-damon-core-copy-nid-for-eligible_mem_bp-damos-quota-goal-commit.patch
mm-damon-sysfs-set-next-refresh-jiffies-per-sysfs-context.patch

