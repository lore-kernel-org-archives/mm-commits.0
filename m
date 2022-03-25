Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE7AC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:14:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbiCYBQ3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357250AbiCYBQB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:16:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54AD72E2C
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:14:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 521E4618F4
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:14:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A10C340EC;
        Fri, 25 Mar 2022 01:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170852;
        bh=g0rshfmvBKg3SRoE4e+/iBfZSeKSsH4HTmeZSvqpxo8=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=vSuQCl3z60T5FBoxwcf91KGRKtIkVwHKk8ZxLcfVBP5sUJa4zurpEeslw6/+mfUxm
         j3X04rNtADpCrwZKK9SXdQenXOYYOZp8y7uvdemFWPzDHFQEg3eoMW5zARmg31SJK6
         zsZfMQz7vlmLS0Ra0GmCJGgiTIswJ0c7VHEB61RI=
Date:   Thu, 24 Mar 2022 18:14:12 -0700
To:     vbabka@suse.cz, shakeelb@google.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, mhocko@suse.com, dgilbert@redhat.com,
        david@redhat.com, hannes@cmpxchg.org, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 112/114] mm: madvise: MADV_DONTNEED_LOCKED
Message-Id: <20220325011412.A9A10C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

- MADV_DONTNEED has been bailing on locked vmas forever. It's at least
  conceivable that someone, somewhere is relying on mlock to protect
  data from perhaps broader invalidation calls. Changing this behavior
  now could lead to quiet data corruption.

- It also clarifies expectations around MADV_FREE and maybe
  MADV_REMOVE. It avoids the situation where one quietly behaves
  different than the others. MADV_FREE_LOCKED can be added later.

- The combination of mlock() and madvise() in the first place is
  probably niche. But where it happens, I'd say that dropping pages
  from a locked region once they don't contain secrets or won't page
  anymore is much saner than relying on mlock to protect memory from
  speculative or errant invalidation calls. It's just that we can't
  change the default behavior because of the two previous points.

Given that, an explicit new flag seems to make the most sense.

[hannes@cmpxchg.org: fix mips build]
Link: https://lkml.kernel.org/r/20220304171912.305060-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/uapi/asm/mman.h     |    2 +
 arch/mips/include/uapi/asm/mman.h      |    2 +
 arch/parisc/include/uapi/asm/mman.h    |    2 +
 arch/xtensa/include/uapi/asm/mman.h    |    2 +
 include/uapi/asm-generic/mman-common.h |    2 +
 mm/madvise.c                           |   24 +++++++++++++----------
 6 files changed, 24 insertions(+), 10 deletions(-)

--- a/arch/alpha/include/uapi/asm/mman.h~mm-madvise-madv_dontneed_locked
+++ a/arch/alpha/include/uapi/asm/mman.h
@@ -74,6 +74,8 @@
 #define MADV_POPULATE_READ	22	/* populate (prefault) page tables readable */
 #define MADV_POPULATE_WRITE	23	/* populate (prefault) page tables writable */
 
+#define MADV_DONTNEED_LOCKED	24	/* like DONTNEED, but drop locked pages too */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
--- a/arch/mips/include/uapi/asm/mman.h~mm-madvise-madv_dontneed_locked
+++ a/arch/mips/include/uapi/asm/mman.h
@@ -101,6 +101,8 @@
 #define MADV_POPULATE_READ	22	/* populate (prefault) page tables readable */
 #define MADV_POPULATE_WRITE	23	/* populate (prefault) page tables writable */
 
+#define MADV_DONTNEED_LOCKED	24	/* like DONTNEED, but drop locked pages too */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
--- a/arch/parisc/include/uapi/asm/mman.h~mm-madvise-madv_dontneed_locked
+++ a/arch/parisc/include/uapi/asm/mman.h
@@ -55,6 +55,8 @@
 #define MADV_POPULATE_READ	22	/* populate (prefault) page tables readable */
 #define MADV_POPULATE_WRITE	23	/* populate (prefault) page tables writable */
 
