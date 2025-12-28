Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089DE2144C7
	for <mm-commits@vger.kernel.org>; Sun, 28 Dec 2025 22:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766962255; cv=none; b=L2cBtB5OO3/24IH9f7x8LVL3ylAi0/hDdmaDXIPs5P78pYMWS+ue+mU6ZXtOCyh2LgWY2qBJewbEsfRtNheV2iTL0gjBiFEHav7q1EwwGdJbLPdUltdS1Agd8ijj2unnWgSdhpriXWGr/PGKx3hOvqZpMY7FMA8i//9olVcLgPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766962255; c=relaxed/simple;
	bh=h4ypf7v3aSVlaM//WMahKAgTPR+WrHyn84xcKEeaxfw=;
	h=Date:To:From:Subject:Message-Id; b=rcYUdK6e45UqooikdYtX/2dpplyHTUB2b+c+xXYo2RU5HjwE2M8PBvHMP5EBcT0n8ZNNsTH8JleiEyLrk5aCkhKzIxGHsSHm78539LPv3oVGFxOHmaP6aDDrR1JnN5TAJggJqQmJWWAw4NzazV2nlPd5ikAtMxI/rhgHY6OdO1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O71326Rb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O71326Rb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C36C4CEFB;
	Sun, 28 Dec 2025 22:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766962254;
	bh=h4ypf7v3aSVlaM//WMahKAgTPR+WrHyn84xcKEeaxfw=;
	h=Date:To:From:Subject:From;
	b=O71326RbaqOCxZoQbuBjv/sTU790SePpetApxDDXXY8IEbz5ponjyFOwZ1kXyKVhI
	 K9UceQcRMDPLHSGYe5c1X2d9WiPswoXtJMFIPMTEDwp/isZNgpDIKCThvoONHE9SF8
	 en7eg9/EisjidkXQnGsaMJFSZgFT5KmRC60zyRsQ=
Date: Sun, 28 Dec 2025 14:50:53 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-count-small-vmas-towards-scan-limit.patch added to mm-new branch
Message-Id: <20251228225054.71C36C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: count small VMAs towards scan limit
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-count-small-vmas-towards-scan-limit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-count-small-vmas-towards-scan-limit.patch

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
Subject: mm/khugepaged: count small VMAs towards scan limit
Date: Wed, 24 Dec 2025 11:13:53 +0000

The khugepaged_scan_mm_slot() uses a 'progress' counter to limit the
amount of work performed and consists of three components:
1. Starting/resuming scan of mm slot (+1).
2. Skipping an unsuitable VMA (+1).
3. Scanning a PMD-sized range (+HPAGE_PMD_NR).

Consider a 1MB VMA sitting between two 2MB alignment boundaries:

     vma1       vma2   vma3
    +----------+------+----------+
    |2M        |1M    |2M        |
    +----------+------+----------+
               ^      ^
               start  end
               ^
          hstart,hend

In this case, for vma2:
  hstart = round_up(start, HPAGE_PMD_SIZE)  -> Next 2MB alignment
  hend   = round_down(end, HPAGE_PMD_SIZE) -> Prev 2MB alignment

Currently, since `hend <= hstart`, VMAs that are too small or unaligned
to contain a hugepage are skipped without incrementing 'progress'.
A process containing a large number of such small VMAs will unfairly
consume more CPU cycles before yielding compared to a process with
fewer, larger, or aligned VMAs.

Fix this by incrementing progress when the `hend <= hstart` condition
is met.

Additionally, change 'progress' to `unsigned int`. This matches both
the 'pages' type and the function return value.

Link: https://lkml.kernel.org/r/20251224111351.41042-8-shivankg@amd.com
Signed-off-by: Shivank Garg <shivankg@amd.com>
Suggested-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-count-small-vmas-towards-scan-limit
+++ a/mm/khugepaged.c
@@ -2403,7 +2403,7 @@ static unsigned int khugepaged_scan_mm_s
 	struct mm_slot *slot;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
-	int progress = 0;
+	unsigned int progress = 0;
 
 	VM_BUG_ON(!pages);
 	lockdep_assert_held(&khugepaged_mm_lock);
@@ -2447,7 +2447,7 @@ static unsigned int khugepaged_scan_mm_s
 		}
 		hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
 		hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
-		if (khugepaged_scan.address > hend) {
+		if (khugepaged_scan.address > hend || hend <= hstart) {
 			progress++;
 			continue;
 		}
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

