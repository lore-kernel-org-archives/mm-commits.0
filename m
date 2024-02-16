Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD1F8F49
	for <mm-commits@vger.kernel.org>; Fri, 16 Feb 2024 01:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708047110; cv=none; b=kcLJks/+D4YST7mdbsnWzQTYY04299yqlHqeVSATW314nt3XQN6JU7pQqaO9QvHr+OXbbNXGXoi+IC70zBnw22+g/XLcp7twAJDr+1NR+lSrg2aqiU6SizsEfagbRZUX2v5h9w+glwhqoZyiDADoI3VC8+bRe4HLTcGb9h5Q7vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708047110; c=relaxed/simple;
	bh=96VoHJ8h/Q9Jm/y8iqDfTn5tiETcrIweS1k3EJf4JaM=;
	h=Date:To:From:Subject:Message-Id; b=preLDyqF8sDkCNosSVPoIFbpi+I86SwRja1MM7+xHE1rbz0kTaqQtMJeioVyaAB8X/zHAruPEhcxpyXWBnwEm+BEAgANEk4rRTqMmiNQ/MDqoEhGFRSLdoyhFqKjC0lbOWpG0hk7hwpP+cZGScvtwUn6WBoRPjRJi4xFQjYnaUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s6wNSmGu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s6wNSmGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0778FC433C7;
	Fri, 16 Feb 2024 01:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708047110;
	bh=96VoHJ8h/Q9Jm/y8iqDfTn5tiETcrIweS1k3EJf4JaM=;
	h=Date:To:From:Subject:From;
	b=s6wNSmGuYbRhG4PSPH3UYjf0FulRRKXL5EwCSo5RhmsdG8H++hSe0FuoZXS5EcwXM
	 i/bFmaRHV1VA9D/Nesmoe0Dzsg4MLal0+gzBmzBNtSkJsghqin22lrQG3KPPKe/3IP
	 8yaqKZ7egQ4pEi0N4hrX/d7/3y3LAxqRzxK5y6RQ=
Date: Thu, 15 Feb 2024 17:31:49 -0800
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-hugetlb-ensure-adequate-cma-areas-available-for-hugetlb_cma.patch removed from -mm tree
Message-Id: <20240216013150.0778FC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: ensure adequate CMA areas available for hugetlb_cma[]
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-ensure-adequate-cma-areas-available-for-hugetlb_cma.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/hugetlb: ensure adequate CMA areas available for hugetlb_cma[]
Date: Thu, 15 Feb 2024 10:04:05 +0530

HugeTLB CMA area array is being created for possible MAX_NUMNODES without
ensuring corresponding MAX_CMA_AREAS support in CMA.  This fails the build
for such scenarios indicating need for CONFIG_CMA_AREAS adjustment.

Link: https://lkml.kernel.org/r/20240215043405.2379295-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-ensure-adequate-cma-areas-available-for-hugetlb_cma
+++ a/mm/hugetlb.c
@@ -7855,6 +7855,13 @@ void __init hugetlb_cma_reserve(int orde
 	}
 
 	reserved = 0;
+
+	/*
+	 * There needs to be enough MAX_CMA_AREAS to accommodate
+	 * MAX_NUMNODES heap areas being created here. Otherwise
+	 * adjust CONFIG_CMA_AREAS as required.
+	 */
+	BUILD_BUG_ON(MAX_CMA_AREAS < MAX_NUMNODES);
 	for_each_online_node(nid) {
 		int res;
 		char name[CMA_MAX_NAME];
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-memblock-add-memblock_rsrv_noinit-into-flagname-array.patch
mm-cma-dont-treat-bad-input-arguments-for-cma_alloc-as-its-failure.patch
mm-cma-drop-config_cma_debug.patch
mm-cma-make-max_cma_areas-=-config_cma_areas.patch
mm-cma-add-sysfs-file-release_pages_success.patch
mm-hugetlb-move-page-order-check-inside-hugetlb_cma_reserve.patch

