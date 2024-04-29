Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8855484D09;
	Mon, 29 Apr 2024 16:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714406950; cv=none; b=QEFAgK+m0KzpxN6HYlkZJbJMfflGIsBxDKUFFoRrRjwZHpeorpdpfWjKNhM+nDnLhVQsDJUPG6rrn4DqDd+SI03o/K79E9zSUfBo86f44wjYJgdbhirSlN159MqB+RWInSsqPgXlNkvTTN1FvVQhCYs/q/rSriYVukI6qOH8d98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714406950; c=relaxed/simple;
	bh=6KnWDx7/9v+OtR7i/7KRduEftyZKfAFP0YhCHcYTgNw=;
	h=Date:To:From:Subject:Message-Id; b=qRcSxPONM+iAcuRCPHirfQNlheHpWa9s3A8/Dc+EgMS9gftM9gSyDU6gkIvMYPygUU/xuvheAYTFcF6kWclu0wYlRZ5xZb9IE3dXstsUAigjAYCItThtM3RxebZHYd0nkOVdwbITTsNJZr6L0VLFPx8APoZeAghhH3lLwcPGgeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F+wANNxB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F+wANNxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5954C113CD;
	Mon, 29 Apr 2024 16:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714406949;
	bh=6KnWDx7/9v+OtR7i/7KRduEftyZKfAFP0YhCHcYTgNw=;
	h=Date:To:From:Subject:From;
	b=F+wANNxBgrW+DCkA0WqU7mquo3lTY/9nHGG3yJlR/N+6re1u7G26gHIrUumkHP4hT
	 SgxA2yqyicRZFV+oTeX0gsZc31ei5jcrT7+xlrFbYIYBDgy6bwVxQfbPLu/NeAI4V3
	 HUnyhfK4rP4WmNSHkTnJM1Tm5UF7ObK972xd9pKI=
Date: Mon, 29 Apr 2024 09:09:07 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,stable@vger.kernel.org,peterx@redhat.com,david@redhat.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-fix-uffd-wp-confusion-in-pagemap_scan_pmd_entry.patch added to mm-hotfixes-unstable branch
Message-Id: <20240429160908.C5954C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/task_mmu: fix uffd-wp confusion in pagemap_scan_pmd_entry()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-proc-task_mmu-fix-uffd-wp-confusion-in-pagemap_scan_pmd_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-fix-uffd-wp-confusion-in-pagemap_scan_pmd_entry.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: fs/proc/task_mmu: fix uffd-wp confusion in pagemap_scan_pmd_entry()
Date: Mon, 29 Apr 2024 12:41:04 +0100

pagemap_scan_pmd_entry() checks if uffd-wp is set on each pte to avoid
unnecessary if set.  However it was previously checking with
`pte_uffd_wp(ptep_get(pte))` without first confirming that the pte was
present.  It is only valid to call pte_uffd_wp() for present ptes.  For
swap ptes, pte_swp_uffd_wp() must be called because the uffd-wp bit may be
kept in a different position, depending on the arch.

This was leading to test failures in the pagemap_ioctl mm selftest, when
bringing up uffd-wp support on arm64 due to incorrectly interpretting the
uffd-wp status of migration entries.

Let's fix this by using the correct check based on pte_present().  While
we are at it, let's pass the pte to make_uffd_wp_pte() to avoid the
pointless extra ptep_get() which can't be optimized out due to READ_ONCE()
on many arches.

Link: https://lkml.kernel.org/r/20240429114104.182890-1-ryan.roberts@arm.com
Fixes: 12f6b01a0bcb ("fs/proc/task_mmu: add fast paths to get/clear PAGE_IS_WRITTEN flag")
Closes: https://lore.kernel.org/linux-arm-kernel/ZiuyGXt0XWwRgFh9@x1n/
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com> 
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-fix-uffd-wp-confusion-in-pagemap_scan_pmd_entry
+++ a/fs/proc/task_mmu.c
@@ -1817,10 +1817,8 @@ static unsigned long pagemap_page_catego
 }
 
 static void make_uffd_wp_pte(struct vm_area_struct *vma,
-			     unsigned long addr, pte_t *pte)
+			     unsigned long addr, pte_t *pte, pte_t ptent)
 {
-	pte_t ptent = ptep_get(pte);
-
 	if (pte_present(ptent)) {
 		pte_t old_pte;
 
@@ -2175,9 +2173,12 @@ static int pagemap_scan_pmd_entry(pmd_t
 	if ((p->arg.flags & PM_SCAN_WP_MATCHING) && !p->vec_out) {
 		/* Fast path for performing exclusive WP */
 		for (addr = start; addr != end; pte++, addr += PAGE_SIZE) {
-			if (pte_uffd_wp(ptep_get(pte)))
+			pte_t ptent = ptep_get(pte);
+
+			if ((pte_present(ptent) && pte_uffd_wp(ptent)) ||
+			    pte_swp_uffd_wp_any(ptent))
 				continue;
-			make_uffd_wp_pte(vma, addr, pte);
+			make_uffd_wp_pte(vma, addr, pte, ptent);
 			if (!flush_end)
 				start = addr;
 			flush_end = addr + PAGE_SIZE;
@@ -2190,8 +2191,10 @@ static int pagemap_scan_pmd_entry(pmd_t
 	    p->arg.return_mask == PAGE_IS_WRITTEN) {
 		for (addr = start; addr < end; pte++, addr += PAGE_SIZE) {
 			unsigned long next = addr + PAGE_SIZE;
+			pte_t ptent = ptep_get(pte);
 
-			if (pte_uffd_wp(ptep_get(pte)))
+			if ((pte_present(ptent) && pte_uffd_wp(ptent)) ||
+			    pte_swp_uffd_wp_any(ptent))
 				continue;
 			ret = pagemap_scan_output(p->cur_vma_category | PAGE_IS_WRITTEN,
 						  p, addr, &next);
@@ -2199,7 +2202,7 @@ static int pagemap_scan_pmd_entry(pmd_t
 				break;
 			if (~p->arg.flags & PM_SCAN_WP_MATCHING)
 				continue;
-			make_uffd_wp_pte(vma, addr, pte);
+			make_uffd_wp_pte(vma, addr, pte, ptent);
 			if (!flush_end)
 				start = addr;
 			flush_end = next;
@@ -2208,8 +2211,9 @@ static int pagemap_scan_pmd_entry(pmd_t
 	}
 
 	for (addr = start; addr != end; pte++, addr += PAGE_SIZE) {
+		pte_t ptent = ptep_get(pte);
 		unsigned long categories = p->cur_vma_category |
-					   pagemap_page_category(p, vma, addr, ptep_get(pte));
+					   pagemap_page_category(p, vma, addr, ptent);
 		unsigned long next = addr + PAGE_SIZE;
 
 		if (!pagemap_scan_is_interesting_page(categories, p))
@@ -2224,7 +2228,7 @@ static int pagemap_scan_pmd_entry(pmd_t
 		if (~categories & PAGE_IS_WRITTEN)
 			continue;
 
-		make_uffd_wp_pte(vma, addr, pte);
+		make_uffd_wp_pte(vma, addr, pte, ptent);
 		if (!flush_end)
 			start = addr;
 		flush_end = next;
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

fs-proc-task_mmu-fix-uffd-wp-confusion-in-pagemap_scan_pmd_entry.patch
selftests-mm-soft-dirty-should-fail-if-a-testcase-fails.patch
mm-fix-race-between-__split_huge_pmd_locked-and-gup-fast.patch

