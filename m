Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B683B38AD;
	Fri, 29 May 2026 23:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780097403; cv=none; b=X3HfYb9oxxp7mgypq6Pe6zBeY/jGhy+DNyrIrGrrMiWTcrlQS3AqQf62F9RonLn4ZoSjhnirOV0StCmlounTjElX3t5HebmOxwt0p2mFVABiBiJ0U5LVaXReRMeqMxYOwXTCGASky8OanKMkzL+L85hMPdHD05m2yjAhJojaHMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780097403; c=relaxed/simple;
	bh=HaBzKETcgHQ+G+wBZDyTwIeEulvXbw/qTdt4Q4AYPBA=;
	h=Date:To:From:Subject:Message-Id; b=oRtwWHZD+2b0p/TU0fjFL5Y35FCuTgwpWUlLEwZbw3yEaYAYNC+etfeCjLGQd9zhKE+qsqS7E4QNuoL2nDeIM9MS4FhDveRL9YPBUNvFFxaUrPYdav4qFu5UuetK3UMLznvPoP1YicmfQGpue4LmhVDk7XoihEQ1WgZvIBm7Kx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=neZTBStX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="neZTBStX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3C31F00893;
	Fri, 29 May 2026 23:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780097402;
	bh=UeaCMd2dK6jhLDM7W9W7hHKjGU/o8mdT3Df6BFxaKEs=;
	h=Date:To:From:Subject;
	b=neZTBStXT2bqY+U5iteIPp0nG3ubXhrrSqFwEALHR5A86/XP5wHkf4YkMUyP6RHaS
	 SbGS3kOeEaxq7QEbOZBhX021zS0YRB+GjMakchedr58GiSWHEVBTtv+i9+kIzxcpYH
	 mv9DHD9+j4oOBl7T+fa3W7lDKbko/3ADIuWUy4WY=
Date: Fri, 29 May 2026 16:30:01 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,sashiko-bot@kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,ljs@kernel.org,david@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-gate-must_wait-writability-check-on-pte_present.patch added to mm-new branch
Message-Id: <20260529233001.DA3C31F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: gate must_wait writability check on pte_present()
has been added to the -mm mm-new branch.  Its filename is
     userfaultfd-gate-must_wait-writability-check-on-pte_present.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-gate-must_wait-writability-check-on-pte_present.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Subject: userfaultfd: gate must_wait writability check on pte_present()
Date: Fri, 29 May 2026 18:23:29 +0100

userfaultfd_must_wait() and userfaultfd_huge_must_wait() read the PTE
without taking the page table lock and then apply pte_write() /
huge_pte_write() to it.  Those accessors decode bits from the present
encoding only; on a swap or migration entry they read the offset bits that
happen to share the same position and return an undefined result.

The intent of the check is "is this fault still WP-blocked?".  A
non-marker swap entry means the page is in transit -- the userfault
context the original fault delivered against is no longer the same, and
the swap-in or migration completion path will re-deliver a fresh fault if
userspace still needs to handle it.  Worst case under the current code the
garbage write bit says "wait", and the thread stays asleep until a
UFFDIO_WAKE that may never arrive.

Gate the writability check on pte_present() so the lockless re-check only
inspects present-PTE bits when the entry is actually present.  The
non-present, non-marker case returns "don't wait" and lets the fault path
retry.

Link: https://lore.kernel.org/20260529172331.356655-6-kas@kernel.org
Fixes: 369cd2121be4 ("userfaultfd: hugetlbfs: userfaultfd_huge_must_wait for hugepmd ranges")
Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/mm/userfaultfd.c~userfaultfd-gate-must_wait-writability-check-on-pte_present
+++ a/mm/userfaultfd.c
@@ -2543,6 +2543,15 @@ static inline bool userfaultfd_huge_must
 	if (pte_is_uffd_marker(pte))
 		return true;
 	/*
+	 * Concurrent migration may have replaced the present PTE with a
+	 * non-marker swap entry between fault delivery and this lockless
+	 * re-check. huge_pte_write() on a swap entry decodes random offset
+	 * bits, so gate it on pte_present(). The migration completion path
+	 * will re-deliver the fault if it still needs userspace.
+	 */
+	if (!pte_present(pte))
+		return false;
+	/*
 	 * If VMA has UFFD WP faults enabled and WP fault, wait for userspace to
 	 * resolve the fault.
 	 */
@@ -2629,6 +2638,17 @@ again:
 	if (pte_is_uffd_marker(ptent))
 		goto out;
 	/*
+	 * Concurrent swap-out / migration may have replaced the present PTE
+	 * with a non-marker swap entry between fault delivery and this
+	 * lockless re-check. pte_write() on a swap entry decodes random
+	 * offset bits, so gate it on pte_present(). The page-in path will
+	 * re-deliver the fault if it still needs userspace.
+	 */
+	if (!pte_present(ptent)) {
+		ret = false;
+		goto out;
+	}
+	/*
 	 * If VMA has UFFD WP faults enabled and WP fault, wait for userspace to
 	 * resolve the fault.
 	 */
_

Patches currently in -mm which might be from kas@kernel.org are

fs-proc-task_mmu-fix-make_uffd_wp_huge_pte-prot-update-race.patch
fs-proc-task_mmu-use-huge_page_size-in-pagemap_scan_hugetlb_entry.patch
fs-proc-task_mmu-fix-hugetlb-self-deadlock-in-pagemap_scan_pte_hole.patch
mm-huge_memory-preserve-pmd_swp_uffd_wp-on-device-private-pmd-downgrade.patch
userfaultfd-gate-must_wait-writability-check-on-pte_present.patch
userfaultfd-build-__vma_uffd_flags-from-config-gated-masks.patch

