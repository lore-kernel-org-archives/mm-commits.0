Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4BFAD5E
	for <mm-commits@vger.kernel.org>; Thu, 12 Jun 2025 00:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749687505; cv=none; b=dB5zeyQDP8CQ+DGCROgpyGjDJRpqpvFD9Scyxcjz6hsbpcgFU1vNGmvamT+YIdROGU60utatIgD/ZzVJDjJ/QoprLRaJB/epaAdK/Ipapf/GztyiqpPiyproDi7rfcf8TkuSWgqULTjbr6CM+KJzEFa0KWtPj7VW/pgaF2BN/z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749687505; c=relaxed/simple;
	bh=zwwVll+IRzCKjTQ//hkR9tDqvxv6ztQb8kQOgDVDhsk=;
	h=Date:To:From:Subject:Message-Id; b=TmldgvkdVo9ra0iohfvRiJcTmtFGkuDm7FIrq/S2I81YiYbwsH3MtAeOr81H9xxnszyMMKJP86LY0Y674xbJV4FkTUGhmpUBUqvai/o2c6ALr8exxTudGb82qbCDulOly6HrJZcTmUvh7xXyQsLlshTrQ2r9g+kzLloYl7mtlJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lv5IfjCL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lv5IfjCL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C62C4CEE3;
	Thu, 12 Jun 2025 00:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749687504;
	bh=zwwVll+IRzCKjTQ//hkR9tDqvxv6ztQb8kQOgDVDhsk=;
	h=Date:To:From:Subject:From;
	b=lv5IfjCLjLrAxDoNpg9g4HCgwh7c6HzP5ruoNq70tl1qvm8TAbTv4Chvk/qq37C1+
	 m+PXqw/h0iNh8pqmkTdBRaTAFJIgdffQCpNWX0aaOeWRevNw02MNaxg9ykJFrzfyFQ
	 q7tLgT1W1wfowJP7fbuHYV4yjStjlH4KlFqP2aag=
Date: Wed, 11 Jun 2025 17:18:23 -0700
To: mm-commits@vger.kernel.org,zhengtangquan@oppo.com,zhengqi.arch@bytedance.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@oracle.com,jannh@google.com,david@redhat.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-use-per_vma-lock-for-madv_free.patch added to mm-new branch
Message-Id: <20250612001824.48C62C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: madvise: use per_vma lock for MADV_FREE
has been added to the -mm mm-new branch.  Its filename is
     mm-madvise-use-per_vma-lock-for-madv_free.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-use-per_vma-lock-for-madv_free.patch

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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: madvise: use per_vma lock for MADV_FREE
Date: Wed, 11 Jun 2025 22:47:45 +1200

MADV_FREE is another option, besides MADV_DONTNEED, for dynamic memory
freeing in user-space native or Java heap memory management.  For example,
jemalloc can be configured to use MADV_FREE, and recent versions of the
Android Java heap have also increasingly adopted MADV_FREE.  Supporting
per-VMA locking for MADV_FREE thus appears increasingly necessary.

We have replaced walk_page_range() with walk_page_range_vma().  Along with
the proposed madvise_lock_mode by Lorenzo, the necessary infrastructure is
now in place to begin exploring per-VMA locking support for MADV_FREE and
potentially other madvise using walk_page_range_vma().

This patch adds support for the PGWALK_VMA_RDLOCK walk_lock mode in
walk_page_range_vma(), and leverages madvise_lock_mode from madv_behavior
to select the appropriate walk_lock—either mmap_lock or per-VMA
lock—based on the context.

Because we now dynamically update the walk_ops->walk_lock field, we must
ensure this is thread-safe.  The madvise_free_walk_ops is now defined as a
stack variable instead of a global constant.

Link: https://lkml.kernel.org/r/20250611104745.57405-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: SeongJae Park <sj@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Tangquan Zheng <zhengtangquan@oppo.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagewalk.h |    2 ++
 mm/madvise.c             |   25 +++++++++++++++++++------
 mm/pagewalk.c            |    5 ++++-
 3 files changed, 25 insertions(+), 7 deletions(-)

