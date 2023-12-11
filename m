Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86DE5246
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NRn4dPTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D52C433C7;
	Mon, 11 Dec 2023 00:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256131;
	bh=3nUWAF0q25G6dMrSg9Uz204RbKzrW26SYIhjGFdYfFI=;
	h=Date:To:From:Subject:From;
	b=NRn4dPTdM+t/fCNI8J93ebhSahpJ+GsXSf4gv85EddM3o9wKx8piXmQPWrbCKXpjI
	 S6rre6j9OxHZXSJl1PeiQNFrNzzltqBL7WG2cvS+2VEof2ZswGBmhwN9Cj5piQvJUy
	 8J3oFlZMpUFT+3iIFRojhDGfXeraTqSa8Y8NDP48=
Date: Sun, 10 Dec 2023 16:55:31 -0800
To: mm-commits@vger.kernel.org,ira.weiny@intel.com,fabio.maria.de.francesco@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swapfile-replace-kmap_atomic-with-kmap_local_page.patch removed from -mm tree
Message-Id: <20231211005531.85D52C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swapfile: replace kmap_atomic() with kmap_local_page()
has been removed from the -mm tree.  Its filename was
     mm-swapfile-replace-kmap_atomic-with-kmap_local_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Fabio M. De Francesco" <fabio.maria.de.francesco@linux.intel.com>
Subject: mm/swapfile: replace kmap_atomic() with kmap_local_page()
Date: Mon, 27 Nov 2023 16:54:37 +0100

kmap_atomic() has been deprecated in favor of kmap_local_page().

Therefore, replace kmap_atomic() with kmap_local_page() in swapfile.c.

kmap_atomic() is implemented like a kmap_local_page() which also disables
page-faults and preemption (the latter only in !PREEMPT_RT kernels).  The
kernel virtual addresses returned by these two API are only valid in the
context of the callers (i.e., they cannot be handed to other threads).

With kmap_local_page() the mappings are per thread and CPU local like in
kmap_atomic(); however, they can handle page-faults and can be called from
any context (including interrupts).  The tasks that call kmap_local_page()
can be preempted and, when they are scheduled to run again, the kernel
virtual addresses are restored and are still valid.

In mm/swapfile.c, the blocks of code between the mappings and un-mappings
do not depend on the above-mentioned side effects of kmap_atomic(), so
that the mere replacements of the old API with the new one is all that is
required (i.e., there is no need to explicitly call pagefault_disable()
and/or preempt_disable()).

Link: https://lkml.kernel.org/r/20231127155452.586387-1-fabio.maria.de.francesco@linux.intel.com
Signed-off-by: Fabio M. De Francesco <fabio.maria.de.francesco@linux.intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-replace-kmap_atomic-with-kmap_local_page
+++ a/mm/swapfile.c
@@ -1495,9 +1495,9 @@ int swp_swapcount(swp_entry_t entry)
 
 	do {
 		page = list_next_entry(page, lru);
-		map = kmap_atomic(page);
+		map = kmap_local_page(page);
 		tmp_count = map[offset];
-		kunmap_atomic(map);
+		kunmap_local(map);
 
 		count += (tmp_count & ~COUNT_CONTINUED) * n;
 		n *= (SWAP_CONT_MAX + 1);
@@ -3477,9 +3477,9 @@ int add_swap_count_continuation(swp_entr
 		if (!(count & COUNT_CONTINUED))
 			goto out_unlock_cont;
 
-		map = kmap_atomic(list_page) + offset;
+		map = kmap_local_page(list_page) + offset;
 		count = *map;
-		kunmap_atomic(map);
+		kunmap_local(map);
 
 		/*
 		 * If this continuation count now has some space in it,
@@ -3529,7 +3529,7 @@ static bool swap_count_continued(struct
 	spin_lock(&si->cont_lock);
 	offset &= ~PAGE_MASK;
 	page = list_next_entry(head, lru);
-	map = kmap_atomic(page) + offset;
+	map = kmap_local_page(page) + offset;
 
 	if (count == SWAP_MAP_MAX)	/* initial increment from swap_map */
 		goto init_map;		/* jump over SWAP_CONT_MAX checks */
@@ -3539,27 +3539,27 @@ static bool swap_count_continued(struct
 		 * Think of how you add 1 to 999
 		 */
 		while (*map == (SWAP_CONT_MAX | COUNT_CONTINUED)) {
-			kunmap_atomic(map);
+			kunmap_local(map);
 			page = list_next_entry(page, lru);
 			BUG_ON(page == head);
-			map = kmap_atomic(page) + offset;
+			map = kmap_local_page(page) + offset;
 		}
 		if (*map == SWAP_CONT_MAX) {
-			kunmap_atomic(map);
+			kunmap_local(map);
 			page = list_next_entry(page, lru);
 			if (page == head) {
 				ret = false;	/* add count continuation */
 				goto out;
 			}
-			map = kmap_atomic(page) + offset;
+			map = kmap_local_page(page) + offset;
 init_map:		*map = 0;		/* we didn't zero the page */
 		}
 		*map += 1;
-		kunmap_atomic(map);
+		kunmap_local(map);
 		while ((page = list_prev_entry(page, lru)) != head) {
-			map = kmap_atomic(page) + offset;
+			map = kmap_local_page(page) + offset;
 			*map = COUNT_CONTINUED;
-			kunmap_atomic(map);
+			kunmap_local(map);
 		}
 		ret = true;			/* incremented */
 
@@ -3569,21 +3569,21 @@ init_map:		*map = 0;		/* we didn't zero
 		 */
 		BUG_ON(count != COUNT_CONTINUED);
 		while (*map == COUNT_CONTINUED) {
-			kunmap_atomic(map);
+			kunmap_local(map);
 			page = list_next_entry(page, lru);
 			BUG_ON(page == head);
-			map = kmap_atomic(page) + offset;
+			map = kmap_local_page(page) + offset;
 		}
 		BUG_ON(*map == 0);
 		*map -= 1;
 		if (*map == 0)
 			count = 0;
-		kunmap_atomic(map);
+		kunmap_local(map);
 		while ((page = list_prev_entry(page, lru)) != head) {
-			map = kmap_atomic(page) + offset;
+			map = kmap_local_page(page) + offset;
 			*map = SWAP_CONT_MAX | count;
 			count = COUNT_CONTINUED;
-			kunmap_atomic(map);
+			kunmap_local(map);
 		}
 		ret = count == COUNT_CONTINUED;
 	}
_

Patches currently in -mm which might be from fabio.maria.de.francesco@linux.intel.com are


