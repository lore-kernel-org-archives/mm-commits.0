Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5820A2D7DD4
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782066744; cv=none; b=BytvEMQMClyyptvMK4FxHNR9vS1vlAlO3Oxf4hQ9GGrfokJrH7ByitM5HwAAMZpgkRAtCw4LPF9KLlSCcszPHK0X+WDTIiPMfs+hOa7gkMZorO/uPC+bDKVr/6tbez4nNa415akVCo8/hTQi6houfh2IG2n9Lnlq93mBXvsbjJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782066744; c=relaxed/simple;
	bh=n/0OJmV99Ioj1czkzOvIfhCMRM2/p73tT5RJcdICd5Q=;
	h=Date:To:From:Subject:Message-Id; b=T4itBZBdjouZDHnkVoe+FM/TxNcLSPQEzBIdXlbnvQBdPyVGSqy4l73m4GAsq5/+vr61ikKxDuSssOINRujwv8C/s67Ruaax60yo+20k2REkat20FmAPhr0Ri6iSF7kYsfrrxxU00uX3eRv/Jc10mbF9H87TAGMI+44DshnY+J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PgmDFCYT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PgmDFCYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1445B1F000E9;
	Sun, 21 Jun 2026 18:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782066743;
	bh=cgtXWmxqmBFPHwbKJIYPkOmEOpD5CyIZ3R7CYtctHUQ=;
	h=Date:To:From:Subject;
	b=PgmDFCYT+zwHUZpWQHiftCNe7X0QMG1t9dCP7cztz6y21iLMYU4psta3dGlv3Er+7
	 LfeQ8KeVRuASfErzAYnnNKRIw+4pe2OpoS3D2O1cT79gPnXZYNZ9r+3KSVh2bZ0Dtp
	 n/T7rb+qMjgXjyO1aPGCs7aTJXov6uKBvlJ0jCgo=
Date: Sun, 21 Jun 2026 11:32:22 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,shijianlin11@foxmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-only-update-numa-min-ratios-on-sysctl-write.patch removed from -mm tree
Message-Id: <20260621183223.1445B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: only update NUMA min ratios on sysctl write
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-only-update-numa-min-ratios-on-sysctl-write.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jianlin Shi <shijianlin11@foxmail.com>
Subject: mm/page_alloc: only update NUMA min ratios on sysctl write
Date: Thu, 4 Jun 2026 12:01:38 +0800

The sysctl handlers for min_unmapped_ratio and min_slab_ratio invoke
setup_min_unmapped_ratio() and setup_min_slab_ratio() unconditionally
after proc_dointvec_minmax(), even for read operations.

These setup functions first zero all per-NUMA node thresholds
(min_unmapped_pages and min_slab_pages) before recalculating them. 
Reading /proc sysctl entries therefore temporarily resets node reclaim
thresholds to zero, which may disturb the behavior of __node_reclaim() and
node_reclaim() during the recomputation.

Fix this by only calling the setup functions when the sysctl is actually
written (write == 1), matching the behavior of existing sysctl handlers
like min_free_kbytes and watermark_scale_factor.

This only affects systems with CONFIG_NUMA.

Link: https://lore.kernel.org/tencent_5891052AF9A4C2D490A62F478D446F74AB09@qq.com
Signed-off-by: Jianlin Shi <shijianlin11@foxmail.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-only-update-numa-min-ratios-on-sysctl-write
+++ a/mm/page_alloc.c
@@ -6653,7 +6653,8 @@ static int sysctl_min_unmapped_ratio_sys
 	if (rc)
 		return rc;
 
-	setup_min_unmapped_ratio();
+	if (write)
+		setup_min_unmapped_ratio();
 
 	return 0;
 }
@@ -6680,7 +6681,8 @@ static int sysctl_min_slab_ratio_sysctl_
 	if (rc)
 		return rc;
 
-	setup_min_slab_ratio();
+	if (write)
+		setup_min_slab_ratio();
 
 	return 0;
 }
_

Patches currently in -mm which might be from shijianlin11@foxmail.com are


