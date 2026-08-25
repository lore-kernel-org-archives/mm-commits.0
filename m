Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF46C343D91
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622823; cv=none; b=ubWR705W8whoE/5vMcmChneeBFzT1Qm6SBzr405Hk36pIhvT+p/rTljd0mmQufmTqdtXWDNl1Sc0UHDH1d1bjvNkH62ETjK/ALs9qFhp2sYZ74hvCIEnk1pVJc4f5CtoUUDlNeXzx2E9bT1UXzja4lFaVLJmitroNNbmLawhQmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622823; c=relaxed/simple;
	bh=HG6qKGtXyctthn25AYmt9YoYPEhq0zTwrVKKK9jWPpU=;
	h=Date:To:From:Subject:Message-Id; b=T6mj5/b/UeMOyp5KIxItn0fqSXbn/dB7u5WCA9BGxi24yTJfg/+fpbBwjn/bTlm+oHdU0Cy3fERaj83jnw+xbxoLmn4iiC4QgdG+PkybDs3K9Jc7skpllogNjuaaaNMgnEPBfVED/Bl8dAoAnYiTIufdCm5+9kCtqVuVhd+vfVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QysdatG5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QysdatG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D011F00A3A;
	Tue, 25 Aug 2026 01:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622821;
	bh=u9sIkgCqKJ9p2rrJ7dNIaRwiSG1BZ78cxT5IChBF0S4=;
	h=Date:To:From:Subject;
	b=QysdatG5qidD9BDmqxkD5aEaeQ2ROtcfX718dhtwcYrvDCC8Xm3mWaRuiAgpr5X9o
	 ynGBMWNOWAhWM4Cv2mhrTAGYynodVcTDlV3rlv+3U3T0jELqXeqLQDkIlsn4JjWXQR
	 NSeej+3lyl26h9ixEVg5zGaDZFe04wUF4Mcjo3QA=
Date: Mon, 24 Aug 2026 18:53:41 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,joel.granados@kernel.org,jackmanb@google.com,hannes@cmpxchg.org,shijianlin11@foxmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write.patch removed from -mm tree
Message-Id: <20260825015341.B4D011F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: only update lowmem_reserve_ratio on sysctl write
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jianlin Shi <shijianlin11@foxmail.com>
Subject: mm/page_alloc: only update lowmem_reserve_ratio on sysctl write
Date: Thu, 6 Aug 2026 16:27:34 +0800

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

Drop the manual "< 1 -> 0" sanitization loop and set .extra1 = SYSCTL_ZERO
on the ctl_table entry so proc_dointvec_minmax() enforces the minimum on
write; negative values now return -EINVAL instead of being silently
coerced to 0 (suggested by Vlastimil Babka).

[akpm@linux-foundation.org: add comment, per hannes]
  Link: https://lore.kernel.org/anSRGASe5FIrqwlg@cmpxchg.org
Link: https://lore.kernel.org/linux-mm/tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com/
Link: https://lore.kernel.org/tencent_A860C873956A52E26AD8D309A308A241BA08@qq.com
Signed-off-by: Jianlin Shi <shijianlin11@foxmail.com>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Joel Granados <joel.granados@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write
+++ a/mm/page_alloc.c
@@ -6853,8 +6853,8 @@ static int sysctl_min_slab_ratio_sysctl_
 
 /*
  * lowmem_reserve_ratio_sysctl_handler - just a wrapper around
- *	proc_dointvec() so that we can call setup_per_zone_lowmem_reserve()
- *	whenever sysctl_lowmem_reserve_ratio changes.
+ *	proc_dointvec_minmax() so that we can call
+ *	setup_per_zone_lowmem_reserve() when the sysctl is written.
  *
  * The reserve ratio obviously has absolutely no relation with the
  * minimum watermarks. The lowmem reserve ratio can only make sense
@@ -6863,16 +6863,27 @@ static int sysctl_min_slab_ratio_sysctl_
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
+	/*
+	 * proc_dointvec_max() works incrementally. Use a buffer and only set
+	 * the values if all of them parse cleanly.
+	 */
+	memcpy(ratio, sysctl_lowmem_reserve_ratio, sizeof(ratio));
+	tmp.data = ratio;
+
+	rc = proc_dointvec_minmax(&tmp, write, buffer, length, ppos);
+	if (rc)
+		return rc;
 
+	memcpy(sysctl_lowmem_reserve_ratio, ratio, sizeof(ratio));
 	setup_per_zone_lowmem_reserve();
+
 	return 0;
 }
 
@@ -6971,6 +6982,7 @@ static const struct ctl_table page_alloc
 		.maxlen		= sizeof(sysctl_lowmem_reserve_ratio),
 		.mode		= 0644,
 		.proc_handler	= lowmem_reserve_ratio_sysctl_handler,
+		.extra1		= SYSCTL_ZERO,
 	},
 #ifdef CONFIG_NUMA
 	{
_

Patches currently in -mm which might be from shijianlin11@foxmail.com are


