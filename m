Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B10C17B433;
	Tue, 13 Aug 2024 21:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723584762; cv=none; b=dZbEBtUbPNoWo35aHi3X+0L5B6Lpypo4lcuisvvuiXztc2jXNEeEVTOHNnX/TbwUGawt0mv4pWB69yfoPQ23Kx9OHXkoL1HQKNuGayKJQMkUwPhnzkeba7YJbjigqjzkNyqGk26q2SCN+DRhNXswLdj1ht7PWs+lpRT5H/UnlDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723584762; c=relaxed/simple;
	bh=cdA0cS4nde5UXJ0+sLP0BgTzI3Q/ct9huKpZ6sDSagc=;
	h=Date:To:From:Subject:Message-Id; b=Htv05rOuGx/F+PI3oRddZ3W00PMGJD9eF7P3W8HrJrbryaeGDzJGshMbgRr4yVaokfFnzAA2W0Lj+dzEePwlUYQugsGTNs6fV6gsFEHZkn/Og3TQFnBNDfbC0XSWMFO7iOZFQGmpsJdlzbRN8xHTgYm4JiW5NGOZ+ICygkmdiXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=08NL+60w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="08NL+60w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B550BC32782;
	Tue, 13 Aug 2024 21:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723584761;
	bh=cdA0cS4nde5UXJ0+sLP0BgTzI3Q/ct9huKpZ6sDSagc=;
	h=Date:To:From:Subject:From;
	b=08NL+60wLMnhs101nf1UGnt4pkV1IYEtDmAlezwJ43OPrYrXBYQnFmffotaZo/GZ0
	 B7xI6y7LIV2MLAV3ChPJUQot2IHh3vtb0fWtf6tr6TM7xOQsnoOXTnEgqCD6rvYHIq
	 NUSERXQQQ9tisyL3tBVpu9AM+UIOLmZkpCYz7O90=
Date: Tue, 13 Aug 2024 14:32:41 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,xemul@virtuozzo.com,stable@vger.kernel.org,hughd@google.com,david@redhat.com,aarcange@redhat.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-fix-checks-for-huge-pmds.patch added to mm-hotfixes-unstable branch
Message-Id: <20240813213241.B550BC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: fix checks for huge PMDs
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     userfaultfd-fix-checks-for-huge-pmds.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-fix-checks-for-huge-pmds.patch

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
From: Jann Horn <jannh@google.com>
Subject: userfaultfd: fix checks for huge PMDs
Date: Tue, 13 Aug 2024 22:25:21 +0200

Patch series "userfaultfd: fix races around pmd_trans_huge() check", v2.

The pmd_trans_huge() code in mfill_atomic() is wrong in three different
ways depending on kernel version:

1. The pmd_trans_huge() check is racy and can lead to a BUG_ON() (if you hit
   the right two race windows) - I've tested this in a kernel build with
   some extra mdelay() calls. See the commit message for a description
   of the race scenario.
   On older kernels (before 6.5), I think the same bug can even
   theoretically lead to accessing transhuge page contents as a page table
   if you hit the right 5 narrow race windows (I haven't tested this case).
2. As pointed out by Qi Zheng, pmd_trans_huge() is not sufficient for
   detecting PMDs that don't point to page tables.
   On older kernels (before 6.5), you'd just have to win a single fairly
   wide race to hit this.
   I've tested this on 6.1 stable by racing migration (with a mdelay()
   patched into try_to_migrate()) against UFFDIO_ZEROPAGE - on my x86
   VM, that causes a kernel oops in ptlock_ptr().
