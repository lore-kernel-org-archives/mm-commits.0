Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A3A19309C
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 02:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736305099; cv=none; b=IerOprm2DEKd4glmsWpj0xGN1FuUcBt3YLGfe/nSP3wPrrlmrU8HxEF9L9yYqJ34i7vKlBDFUaax3Ke6bYUwC+8XIjtfbO4xvNyjPrHA8rLAoy2MeohAVyTxquldPXuTUwjxCT5CF0MefDndx1ppdCKx9Z0wYaeeIJJKVOvv5yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736305099; c=relaxed/simple;
	bh=K+sk6W8m8YbS1Nar/dJj6XsGsNDQvIymaghIlPZ7I9w=;
	h=Date:To:From:Subject:Message-Id; b=GXV971prVDKMaaSP3vwDWMRZiNAXVELuNU0Js5AVGR/BSCFzZRuWNM21g81+fWpbk+qQD4Y45ROHPJdYxx0jIOpS0DwXobo1WaeqM2IMN8llNJycxNrd5VI68Zta4w69Hch56/BS4r6SguP3vKz//rOqeMMI1qpTRNNSp4BFYkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SOeYuUYW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SOeYuUYW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00BFCC4CED6;
	Wed,  8 Jan 2025 02:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736305098;
	bh=K+sk6W8m8YbS1Nar/dJj6XsGsNDQvIymaghIlPZ7I9w=;
	h=Date:To:From:Subject:From;
	b=SOeYuUYWbthyi+1yo5jITL9MjRxkLDSylX34e1gvGymBF9G3erWjZ1wiMy9RdKlpm
	 TTxaJcO5mZA0eZhNpDFRBNQi/PFNPbaWZ6vRpNOlDr6V2hHDiKVIhZoFTdHIu4Xctx
	 px82JeLHmEtAE9xX4OuG3p+OrPybncWEfx6nHrbQ=
Date: Tue, 07 Jan 2025 18:58:17 -0800
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,kasong@tencent.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device.patch added to mm-unstable branch
Message-Id: <20250108025818.00BFCC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: skip swapcache for swapin of synchronous swap device
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: skip swapcache for swapin of synchronous swap device
Date: Wed, 8 Jan 2025 10:16:49 +0800

With fast swap devices (such as zram), swapin latency is crucial to
applications.  For shmem swapin, similar to anonymous memory swapin, we
can skip the swapcache operation to improve swapin latency.  Testing 1G
shmem sequential swapin without THP enabled, I observed approximately a 6%
performance improvement: (Note: I repeated 5 times and took the mean data
for each test)

w/o patch	w/ patch	changes
534.8ms		501ms		+6.3%

In addition, currently, we always split the large swap entry stored in the
shmem mapping during shmem large folio swapin, which is not perfect,
especially with a fast swap device.  We should swap in the whole large
folio instead of splitting the precious large folios to take advantage of
the large folios and improve the swapin latency if the swap device is
synchronous device, which is similar to anonymous memory mTHP swapin. 
Testing 1G shmem sequential swapin with 64K mTHP and 2M mTHP, I observed
obvious performance improvement:

mTHP=64K
w/o patch	w/ patch	changes
550.4ms		169.6ms		+69%

mTHP=2M
w/o patch	w/ patch	changes
542.8ms		126.8ms		+77%

Note that skipping swapcache requires attention to concurrent swapin
scenarios.  Fortunately the swapcache_prepare() and
shmem_add_to_page_cache() can help identify concurrent swapin and large
swap entry split scenarios, and return -EEXIST for retry.

Link: https://lkml.kernel.org/r/3d9f3bd3bc6ec953054baff5134f66feeaae7c1e.1736301701.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |  112 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 107 insertions(+), 5 deletions(-)

--- a/mm/shmem.c~mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device
+++ a/mm/shmem.c
@@ -1967,6 +1967,67 @@ unlock:
 	return ERR_PTR(error);
 }
 
