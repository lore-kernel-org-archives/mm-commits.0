Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BB74A0C
	for <mm-commits@vger.kernel.org>; Mon, 22 Sep 2025 22:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758580914; cv=none; b=fza/mbwwDYuL3sGPYNJyaOVgVHpnyZCV+WSB76E3QuVXRkVJwmtB9fKX9/3iItrHEi/SfRZh/BLpc7BLyDdhKTxngjFn2/05g0W9Se8p+0i7eSqaJqHr+GlMnBbhNTOAOuG7CmvOnH0FVhqTYWYGuh4y0q8aewF6JcovlkS/3yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758580914; c=relaxed/simple;
	bh=OK92UIAPEC4z1qae0T5rU601Y9a07c+kqKe2vY+lPkc=;
	h=Date:To:From:Subject:Message-Id; b=b2byL8HJPsWsj++cveTVWqt05oqe9n8aPMmRZLYnaTZX0AUw8qFteY71o7xvPjRMItQjkm2huhPDzhLaPp2D5OLaLH3lGivZmd/4K4MRe24Firdhm4pvUXyFdaBTXdp42lm7PFIEmVp+lu0K7i0f76UsAH+qsoCyR2n4rtIXfVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Pvph1wWm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pvph1wWm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75247C4CEF0;
	Mon, 22 Sep 2025 22:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758580913;
	bh=OK92UIAPEC4z1qae0T5rU601Y9a07c+kqKe2vY+lPkc=;
	h=Date:To:From:Subject:From;
	b=Pvph1wWm/KHoynwefw0GqoNYDMEpwrB6bayS+/jev1oYxWlbT81jy3yI/O/hFPstl
	 wFBSGzumvxdXfDBrbnoz2bnEiZV9ukLxo3YwRkDwPV9Jei77UopqZFyhdciQm12ydQ
	 P7w7fcZi3hXTmwHiuUJDQr1aD5BAIxkICYhduDDE=
Date: Mon, 22 Sep 2025 15:41:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xu.xin16@zte.com.cn,sj@kernel.org,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,kirill@shutemov.name,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot-fix.patch added to mm-new branch
Message-Id: <20250922224153.75247C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot-fix
Date: Mon, 22 Sep 2025 00:28:34 +0000

fix use-after-free crash

Link: https://lkml.kernel.org/r/20250922002834.vz6ntj36e75ehkyp@master
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Debugged-by: Lance Yang <lance.yang@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot-fix
+++ a/mm/khugepaged.c
@@ -2508,8 +2508,7 @@ breakouterloop_mmap_lock:
 		 * mm_slot not pointing to the exiting mm.
 		 */
 		if (!list_is_last(&slot->mm_node, &khugepaged_scan.mm_head)) {
-			slot = list_next_entry(slot, mm_node);
-			khugepaged_scan.mm_slot = slot;
+			khugepaged_scan.mm_slot = list_next_entry(slot, mm_node);
 			khugepaged_scan.address = 0;
 		} else {
 			khugepaged_scan.mm_slot = NULL;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-compaction-fix-low_pfn-advance-on-isolating-hugetlb.patch
mm-ksm-get-mm_slot-by-mm_slot_entry-when-slot-is-null.patch
mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot.patch
mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot-fix.patch
mm-khugepaged-use-start_addr-addr-for-better-reading.patch

