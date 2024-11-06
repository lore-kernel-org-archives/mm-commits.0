Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47861885BF
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854791; cv=none; b=L0ZYrtVzfg1qhDK32AQtvmPu2RZCNq5MOetXanucppNH6qnpMlfXEryhkAwQMKnrxQun6EEnNp+bMvtdsUsg6a3Dh2xrVvAZfoxCnuXbm7okITZShMiBWPN2MHbRG42J5j+HsiTYRNupkoGAbOBA09QGweVl30Jf4eofq1zpCGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854791; c=relaxed/simple;
	bh=GD4meIzEItOR9lifWCIIiPVKdz9TeTGEzC5L0qPClnU=;
	h=Date:To:From:Subject:Message-Id; b=dNwRMCJmHLYwC02MSlHypBWELOm7AnAPf1Dq5HR1p5WMayLnnmAzRDeoRGexHfVL/XBciiwGyUe4/uZPc38eK9UQ4mb7CxrfvYJYEpTKQGMmDz7BhwdxOsOsT6TrUVBIjG8qFK7Zh9yrpZMof2eXU8fXAYpqSBiJKL5RSCS9ROY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UP3SeUtP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UP3SeUtP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7405AC4CECF;
	Wed,  6 Nov 2024 00:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854791;
	bh=GD4meIzEItOR9lifWCIIiPVKdz9TeTGEzC5L0qPClnU=;
	h=Date:To:From:Subject:From;
	b=UP3SeUtPb532vcwoxdTH9QAv/97OwkUMYG8wvvSC8+VIFQVTLlDYNDBremgcLClLX
	 Vx2VPmYTaf7mmDyWHeOCCW95a39K7SWq6XWO1pBh0L2bLX4eST89Sjbxk8u7UMudSJ
	 l7ZwZd2yrN2QBTVhBra6gqZF/iEX/6UgbbZ5dzWg=
Date: Tue, 05 Nov 2024 16:59:50 -0800
To: mm-commits@vger.kernel.org,alexjlzheng@tencent.com,mengensun@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-pcp-high_min-high_max-to-proc-zoneinfo.patch removed from -mm tree
Message-Id: <20241106005951.7405AC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add pcp high_min high_max to proc zoneinfo
has been removed from the -mm tree.  Its filename was
     mm-add-pcp-high_min-high_max-to-proc-zoneinfo.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: MengEn Sun <mengensun@tencent.com>
Subject: mm: add pcp high_min high_max to proc zoneinfo
Date: Thu, 10 Oct 2024 20:09:36 +0800

When we do not set percpu_pagelist_high_fraction the kernel will compute
the pcp high_min/max by itself, which makes it hard to determine the
current high_min/max values.

So output the pcp high_min/max values to /proc/zoneinfo.

Link: https://lkml.kernel.org/r/20241010120935.656619-1-mengensun@tencent.com
Signed-off-by: MengEn Sun <mengensun@tencent.com>
Reviewed-by: Jinliang Zheng <alexjlzheng@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/mm/vmstat.c~mm-add-pcp-high_min-high_max-to-proc-zoneinfo
+++ a/mm/vmstat.c
@@ -1791,13 +1791,17 @@ static void zoneinfo_show_print(struct s
 		pcp = per_cpu_ptr(zone->per_cpu_pageset, i);
 		seq_printf(m,
 			   "\n    cpu: %i"
-			   "\n              count: %i"
-			   "\n              high:  %i"
-			   "\n              batch: %i",
+			   "\n              count:    %i"
+			   "\n              high:     %i"
+			   "\n              batch:    %i"
+			   "\n              high_min: %i"
+			   "\n              high_max: %i",
 			   i,
 			   pcp->count,
 			   pcp->high,
-			   pcp->batch);
+			   pcp->batch,
+			   pcp->high_min,
+			   pcp->high_max);
 #ifdef CONFIG_SMP
 		pzstats = per_cpu_ptr(zone->per_cpu_zonestats, i);
 		seq_printf(m, "\n  vm stats threshold: %d",
_

Patches currently in -mm which might be from mengensun@tencent.com are

vmstat-call-fold_vm_zone_numa_events-before-show-per-zone-numa-event.patch

