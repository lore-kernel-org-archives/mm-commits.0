Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74AC713D289
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291699; cv=none; b=L3kEn2/xhAaULl1l8TMReM0tKH2887LV/JUhLVJekqg+AzzDlwL82cu9c1mwt3UQBj0JmkAf7Fu+yXK+30TenGboip4KPGwjUlac/fjPsw8b7vSwlyem/NRe/J4h7cFxnbw6FlUbmsA9HWgPnMKRz8yE0ne47d96b2ax/QFMkMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291699; c=relaxed/simple;
	bh=fxcEMGFlPEZUWUPTQG3peXNZDDtDEZItY6wdZjc4rkU=;
	h=Date:To:From:Subject:Message-Id; b=ciaJmuAhFHoiZhflZH0WBjtgtl9QfKMoadU/x85ZIbYLyfPMnfM6EQ8Bw7fj89ElEt34ZE4ou1mGvLsluSmCF46AAm6gL9zhztJWIZYDyz6sple3mxV2ot8h/+0CwfCwKJFcE+x6omUG5xp/tqkHbkfRMXjuYEwLS5CJT8ILE1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d7HTopeI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d7HTopeI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7901C32782;
	Tue, 25 Jun 2024 05:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291699;
	bh=fxcEMGFlPEZUWUPTQG3peXNZDDtDEZItY6wdZjc4rkU=;
	h=Date:To:From:Subject:From;
	b=d7HTopeIXKg9d0M7YtMmL6KqTp5+Y1GQ4ajZE5SU6HIIvuCQvKkQrh8/BJksmSyKi
	 CrDoPzz9K15LEOrwR0YQlXA8oxw2xLEiPjjbFDsmqfl8fowAp0YCrdMDGHEbNmJB7z
	 R4llpy5HyPFojk++AZ85M1i7bGmfRdf785Jf3nFc=
Date: Mon, 24 Jun 2024 22:01:38 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,xiujianfeng@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_cgroup-identify-the-legacy-using-cgroup_subsys_on_dfl.patch removed from -mm tree
Message-Id: <20240625050138.E7901C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb_cgroup: identify the legacy using cgroup_subsys_on_dfl()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_cgroup-identify-the-legacy-using-cgroup_subsys_on_dfl.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


