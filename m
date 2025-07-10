Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B812036FF
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126283; cv=none; b=HTl7l8whX3WNFGD0LR3/QDKVzj9PzhIVNJZY4jnH82j+mFPOo1642Oh7Ohi9ruMKgeJn+OAWSORL6BcFsfdvZxWjjoMOeyFIXjQQul6KCyI8aU/6SbUKgmboNLF4MgAEO5yQ35cIMsuW23wgiv24pmk+SbXr12ouavBwUFpFWs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126283; c=relaxed/simple;
	bh=Lc8GZ09ePGnRvAen2xB5HbW/XrUGKkRYBQTC4hEsNwQ=;
	h=Date:To:From:Subject:Message-Id; b=BDh6v1OWL2UGh/N0pQgCoD27EUDzTt3tt6DMgc8YA/kTaYknYfC6DZoRjW6VGwRO6QnZK9yak7i4ZMa8j3BkT/P7E9caMKQjVyqhvkWu6wNqoiqKkZKE5/7KZj2ieVIalBVHENp58ZTSLJYJDrD0lU9NRNtbigJfhxqobAbrBR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R+IqTkBy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R+IqTkBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0CFC4CEE3;
	Thu, 10 Jul 2025 05:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126283;
	bh=Lc8GZ09ePGnRvAen2xB5HbW/XrUGKkRYBQTC4hEsNwQ=;
	h=Date:To:From:Subject:From;
	b=R+IqTkBy0YCPD6N5UOkbsWOB9OWLLYKCDRDsNh2YBiJLze7SFdA1KS2judKz+zhaA
	 h9RRE6/p9REkPnsNM5WK5OLiVNFhNPeBocQQT9yvw37kEeS6iSjIOrx6OtW92NLztQ
	 Uf7BYyKRRkFqLvORgixYcKJF1jEdUNcxtpbYd1Bk=
Date: Wed, 09 Jul 2025 22:44:42 -0700
To: mm-commits@vger.kernel.org,zhengtangquan@oppo.com,zhengqi.arch@bytedance.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@oracle.com,jannh@google.com,david@redhat.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-use-per_vma-lock-for-madv_free.patch removed from -mm tree
Message-Id: <20250710054443.4D0CFC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: madvise: use per_vma lock for MADV_FREE
has been removed from the -mm tree.  Its filename was
     mm-madvise-use-per_vma-lock-for-madv_free.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1658,7 +1671,6 @@ static enum madvise_lock_mode get_lock_m
 	case MADV_WILLNEED:
 	case MADV_COLD:
 	case MADV_PAGEOUT:
-	case MADV_FREE:
 	case MADV_POPULATE_READ:
 	case MADV_POPULATE_WRITE:
 	case MADV_COLLAPSE:
@@ -1667,6 +1679,7 @@ static enum madvise_lock_mode get_lock_m
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


