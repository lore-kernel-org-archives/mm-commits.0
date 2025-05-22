Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47427257432;
	Thu, 22 May 2025 21:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747950099; cv=none; b=PZwYOR+McII3xHoz3GRHB8/BFWjpOpxEI5KG82Ol3FrpyRptOjIkWv79DYkALeG941M30ebIKNdfRQP6HhLkPVlrfv6zDQBigzwTfpC0T5Iww07H9+u78lNM+k83jM/hjP7bmkItRYfU3fymsTLUi13lBuVYuT8nYBGBS+XVywo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747950099; c=relaxed/simple;
	bh=nh/sIL8cZ/IY37w59J7C5fzgZJJ7O7M4594g2nt1jnk=;
	h=Date:To:From:Subject:Message-Id; b=mu8xHpnwsHSovglWI3EHEg+u9yNEQkKvjCO7vw5DoT+GzruEZ1nqvxTWrwBycUrsOtDCU2O4xe3LZKUzyeO3rrHS16wEw6njtKFTjqtPnGFb8EcTAtXj9iy/bfbgwWVnKjZThUV5NobC7bJCMYvDENa80CwD5faIoBdUByjBTpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v8qVWNCk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v8qVWNCk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B52C4CEE4;
	Thu, 22 May 2025 21:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747950099;
	bh=nh/sIL8cZ/IY37w59J7C5fzgZJJ7O7M4594g2nt1jnk=;
	h=Date:To:From:Subject:From;
	b=v8qVWNCkX10fxlAyUilphsecDcNSGXxi6he1P9gQZ/Qvx7ZrYwfmrZsN6WuSY/4+i
	 GcjJD0jK9hc3r/aIZvXj2UGgP5b2mvVuLV2fihwSlUIFjAZbOObBLZlri2QFluL7zM
	 PBOE9tKRKBEUTv8edNA629H00zs/pU4g1fHYxuC8=
Date: Thu, 22 May 2025 14:41:38 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kasong@tencent.com,hannes@cmpxchg.org,bhe@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-move-nr_swap_pages-counter-decrement-from-folio_alloc_swap-to-swap_range_alloc.patch added to mm-new branch
Message-Id: <20250522214138.E1B52C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: move nr_swap_pages counter decrement from folio_alloc_swap() to swap_range_alloc()
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-move-nr_swap_pages-counter-decrement-from-folio_alloc_swap-to-swap_range_alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-move-nr_swap_pages-counter-decrement-from-folio_alloc_swap-to-swap_range_alloc.patch

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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: swap: move nr_swap_pages counter decrement from folio_alloc_swap() to swap_range_alloc()
Date: Thu, 22 May 2025 20:25:51 +0800

Patch series "Some randome fixes and cleanups to swapfile".

Patch 0-3 are some random fixes.  Patch 4 is a cleanup.  More details can
be found in respective patches.


This patch (of 4):

When folio_alloc_swap() encounters a failure in either
mem_cgroup_try_charge_swap() or add_to_swap_cache(), nr_swap_pages counter
is not decremented for allocated entry.  However, the following
put_swap_folio() will increase nr_swap_pages counter unpairly and lead to
an imbalance.

Move nr_swap_pages decrement from folio_alloc_swap() to swap_range_alloc()
to pair the nr_swap_pages counting.

Link: https://lkml.kernel.org/r/20250522122554.12209-1-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/20250522122554.12209-2-shikemeng@huaweicloud.com
Fixes: 0ff67f990bd45 ("mm, swap: remove swap slot cache")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-move-nr_swap_pages-counter-decrement-from-folio_alloc_swap-to-swap_range_alloc
+++ a/mm/swapfile.c
@@ -1115,6 +1115,7 @@ static void swap_range_alloc(struct swap
 		if (vm_swap_full())
 			schedule_work(&si->reclaim_work);
 	}
+	atomic_long_sub(nr_entries, &nr_swap_pages);
 }
 
 static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
@@ -1313,7 +1314,6 @@ int folio_alloc_swap(struct folio *folio
 	if (add_to_swap_cache(folio, entry, gfp | __GFP_NOMEMALLOC, NULL))
 		goto out_free;
 
-	atomic_long_sub(size, &nr_swap_pages);
 	return 0;
 
 out_free:
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-shmem-avoid-unpaired-folio_unlock-in-shmem_swapin_folio.patch
mm-shmem-add-missing-shmem_unacct_size-in-__shmem_file_setup.patch
mm-shmem-fix-potential-dead-loop-in-shmem_unuse.patch
mm-shmem-only-remove-inode-from-swaplist-when-its-swapped-page-count-is-0.patch
mm-shmem-remove-unneeded-xa_is_value-check-in-shmem_unuse_swap_entries.patch
mm-swap-move-nr_swap_pages-counter-decrement-from-folio_alloc_swap-to-swap_range_alloc.patch
mm-swap-correctly-use-maxpages-in-swapon-syscall-to-avoid-potensial-deadloop.patch
mm-swap-fix-potensial-buffer-overflow-in-setup_clusters.patch
mm-swap-remove-stale-comment-stale-comment-in-cluster_alloc_swap_entry.patch

