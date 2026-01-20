Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190313A9616
	for <mm-commits@vger.kernel.org>; Tue, 20 Jan 2026 20:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768941220; cv=none; b=E5tiUzMi/FZjGUPO4ZJ5K4/h9K6UOYPAtl+A6PnKPWwHFY9zoDB3F8KzDO4ilSOxBwRK3UKQEMtvev7S1z1tchKJ+z4F6Mkt6beNhM8M/26UG8AvpfjXEGZfnneps8uzJGmGMG4mOU2lEBFmEj7XqLKX7k22D9ecsLY/Ur4W3Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768941220; c=relaxed/simple;
	bh=xZMGrQ8JxQJxtodbJF1JXY5ETL1156+lkRS2mrNDc8U=;
	h=Date:To:From:Subject:Message-Id; b=g7NR2nU+LuLIV86rjFsaHwBcp6DoyrZH7bTK5zAOd2gtAvnI1fBG6PVkvEwJXLVlzfMszwWC33iMqakSNjb8UuwutbOSe+175ktmpO+5WFS4icmD1zZR6MifiBAu7fJLhARFlaY7NVcFMyWRyAclApp1T7ITDAWDk2zjOPI0PxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g4hF02LG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g4hF02LG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F6EC16AAE;
	Tue, 20 Jan 2026 20:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768941219;
	bh=xZMGrQ8JxQJxtodbJF1JXY5ETL1156+lkRS2mrNDc8U=;
	h=Date:To:From:Subject:From;
	b=g4hF02LG0N8OsZX37TXpoH/O0sb6wz+XuR0DWLWMcsbnawmZtg4DsJP/Y+iWW4xQa
	 KjbeUXKI6nI8W32sV+EE/qRq9g6QNMGJFKWyNPbQb2D/SvniEcYfaToCeQZeQ1CgIh
	 NHUj4qcWFtnEjOZTU6rTlAbVyrwdwzGzxKG0bp7k=
Date: Tue, 20 Jan 2026 12:33:38 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,wangkefeng.wang@huawei.com,rakie.kim@sk.com,mgorman@suse.de,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-fix-mpol_rebind_nodemask-for-mpol_f_numa_balancing.patch added to mm-unstable branch
Message-Id: <20260120203339.88F6EC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mempolicy: fix mpol_rebind_nodemask() for MPOL_F_NUMA_BALANCING
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempolicy-fix-mpol_rebind_nodemask-for-mpol_f_numa_balancing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-fix-mpol_rebind_nodemask-for-mpol_f_numa_balancing.patch

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

I can reproduce with the following steps in qemu with 4 NUMA nodes:
1. echo '+cpuset' > /sys/fs/cgroup/cgroup.subtree_control
2. mkdir /sys/fs/cgroup/test
3. ./reproducer &
4. cat /proc/$pid/numa_maps, the task is bound to NUMA 1
5. echo $pid > /sys/fs/cgroup/test/cgroup.procs
6. cat /proc/$pid/numa_maps, the task is bound to NUMA 0 now.

The reproducer code:

int main()
{
        struct bitmask *bmp;
        int ret;

        bmp = numa_parse_nodestring("1");
        ret = set_mempolicy(MPOL_BIND | MPOL_F_NUMA_BALANCING,
                bmp->maskp, bmp->size + 1);
        if (ret < 0) {
                perror("Failed to call set_mempolicy");
                exit(-1);
        }

        while (1);
        return 0;
}

If I call set_mempolicy() without MPOL_F_NUMA_BALANCING in the reproducer
code.  After step 5, the task is still bound to NUMA 1.

To fix this, only set mempolicy->w.user_nodemask to the user-specified
nodemask if MPOL_F_STATIC_NODES or MPOL_F_RELATIVE_NODES is present.

Link: https://lkml.kernel.org/r/20260120011018.1256654-1-tujinjiang@huawei.com
Link: https://lkml.kernel.org/r/20251223110523.1161421-1-tujinjiang@huawei.com
Fixes: bda420b98505 ("numa balancing: migrate on fault among multiple bound nodes")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
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

