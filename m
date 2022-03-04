Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3204C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  4 Mar 2022 00:01:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbiCDACc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Mar 2022 19:02:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbiCDACc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Mar 2022 19:02:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC38170D6C
        for <mm-commits@vger.kernel.org>; Thu,  3 Mar 2022 16:01:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 194FD61548
        for <mm-commits@vger.kernel.org>; Fri,  4 Mar 2022 00:01:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CBBC340E9;
        Fri,  4 Mar 2022 00:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646352104;
        bh=zxdDAhUlOsJUPDCUoKU5rdvN9LAJEC2cO+1GP7VsuQM=;
        h=Date:To:From:Subject:From;
        b=TgH2TM9glbEVhJXSRP8yBXKNX5c1A2nE0HiR9o2VPVwPoDdp5uq+zNFrAWCaeF0/j
         F2PgdB4bfIOmDngyLB6osbep6n3HUolt/4L3fdKFplXksGAFNcbBiankrxylMmKruA
         Z0btx//qQcKVp22EpcdclCvIxvU56UcYO1yoaDp0=
Date:   Thu, 03 Mar 2022 16:01:43 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, nadav.amit@gmail.com,
        mhocko@suse.com, hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-madv_dontneed_locked.patch added to -mm tree
Message-Id: <20220304000144.67CBBC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: madvise: MADV_DONTNEED_LOCKED
has been added to the -mm tree.  Its filename is
     mm-madvise-madv_dontneed_locked.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-madv_dontneed_locked.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-madv_dontneed_locked.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: madvise: MADV_DONTNEED_LOCKED

MADV_DONTNEED historically rejects mlocked ranges, but with MLOCK_ONFAULT
and MCL_ONFAULT allowing to mlock without populating, there are valid use
cases for depopulating locked ranges as well.

Users mlock memory to protect secrets.  There are allocators for secure
buffers that want in-use memory generally mlocked, but cleared and
invalidated memory to give up the physical pages.  This could be done with
explicit munlock -> mlock calls on free -> alloc of course, but that adds
two unnecessary syscalls, heavy mmap_sem write locks, vma splits and
re-merges - only to get rid of the backing pages.

Users also mlockall(MCL_ONFAULT) to suppress sustained paging, but are
okay with on-demand initial population.  It seems valid to selectively
free some memory during the lifetime of such a process, without having to
mess with its overall policy.

Why add a separate flag? Isn't this a pretty niche usecase?

- MADV_DONTNEED has been bailing on locked vmas forever.  It's at least
  conceivable that someone, somewhere is relying on mlock to protect data
  from perhaps broader invalidation calls.  Changing this behavior now
  could lead to quiet data corruption.

- It also clarifies expectations around MADV_FREE and maybe MADV_REMOVE.
  It avoids the situation where one quietly behaves different than the
  others.  MADV_FREE_LOCKED can be added later.

- The combination of mlock() and madvise() in the first place is
  probably niche.  But where it happens, I'd say that dropping pages from
  a locked region once they don't contain secrets or won't page anymore is
  much saner than relying on mlock to protect memory from speculative or
  errant invalidation calls.  It's just that we can't change the default
  behavior because of the two previous points.

Given that, an explicit new flag seems to make the most sense.

Link: https://lkml.kernel.org/r/20220303212956.229409-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/asm-generic/mman-common.h |    2 ++
 mm/madvise.c                           |   16 +++++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

--- a/include/uapi/asm-generic/mman-common.h~mm-madvise-madv_dontneed_locked
+++ a/include/uapi/asm-generic/mman-common.h
@@ -75,6 +75,8 @@
 #define MADV_POPULATE_READ	22	/* populate (prefault) page tables readable */
 #define MADV_POPULATE_WRITE	23	/* populate (prefault) page tables writable */
 
+#define MADV_DONTNEED_LOCKED	24	/* like DONTNEED, but drop locked pages too */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
--- a/mm/madvise.c~mm-madvise-madv_dontneed_locked
+++ a/mm/madvise.c
@@ -772,6 +772,13 @@ static long madvise_dontneed_single_vma(
 	return 0;
 }
 
+static bool can_madv_dontneed_free(struct vm_area_struct *vma, int behavior)
+{
+	if (behavior == MADV_DONTNEED_LOCKED)
+		return !(vma->vm_flags & (VM_HUGETLB|VM_PFNMAP));
+	return can_madv_lru_vma(vma);
+}
+
 static long madvise_dontneed_free(struct vm_area_struct *vma,
 				  struct vm_area_struct **prev,
 				  unsigned long start, unsigned long end,
@@ -780,7 +787,8 @@ static long madvise_dontneed_free(struct
 	struct mm_struct *mm = vma->vm_mm;
 
 	*prev = vma;
-	if (!can_madv_lru_vma(vma))
+
+	if (!can_madv_dontneed_free(vma, behavior))
 		return -EINVAL;
 
 	if (!userfaultfd_remove(vma, start, end)) {
@@ -802,7 +810,7 @@ static long madvise_dontneed_free(struct
 			 */
 			return -ENOMEM;
 		}
-		if (!can_madv_lru_vma(vma))
+		if (!can_madv_dontneed_free(vma, behavior))
 			return -EINVAL;
 		if (end > vma->vm_end) {
 			/*
@@ -822,7 +830,7 @@ static long madvise_dontneed_free(struct
 		VM_WARN_ON(start >= end);
 	}
 
-	if (behavior == MADV_DONTNEED)
+	if (behavior == MADV_DONTNEED || behavior == MADV_DONTNEED_LOCKED)
 		return madvise_dontneed_single_vma(vma, start, end);
 	else if (behavior == MADV_FREE)
 		return madvise_free_single_vma(vma, start, end);
@@ -961,6 +969,7 @@ static int madvise_vma_behavior(struct v
 		return madvise_pageout(vma, prev, start, end);
 	case MADV_FREE:
 	case MADV_DONTNEED:
+	case MADV_DONTNEED_LOCKED:
 		return madvise_dontneed_free(vma, prev, start, end, behavior);
 	case MADV_POPULATE_READ:
 	case MADV_POPULATE_WRITE:
@@ -1091,6 +1100,7 @@ madvise_behavior_valid(int behavior)
 	case MADV_REMOVE:
 	case MADV_WILLNEED:
 	case MADV_DONTNEED:
+	case MADV_DONTNEED_LOCKED:
 	case MADV_FREE:
 	case MADV_COLD:
 	case MADV_PAGEOUT:
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcg-opencode-the-inner-part-of-obj_cgroup_uncharge_pages-in-drain_obj_stock.patch
mm-page_io-fix-psi-memory-pressure-error-on-cold-swapins.patch
mm-madvise-madv_dontneed_locked.patch

