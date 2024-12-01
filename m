Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E711B5474C
	for <mm-commits@vger.kernel.org>; Sun,  1 Dec 2024 06:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733035950; cv=none; b=EuOaZUq7iBHplJph4mK539DWiBDBpZetnEm43fGRgCb9q8vxRjj/rZHxKn5y5Q+zRGvWxs9A1+ZP6m0qEsdGaIzfcDoeAW3PLfOdNbnI6vLHCjgW3PLRslCp99yp71E+NrwP06oLcq2Xlf6z4TDQhjBRn3qwwb3rFaVqc5dhDJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733035950; c=relaxed/simple;
	bh=RXswzevWjLeTVZw1InRDL0f8y3uEIFmnGrA/Prs2ckg=;
	h=Date:To:From:Subject:Message-Id; b=TSkeoPGUlrdwtFrwcAlcFmLogKVfpqjGuqr1zeSSZJgRgy4xax0sDB9qdJgvwXzsjINPtLw0x8L/rpzmt1ddZcJOG95hWU/krMeV8MJjZY98U3aURXzAoM/FaygbtbnqPaHpqA3mlNoueNHF/J9ms47lnWTfpXQtlP0oDXDLQOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QW2STu55; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QW2STu55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF11CC4CECF;
	Sun,  1 Dec 2024 06:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733035949;
	bh=RXswzevWjLeTVZw1InRDL0f8y3uEIFmnGrA/Prs2ckg=;
	h=Date:To:From:Subject:From;
	b=QW2STu55OGAuiuZZX/vnPkMxvNc3KPgyVc5CXn44m1kYBhHAvrQ8wlUOFVgRvOCJH
	 eDDGj8h7go2KPoP8vs7TA0Bt+2aQrh8y849UiCRdznXDlvGc01c26l/OKHVFIOG2fT
	 mfUv2XCVOMelgSXLB7EsoMEltf3Lg3Nq4GVd50SQ=
Date: Sat, 30 Nov 2024 22:52:29 -0800
To: mm-commits@vger.kernel.org,tj@kernel.org,sidhartha.kumar@oracle.com,lizefan.x@bytedance.com,linmiaohe@huawei.com,hannes@cmpxchg.org,corbet@lwn.net,baolin.wang@linux.alibaba.com,xiujianfeng@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb_cgroup-introduce-peak-and-rsvdpeak-to-v2.patch removed from -mm tree
Message-Id: <20241201065229.AF11CC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb_cgroup: introduce peak and rsvd.peak to v2
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_cgroup-introduce-peak-and-rsvdpeak-to-v2.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Xiu Jianfeng <xiujianfeng@huawei.com>
Subject: mm/hugetlb_cgroup: introduce peak and rsvd.peak to v2
Date: Tue, 2 Jul 2024 12:57:28 +0000

Introduce peak and rsvd.peak to v2 to show the historical maximum usage of
resources, as in some scenarios it is necessary to configure the value of
max/rsvd.max based on the peak usage of resources.

Since HugeTLB doesn't support page reclaim, enforcing the limit at page
fault time implies that, the application will get SIGBUS signal if it
tries to fault in HugeTLB pages beyond its limit.  Therefore the
application needs to know exactly how many HugeTLB pages it uses before
hand, and the sysadmin needs to make sure that there are enough available
on the machine for all the users to avoid processes getting SIGBUS.

When running some open-source software, it may not be possible to know the
exact amount of hugetlb it consumes, so cannot correctly configure the max
value.  If there is a peak metric, we can run the open-source software
first and then configure the max based on the peak value.  In cgroup v1,
the hugetlb controller provides the max_usage_in_bytes and
rsvd.max_usage_in_bytes interface to display the historical maximum usage,
so introduce peak and rsvd.peak to v2 to address this issue.

Link: https://lkml.kernel.org/r/20240702125728.2743143-1-xiujianfeng@huawei.com
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    8 ++++++++
 mm/hugetlb_cgroup.c                     |   19 +++++++++++++++++++
 2 files changed, 27 insertions(+)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-hugetlb_cgroup-introduce-peak-and-rsvdpeak-to-v2
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -2659,6 +2659,14 @@ HugeTLB Interface Files
         hugetlb pages of <hugepagesize> in this cgroup.  Only active in
         use hugetlb pages are included.  The per-node values are in bytes.
 
+  hugetlb.<hugepagesize>.peak
+	Show historical maximum usage for "hugepagesize" hugetlb.  It exists
+        for all the cgroup except root.
+
+  hugetlb.<hugepagesize>.rsvd.peak
+	Show historical maximum usage for "hugepagesize" hugetlb reservations.
+        It exists for all the cgroup except root.
+
 Misc
 ----
 
--- a/mm/hugetlb_cgroup.c~mm-hugetlb_cgroup-introduce-peak-and-rsvdpeak-to-v2
+++ a/mm/hugetlb_cgroup.c
@@ -583,6 +583,13 @@ static int hugetlb_cgroup_read_u64_max(s
 		else
 			seq_printf(seq, "%llu\n", val * PAGE_SIZE);
 		break;
+	case RES_RSVD_MAX_USAGE:
+		counter = &h_cg->rsvd_hugepage[idx];
+		fallthrough;
+	case RES_MAX_USAGE:
+		val = (u64)counter->watermark;
+		seq_printf(seq, "%llu\n", val * PAGE_SIZE);
+		break;
 	default:
 		BUG();
 	}
@@ -739,6 +746,18 @@ static struct cftype hugetlb_dfl_tmpl[]
 		.seq_show = hugetlb_cgroup_read_u64_max,
 		.flags = CFTYPE_NOT_ON_ROOT,
 	},
+	{
+		.name = "peak",
+		.private = RES_MAX_USAGE,
+		.seq_show = hugetlb_cgroup_read_u64_max,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+	{
+		.name = "rsvd.peak",
+		.private = RES_RSVD_MAX_USAGE,
+		.seq_show = hugetlb_cgroup_read_u64_max,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
 	{
 		.name = "events",
 		.seq_show = hugetlb_events_show,
_

Patches currently in -mm which might be from xiujianfeng@huawei.com are


