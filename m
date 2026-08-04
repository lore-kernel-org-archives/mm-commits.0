Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FD237F30D
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 00:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785804244; cv=none; b=Mnp94EOXVi23wGJ2sp2W22AIUZZgErBv8N05Pz4gucODZhDdFX5wCcaREvhuS8SrFz2dRitEBYp35mXeQd0VZdqW/zUwqG2qK3/QS43aQes3fNgolQxJgbUI8oFJVT3Kd7csPaqAlo+WaDfPZy+5u0dt95W1uRf9F2yWuYa5ew8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785804244; c=relaxed/simple;
	bh=3uxCfDnlK0q4m9NgXXJIK++SwM4UzyDq6o4wyPtmxf8=;
	h=Date:To:From:Subject:Message-Id; b=t+IXzfEBb7Cl3TxY4hYmHr/HkNr6/0MVSrcrJU4fIwnzX9ePMJlwB3/L6F/pn39HM9XARZHwouKjANLiCD7YB0lGumGzxj3Nwd+INqX0C/P6ZC5DyfsWVayhFaTFKMKVX1FtEd/w4ae+RfNHh0QAVvJnBQul0NDdHKXKuxgKtc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X+Kd7JHm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X+Kd7JHm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A011F00A3A;
	Tue,  4 Aug 2026 00:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785804242;
	bh=QzwPw0jOqKVFUwr2SKt9M5jRgsyymWnn/mnsljsPrzQ=;
	h=Date:To:From:Subject;
	b=X+Kd7JHmxAb8yQGpZOoARMf8ko+/eM2TBqigvzyIgkdh+8KhF8/r7h6JH3gNo4Fzr
	 TxKsIe6lyBTHyNtxxNFQMRLvfeaS/Dke/+7xXK2DIsTgF5IZ2NPyi1G4Ay2wBYJQSg
	 lDyxdDdiE8y6I2ujFEHA7QfwdBZKUpIGQ3cwvlNs=
Date: Mon, 03 Aug 2026 17:44:02 -0700
To: mm-commits@vger.kernel.org,shijianlin11@foxmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write.patch removed from -mm tree
Message-Id: <20260804004402.C3A011F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: only update lowmem_reserve_ratio on sysctl write
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write.patch

This patch was dropped because an updated version will be issued

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

ipc-only-destroy-orphaned-shm-segments-on-sysctl-write.patch

