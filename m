Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0596B6F2EB
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423475; cv=none; b=LitiiD4dayWfw04xQPrPOXB1hS99nh7p/5jWMhzi+Q9yd+wFshDNtthqTAYoMoPyd+r78eT/x+o04u+YftidUAR42XAR0DMAO+QFuwN3EI7h/+2HoF5iW5aGfvvsXBr0BAI3thL6OeiJMuc7/dQXvfj1aOERmFkOMJ5MyilHeno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423475; c=relaxed/simple;
	bh=a8XYCbuavcI7oaq+s+TpAys4jIdpfOPtuVuRwHSjfIE=;
	h=Date:To:From:Subject:Message-Id; b=FfV7Tt/RggLJSkj3L+0YK0hZmgytg4vTY30v8H7jNTcOLZ9kGAks19HotBhVXdB2MKnURlJlhoypgP3oYiRiq/4I3DnveofW/JjcF04AFT/5QqNpKFnbU14+6p3XYVR9AihvTMn5+KEw7pHPLr4R5eULe7YlZZF2K/8fHS06BC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uw8bX+1C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uw8bX+1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB60C4CEC2;
	Wed,  4 Sep 2024 04:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423474;
	bh=a8XYCbuavcI7oaq+s+TpAys4jIdpfOPtuVuRwHSjfIE=;
	h=Date:To:From:Subject:From;
	b=uw8bX+1CSjyEh5Driv+MlJpd8VIJx6ssXaKLSUrd6Tr0/lZYvsNYvYZZpakJvy8b+
	 pio9Gv8Q7QoTcKmrJPR3CWGcigwpMiUoq6/dq73rRBuzT65oxLBf7gsHXzJW+77Yin
	 uLEgRMTf/m3q29pghm9z5K9pbcp4D+kWfPYlkk1A=
Date: Tue, 03 Sep 2024 21:17:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,chrisl@kernel.org,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large.patch removed from -mm tree
Message-Id: <20240904041754.CEB60C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: split large entry if the swapin folio is not large
has been removed from the -mm tree.  Its filename was
     mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: split large entry if the swapin folio is not large
Date: Mon, 12 Aug 2024 15:42:09 +0800

Now the swap device can only swap-in order 0 folio, even though a large
folio is swapped out.  This requires us to split the large entry
previously saved in the shmem pagecache to support the swap in of small
folios.

[hughd@google.com: fix warnings from kmalloc_fix_flags()]
  Link: https://lkml.kernel.org/r/e2a2ba5d-864c-50aa-7579-97cba1c7dd0c@google.com
[baolin.wang@linux.alibaba.com: drop the 'new_order' parameter]
  Link: https://lkml.kernel.org/r/39c71ccf-669b-4d9f-923c-f6b9c4ceb8df@linux.alibaba.com
Link: https://lkml.kernel.org/r/4a0f12f27c54a62eb4d9ca1265fed3a62531a63e.1723434324.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |  103 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 103 insertions(+)

--- a/mm/shmem.c~mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large
+++ a/mm/shmem.c
@@ -1999,6 +1999,84 @@ static void shmem_set_folio_swapin_error
 	swap_free_nr(swap, nr_pages);
 }
 
+static int shmem_split_large_entry(struct inode *inode, pgoff_t index,
+				   swp_entry_t swap, gfp_t gfp)
+{
+	struct address_space *mapping = inode->i_mapping;
+	XA_STATE_ORDER(xas, &mapping->i_pages, index, 0);
+	void *alloced_shadow = NULL;
+	int alloced_order = 0, i;
+
+	/* Convert user data gfp flags to xarray node gfp flags */
+	gfp &= GFP_RECLAIM_MASK;
+
+	for (;;) {
+		int order = -1, split_order = 0;
+		void *old = NULL;
+
+		xas_lock_irq(&xas);
+		old = xas_load(&xas);
+		if (!xa_is_value(old) || swp_to_radix_entry(swap) != old) {
+			xas_set_err(&xas, -EEXIST);
+			goto unlock;
+		}
+
+		order = xas_get_order(&xas);
+
+		/* Swap entry may have changed before we re-acquire the lock */
+		if (alloced_order &&
+		    (old != alloced_shadow || order != alloced_order)) {
+			xas_destroy(&xas);
+			alloced_order = 0;
+		}
+
+		/* Try to split large swap entry in pagecache */
+		if (order > 0) {
+			if (!alloced_order) {
+				split_order = order;
+				goto unlock;
+			}
+			xas_split(&xas, old, order);
+
+			/*
+			 * Re-set the swap entry after splitting, and the swap
+			 * offset of the original large entry must be continuous.
+			 */
+			for (i = 0; i < 1 << order; i++) {
+				pgoff_t aligned_index = round_down(index, 1 << order);
+				swp_entry_t tmp;
+
+				tmp = swp_entry(swp_type(swap), swp_offset(swap) + i);
+				__xa_store(&mapping->i_pages, aligned_index + i,
+					   swp_to_radix_entry(tmp), 0);
+			}
+		}
+
+unlock:
+		xas_unlock_irq(&xas);
+
+		/* split needed, alloc here and retry. */
+		if (split_order) {
+			xas_split_alloc(&xas, old, split_order, gfp);
+			if (xas_error(&xas))
+				goto error;
+			alloced_shadow = old;
+			alloced_order = split_order;
+			xas_reset(&xas);
+			continue;
+		}
+
+		if (!xas_nomem(&xas, gfp))
+			break;
+	}
+
+error:
+	if (xas_error(&xas))
+		return xas_error(&xas);
+
+	return alloced_order;
+}
+
 /*
  * Swap in the folio pointed to by *foliop.
  * Caller has to make sure that *foliop contains a valid swapped folio.
@@ -2036,12 +2114,37 @@ static int shmem_swapin_folio(struct ino
 	/* Look it up and read it in.. */
 	folio = swap_cache_get_folio(swap, NULL, 0);
 	if (!folio) {
+		int split_order;
+
 		/* Or update major stats only when swapin succeeds?? */
 		if (fault_type) {
 			*fault_type |= VM_FAULT_MAJOR;
 			count_vm_event(PGMAJFAULT);
 			count_memcg_event_mm(fault_mm, PGMAJFAULT);
 		}
+
+		/*
+		 * Now swap device can only swap in order 0 folio, then we
+		 * should split the large swap entry stored in the pagecache
+		 * if necessary.
+		 */
+		split_order = shmem_split_large_entry(inode, index, swap, gfp);
+		if (split_order < 0) {
+			error = split_order;
+			goto failed;
+		}
+
+		/*
+		 * If the large swap entry has already been split, it is
+		 * necessary to recalculate the new swap entry based on
+		 * the old order alignment.
+		 */
+		if (split_order > 0) {
+			pgoff_t offset = index - round_down(index, 1 << split_order);
+
+			swap = swp_entry(swp_type(swap), swp_offset(swap) + offset);
+		}
+
 		/* Here we actually start the io */
 		folio = shmem_swapin_cluster(swap, gfp, info, index);
 		if (!folio) {
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


