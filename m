Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655821DFF0
	for <mm-commits@vger.kernel.org>; Wed, 14 Oct 2026 21:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792012605; cv=none; b=kq2pkeRwEmFYV4qaBK4VbU4IYZzHMWNW0Pnk+puT4BAI3MaRpZRXIobxU5/eA/roHDck9fNSMUi8/MzN9QfLcR9HR75xrhi6zD8evoh0ElnTGkJBIWwA4zCfj5hENKEl7plqKW81LTMA3qFdQHzP/NHS9hD50ESwHM8lB9ijBM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792012605; c=relaxed/simple;
	bh=qps7poZDyz8rd3bnOJUPU7tedY0Nl/sishQZHeBUnXw=;
	h=Date:To:From:Subject:Message-Id; b=uWH+iX0pfuCXdeYPufBcjPrkGi+lnzvRtcAznZhvnOSKIN5+DWEFtsptYlqGiCc/DSooFHLcgEUQG+X3zxziE7H6RfL3zc+kpcvthN3+kIXpTo2gEIwpXbWdJ8NUHSH2i0MkMit968lJWbTFJfx3kINA4sKQPWtN44XkBbfVSiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YKpvgody; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YKpvgody"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD661F000C4;
	Wed, 14 Oct 2026 21:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792012604;
	bh=J6kZwhkX7gliUNU63OzkaM6sr20RichznNrZv0g8VHc=;
	h=Date:To:From:Subject;
	b=YKpvgodyHXYfpf6DI9Xj2eJ/ZIcRL3zyfGK5CozTA0+HKf7bOHzAixIsdv+oLUEop
	 Q3tM67DwZfYmxidQVm21OnBm5O1EsbiO6V6deG4s7kk8Td0zuB14MAmhWUExzeS8Cs
	 gqZM7PwYX9MKrmyJwtLwSKiaiBGZR5B7douevnXg=
Date: Wed, 14 Oct 2026 14:16:43 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-count-collapses-where-khugepaged-makes-them.patch added to mm-unstable branch
Message-Id: <20261014211643.EBD661F000C4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: count collapses where khugepaged makes them
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-count-collapses-where-khugepaged-makes-them.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-count-collapses-where-khugepaged-makes-them.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm/khugepaged: count collapses where khugepaged makes them
Date: Wed, 14 Oct 2026 18:11:35 +0100

collapse_single_pmd() bumps khugepaged_pages_collapsed for its caller, and
tests cc->is_khugepaged to know whether it should: the counter belongs to
the daemon, and MADV_COLLAPSE must not touch it.

The daemon sees every result of every collapse it asks for, so it can keep
its own counter without the shared path testing who called.

Link: https://lore.kernel.org/20261014171145.3292736-3-kas@kernel.org
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Assisted-by: LLM
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
---

 mm/khugepaged.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-count-collapses-where-khugepaged-makes-them
+++ a/mm/khugepaged.c
@@ -2845,10 +2845,8 @@ static enum scan_result collapse_single_
 
 	mmap_assert_locked(mm);
 
-	if (vma_is_anonymous(vma)) {
-		result = collapse_scan_pmd(mm, vma, addr, lock_dropped, cc);
-		goto end;
-	}
+	if (vma_is_anonymous(vma))
+		return collapse_scan_pmd(mm, vma, addr, lock_dropped, cc);
 
 	file = get_file(vma->vm_file);
 	pgoff = linear_page_index(vma, addr);
@@ -2884,9 +2882,6 @@ retry:
 			result = SCAN_SUCCEED;
 		mmap_read_unlock(mm);
 	}
-end:
-	if (cc->is_khugepaged && result == SCAN_SUCCEED)
-		++khugepaged_pages_collapsed;
 	return result;
 }
 
@@ -2963,6 +2958,8 @@ static void collapse_scan_mm_slot(unsign
 
 			*result = collapse_single_pmd(khugepaged_scan.address,
 						      vma, &lock_dropped, cc);
+			if (*result == SCAN_SUCCEED)
+				khugepaged_pages_collapsed++;
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
 			if (lock_dropped)
_

Patches currently in -mm which might be from kas@kernel.org are

mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order.patch
mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse.patch
mm-khugepaged-count-collapses-where-khugepaged-makes-them.patch
mm-khugepaged-rename-mthp_present_ptes-bitmap-to-eligible_ptes.patch
mm-collapse-add-collapseh-for-the-collapse-interface.patch
mm-collapse-state-what-a-collapse-may-do-in-the-policy.patch
mm-collapse-drop-the-collapse_possible-wrapper.patch
mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch
mm-collapse-call-collapse_file-from-collapse_single_pmd.patch
mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch

