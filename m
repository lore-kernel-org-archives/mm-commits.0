Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB9017E4
	for <mm-commits@vger.kernel.org>; Sat,  6 Sep 2025 00:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757118430; cv=none; b=VQ9FD3ckh+p2Z48UAxCfKepVOpJBTO+1in+aNZJq4BV1kybUg81P20It/0t03g/fByj2jiBDi3IR3gVSL+VSmcSRZFzFJoJ4NY9evBxiGZttjxtvyA/74+KHVbgWycB+T70UbVSwtF2Wcy1blc3VGZxFbqEUU/sBcjTBNHirv24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757118430; c=relaxed/simple;
	bh=eb79NpM3EHRrj6LEJfqZx63AsY/np/pbIBfvA8Usq6c=;
	h=Date:To:From:Subject:Message-Id; b=RvVt6mTMQXx57xjqRKZkXwJspUoG7CNEbMdF8W9f6jmhddJs72GSUvWXkmOrVAl+5YJP2DAWdCp9jSL+rd8yaTfJn4FT8ljZHj3d34dJvymte4Ba2gflDUnDfy3CGF0qxZtieo9/ZiO4PNG3twuT+euiAav6rSTZwiNxK9FGSxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FnDJNTdm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FnDJNTdm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523E3C4CEF5;
	Sat,  6 Sep 2025 00:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757118430;
	bh=eb79NpM3EHRrj6LEJfqZx63AsY/np/pbIBfvA8Usq6c=;
	h=Date:To:From:Subject:From;
	b=FnDJNTdmjCaYB+90fd3CvsGRULDCfoGphFI9HbJgq39Z/WjY+P4QdX4Wq/BwptNRk
	 VPjCXUsNKMRlN7qGmwUIVvu8wRE3r1QqWcMvtFYwwcQO45zTJx/Xd/JJokrCS7ogeV
	 MOAf73te9rYWj5pADTWLp9JpUy5DmytSSrDohj4U=
Date: Fri, 05 Sep 2025 17:27:09 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yosryahmed@google.com,ying.huang@linux.alibaba.com,willy@infradead.org,shikemeng@huaweicloud.com,oliver.sang@intel.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-swap-remove-redundant-error-handling-for-replacing-folio.patch added to mm-new branch
Message-Id: <20250906002710.523E3C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem, swap: remove redundant error handling for replacing folio
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-swap-remove-redundant-error-handling-for-replacing-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-swap-remove-redundant-error-handling-for-replacing-folio.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/shmem, swap: remove redundant error handling for replacing folio
Date: Sat, 6 Sep 2025 03:13:50 +0800

Shmem may replace a folio in the swap cache if the cached one doesn't fit
the swapin's GFP zone.  When doing so, shmem has already double checked
that the swap cache folio is locked, still has the swap cache flag set,
and contains the wanted swap entry.  So it is impossible to fail due to an
Xarray mismatch.  There is even a comment for that.

Delete the defensive error handling path, and add a WARN_ON instead: if
that happened, something has broken the basic principle of how the swap
cache works, we should catch and fix that.

Link: https://lkml.kernel.org/r/20250905191357.78298-9-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   42 ++++++++++++------------------------------
 1 file changed, 12 insertions(+), 30 deletions(-)

--- a/mm/shmem.c~mm-shmem-swap-remove-redundant-error-handling-for-replacing-folio
+++ a/mm/shmem.c
@@ -1661,13 +1661,13 @@ try_split:
 		}
 
 		/*
-		 * The delete_from_swap_cache() below could be left for
+		 * The swap_cache_del_folio() below could be left for
 		 * shrink_folio_list()'s folio_free_swap() to dispose of;
 		 * but I'm a little nervous about letting this folio out of
 		 * shmem_writeout() in a hybrid half-tmpfs-half-swap state
 		 * e.g. folio_mapping(folio) might give an unexpected answer.
 		 */
-		delete_from_swap_cache(folio);
+		swap_cache_del_folio(folio);
 		goto redirty;
 	}
 	if (nr_pages > 1)
@@ -2045,7 +2045,7 @@ retry:
 	new->swap = entry;
 
 	memcg1_swapin(entry, nr_pages);