+static struct folio *shmem_swap_alloc_folio(struct inode *inode,
+		struct vm_area_struct *vma, pgoff_t index,
+		swp_entry_t entry, int order, gfp_t gfp)
+{
+	struct shmem_inode_info *info = SHMEM_I(inode);
+	struct folio *new;
+	void *shadow;
+	int nr_pages;
+
+	/*
+	 * We have arrived here because our zones are constrained, so don't
+	 * limit chance of success by further cpuset and node constraints.
+	 */
+	gfp &= ~GFP_CONSTRAINT_MASK;
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	if (order > 0) {
+		gfp_t huge_gfp = vma_thp_gfp_mask(vma);
+
+		gfp = limit_gfp_mask(huge_gfp, gfp);
+	}
+#endif
+
+	new = shmem_alloc_folio(gfp, order, info, index);
+	if (!new)
+		return ERR_PTR(-ENOMEM);
+
+	nr_pages = folio_nr_pages(new);
+	if (mem_cgroup_swapin_charge_folio(new, vma ? vma->vm_mm : NULL,
+					   gfp, entry)) {
+		folio_put(new);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	/*
+	 * Prevent parallel swapin from proceeding with the swap cache flag.
+	 *
+	 * Of course there is another possible concurrent scenario as well,
+	 * that is to say, the swap cache flag of a large folio has already
+	 * been set by swapcache_prepare(), while another thread may have
+	 * already split the large swap entry stored in the shmem mapping.
+	 * In this case, shmem_add_to_page_cache() will help identify the
+	 * concurrent swapin and return -EEXIST.
+	 */
+	if (swapcache_prepare(entry, nr_pages)) {
+		folio_put(new);
+		return ERR_PTR(-EEXIST);
+	}
+
+	__folio_set_locked(new);
+	__folio_set_swapbacked(new);
+	new->swap = entry;
+
+	mem_cgroup_swapin_uncharge_swap(entry, nr_pages);
+	shadow = get_shadow_from_swap_cache(entry);
+	if (shadow)
+		workingset_refault(new, shadow);
+	folio_add_lru(new);
+	swap_read_folio(new, NULL);
+	return new;
+}
+
 /*
  * When a page is moved from swapcache to shmem filecache (either by the
  * usual swapin of shmem_get_folio_gfp(), or by the less common swapoff of
@@ -2070,7 +2131,8 @@ static int shmem_replace_folio(struct fo
 }
 
 static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
-					 struct folio *folio, swp_entry_t swap)
+					 struct folio *folio, swp_entry_t swap,
+					 bool skip_swapcache)
 {
 	struct address_space *mapping = inode->i_mapping;
 	swp_entry_t swapin_error;
@@ -2086,7 +2148,8 @@ static void shmem_set_folio_swapin_error
 
 	nr_pages = folio_nr_pages(folio);
 	folio_wait_writeback(folio);
-	delete_from_swap_cache(folio);
+	if (!skip_swapcache)
+		delete_from_swap_cache(folio);
 	/*
 	 * Don't treat swapin error folio as alloced. Otherwise inode->i_blocks
 	 * won't be 0 when inode is released and thus trigger WARN_ON(i_blocks)
@@ -2190,6 +2253,7 @@ static int shmem_swapin_folio(struct ino
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct swap_info_struct *si;
 	struct folio *folio = NULL;
+	bool skip_swapcache = false;
 	swp_entry_t swap;
 	int error, nr_pages;
 
@@ -2211,6 +2275,8 @@ static int shmem_swapin_folio(struct ino
 	/* Look it up and read it in.. */
 	folio = swap_cache_get_folio(swap, NULL, 0);
 	if (!folio) {
+		int order = xa_get_order(&mapping->i_pages, index);
+		bool fallback_order0 = false;
 		int split_order;
 
 		/* Or update major stats only when swapin succeeds?? */
@@ -2221,6 +2287,33 @@ static int shmem_swapin_folio(struct ino
 		}
 
 		/*
+		 * If uffd is active for the vma, we need per-page fault
+		 * fidelity to maintain the uffd semantics, then fallback
+		 * to swapin order-0 folio, as well as for zswap case.
+		 */
+		if (order > 0 && ((vma && unlikely(userfaultfd_armed(vma))) ||
+				  !zswap_never_enabled()))
+			fallback_order0 = true;
+
+		/* Skip swapcache for synchronous device. */
+		if (!fallback_order0 && data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
+			folio = shmem_swap_alloc_folio(inode, vma, index, swap, order, gfp);
+			if (!IS_ERR(folio)) {
+				skip_swapcache = true;
+				goto alloced;
+			}
+
+			/*
+			 * Fallback to swapin order-0 folio unless the swap entry
+			 * already exists.
+			 */
+			error = PTR_ERR(folio);
+			folio = NULL;
+			if (error == -EEXIST)
+				goto failed;
+		}
+
+		/*
 		 * Now swap device can only swap in order 0 folio, then we
 		 * should split the large swap entry stored in the pagecache
 		 * if necessary.
@@ -2250,9 +2343,10 @@ static int shmem_swapin_folio(struct ino
 		}
 	}
 
+alloced:
 	/* We have to do this with folio locked to prevent races */
 	folio_lock(folio);
-	if (!folio_test_swapcache(folio) ||
+	if ((!skip_swapcache && !folio_test_swapcache(folio)) ||
 	    folio->swap.val != swap.val ||
 	    !shmem_confirm_swap(mapping, index, swap)) {
 		error = -EEXIST;
@@ -2288,7 +2382,12 @@ static int shmem_swapin_folio(struct ino
 	if (sgp == SGP_WRITE)
 		folio_mark_accessed(folio);
 
-	delete_from_swap_cache(folio);
+	if (skip_swapcache) {
+		folio->swap.val = 0;
+		swapcache_clear(si, swap, nr_pages);
+	} else {
+		delete_from_swap_cache(folio);
+	}
 	folio_mark_dirty(folio);
 	swap_free_nr(swap, nr_pages);
 	put_swap_device(si);
@@ -2299,8 +2398,11 @@ failed:
 	if (!shmem_confirm_swap(mapping, index, swap))
 		error = -EEXIST;
 	if (error == -EIO)
-		shmem_set_folio_swapin_error(inode, index, folio, swap);
+		shmem_set_folio_swapin_error(inode, index, folio, swap,
+					     skip_swapcache);
 unlock:
+	if (skip_swapcache)
+		swapcache_clear(si, swap, folio_nr_pages(folio));
 	if (folio) {
 		folio_unlock(folio);
 		folio_put(folio);
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-factor-out-the-order-calculation-into-a-new-helper.patch
mm-shmem-change-shmem_huge_global_enabled-to-return-huge-order-bitmap.patch
mm-shmem-add-large-folio-support-for-tmpfs.patch
mm-shmem-add-a-kernel-command-line-to-change-the-default-huge-policy-for-tmpfs.patch
docs-tmpfs-drop-fadvise-from-the-documentation.patch
mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device.patch

