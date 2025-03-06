Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DF219E99E;
	Thu,  6 Mar 2025 05:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741239465; cv=none; b=UguaAvQslRZEMWFMVLjU0DrYrXPGwdOTzRI8USuZ69AB43GIqZZl16P0ZzpixO5mrOKpjP3/0aw9qKLJijFv1JZo+RTkfX+SK2HctzMY6Q5kSVFhJgEITde8/zt8IFYSbT7JMLxpdeU/LeCLZSu7KQemZVvwkpVsUQpYu8BsFxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741239465; c=relaxed/simple;
	bh=vCme8TqDNX3HR4cFm/t/cv1fYqIgR/+f/5ODzFVnesY=;
	h=Date:To:From:Subject:Message-Id; b=bgeL2bQDxwV+333aDq9EErCc/c04EkVCQvHUNDxkn1EmaE0SSq/bAQj8HVSdGS7BktOjZ4vEh9dBgwJW0HUGtejEC7Ej1rXZjdUgXtNd3yYEiF0xn+LZg3O/JAn0BKDWL/eT0dfwcVuOGQB/SRx3meJHFLpcBv6q9rQBNBNyq2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uHuiaQxu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uHuiaQxu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0797C4CEE4;
	Thu,  6 Mar 2025 05:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741239464;
	bh=vCme8TqDNX3HR4cFm/t/cv1fYqIgR/+f/5ODzFVnesY=;
	h=Date:To:From:Subject:From;
	b=uHuiaQxudIiYDsedB0dmNvP3kW61yKElJuxReD32loc7HhjprePLG482hxjPRxEZb
	 QlUc6AF1HrIvR6ATKwn+XvPn0YRDwxi2EJdH0v9JjWIP4RmoHFS3dtPfx/lYUUkxwz
	 2ApvB0lAys4+YQEcczwD4dx6xllfV6PLi38bOaI4=
Date: Wed, 05 Mar 2025 21:37:44 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,ryncsn@gmail.com,kasong@tencent.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,alex_y_xu@yahoo.ca,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-shmem-fix-potential-data-corruption-during-shmem-swapin.patch removed from -mm tree
Message-Id: <20250306053744.B0797C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: fix potential data corruption during shmem swapin
has been removed from the -mm tree.  Its filename was
     mm-shmem-fix-potential-data-corruption-during-shmem-swapin.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: fix potential data corruption during shmem swapin
Date: Tue, 25 Feb 2025 17:52:55 +0800

Alex and Kairui reported some issues (system hang or data corruption) when
swapping out or swapping in large shmem folios.  This is especially easy
to reproduce when the tmpfs is mount with the 'huge=within_size'
parameter.  Thanks to Kairui's reproducer, the issue can be easily
replicated.

The root cause of the problem is that swap readahead may asynchronously
swap in order 0 folios into the swap cache, while the shmem mapping can
still store large swap entries.  Then an order 0 folio is inserted into
the shmem mapping without splitting the large swap entry, which overwrites
the original large swap entry, leading to data corruption.

When getting a folio from the swap cache, we should split the large swap
entry stored in the shmem mapping if the orders do not match, to fix this
issue.

Link: https://lkml.kernel.org/r/2fe47c557e74e9df5fe2437ccdc6c9115fa1bf70.1740476943.git.baolin.wang@linux.alibaba.com
Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reported-by: Alex Xu (Hello71) <alex_y_xu@yahoo.ca>
Reported-by: Kairui Song <ryncsn@gmail.com>
Closes: https://lore.kernel.org/all/1738717785.im3r5g2vxc.none@localhost/
Tested-by: Kairui Song <kasong@tencent.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcow <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

--- a/mm/shmem.c~mm-shmem-fix-potential-data-corruption-during-shmem-swapin
+++ a/mm/shmem.c
@@ -2253,7 +2253,7 @@ static int shmem_swapin_folio(struct ino
 	struct folio *folio = NULL;
 	bool skip_swapcache = false;
 	swp_entry_t swap;
-	int error, nr_pages;
+	int error, nr_pages, order, split_order;
 
 	VM_BUG_ON(!*foliop || !xa_is_value(*foliop));
 	swap = radix_to_swp_entry(*foliop);
@@ -2272,10 +2272,9 @@ static int shmem_swapin_folio(struct ino
 
 	/* Look it up and read it in.. */
 	folio = swap_cache_get_folio(swap, NULL, 0);
+	order = xa_get_order(&mapping->i_pages, index);
 	if (!folio) {
-		int order = xa_get_order(&mapping->i_pages, index);
 		bool fallback_order0 = false;
-		int split_order;
 
 		/* Or update major stats only when swapin succeeds?? */
 		if (fault_type) {
@@ -2339,6 +2338,29 @@ static int shmem_swapin_folio(struct ino
 			error = -ENOMEM;
 			goto failed;
 		}
+	} else if (order != folio_order(folio)) {
+		/*
+		 * Swap readahead may swap in order 0 folios into swapcache
+		 * asynchronously, while the shmem mapping can still stores
+		 * large swap entries. In such cases, we should split the
+		 * large swap entry to prevent possible data corruption.
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
 	}
 
 alloced:
@@ -2346,7 +2368,8 @@ alloced:
 	folio_lock(folio);
 	if ((!skip_swapcache && !folio_test_swapcache(folio)) ||
 	    folio->swap.val != swap.val ||
-	    !shmem_confirm_swap(mapping, index, swap)) {
+	    !shmem_confirm_swap(mapping, index, swap) ||
+	    xa_get_order(&mapping->i_pages, index) != folio_order(folio)) {
 		error = -EEXIST;
 		goto unlock;
 	}
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-drop-the-unused-macro.patch
mm-shmem-remove-fadvise-comments.patch
mm-shmem-remove-duplicate-error-validation.patch
mm-shmem-change-the-return-value-of-shmem_find_swap_entries.patch
mm-shmem-factor-out-the-within_size-logic-into-a-new-helper.patch
maintainers-add-myself-as-shmem-reviewer.patch

