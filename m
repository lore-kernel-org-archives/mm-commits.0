Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA8A20F3EB
	for <mm-commits@vger.kernel.org>; Fri, 25 Oct 2024 20:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729887521; cv=none; b=NHYyXCD4k/1kuqTFiIREvO8yl9DEdW4UaivAASmczsRiyQZDZri5S0db0x8Sj8mlEcb8IL1JFqV3EZvQqp+9j8PrNcrBj5Odnk4bMVABwzsy2bjVLvXU4APtCE+lDzOERt69vIML6cIchv7cK4bPwZH+tSqc1L6DMFGb4DYzqSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729887521; c=relaxed/simple;
	bh=SD5zFR9KSL6kPb9PExmDQAd864zKGS0S/pmNt4sIJ/M=;
	h=Date:To:From:Subject:Message-Id; b=q7JpVb7beWwxiDKThy0m28sQ9P6j4LIHaT/UDn1l3vdKlIrtPg1Km6zaBA981zcqoVQoRjgLSEoUF94tHcqyXouEo1KuN2tW4c29ya64G4KeQPQ+rMpF7LGKDb0GpB4qn/z9Ld4AxaE1iH6Wi2Bmh5hIhjhq44iQevb+cshkFlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rmyoicMe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rmyoicMe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8575C4CECC;
	Fri, 25 Oct 2024 20:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729887520;
	bh=SD5zFR9KSL6kPb9PExmDQAd864zKGS0S/pmNt4sIJ/M=;
	h=Date:To:From:Subject:From;
	b=rmyoicMewEiuHh1krxF608FBv17Hea+A091fHlN9F6P5J3Htq7JRI4ph1loXbAuRf
	 2Yb7fOiYg96x/mRTzGcyw4gJ61LaqzVWGU1bKKpfqZj3D0KuqZrYyrEslYeO/4U3/a
	 nnb/eeo2uT39UPX9qpJN+gfBvv+iIjRO5lBnOM0Y=
Date: Fri, 25 Oct 2024 13:18:40 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hughd@google.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-v1-no-need-for-memcg-locking-for-mglru.patch added to mm-unstable branch
Message-Id: <20241025201840.C8575C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg-v1: no need for memcg locking for MGLRU
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-v1-no-need-for-memcg-locking-for-mglru.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-v1-no-need-for-memcg-locking-for-mglru.patch

This patch will later appear in the mm-unstable branch at
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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg-v1: no need for memcg locking for MGLRU
Date: Thu, 24 Oct 2024 18:23:02 -0700

While updating the generation of the folios, MGLRU requires that the
folio's memcg association remains stable.  With the charge migration
deprecated, there is no need for MGLRU to acquire locks to keep the folio
and memcg association stable.

Link: https://lkml.kernel.org/r/20241025012304.2473312-6-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/mm/vmscan.c~memcg-v1-no-need-for-memcg-locking-for-mglru
+++ a/mm/vmscan.c
@@ -3662,10 +3662,6 @@ static void walk_mm(struct mm_struct *mm
 		if (walk->seq != max_seq)
 			break;
 
-		/* folio_update_gen() requires stable folio_memcg() */
-		if (!mem_cgroup_trylock_pages(memcg))
-			break;
-
 		/* the caller might be holding the lock for write */
 		if (mmap_read_trylock(mm)) {
 			err = walk_page_range(mm, walk->next_addr, ULONG_MAX, &mm_walk_ops, walk);
@@ -3673,8 +3669,6 @@ static void walk_mm(struct mm_struct *mm
 			mmap_read_unlock(mm);
 		}
 
-		mem_cgroup_unlock_pages();
-
 		if (walk->batched) {
 			spin_lock_irq(&lruvec->lru_lock);
 			reset_batch_size(walk);
@@ -4096,10 +4090,6 @@ bool lru_gen_look_around(struct page_vma
 		}
 	}
 
-	/* folio_update_gen() requires stable folio_memcg() */
-	if (!mem_cgroup_trylock_pages(memcg))
-		return true;
-
 	arch_enter_lazy_mmu_mode();
 
 	pte -= (addr - start) / PAGE_SIZE;
@@ -4144,7 +4134,6 @@ bool lru_gen_look_around(struct page_vma
 	}
 
 	arch_leave_lazy_mmu_mode();
-	mem_cgroup_unlock_pages();
 
 	/* feedback from rmap walkers to page table walkers */
 	if (mm_state && suitable_to_scan(i, young))
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

mm-optimize-truncation-of-shadow-entries.patch
mm-optimize-invalidation-of-shadow-entries.patch
mm-truncate-reset-xa_has_values-flag-on-each-iteration.patch
memcg-add-tracing-for-memcg-stat-updates.patch
memcg-add-tracing-for-memcg-stat-updates-v2.patch
memcg-v1-fully-deprecate-move_charge_at_immigrate.patch
memcg-v1-remove-charge-move-code.patch
memcg-v1-no-need-for-memcg-locking-for-dirty-tracking.patch
memcg-v1-no-need-for-memcg-locking-for-writeback-tracking.patch
memcg-v1-no-need-for-memcg-locking-for-mglru.patch
memcg-v1-remove-memcg-move-locking-code.patch

