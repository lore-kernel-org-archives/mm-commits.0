Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F6429B8E5
	for <mm-commits@vger.kernel.org>; Sun, 28 Dec 2025 22:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766962257; cv=none; b=ZbVJNH78e1rN6j+kX+5AeZtP5+gMaIl8POPc50p/TyEDfv4KbYZVHpRNNegBJhlBSmEETZJoN+WQ/6b6K44QZM6K75tPY6EJb5OYN7lWChSN0ToVRt4lzStvMh0sgk//WTBDegkLdYbV9ttis05m61+a54OjSHYP9f2ZpLEXNzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766962257; c=relaxed/simple;
	bh=NO4s6EwlcPvXqybyz1NXFlvmIKoai59PoE9xpp9rj9s=;
	h=Date:To:From:Subject:Message-Id; b=ovxnqzylMJfB9kYfd7PpjuBEsZ24uwLZM2WFM3FUJR9ANyGnKEZL7bKkL9hNGmNdkaezVKNg5ViFbaVwXswPpZ5BzrS0Fvnui6u90YHPj9d2glOGOHj8SR+YjD2uirSNeSm/b1TBApNu2VUR/482dzWubqDBKysuw8IkGFMOAz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XALEo2l2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XALEo2l2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95764C4CEFB;
	Sun, 28 Dec 2025 22:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766962256;
	bh=NO4s6EwlcPvXqybyz1NXFlvmIKoai59PoE9xpp9rj9s=;
	h=Date:To:From:Subject:From;
	b=XALEo2l2PNxSblsr8Izlah20GgJk8CpM1c9iRxHQbdTAg6LcQye8FJGGxWWYjGjvh
	 72w+no1UOWRK7mEUfCzroVDvc71gkXqGZ3zLk2LnMI0MmC6HpEVR4pbjW4EZeeJfEs
	 rNG9CnHb64RoWCZY7EE5chsR1coRYuvBkExEI++4=
Date: Sun, 28 Dec 2025 14:50:56 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-count-small-vmas-towards-scan-limit-fix.patch added to mm-new branch
Message-Id: <20251228225056.95764C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-khugepaged-count-small-vmas-towards-scan-limit-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-count-small-vmas-towards-scan-limit-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-count-small-vmas-towards-scan-limit-fix.patch

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
From: "Garg, Shivank" <shivankg@amd.com>
Subject: mm-khugepaged-count-small-vmas-towards-scan-limit-fix
Date: Sun, 28 Dec 2025 23:28:12 +0530

update changelog, add comment per Lance

Link: https://lkml.kernel.org/r/24ed11d1-4761-458f-900b-8fa79379ace2@amd.com
Signed-off-by: Shivank Garg <shivankg@amd.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/khugepaged.c~mm-khugepaged-count-small-vmas-towards-scan-limit-fix
+++ a/mm/khugepaged.c
@@ -2448,6 +2448,7 @@ static unsigned int khugepaged_scan_mm_s
 		hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
 		hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
 		if (khugepaged_scan.address > hend || hend <= hstart) {
+			/* VMA already scanned or too small/unaligned for hugepage. */
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