3. On newer kernels (>=6.5), for shmem mappings, khugepaged is allowed
   to yank page tables out from under us (though I haven't tested that),
   so I think the BUG_ON() checks in mfill_atomic() are just wrong.

I decided to write two separate fixes for these (one fix for bugs 1+2, one
fix for bug 3), so that the first fix can be backported to kernels
affected by bugs 1+2.


This patch (of 2):

This fixes two issues.

I discovered that the following race can occur:

  mfill_atomic                other thread
  ============                ============
                              <zap PMD>
  pmdp_get_lockless() [reads none pmd]
  <bail if trans_huge>
  <if none:>
                              <pagefault creates transhuge zeropage>
    __pte_alloc [no-op]
                              <zap PMD>
  <bail if pmd_trans_huge(*dst_pmd)>
  BUG_ON(pmd_none(*dst_pmd))

I have experimentally verified this in a kernel with extra mdelay() calls;
the BUG_ON(pmd_none(*dst_pmd)) triggers.

On kernels newer than commit 0d940a9b270b ("mm/pgtable: allow
pte_offset_map[_lock]() to fail"), this can't lead to anything worse than
a BUG_ON(), since the page table access helpers are actually designed to
deal with page tables concurrently disappearing; but on older kernels
(<=6.4), I think we could probably theoretically race past the two
BUG_ON() checks and end up treating a hugepage as a page table.

The second issue is that, as Qi Zheng pointed out, there are other types
of huge PMDs that pmd_trans_huge() can't catch: devmap PMDs and swap PMDs
(in particular, migration PMDs).

On <=6.4, this is worse than the first issue: If mfill_atomic() runs on a
PMD that contains a migration entry (which just requires winning a single,
fairly wide race), it will pass the PMD to pte_offset_map_lock(), which
assumes that the PMD points to a page table.

Breakage follows: First, the kernel tries to take the PTE lock (which will
crash or maybe worse if there is no "struct page" for the address bits in
the migration entry PMD - I think at least on X86 there usually is no
corresponding "struct page" thanks to the PTE inversion mitigation, amd64
looks different).

If that didn't crash, the kernel would next try to write a PTE into what
it wrongly thinks is a page table.

As part of fixing these issues, get rid of the check for pmd_trans_huge()
before __pte_alloc() - that's redundant, we're going to have to check for
that after the __pte_alloc() anyway.

Backport note: pmdp_get_lockless() is pmd_read_atomic() in older kernels.

Link: https://lkml.kernel.org/r/20240813-uffd-thp-flip-fix-v2-0-5efa61078a41@google.com
Link: https://lkml.kernel.org/r/20240813-uffd-thp-flip-fix-v2-1-5efa61078a41@google.com
Fixes: c1a4de99fada ("userfaultfd: mcopy_atomic|mfill_zeropage: UFFDIO_COPY|UFFDIO_ZEROPAGE preparation")
Signed-off-by: Jann Horn <jannh@google.com>
Reported-by: Qi Zheng <zhengqi.arch@bytedance.com>
Closes: https://lore.kernel.org/r/59bf3c2e-d58b-41af-ab10-3e631d802229@bytedance.com
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-fix-checks-for-huge-pmds
+++ a/mm/userfaultfd.c
@@ -787,21 +787,23 @@ retry:
 		}
 
 		dst_pmdval = pmdp_get_lockless(dst_pmd);
-		/*
-		 * If the dst_pmd is mapped as THP don't
-		 * override it and just be strict.
-		 */
-		if (unlikely(pmd_trans_huge(dst_pmdval))) {
-			err = -EEXIST;
-			break;
-		}
 		if (unlikely(pmd_none(dst_pmdval)) &&
 		    unlikely(__pte_alloc(dst_mm, dst_pmd))) {
 			err = -ENOMEM;
 			break;
 		}
-		/* If an huge pmd materialized from under us fail */
-		if (unlikely(pmd_trans_huge(*dst_pmd))) {
+		dst_pmdval = pmdp_get_lockless(dst_pmd);
+		/*
+		 * If the dst_pmd is THP don't override it and just be strict.
+		 * (This includes the case where the PMD used to be THP and
+		 * changed back to none after __pte_alloc().)
+		 */
+		if (unlikely(!pmd_present(dst_pmdval) || pmd_trans_huge(dst_pmdval) ||
+			     pmd_devmap(dst_pmdval))) {
+			err = -EEXIST;
+			break;
+		}
+		if (unlikely(pmd_bad(dst_pmdval))) {
 			err = -EFAULT;
 			break;
 		}
_

Patches currently in -mm which might be from jannh@google.com are

userfaultfd-fix-checks-for-huge-pmds.patch
userfaultfd-dont-bug_on-if-khugepaged-yanks-our-page-table.patch
mm-fix-harmless-type-confusion-in-lock_vma_under_rcu.patch

