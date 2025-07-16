Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D1718C008
	for <mm-commits@vger.kernel.org>; Wed, 16 Jul 2025 22:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752705139; cv=none; b=Nzmt4pPCuT4nk8+j4wSszHQlDecwHiiehNgtabpnCRPM/sl9We/IEjFuHR9NvnDHcx/Vnbzz5h/k+sdjUm6V54QyIy5coeF7NL96IUSW2GVgGgc2f/3PEOInz94ryuhAeNfC8NAxcu38VGmq67XDH7U/8b6ZoZ1swyUpQ3Vh9Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752705139; c=relaxed/simple;
	bh=M0H/8NN/x9bBBvZWu16lEkylxVMcyJSnFvyv/f/h0yo=;
	h=Date:To:From:Subject:Message-Id; b=iUEQ5en+eR2wZD5lJDzYpcL17PIS9i6N4vnPjXusBBRiXW5Ai5RzZPfAyNcPCmtzzr8fAx0jH+AlsLgYpaXOJdtJiOPNNmfJseRP/nIluD8BEtJhNnFPXlBNUjr0xUsJApGC+uaotQsK0BPyw8aYJRB3whymODAcofanfnbN7w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fkr04wd5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fkr04wd5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68C2C4CEE7;
	Wed, 16 Jul 2025 22:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752705139;
	bh=M0H/8NN/x9bBBvZWu16lEkylxVMcyJSnFvyv/f/h0yo=;
	h=Date:To:From:Subject:From;
	b=Fkr04wd53MqIU3vOnt4N/YHlIEFs9TbDfIHf2A9yZhm+vJojsbOIGCbS5p9DcVHaa
	 ryOt+1edEQEv4Tp5AkjO73z5e6pFFZ5/QJVnrvdWhwvQ5Xh62Vm+azaha4YntW/i3D
	 z8Tn+FCoEsAoQPNvKhIeLtH1kD3/sDpg144mypvU=
Date: Wed, 16 Jul 2025 15:32:18 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,ryncsn@gmail.com,rientjes@google.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,21cnbao@gmail.com,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-writeout-free-swap-if-swap_writeout-reactivates.patch added to mm-new branch
Message-Id: <20250716223218.E68C2C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem: writeout free swap if swap_writeout() reactivates
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-writeout-free-swap-if-swap_writeout-reactivates.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-writeout-free-swap-if-swap_writeout-reactivates.patch

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
From: Hugh Dickins <hughd@google.com>
Subject: mm/shmem: writeout free swap if swap_writeout() reactivates
Date: Wed, 16 Jul 2025 01:08:39 -0700 (PDT)

If swap_writeout() returns AOP_WRITEPAGE_ACTIVATE (for example, because
zswap cannot compress and memcg disables writeback), there is no virtue in
keeping that folio in swap cache and holding the swap allocation:
shmem_writeout() switch it back to shmem page cache before returning.

Folio lock is held, and folio->memcg_data remains set throughout, so there
is no need to get into any memcg or memsw charge complications:
swap_free_nr() and delete_from_swap_cache() do as much as is needed (but
beware the race with shmem_free_swap() when inode truncated or evicted).

Doing the same for an anonymous folio is harder, since it will usually
have been unmapped, with references to the swap left in the page tables. 
Adding a function to remap the folio would be fun, but not worthwhile
unless it has other uses, or an urgent bug with anon is demonstrated.

Link: https://lkml.kernel.org/r/5c911f7a-af7a-5029-1dd4-2e00b66d565c@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-writeout-free-swap-if-swap_writeout-reactivates
+++ a/mm/shmem.c
@@ -1655,6 +1655,7 @@ try_split:
 
 	if (!folio_alloc_swap(folio, __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
 		bool first_swapped = shmem_recalc_inode(inode, 0, nr_pages);
+		int error;
 
 		/*
 		 * Add inode to shmem_unuse()'s list of swapped-out inodes,
@@ -1675,7 +1676,37 @@ try_split:
 		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
 
 		BUG_ON(folio_mapped(folio));
-		return swap_writeout(folio, plug);
+		error = swap_writeout(folio, plug);
+		if (error != AOP_WRITEPAGE_ACTIVATE) {
+			/* folio has been unlocked */
+			return error;
+		}
+
+		/*
+		 * The intention here is to avoid holding on to the swap when
+		 * zswap was unable to compress and unable to writeback; but
+		 * it will be appropriate if other reactivate cases are added.
+		 */
+		error = shmem_add_to_page_cache(folio, mapping, index,
+				swp_to_radix_entry(folio->swap),
+				__GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
+		/* Swap entry might be erased by racing shmem_free_swap() */
+		if (!error) {
+			spin_lock(&info->lock);
+			info->swapped -= nr_pages;
+			spin_unlock(&info->lock);
+			swap_free_nr(folio->swap, nr_pages);
+		}
+
+		/*
+		 * The delete_from_swap_cache() below could be left for
+		 * shrink_folio_list()'s folio_free_swap() to dispose of;
+		 * but I'm a little nervous about letting this folio out of
+		 * shmem_writeout() in a hybrid half-tmpfs-half-swap state
+		 * e.g. folio_mapping(folio) might give an unexpected answer.
+		 */
+		delete_from_swap_cache(folio);
+		goto redirty;
 	}
 	if (nr_pages > 1)
 		goto try_split;
_

Patches currently in -mm which might be from hughd@google.com are

mm-optimize-lru_note_cost-by-adding-lru_note_cost_unlock_irq.patch
mm-optimize-lru_note_cost-by-adding-lru_note_cost_unlock_irq-fix.patch
mm-shmem-hold-shmem_swaplist-spinlock-not-mutex-much-less.patch
mm-shmem-writeout-free-swap-if-swap_writeout-reactivates.patch

