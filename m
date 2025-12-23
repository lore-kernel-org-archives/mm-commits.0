Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E89B2E6CD0
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 17:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766509540; cv=none; b=teUUnshZpDdezn3xHIZH2499hUgyYhD7sOOFHEmL8gUjjQE35Qdx1uwSO+FTOjLMIkT3owgiNK70ayj2ZZ9J0q7iWODwE95z/dwFJrgV+kuvIVSZFlBt+LvltsSXKAcsaKwWu1+Z9Uzhs1s3k/GUHjInQejtXc0cGKSf63djEJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766509540; c=relaxed/simple;
	bh=PPieUlX4rmPqXC8V/5J5wwIf8qk1Tm83HCWz97V4Zbc=;
	h=Date:To:From:Subject:Message-Id; b=RMgUkc95RjXOFJZTzyrHIyd8eYqKp7vsb/y4PFyPQRVPxfJKc1JiliVvUhj3y+fOEDRz18ysVcj8AxWiEC3HC4Pz15Hwm35docESPD5LlQxbMDEmqMlYuz30nFBIbNyRztaGL6PU61zHPu541sqbDyCsSFCiglX0rlU9P0CbQKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Oueq2tpJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Oueq2tpJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F8DC113D0;
	Tue, 23 Dec 2025 17:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766509540;
	bh=PPieUlX4rmPqXC8V/5J5wwIf8qk1Tm83HCWz97V4Zbc=;
	h=Date:To:From:Subject:From;
	b=Oueq2tpJrieadhi2jbbJ7uEo7HDuEl4LDQr9E+NgfqPANoOH6nTwFeiUoGXSwVtau
	 3nJCCEo1VowWr6vFcXpCwEdcJPcvPihR3vArY+dANGUVl8Xy3LWB2Mwcj+TvLJgbjt
	 mcr7TadfnwZfwbezWV1ZjH9WFd6dcYzL1Q9DtWmo=
Date: Tue, 23 Dec 2025 09:05:39 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,wangkefeng.wang@huawei.com,rakie.kim@sk.com,mgorman@suse.de,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-fix-mpol_rebind_nodemask-for-mpol_f_numa_balancing.patch added to mm-new branch
Message-Id: <20251223170540.18F8DC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mempolicy: fix mpol_rebind_nodemask() for MPOL_F_NUMA_BALANCING
has been added to the -mm mm-new branch.  Its filename is
     mm-mempolicy-fix-mpol_rebind_nodemask-for-mpol_f_numa_balancing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-fix-mpol_rebind_nodemask-for-mpol_f_numa_balancing.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm/mempolicy: fix mpol_rebind_nodemask() for MPOL_F_NUMA_BALANCING
Date: Tue, 23 Dec 2025 19:05:23 +0800

commit bda420b98505 ("numa balancing: migrate on fault among multiple
bound nodes") adds new flag MPOL_F_NUMA_BALANCING to enable NUMA balancing
for MPOL_BIND memory policy.

When the cpuset of tasks changes, the mempolicy of the task is rebound by
mpol_rebind_nodemask().  When MPOL_F_STATIC_NODES and
MPOL_F_RELATIVE_NODES are both not set, the behaviour of rebinding should
be same whenever MPOL_F_NUMA_BALANCING is set or not.  So, when an
application calls set_mempolicy() with MPOL_F_NUMA_BALANCING set but both
MPOL_F_STATIC_NODES and MPOL_F_RELATIVE_NODES cleared,
mempolicy.w.cpuset_mems_allowed should be set to
cpuset_current_mems_allowed nodemask.  However, in current implementation,
mpol_store_user_nodemask() wrongly returns true, causing
mempolicy->w.user_nodemask to be incorrectly set to the user-specified
nodemask.  Later, when the cpuset of the application changes,
mpol_rebind_nodemask() ends up rebinding based on the user-specified
nodemask rather than the cpuset_mems_allowed nodemask as intended.

To fix this, only set mempolicy->w.user_nodemask to the user-specified
nodemask if MPOL_F_STATIC_NODES or MPOL_F_RELATIVE_NODES is present.

Link: https://lkml.kernel.org/r/20251223110523.1161421-1-tujinjiang@huawei.com
Link: https://lkml.kernel.org/r/20251223110523.1161421-1-tujinjiang@huawei.com
Fixes: bda420b98505 ("numa balancing: migrate on fault among multiple bound nodes")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Mel Gorman <mgorman <mgorman@suse.de>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/mempolicy.h |    3 +++
 mm/mempolicy.c                 |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/include/uapi/linux/mempolicy.h~mm-mempolicy-fix-mpol_rebind_nodemask-for-mpol_f_numa_balancing
+++ a/include/uapi/linux/mempolicy.h
@@ -39,6 +39,9 @@ enum {
 #define MPOL_MODE_FLAGS							\
 	(MPOL_F_STATIC_NODES | MPOL_F_RELATIVE_NODES | MPOL_F_NUMA_BALANCING)
 
+/* Whether the nodemask is specified by users */
+#define MPOL_USER_NODEMASK_FLAGS (MPOL_F_STATIC_NODES | MPOL_F_RELATIVE_NODES)
+
 /* Flags for get_mempolicy */
 #define MPOL_F_NODE	(1<<0)	/* return next IL mode instead of node mask */
 #define MPOL_F_ADDR	(1<<1)	/* look up vma using address */
--- a/mm/mempolicy.c~mm-mempolicy-fix-mpol_rebind_nodemask-for-mpol_f_numa_balancing
+++ a/mm/mempolicy.c
@@ -365,7 +365,7 @@ static const struct mempolicy_operations
 
 static inline int mpol_store_user_nodemask(const struct mempolicy *pol)
 {
-	return pol->flags & MPOL_MODE_FLAGS;
+	return pol->flags & MPOL_USER_NODEMASK_FLAGS;
 }
 
 static void mpol_relative_nodemask(nodemask_t *ret, const nodemask_t *orig,
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-mempolicy-fix-mpol_rebind_nodemask-for-mpol_f_numa_balancing.patch

