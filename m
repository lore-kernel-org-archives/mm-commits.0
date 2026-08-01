Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33C61A5B9D
	for <mm-commits@vger.kernel.org>; Sat,  1 Aug 2026 18:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785609145; cv=none; b=TiVuZ0XPU/1QVfNczHCDslU7KnmfY08IPa+Uwq/Bl8AnvtIdyJuyalVmJSPeUBy+l44Kuqvg/RA6qlqqbclWL3My1bGDf2qyFVqPi61S4iCvCvXat/grekQpQvCQHidtBArTvxrpPkHXIOEL/z37NQG1LK3t/mJwh78agCxaivc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785609145; c=relaxed/simple;
	bh=Y2feUMkafaD7++r8nPm4j4OwTf816lMqO/V9fyL2qKY=;
	h=Date:To:From:Subject:Message-Id; b=F6Kyfy/it4sPg9GmAtNwboAWiTcJCdfCWJR0VjdbK8oHRP82iOeX3HuDhNiYdukAwvIFcP4WSJD3LKh9zUTign5kck5t+fCV9XDwgKWJa+hLoHFTcWZSK1JC0L0qvqGq9UIvxJvux5yyjnG3sU8lPiHlfvhFlD6S/u+Ki6VAwsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S3xjqRu2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S3xjqRu2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B82F1F00AC4;
	Sat,  1 Aug 2026 18:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785609144;
	bh=6NM/JgB7jx35kZarsWVbEDIYRTEENpFNYCLPqvbe1nU=;
	h=Date:To:From:Subject;
	b=S3xjqRu2yJmxfZgUgWRzM8DDKrWVJhaZWIRDRVh94z+m0f2nXX8sDW2VrsujZERzk
	 mtp0+hPYl46ZCPNuQUEEa3/7XjbDd/njMJzYN/ogUANBaDrTaUkE92vvrWq/EijeoC
	 aI8O0cBrfIY7XZtMii7wiJUNpnVMOLrVFfwKUE/w=
Date: Sat, 01 Aug 2026 11:32:23 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,shijianlin11@foxmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write.patch added to mm-new branch
Message-Id: <20260801183224.4B82F1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: only update lowmem_reserve_ratio on sysctl write
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write.patch

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
From: Jianlin Shi <shijianlin11@foxmail.com>
Subject: mm/page_alloc: only update lowmem_reserve_ratio on sysctl write
Date: Sat, 1 Aug 2026 23:11:25 +0800

lowmem_reserve_ratio_sysctl_handler() ignores the return value of
proc_dointvec_minmax() and always calls setup_per_zone_lowmem_reserve(),
even for read operations.

Fix two issues:

1. Propagate errors from proc_dointvec_minmax() instead of always
   returning success.  For example, writing non-integer garbage to the
   sysctl now returns an error instead of silently succeeding with
   unchanged values.

2. Only call setup_per_zone_lowmem_reserve() when the sysctl is
   actually written.  Reading /proc/sys/vm/lowmem_reserve_ratio should
   not recompute derived lowmem_reserve[] and totalreserve_pages when
   the inputs did not change, matching min_free_kbytes and
   watermark_scale_factor handlers.

Drop the manual "< 1 -> 0" sanitization loop and set .extra1 = SYSCTL_ZERO
on the ctl_table entry so proc_dointvec_minmax() enforces the minimum on
write; negative values now return -EINVAL instead of being silently
coerced to 0 (suggested by Vlastimil Babka).

Link: https://lore.kernel.org/tencent_1BB7A5C4D5EEA67346634417753190E92A09@qq.com
Link: https://lore.kernel.org/linux-mm/tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com/
Signed-off-by: Jianlin Shi <shijianlin11@foxmail.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write
+++ a/mm/page_alloc.c
@@ -6925,16 +6925,15 @@ static int sysctl_min_slab_ratio_sysctl_
 static int lowmem_reserve_ratio_sysctl_handler(const struct ctl_table *table,
 		int write, void *buffer, size_t *length, loff_t *ppos)
 {
-	int i;
+	int rc;
 
-	proc_dointvec_minmax(table, write, buffer, length, ppos);
+	rc = proc_dointvec_minmax(table, write, buffer, length, ppos);
+	if (rc)
+		return rc;
 
-	for (i = 0; i < MAX_NR_ZONES; i++) {
-		if (sysctl_lowmem_reserve_ratio[i] < 1)
-			sysctl_lowmem_reserve_ratio[i] = 0;
-	}
+	if (write)
+		setup_per_zone_lowmem_reserve();
 
-	setup_per_zone_lowmem_reserve();
 	return 0;
 }
 
@@ -7033,6 +7032,7 @@ static const struct ctl_table page_alloc
 		.maxlen		= sizeof(sysctl_lowmem_reserve_ratio),
 		.mode		= 0644,
 		.proc_handler	= lowmem_reserve_ratio_sysctl_handler,
+		.extra1		= SYSCTL_ZERO,
 	},
 #ifdef CONFIG_NUMA
 	{
_

Patches currently in -mm which might be from shijianlin11@foxmail.com are

mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write.patch
ipc-only-destroy-orphaned-shm-segments-on-sysctl-write.patch

