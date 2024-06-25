Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8101BC4E
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719289546; cv=none; b=P2zOFRXm8aeq33POdJurZPBK/9vvSciUwP9tVVS1y6jZvZFOYUv01QSwReIsU8OIqq3wMmXsh71EZ95bmBI83x5jLxQv/YElaQ1sr4IosL2q961afwKfwAnzQEaNF/EZXIh8ukICxv8UGJpOC2X1wProUCCp5ak3Gc+JI7Wtz9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719289546; c=relaxed/simple;
	bh=mvNDnbK07fAzmK9w1E2a1uWeqLWSMNJzVS3PDS5GxSw=;
	h=Date:To:From:Subject:Message-Id; b=EJ0GZKsQfLnD0xz0jZDhwxwXFAOCE9/QnYpr7EhjUyCl0TRTv/fM7Z56hEKiCJ5mQLEn/8Yg0XsLFoZQXWFBt/DtWCkqNBdglfEruh535ApmE4+TGGgK28vst9rUlDltSvpYIgc8NGRkBDfYtoGcL/Y4TACyeXbIl9QI8nQ+2ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sS/V4Yj2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sS/V4Yj2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E20C32782;
	Tue, 25 Jun 2024 04:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719289545;
	bh=mvNDnbK07fAzmK9w1E2a1uWeqLWSMNJzVS3PDS5GxSw=;
	h=Date:To:From:Subject:From;
	b=sS/V4Yj2cJZNvtBumxUBbVFmpGK/DHJp2Kf8ZgHIoqrx72WRWSKQVOKVi8nxNv7Lz
	 txOpChDpVRs3A7bzdvuVNZaCjDgRz9sb12IakTbtVzZT05rJja8PoeYCk/RzqBmJy6
	 lbBC18+JFtilsXI375chneECTn2nDYS4mp/9D/dE=
Date: Mon, 24 Jun 2024 21:25:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,wangkefeng.wang@huawei.com,v-songbaohua@oppo.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-shmem-add-mthp-counters-for-anonymous-shmem-fix.patch removed from -mm tree
Message-Id: <20240625042545.A0E20C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-shmem-add-mthp-counters-for-anonymous-shmem-fix
has been removed from the -mm tree.  Its filename was
     mm-shmem-add-mthp-counters-for-anonymous-shmem-fix.patch

This patch was dropped because it was folded into mm-shmem-add-mthp-counters-for-anonymous-shmem.patch

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm-shmem-add-mthp-counters-for-anonymous-shmem-fix
Date: Thu, 13 Jun 2024 09:08:37 +0800

update Documentation/admin-guide/mm/transhuge.rst

Link: https://lkml.kernel.org/r/d86e2e7f-4141-432b-b2ba-c6691f36ef0b@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-shmem-add-mthp-counters-for-anonymous-shmem-fix
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -501,6 +501,19 @@ swpout_fallback
 	Usually because failed to allocate some continuous swap space
 	for the huge page.
 
+file_alloc
+	is incremented every time a file huge page is successfully
+	allocated.
+
+file_fallback
+	is incremented if a file huge page is attempted to be allocated
+	but fails and instead falls back to using small pages.
+
+file_fallback_charge
+	is incremented if a file huge page cannot be charged and instead
+	falls back to using small pages even though the allocation was
+	successful.
+
 As the system ages, allocating huge pages may be expensive as the
 system uses memory compaction to copy data around memory to free a
 huge page for use. There are some counters in ``/proc/vmstat`` to help
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-memory-extend-finish_fault-to-support-large-folio.patch
mm-shmem-add-thp-validation-for-pmd-mapped-thp-related-statistics.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem.patch
mm-shmem-add-mthp-support-for-anonymous-shmem.patch
mm-shmem-add-mthp-size-alignment-in-shmem_get_unmapped_area.patch
mm-shmem-add-mthp-counters-for-anonymous-shmem.patch
mm-memcontrol-add-vm_bug_on_folio-to-catch-lru-folio-in-mem_cgroup_migrate.patch

