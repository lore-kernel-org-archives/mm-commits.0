Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD7E29AB15
	for <mm-commits@vger.kernel.org>; Sun, 28 Dec 2025 22:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766962252; cv=none; b=QqW7oiamlR3MwxUsRkJNf577EEHyjbuwJrXcLphvg3rxtg9RG13mK7DbBT7qrlQFLS9wSt/hlq5b5Z2ZiN6OxrW5LvnhI/0aI4sBJpBt5VFRXFtR7LtWZE7+tvkywDG+/NZSucbNjNPXJad4XWvnCIPswVvY2HNesm+1h9Sq+Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766962252; c=relaxed/simple;
	bh=yVabb3Z4b/2h1tDY+Fr32JI1EvzljlR5M+tTnc3+egg=;
	h=Date:To:From:Subject:Message-Id; b=AUKjaD2QJmWtl8akiEZzfHqqnmTYiloJhl1HwW5nPJmSik4JerV8tPO9+D7PvlZsbiZk4PnY6igg/SjHJ55S/WQAU+uISZVtIOLM0MV4SlZLfL+5+ZylkMqDwlfS6N9A4cyIQBE79VNi3CgA222PnbGqsDeXM8eMxj9pmSGxg4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rImWHDwV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rImWHDwV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C1CC4CEFB;
	Sun, 28 Dec 2025 22:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766962252;
	bh=yVabb3Z4b/2h1tDY+Fr32JI1EvzljlR5M+tTnc3+egg=;
	h=Date:To:From:Subject:From;
	b=rImWHDwVTaV9GtT6JM6ChD7WjLcpoI9ugf1Juugtam8gfRnoEnqNpbnVGKf9jLn3e
	 PBKiKUgixszEl6cQHd2cHalSLm1I3ZR+pCtcDgnJz3tccVbPINSo0890Ud7IlGWqcG
	 gvlm0WwDDt9FsYyrPvclAZFb2ZdY8djdbGj+z8eI=
Date: Sun, 28 Dec 2025 14:50:51 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-remove-unnecessary-goto-skip-label.patch added to mm-new branch
Message-Id: <20251228225052.41C1CC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: remove unnecessary goto 'skip' label
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-remove-unnecessary-goto-skip-label.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-remove-unnecessary-goto-skip-label.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Shivank Garg <shivankg@amd.com>
Subject: mm/khugepaged: remove unnecessary goto 'skip' label
Date: Wed, 24 Dec 2025 11:13:51 +0000

Patch series "mm/khugepaged: cleanups and scan limit fix", v2.

This series contains several cleanups for mm/khugepaged.c to improve code
readability and type safety, and one functional fix to ensure
khugepaged_scan_mm_slot() correctly accounts for small VMAs towards scan
limit.


This patch (of 5):

Replace goto skip with actual logic for better code readability.

No functional change.

Link: https://lkml.kernel.org/r/20251224111351.41042-4-shivankg@amd.com
Link: https://lkml.kernel.org/r/20251224111351.41042-6-shivankg@amd.com
Signed-off-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-remove-unnecessary-goto-skip-label
+++ a/mm/khugepaged.c
@@ -2442,14 +2442,15 @@ static unsigned int khugepaged_scan_mm_s
 			break;
 		}
 		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
-skip:
 			progress++;
 			continue;
 		}
 		hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
 		hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
-		if (khugepaged_scan.address > hend)
-			goto skip;
+		if (khugepaged_scan.address > hend) {
+			progress++;
+			continue;
+		}
 		if (khugepaged_scan.address < hstart)
 			khugepaged_scan.address = hstart;
 		VM_BUG_ON(khugepaged_scan.address & ~HPAGE_PMD_MASK);
_

Patches currently in -mm which might be from shivankg@amd.com are

mm-khugepaged-map-dirty-writeback-pages-failures-to-eagain.patch
mm-khugepaged-retry-with-sync-writeback-for-madv_collapse.patch
mm-khugepaged-remove-unnecessary-goto-skip-label.patch
mm-khugepaged-count-small-vmas-towards-scan-limit.patch
mm-khugepaged-count-small-vmas-towards-scan-limit-fix.patch
mm-khugepaged-change-collapse_pte_mapped_thp-to-return-void.patch
mm-khugepaged-use-enum-scan_result-for-result-variables-and-return-types.patch
mm-khugepaged-make-khugepaged_collapse_control-static.patch

