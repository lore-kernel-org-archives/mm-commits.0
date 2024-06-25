Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748D014431F
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291632; cv=none; b=G6t2HqOk0pVaRoy829R9IzNk/FLzrZP5QFW/ceLA9uiWaFfRWJwWat6k/19HUlhZHzzbINQB1rzl7QMA4uFw2ydOIoRS0+8kU2JMwz8J5MxGmwC934Au7riObNiOP7eqpiGcgYsQbsE8VQu1DEnLw/KWKgKdhsNTAamtB3+x7Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291632; c=relaxed/simple;
	bh=iYnM3PlnJCKieFeFzBOdFFnnwYGUu99ZOd9VfFGJhYc=;
	h=Date:To:From:Subject:Message-Id; b=VjND0cVP6uTdcewHy3adojM8sRUEdY7B5+l6seGtLe2DZT25x+jz3p2/2gWUrcFMDq6D1El96BvdKSmSWboK9OlRvUj38ou2Amx9aLt+UJKqUJjfo4M1+Lf5FLlAVu58+t/alw9SYuXkLs05AcCSNWFJkKmYJRbarubZaJkAcdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z1XNdFoV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z1XNdFoV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F69C4AF07;
	Tue, 25 Jun 2024 05:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291632;
	bh=iYnM3PlnJCKieFeFzBOdFFnnwYGUu99ZOd9VfFGJhYc=;
	h=Date:To:From:Subject:From;
	b=Z1XNdFoVRckKyEaHUOFo5xqhPheXMyqJdHAb1EbrWK62gcOuZLXHN01dZWbAEsDkY
	 9qhSjHPpFpgLqqAjl7BL8eq7Fy4Zh48AFI+ZnJKEQ+Ui8VyQbVp0n7W7unycMocvNo
	 3fitT8wNebOZsuixlTxCSWrkyj3igEWyl6TAE2E8=
Date: Mon, 24 Jun 2024 22:00:31 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,wangkefeng.wang@huawei.com,v-songbaohua@oppo.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-add-thp-validation-for-pmd-mapped-thp-related-statistics.patch removed from -mm tree
Message-Id: <20240625050032.49F69C4AF07@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: add THP validation for PMD-mapped THP related statistics
has been removed from the -mm tree.  Its filename was
     mm-shmem-add-thp-validation-for-pmd-mapped-thp-related-statistics.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