+#define MADV_DONTNEED_LOCKED	24	/* like DONTNEED, but drop locked pages too */
+
 #define MADV_MERGEABLE   65		/* KSM may merge identical pages */
 #define MADV_UNMERGEABLE 66		/* KSM may not merge identical pages */
 
--- a/arch/xtensa/include/uapi/asm/mman.h~mm-madvise-madv_dontneed_locked
+++ a/arch/xtensa/include/uapi/asm/mman.h
@@ -109,6 +109,8 @@
 #define MADV_POPULATE_READ	22	/* populate (prefault) page tables readable */
 #define MADV_POPULATE_WRITE	23	/* populate (prefault) page tables writable */
 
+#define MADV_DONTNEED_LOCKED	24	/* like DONTNEED, but drop locked pages too */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
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
@@ -52,6 +52,7 @@ static int madvise_need_mmap_write(int b
 	case MADV_REMOVE:
 	case MADV_WILLNEED:
 	case MADV_DONTNEED:
+	case MADV_DONTNEED_LOCKED:
 	case MADV_COLD:
 	case MADV_PAGEOUT:
 	case MADV_FREE:
@@ -502,14 +503,9 @@ static void madvise_cold_page_range(stru
 	tlb_end_vma(tlb, vma);
 }
 
-static inline bool can_madv_lru_non_huge_vma(struct vm_area_struct *vma)
-{
-	return !(vma->vm_flags & (VM_LOCKED|VM_PFNMAP));
-}
-
 static inline bool can_madv_lru_vma(struct vm_area_struct *vma)
 {
-	return can_madv_lru_non_huge_vma(vma) && !is_vm_hugetlb_page(vma);
+	return !(vma->vm_flags & (VM_LOCKED|VM_PFNMAP|VM_HUGETLB));
 }
 
 static long madvise_cold(struct vm_area_struct *vma,
@@ -787,10 +783,16 @@ static bool madvise_dontneed_free_valid_
 					    unsigned long *end,
 					    int behavior)
 {
-	if (!is_vm_hugetlb_page(vma))
-		return can_madv_lru_non_huge_vma(vma);
+	if (!is_vm_hugetlb_page(vma)) {
+		unsigned int forbidden = VM_PFNMAP;
+
+		if (behavior != MADV_DONTNEED_LOCKED)
+			forbidden |= VM_LOCKED;
+
+		return !(vma->vm_flags & forbidden);
+	}
 
-	if (behavior != MADV_DONTNEED)
+	if (behavior != MADV_DONTNEED && behavior != MADV_DONTNEED_LOCKED)
 		return false;
 	if (start & ~huge_page_mask(hstate_vma(vma)))
 		return false;
@@ -854,7 +856,7 @@ static long madvise_dontneed_free(struct
 		VM_WARN_ON(start >= end);
 	}
 
-	if (behavior == MADV_DONTNEED)
+	if (behavior == MADV_DONTNEED || behavior == MADV_DONTNEED_LOCKED)
 		return madvise_dontneed_single_vma(vma, start, end);
 	else if (behavior == MADV_FREE)
 		return madvise_free_single_vma(vma, start, end);
@@ -993,6 +995,7 @@ static int madvise_vma_behavior(struct v
 		return madvise_pageout(vma, prev, start, end);
 	case MADV_FREE:
 	case MADV_DONTNEED:
+	case MADV_DONTNEED_LOCKED:
 		return madvise_dontneed_free(vma, prev, start, end, behavior);
 	case MADV_POPULATE_READ:
 	case MADV_POPULATE_WRITE:
@@ -1123,6 +1126,7 @@ madvise_behavior_valid(int behavior)
 	case MADV_REMOVE:
 	case MADV_WILLNEED:
 	case MADV_DONTNEED:
+	case MADV_DONTNEED_LOCKED:
 	case MADV_FREE:
 	case MADV_COLD:
 	case MADV_PAGEOUT:
_
