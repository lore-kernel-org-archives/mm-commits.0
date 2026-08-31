Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904583BB107
	for <mm-commits@vger.kernel.org>; Mon, 31 Aug 2026 23:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788218668; cv=none; b=tOOjKnW7eqsA0dHVQnUInvPBwEdT85PIXmN3O3h3Bga0XCUTYcedlyh8ovWAccq8ZxJRgmYEII/tmvffxsFuA/GrcPmQ8QDgV0ParGH2n25z74kvmLZHx1VmcVnunEv/cwVdE2EHPzwfAO2cmNjSqc1FngENwr50RDevZy3K/Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788218668; c=relaxed/simple;
	bh=lg1pIAqAZ+PB3X62z72SALiDOQTWw0JsdDxj9zjW0yw=;
	h=Date:To:From:Subject:Message-Id; b=eLR0n4b3mfhkx9gUqikABAzW566eA27UAZz+/jCYJT9GnBzTnkgw3ARZxYycLVLGUvn5CNlOGxAISVQ1+n2qJ0t5m1hc/LGsxw+cfC8u4nm5emqCmmqCfAqpOCFrT275Bx0TyW2e2XxKEAQ3e+BDCLlbjpSw7qGaVjKHD54Na+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vNU2o+E/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vNU2o+E/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182AA1F000E9;
	Mon, 31 Aug 2026 23:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788218667;
	bh=GT1IJlhT9JCR3MLn9FHfOnd0wrobxv4zthziGdbUOZ0=;
	h=Date:To:From:Subject;
	b=vNU2o+E/UqIMZdSD6pIMQxVT9XTFr0Zwjn9aRTynZqdTtpxwYyqDK5RsurZUEVZfA
	 lzzoxrE/3UHo1aCkevVleJoLKveThX5bKMZ9M+ScFCTaVxNh964zghl+iMIl43D40s
	 WLYtKhuHBOOM4QJYR755ihd4FDVvbDghRGOrVDBI=
Date: Mon, 31 Aug 2026 16:24:26 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,gutierrez.asier@huawei-partners.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-support-hugepage_mem_bp-quota-goal-metric.patch added to mm-new branch
Message-Id: <20260831232427.182AA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: support hugepage_mem_bp quota goal metric
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-support-hugepage_mem_bp-quota-goal-metric.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-support-hugepage_mem_bp-quota-goal-metric.patch

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
From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Subject: mm/damon/sysfs: support hugepage_mem_bp quota goal metric
Date: Mon, 31 Aug 2026 07:47:29 -0700

DAMOS has a new autotune policy metric: DAMOS_QUOTA_HUGEPAGE_MEM_BP.  This
patch exposes DAMOS_QUOTA_HUGEPAGE_MEM_BP through sysfs.

Add the "hugepage_mem_bp" to the sysfs-schemes interface.

Link: https://lore.kernel.org/20260831144732.80910-3-sj@kernel.org
Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Signed-off-by: SJ Park <sj@kernel.org>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-damon-introduce-damos_quota_hugepage-auto-tuning.patch
mm-damon-sysfs-support-hugepage_mem_bp-quota-goal-metric.patch
docs-mm-damon-design-document-hugepage_mem_bp-target-metric.patch

