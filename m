Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF67A20CCDC
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898233; cv=none; b=qIG+ZvTkY8pqQmslsT2O5pzpR6/tyiDWrEZuQYr4ZdCqy1s8e5kT1hvzWHLh+w8cPWv1z9H3gmLlJEn89bn/Tsoz0IQEkmKrF6nSzQuQmE4/qp+OHiJpBtvPPPjTKljarYtQiJ3/SKhw2Yr25LKvq/B8xBn0xW76ozLj/wN1oLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898233; c=relaxed/simple;
	bh=BKGSN00JVCtA9Px2mXe6zDBpnYqiuwYFGvGa5tSVyyc=;
	h=Date:To:From:Subject:Message-Id; b=qVvgkjqEXg/WevAbc9TX5UeH3YNmQeP6FwovYZWo7zI28sXdSKe6Bd5rZckQjs8j91oe8nfTIbbzV7QU6P8gk7dKYOuswhpYHH2InBMh9O8jWSS2hMWoHsbTDkzYX4msJVI83Ftz2NveNQclDsYc+VEttkaq36wFEBBPuzV46Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qPORbpH5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qPORbpH5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89548C4CEF1;
	Sat, 31 Jan 2026 22:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898232;
	bh=BKGSN00JVCtA9Px2mXe6zDBpnYqiuwYFGvGa5tSVyyc=;
	h=Date:To:From:Subject:From;
	b=qPORbpH5k//fuOz1rflTaqrq17WBT4EAafA81Gf+9VcixOHHcz95bUp5Z2LAaGyYK
	 cm04FW+YecA4njLPtxM0q8sjZ9Feml0SxJtYF2ZRkWK86mQamJebfQfa+vMJ9nAEJE
	 cvqfvsxrW9WQXjGhBuZhOTMlr/FJkACgkfawrMs4=
Date: Sat, 31 Jan 2026 14:23:51 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,anshuman.khandual@arm.com,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-remove-unnecessary-goto-skip-label.patch removed from -mm tree
Message-Id: <20260131222352.89548C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: remove unnecessary goto 'skip' label
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-remove-unnecessary-goto-skip-label.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shivank Garg <shivankg@amd.com>
Subject: mm/khugepaged: remove unnecessary goto 'skip' label
Date: Sun, 18 Jan 2026 19:22:53 +0000

Patch series "mm/khugepaged: cleanups and scan limit fix", v3.

This series contains several cleanups for mm/khugepaged.c to improve code
readability and type safety, and one functional fix to ensure
khugepaged_scan_mm_slot() correctly accounts for small VMAs towards scan
limit.


This patch (of 4):

Replace goto skip with actual logic for better code readability.

No functional change.

Link: https://lkml.kernel.org/r/20260118192253.9263-4-shivankg@amd.com
Link: https://lkml.kernel.org/r/20260118192253.9263-6-shivankg@amd.com
Signed-off-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Nico Pache <npache@redhat.com>
Reviewed-by: Nico Pache <npache@redhat.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
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


