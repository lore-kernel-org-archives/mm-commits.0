Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B3831AABC
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334283; cv=none; b=SCt9ttw7dlYO3xpXy3jqUx3vTRk1n0dRTEvfL++S+vMes+Pj3Ajup/Zy3O+UnRyJMPYRcrqb7SbI34KPNzDbzXUUUXcCIBWVjxiPjympYLCqMC13Cu0J9yHp8fsX7IXY9dnYcZddBWKepyBz9/Z4o8Anrks7PiDz+/261TjFBMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334283; c=relaxed/simple;
	bh=ehOfgZO/WHaBXnvrEvkkW2/KbkUmBbY701aTsz1dmxc=;
	h=Date:To:From:Subject:Message-Id; b=R2XZ+hVrT6pudsz1eMz+cZETBTD4gpRPpF/Eyf7cSphJniv0bHTF6bT7dX3VQhZeA3CyW/PEoZ0NN/7dRCqSL6Kyv6Zjr+p81WImpYRL0uzT67NrEipJLj5HsKmEYTuW5Wy0pyUyzN5GEpo3K1mZJk82Fhh3U+MiGigQ2sZgTps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iSkJJPfc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iSkJJPfc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6FC1F0089C;
	Wed,  7 Oct 2026 00:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334282;
	bh=BRavYZ3PeM51K431Jr+q6NU3JOMAgdq8dIJSqDVUcjk=;
	h=Date:To:From:Subject;
	b=iSkJJPfcIfDNaaHv4eCvlm0A7eImxtLyIcfXT94+O2gkMwENzG8vDUtfw2uEIbAlH
	 dKozl8Oc7kk6A/9nhK/lBsKPb5JCvKF7TKTesKGM1HU123kzZOg8lrGuZK54AJap9B
	 BIoz0aIyoK4zADOm/va02YqqM0p2dTSOR6b5QN+4=
Date: Tue, 06 Oct 2026 17:51:21 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,gutierrez.asier@huawei-partners.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-support-hugepage_mem_bp-quota-goal-metric.patch removed from -mm tree
Message-Id: <20261007005121.DC6FC1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: support hugepage_mem_bp quota goal metric
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-support-hugepage_mem_bp-quota-goal-metric.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Subject: mm/damon/sysfs: support hugepage_mem_bp quota goal metric
Date: Mon, 31 Aug 2026 07:47:29 -0700

DAMOS has a new autotune policy metric: DAMOS_QUOTA_HUGEPAGE_MEM_BP.  This
patch exposes DAMOS_QUOTA_HUGEPAGE_MEM_BP through sysfs.

Add the "hugepage_mem_bp" to the sysfs-schemes interface.

Link: https://lore.kernel.org/20260831144732.80910-3-sj@kernel.org
Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/damon/sysfs-schemes.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-support-hugepage_mem_bp-quota-goal-metric
+++ a/mm/damon/sysfs-schemes.c
@@ -1269,6 +1269,10 @@ struct damos_sysfs_qgoal_metric_name dam
 		.metric = DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
 		.name = "node_eligible_mem_bp",
 	},
+	{
+		.metric = DAMOS_QUOTA_HUGEPAGE_MEM_BP,
+		.name = "hugepage_mem_bp",
+	},
 };
 
 static ssize_t target_metric_show(struct kobject *kobj,
_

Patches currently in -mm which might be from gutierrez.asier@huawei-partners.com are


