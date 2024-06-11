Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C31A171A5
	for <mm-commits@vger.kernel.org>; Tue, 11 Jun 2024 19:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718133053; cv=none; b=tzK1XlEFSPb6dEcCAwX8sPda3T4wLRk26InSsYj7oZnSctiLdLEJnn96u8Ak2YJwsuSW7VHuQk3Z1l1fiwjx2Jjhuj2yZTxqBOO2rnzRcKpu8yGbdczuO1Ci0Ua3yqXsOiG0a1rZfk03hGUGAWoyYS9N03rOKojw8K7RhbJjNnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718133053; c=relaxed/simple;
	bh=OrEWP1I0bhOAM1KmQPcSc3uvVhEsDTjSzs5MJ4C9O8I=;
	h=Date:To:From:Subject:Message-Id; b=dn2mLZ1zSvYg8PIX+4xXXpHWeNiqgJnwO1UQbDNoRpIsdblqM+MAP/C6+PbKcCq26kvb8NR8GbUJ5mX8kLJjvVVdGeZp9yuVeBhcJRk9/JvCiucmeacHRiAQBYnzfhGfU3lElh8d0yGoCWH+He3Rx3uoa7hCP2YoSjYKgeZNvHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aIBxFfPi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aIBxFfPi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C21E9C2BD10;
	Tue, 11 Jun 2024 19:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718133052;
	bh=OrEWP1I0bhOAM1KmQPcSc3uvVhEsDTjSzs5MJ4C9O8I=;
	h=Date:To:From:Subject:From;
	b=aIBxFfPi97bXp1JbxBi4k3p4J6xxdrnUDPtqR/e6/s3GqiHBCaT6zXXFI5PqBB5s8
	 nZFtCejSVFSxRGG1+JxqGKw6hSk1A1WjzCvFdNzoKOptb7aBDLtlBaBrKix96yGsCU
	 zCwHV17Kf8MrFXnArF06NFGZCo0STQqsWB+ojZ2I=
Date: Tue, 11 Jun 2024 12:10:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,wangkefeng.wang@huawei.com,v-songbaohua@oppo.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-add-thp-validation-for-pmd-mapped-thp-related-statistics.patch added to mm-unstable branch
Message-Id: <20240611191052.C21E9C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: add THP validation for PMD-mapped THP related statistics
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-add-thp-validation-for-pmd-mapped-thp-related-statistics.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-add-thp-validation-for-pmd-mapped-thp-related-statistics.patch

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
Subject: mm: shmem: add THP validation for PMD-mapped THP related statistics
Date: Tue, 11 Jun 2024 18:11:06 +0800

In order to extend support for mTHP, add THP validation for PMD-mapped THP
related statistics to avoid statistical confusion.

Link: https://lkml.kernel.org/r/c4b04cbd51e6951cc2436a87be8eaa4a1516faec.1718090413.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <v-songbaohua@oppo.com>
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

 mm/shmem.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/shmem.c~mm-shmem-add-thp-validation-for-pmd-mapped-thp-related-statistics
+++ a/mm/shmem.c
@@ -1647,7 +1647,7 @@ static struct folio *shmem_alloc_and_add
 			return ERR_PTR(-E2BIG);
 
 		folio = shmem_alloc_folio(gfp, HPAGE_PMD_ORDER, info, index);
-		if (!folio)
+		if (!folio && pages == HPAGE_PMD_NR)
 			count_vm_event(THP_FILE_FALLBACK);
 	} else {
 		pages = 1;
@@ -1665,7 +1665,7 @@ static struct folio *shmem_alloc_and_add
 		if (xa_find(&mapping->i_pages, &index,
 				index + pages - 1, XA_PRESENT)) {
 			error = -EEXIST;
-		} else if (huge) {
+		} else if (pages == HPAGE_PMD_NR) {
 			count_vm_event(THP_FILE_FALLBACK);
 			count_vm_event(THP_FILE_FALLBACK_CHARGE);
 		}
@@ -2031,7 +2031,8 @@ repeat:
 		folio = shmem_alloc_and_add_folio(huge_gfp,
 				inode, index, fault_mm, true);
 		if (!IS_ERR(folio)) {
-			count_vm_event(THP_FILE_ALLOC);
+			if (folio_test_pmd_mappable(folio))
+				count_vm_event(THP_FILE_ALLOC);
 			goto alloced;
 		}
 		if (PTR_ERR(folio) == -EEXIST)
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-memory-extend-finish_fault-to-support-large-folio.patch
mm-shmem-add-thp-validation-for-pmd-mapped-thp-related-statistics.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem.patch
mm-shmem-add-mthp-support-for-anonymous-shmem.patch
mm-shmem-add-mthp-size-alignment-in-shmem_get_unmapped_area.patch
mm-shmem-add-mthp-counters-for-anonymous-shmem.patch

