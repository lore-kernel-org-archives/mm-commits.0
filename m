Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D473413A3F7
	for <mm-commits@vger.kernel.org>; Thu, 13 Jun 2024 21:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718313536; cv=none; b=IYtu/WuWMdoE0eno793YrptIYqZGtCTaA1+ysezlycjROTZ6aNl98/g4XFh3gJCFQgNU7loIbfv2c/gUp25L/p4KwLkAuzusY5OHMRjFCG700vjyc0DtJ5uiX4cmyNBxjsHXytXGr/wPR4rSx5Aveon9/+syxKuJnBZFKB9Eg+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718313536; c=relaxed/simple;
	bh=YYP6xQOsFGAf++34MYoNQlXaIKEMCF2xFMGkgnnrEYQ=;
	h=Date:To:From:Subject:Message-Id; b=CxYON4+UYWQn8t+4ZPgwZQbHxoWsvmVvJXnBkaXF7xlClcdiqqqFZtEHuPKnIG2+ddDSRMTxUsGDDjG2UbIlcCtRiJ0hJpXEBYilHCS/yX3qMyvtCEJCGW7JkIRAadI1qzwFMtg5gKkBxOTcs8xAA09a2uFJ1rMN0NwWmzSyQX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qhWdc/fr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qhWdc/fr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78CF6C32786;
	Thu, 13 Jun 2024 21:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718313536;
	bh=YYP6xQOsFGAf++34MYoNQlXaIKEMCF2xFMGkgnnrEYQ=;
	h=Date:To:From:Subject:From;
	b=qhWdc/frSX8IJ8YG/qv11hNimhcjFaEJvUesOuGmZ0u6+c316O5rS0NSKSGHDNPgF
	 t2ivs/QJacojzdkOxjiw1GdWDUQEUB5Nz2DQiUgXStHioi+r7SBuvKPvvGlAtOjsor
	 tFPkNTAHTI7poEt1j7NyfqnJp3VK59jb2ahlPQCA=
Date: Thu, 13 Jun 2024 14:18:55 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,wangkefeng.wang@huawei.com,v-songbaohua@oppo.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-add-mthp-counters-for-anonymous-shmem-fix.patch added to mm-unstable branch
Message-Id: <20240613211856.78CF6C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-shmem-add-mthp-counters-for-anonymous-shmem-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-add-mthp-counters-for-anonymous-shmem-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-add-mthp-counters-for-anonymous-shmem-fix.patch

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

mm-shmem-fix-getting-incorrect-lruvec-when-replacing-a-shmem-folio.patch
mm-memory-extend-finish_fault-to-support-large-folio.patch
mm-memory-extend-finish_fault-to-support-large-folio-fix.patch
mm-shmem-add-thp-validation-for-pmd-mapped-thp-related-statistics.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix.patch
mm-shmem-add-mthp-support-for-anonymous-shmem.patch
mm-shmem-add-mthp-size-alignment-in-shmem_get_unmapped_area.patch
mm-shmem-add-mthp-counters-for-anonymous-shmem.patch
mm-shmem-add-mthp-counters-for-anonymous-shmem-fix.patch

