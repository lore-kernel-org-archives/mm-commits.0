Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9785F28379
	for <mm-commits@vger.kernel.org>; Wed,  3 Jul 2024 20:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720039168; cv=none; b=JXBhpwVAwnory2cg1aHmqBblNdlooRQkZUKuStjJXC5e8l9XasywzUrvZG1SI14Vakq1qypGUqEi7SsNbGvbWSGBRilFiJ8mSIrgAzM8Q2gWLmhbTGsLz11WXzOv4engpwok7IKOCQFuoWocH6SbtRXMcmgN8oT2CPFaCgBj4+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720039168; c=relaxed/simple;
	bh=CpVKqJnP+XVVQQAPrUbx1sC4iBjzut7GuYC8uif3mOk=;
	h=Date:To:From:Subject:Message-Id; b=AvdafY1DvRxx/2mrIm5jKAUbSLuxCUjzxOIPZwSnvL1ZH3DxgbjTOi+H5zRr7Cq6Jd2eyRfV7MYxVWWQnCfQW3qooa1htx0uQcXLttKnUre2BO49haaPeffy9UMNhcPwPLdLzQSRUhd5Dq4mXb3mDdO0mua7DRT8M2kadC0iLkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p7Xcdyxy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p7Xcdyxy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C4CC2BD10;
	Wed,  3 Jul 2024 20:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720039168;
	bh=CpVKqJnP+XVVQQAPrUbx1sC4iBjzut7GuYC8uif3mOk=;
	h=Date:To:From:Subject:From;
	b=p7XcdyxyN+qu809f62PL71c5pTmFNv2ZiHOPPBvpnt165YNGYB74B/gKLt68d2E/O
	 UFbvU1Dp1FqUXBBfDdU6AwVQ2ryghkauqU0J4f057EWm5Zjfa0OOgvqqZxbQbUaFO/
	 SmoIVmJYJnpK3quVcsyVc7vkmlJ81USZ4gMTuAOc=
Date: Wed, 03 Jul 2024 13:39:27 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,sidhartha.kumar@oracle.com,lizefan.x@bytedance.com,linmiaohe@huawei.com,hannes@cmpxchg.org,corbet@lwn.net,baolin.wang@linux.alibaba.com,xiujianfeng@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_cgroup-introduce-peak-and-rsvdpeak-to-v2.patch added to mm-unstable branch
Message-Id: <20240703203928.16C4CC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb_cgroup: introduce peak and rsvd.peak to v2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_cgroup-introduce-peak-and-rsvdpeak-to-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_cgroup-introduce-peak-and-rsvdpeak-to-v2.patch

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
@@ -2590,6 +2590,14 @@ HugeTLB Interface Files
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

mm-memcg-remove-redundant-seq_buf_has_overflowed.patch
mm-memcg-adjust-the-warning-when-seq_buf-overflows.patch
mm-hugetlb_cgroup-introduce-peak-and-rsvdpeak-to-v2.patch

