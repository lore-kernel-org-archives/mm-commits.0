Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2C641B8F4
	for <mm-commits@vger.kernel.org>; Thu,  6 Aug 2026 21:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786050782; cv=none; b=ZyNW+dMqqzdL20CygW2HC8dKVwSXqwKDAzb65jemv1hwt9AYXJntjzgodDamfqIKtAMMf0IqJcvN1OJ9O0N5IpA3O44EnGnZi+Vvg205B/1dAP6EDPawCj+YhaPuoDie5LFV2rtvS7gaWh0UjCfj5X1W4b8W/kagt6mh83Uicqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786050782; c=relaxed/simple;
	bh=/izpA/mVadFNZmYq++IMRPlsDi1I/NuUYlygoJTwKtI=;
	h=Date:To:From:Subject:Message-Id; b=gmafMUOTIskr60pTRyP7ctm2G5u+qZjoziHO+WAYWeKDLC1z2szzcFlM5vixipj5wfqgR1qwpznPaU8EbkLtP0sWLGtntIa/G/I+V6WqSIzlHrrqGDsVaFxy29pvVFAq5NPHX9LtlYsoydw7ajhk+8QTxgEGYTcgx3nDryNPpcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d8WAy14f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d8WAy14f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C82B1F000E9;
	Thu,  6 Aug 2026 21:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786050780;
	bh=fzoCRN6VMEh5p2K42xfqh6pAgErc2C8QDJ6UWLHw3jQ=;
	h=Date:To:From:Subject;
	b=d8WAy14fWb4CANMJ13cyxd3u4g4gWGSDv/Kqu5BMujCmxvl/GAZSA+HH5qeV9weKx
	 pOGFWdgFh4iGVdZGnJ7BOfOPvIQKGGa4rwCaCTUHRwIeXxJZ1RrOHGqQJ3wbbOyZaS
	 c2OmYBog6/CdUHs6Y2KLqmtrWHvVz8bVSHBEZXPQ=
Date: Thu, 06 Aug 2026 14:13:00 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,shijianlin11@foxmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write.patch removed from -mm tree
Message-Id: <20260806211300.8C82B1F000E9@smtp.kernel.org>
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
Date: Sun, 2 Aug 2026 22:57:07 +0800

lowmem_reserve_ratio_sysctl_handler() ignores the return value of
proc_dointvec_minmax() and always calls setup_per_zone_lowmem_reserve(),
even for read operations.

Fix three issues:

1. Propagate errors from proc_dointvec_minmax() instead of always
   returning success.  For example, writing non-integer garbage to the
   sysctl now returns an error instead of silently succeeding with
   unchanged values.

2. Only call setup_per_zone_lowmem_reserve() when the sysctl is
   actually written, matching the write-only refresh pattern of
   min_free_kbytes and watermark_scale_factor handlers.

3. On write, parse into a temporary ratio[] array and only copy into
   sysctl_lowmem_reserve_ratio[] and refresh derived state after the
   full vector is validated.  This avoids leaving the ratio array
   partially updated while skipping setup when proc_dointvec_minmax()
   returns an error on a later element (suggested by Andrew Morton).

Drop the manual "< 1 -> 0" sanitization loop and set .extra1 =
SYSCTL_ZERO on the ctl_table entry so proc_dointvec_minmax() enforces
the minimum on write; negative values now return -EINVAL instead of
being silently coerced to 0 (suggested by Vlastimil Babka).

[akpm@linux-foundation.org: use ARRAY_SIZE to dimension ratio[]]
Link: https://lore.kernel.org/tencent_B9556590D4B65ACF74C06897689A6E39F206@qq.com
Link: https://lore.kernel.org/linux-mm/tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com/
Signed-off-by: Jianlin Shi <shijianlin11@foxmail.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write
+++ a/mm/page_alloc.c
@@ -6915,8 +6915,8 @@ static int sysctl_min_slab_ratio_sysctl_
 
 /*
  * lowmem_reserve_ratio_sysctl_handler - just a wrapper around
- *	proc_dointvec() so that we can call setup_per_zone_lowmem_reserve()
- *	whenever sysctl_lowmem_reserve_ratio changes.
+ *	proc_dointvec_minmax() so that we can call
+ *	setup_per_zone_lowmem_reserve() when the sysctl is written.
  *
  * The reserve ratio obviously has absolutely no relation with the
  * minimum watermarks. The lowmem reserve ratio can only make sense
@@ -6925,16 +6925,23 @@ static int sysctl_min_slab_ratio_sysctl_
 static int lowmem_reserve_ratio_sysctl_handler(const struct ctl_table *table,
 		int write, void *buffer, size_t *length, loff_t *ppos)
 {
-	int i;
+	struct ctl_table tmp = *table;
+	int ratio[ARRAY_SIZE(sysctl_lowmem_reserve_ratio)];
+	int rc;
 
-	proc_dointvec_minmax(table, write, buffer, length, ppos);
+	if (!write)
+		return proc_dointvec_minmax(table, write, buffer, length, ppos);
 
-	for (i = 0; i < MAX_NR_ZONES; i++) {
-		if (sysctl_lowmem_reserve_ratio[i] < 1)
-			sysctl_lowmem_reserve_ratio[i] = 0;
-	}
+	memcpy(ratio, sysctl_lowmem_reserve_ratio, sizeof(ratio));
+	tmp.data = ratio;
 
+	rc = proc_dointvec_minmax(&tmp, write, buffer, length, ppos);
+	if (rc)
+		return rc;
+
+	memcpy(sysctl_lowmem_reserve_ratio, ratio, sizeof(ratio));
 	setup_per_zone_lowmem_reserve();
+
 	return 0;
 }
 
@@ -7033,6 +7040,7 @@ static const struct ctl_table page_alloc
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