-	shadow = get_shadow_from_swap_cache(entry);
+	shadow = swap_cache_get_shadow(entry);
 	if (shadow)
 		workingset_refault(new, shadow);
 	folio_add_lru(new);
@@ -2121,35 +2121,17 @@ static int shmem_replace_folio(struct fo
 	/* Swap cache still stores N entries instead of a high-order entry */
 	xa_lock_irq(&swap_mapping->i_pages);
 	for (i = 0; i < nr_pages; i++) {
-		void *item = xas_load(&xas);
-
-		if (item != old) {
-			error = -ENOENT;
-			break;
-		}
-
-		xas_store(&xas, new);
+		WARN_ON_ONCE(xas_store(&xas, new));
 		xas_next(&xas);
 	}
-	if (!error) {
-		mem_cgroup_replace_folio(old, new);
-		shmem_update_stats(new, nr_pages);
-		shmem_update_stats(old, -nr_pages);
-	}
 	xa_unlock_irq(&swap_mapping->i_pages);
 
-	if (unlikely(error)) {
-		/*
-		 * Is this possible?  I think not, now that our callers
-		 * check both the swapcache flag and folio->private
-		 * after getting the folio lock; but be defensive.
-		 * Reverse old to newpage for clear and free.
-		 */
-		old = new;
-	} else {
-		folio_add_lru(new);
-		*foliop = new;
-	}
+	mem_cgroup_replace_folio(old, new);
+	shmem_update_stats(new, nr_pages);
+	shmem_update_stats(old, -nr_pages);
+
+	folio_add_lru(new);
+	*foliop = new;
 
 	folio_clear_swapcache(old);
 	old->private = NULL;
@@ -2183,7 +2165,7 @@ static void shmem_set_folio_swapin_error
 	nr_pages = folio_nr_pages(folio);
 	folio_wait_writeback(folio);
 	if (!skip_swapcache)
-		delete_from_swap_cache(folio);
+		swap_cache_del_folio(folio);
 	/*
 	 * Don't treat swapin error folio as alloced. Otherwise inode->i_blocks
 	 * won't be 0 when inode is released and thus trigger WARN_ON(i_blocks)
@@ -2422,7 +2404,7 @@ static int shmem_swapin_folio(struct ino
 		folio->swap.val = 0;
 		swapcache_clear(si, swap, nr_pages);
 	} else {
-		delete_from_swap_cache(folio);
+		swap_cache_del_folio(folio);
 	}
 	folio_mark_dirty(folio);
 	swap_free_nr(swap, nr_pages);
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-only-scan-one-cluster-in-fragment-list.patch
mm-swap-remove-fragment-clusters-counter.patch
mm-swap-prefer-nonfull-over-free-clusters.patch
mm-mincore-swap-consolidate-swap-cache-checking-for-mincore.patch
mm-mincore-use-a-helper-for-checking-the-swap-cache.patch
mm-page-writeback-drop-usage-of-folio_index.patch
mm-swap-use-unified-helper-for-swap-cache-look-up.patch
mm-swap-fix-swap-cahe-index-error-when-retrying-reclaim.patch
mm-swap-check-page-poison-flag-after-locking-it.patch
mm-swap-always-lock-and-check-the-swap-cache-folio-before-use.patch
mm-swap-rename-and-move-some-swap-cluster-definition-and-helpers.patch
mm-swap-tidy-up-swap-device-and-cluster-info-helpers.patch
mm-shmem-swap-remove-redundant-error-handling-for-replacing-folio.patch
mm-swap-cleanup-swap-cache-api-and-add-kerneldoc.patch
mm-swap-wrap-swap-cache-replacement-with-a-helper.patch
mm-swap-use-the-swap-table-for-the-swap-cache-and-switch-api.patch
mm-swap-mark-swap-address-space-ro-and-add-context-debug-check.patch
mm-swap-remove-contention-workaround-for-swap-cache.patch
mm-swap-implement-dynamic-allocation-of-swap-table.patch
mm-swap-use-a-single-page-for-swap-table-when-the-size-fits.patch

