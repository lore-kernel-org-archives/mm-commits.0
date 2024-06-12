Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F42386131
	for <mm-commits@vger.kernel.org>; Wed, 12 Jun 2024 18:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718217235; cv=none; b=ZangXHlnIAZkO+AF7dMevEm9Fl10gMRDEwSpruGiqR2Kv2bRLAnoZ4JDAV0E1dQpWy+jXke7j1jCx4+Kna0PkNxOI1DoEYvD+y6Qo/nQfEN914TgiUqNvx0cDHBftlmRZyRVhYcrp3ng1eSsibv1vq08zUARGlXQ1JGmB3rrN00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718217235; c=relaxed/simple;
	bh=88UloMwbbghy1eq3xAP3d3stG2qttcTYc1QIbccqwoA=;
	h=Date:To:From:Subject:Message-Id; b=ZPpqLOVMmUiOh16+lCFUX0yfebGzRVif9QIi0PXDUlXLVLtG9B++pyQHqxs48B3AyU/nfGc3knB4qI2g0k2wXvc76hiL/VbfTouot5pGD+pOvYrfXQnkZVcNKRxC0eoL/cAMCiJWfBLOH4pqFurTtWWh//TsCfMf1iQudSDVOv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=loBX5pSb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="loBX5pSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08DBBC116B1;
	Wed, 12 Jun 2024 18:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718217235;
	bh=88UloMwbbghy1eq3xAP3d3stG2qttcTYc1QIbccqwoA=;
	h=Date:To:From:Subject:From;
	b=loBX5pSbJaon1J7TjaVurkGiG1xuvMDlj3D3q/etIOLSbnMBneX99tNcidXPQmuQt
	 iTnxj0m1hbSmaaXDix8rcAoC226VMBq6GC1qEoC66F8o8ri8rldm7WsEbhSWSUr6iu
	 +eKfFPXg+0DUCS0idjvkqx9we+jyEi95TZ7k+b7Q=
Date: Wed, 12 Jun 2024 11:33:54 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,xiujianfeng@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_cgroup-identify-the-legacy-using-cgroup_subsys_on_dfl.patch added to mm-unstable branch
Message-Id: <20240612183355.08DBBC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb_cgroup: identify the legacy using cgroup_subsys_on_dfl()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_cgroup-identify-the-legacy-using-cgroup_subsys_on_dfl.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_cgroup-identify-the-legacy-using-cgroup_subsys_on_dfl.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Xiu Jianfeng <xiujianfeng@huawei.com>
Subject: mm/hugetlb_cgroup: identify the legacy using cgroup_subsys_on_dfl()
Date: Wed, 12 Jun 2024 09:24:07 +0000

Patch series "mm/hugetlb_cgroup: rework on cftypes", v3.

This patchset provides an intuitive view of the control files through
static templates of cftypes.  This improves the readability of the code.  


This patch (of 3):

Currently the numa_stat file encodes 1 into .private using the micro
MEMFILE_PRIVATE() to identify the legacy.  Actually, we can use
cgroup_subsys_on_dfl() instead.  This is helpful to handle .private in the
static templates in the next patch.

Link: https://lkml.kernel.org/r/20240612092409.2027592-1-xiujianfeng@huawei.com
Link: https://lkml.kernel.org/r/20240612092409.2027592-2-xiujianfeng@huawei.com
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb_cgroup.c~mm-hugetlb_cgroup-identify-the-legacy-using-cgroup_subsys_on_dfl
+++ a/mm/hugetlb_cgroup.c
@@ -460,7 +460,7 @@ static int hugetlb_cgroup_read_numa_stat
 	int nid;
 	struct cftype *cft = seq_cft(seq);
 	int idx = MEMFILE_IDX(cft->private);
-	bool legacy = MEMFILE_ATTR(cft->private);
+	bool legacy = !cgroup_subsys_on_dfl(hugetlb_cgrp_subsys);
 	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_css(seq_css(seq));
 	struct cgroup_subsys_state *css;
 	unsigned long usage;
@@ -839,7 +839,7 @@ static void __init __hugetlb_cgroup_file
 	/* Add the numa stat file */
 	cft = &h->cgroup_files_legacy[8];
 	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.numa_stat", buf);
-	cft->private = MEMFILE_PRIVATE(idx, 1);
+	cft->private = MEMFILE_PRIVATE(idx, 0);
 	cft->seq_show = hugetlb_cgroup_read_numa_stat;
 
 	/* NULL terminate the last cft */
_

Patches currently in -mm which might be from xiujianfeng@huawei.com are

mm-hugetlb_cgroup-identify-the-legacy-using-cgroup_subsys_on_dfl.patch
mm-hugetlb_cgroup-prepare-cftypes-based-on-template.patch
mm-hugetlb_cgroup-switch-to-the-new-cftypes.patch