--- a/include/linux/pagewalk.h~mm-madvise-use-per_vma-lock-for-madv_free
+++ a/include/linux/pagewalk.h
@@ -14,6 +14,8 @@ enum page_walk_lock {
 	PGWALK_WRLOCK = 1,
 	/* vma is expected to be already write-locked during the walk */
 	PGWALK_WRLOCK_VERIFY = 2,
+	/* vma is expected to be already read-locked during the walk */
+	PGWALK_VMA_RDLOCK_VERIFY = 3,
 };
 
 /**
--- a/mm/madvise.c~mm-madvise-use-per_vma-lock-for-madv_free
+++ a/mm/madvise.c
@@ -777,10 +777,19 @@ static int madvise_free_pte_range(pmd_t
 	return 0;
 }
 
-static const struct mm_walk_ops madvise_free_walk_ops = {
-	.pmd_entry		= madvise_free_pte_range,
-	.walk_lock		= PGWALK_RDLOCK,
-};
+static inline enum page_walk_lock get_walk_lock(enum madvise_lock_mode mode)
+{
+	switch (mode) {
+	case MADVISE_VMA_READ_LOCK:
+		return PGWALK_VMA_RDLOCK_VERIFY;
+	case MADVISE_MMAP_READ_LOCK:
+		return PGWALK_RDLOCK;
+	default:
+		/* Other modes don't require fixing up the walk_lock */
+		WARN_ON_ONCE(1);
+		return PGWALK_RDLOCK;
+	}
+}
 
 static int madvise_free_single_vma(struct madvise_behavior *madv_behavior,
 			struct vm_area_struct *vma,
@@ -789,6 +798,9 @@ static int madvise_free_single_vma(struc
 	struct mm_struct *mm = vma->vm_mm;
 	struct mmu_notifier_range range;
 	struct mmu_gather *tlb = madv_behavior->tlb;
+	struct mm_walk_ops walk_ops = {
+		.pmd_entry		= madvise_free_pte_range,
+	};
 
 	/* MADV_FREE works for only anon vma at the moment */
 	if (!vma_is_anonymous(vma))
@@ -808,8 +820,9 @@ static int madvise_free_single_vma(struc
 
 	mmu_notifier_invalidate_range_start(&range);
 	tlb_start_vma(tlb, vma);
+	walk_ops.walk_lock = get_walk_lock(madv_behavior->lock_mode);
 	walk_page_range_vma(vma, range.start, range.end,
-			&madvise_free_walk_ops, tlb);
+			&walk_ops, tlb);
 	tlb_end_vma(tlb, vma);
 	mmu_notifier_invalidate_range_end(&range);
 	return 0;
@@ -1655,7 +1668,6 @@ static enum madvise_lock_mode get_lock_m
 	case MADV_WILLNEED:
 	case MADV_COLD:
 	case MADV_PAGEOUT:
-	case MADV_FREE:
 	case MADV_POPULATE_READ:
 	case MADV_POPULATE_WRITE:
 	case MADV_COLLAPSE:
@@ -1664,6 +1676,7 @@ static enum madvise_lock_mode get_lock_m
 		return MADVISE_MMAP_READ_LOCK;
 	case MADV_DONTNEED:
 	case MADV_DONTNEED_LOCKED:
+	case MADV_FREE:
 		return MADVISE_VMA_READ_LOCK;
 	default:
 		return MADVISE_MMAP_WRITE_LOCK;
--- a/mm/pagewalk.c~mm-madvise-use-per_vma-lock-for-madv_free
+++ a/mm/pagewalk.c
@@ -422,7 +422,7 @@ static inline void process_mm_walk_lock(
 {
 	if (walk_lock == PGWALK_RDLOCK)
 		mmap_assert_locked(mm);
-	else
+	else if (walk_lock != PGWALK_VMA_RDLOCK_VERIFY)
 		mmap_assert_write_locked(mm);
 }
 
@@ -437,6 +437,9 @@ static inline void process_vma_walk_lock
 	case PGWALK_WRLOCK_VERIFY:
 		vma_assert_write_locked(vma);
 		break;
+	case PGWALK_VMA_RDLOCK_VERIFY:
+		vma_assert_locked(vma);
+		break;
 	case PGWALK_RDLOCK:
 		/* PGWALK_RDLOCK is handled by process_mm_walk_lock */
 		break;
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-madvise-use-walk_page_range_vma-instead-of-walk_page_range.patch
mm-madvise-use-walk_page_range_vma-instead-of-walk_page_range-fix.patch
mm-use-per_vma-lock-for-madv_dontneed.patch
mm-madvise-use-per_vma-lock-for-madv_free.patch

