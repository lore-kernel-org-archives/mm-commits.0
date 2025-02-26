Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CAF19ADA2;
	Wed, 26 Feb 2025 02:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740535911; cv=none; b=mEj5pCVMWUchrhqoKPdfrNjEdHNZa7+gMpBCCqheYUv5toFWc8kp+hniseVhE1139FxTceby9yZ1q/b0b/VE7BBXweecnT8HBdL/RcyUh8NIiy+D+xlVJVX2dqr4S4f/Qs/7ZO4lCEkL6V3cITUCfGd7SflWjVN0XWH7PKajmys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740535911; c=relaxed/simple;
	bh=O4H008rVzhq/HoZXR/O/vMPvsdCCBN4ubtlpHYDpQLY=;
	h=Date:To:From:Subject:Message-Id; b=YYXJNNGl9iLlemgtsr1i1p6n0ON4j+OOJHU0HPatnCq6JBGRVvtP2+44OMsOHEXHiWgJgWsGIEUSfz4avPSaAZAmASAR5TT/NePsw6iJ0F3K2SOB/MnFAYfPN0KUetbTqqIAHDrKl5eTPHwdj08uYIp5fVSdtNA2FBOigCcRlJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UiYMhkh+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UiYMhkh+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7292CC4CEDD;
	Wed, 26 Feb 2025 02:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740535910;
	bh=O4H008rVzhq/HoZXR/O/vMPvsdCCBN4ubtlpHYDpQLY=;
	h=Date:To:From:Subject:From;
	b=UiYMhkh+4McISSKjD2QtCMo0SMJlwoHEtoEi7+OnA2+vHFJdi/QjQfmNJ+0rKB/ll
	 fwmdtOvgGgFetPEBCuM59FPB5ERoKoFZzjOxpB8Jj562xrOCBAVZabxF2fYHvYOxXv
	 Yc8EcFlwRgqrOsFSmVTzyallFJGgLP9tBS3GFTzQ=
Date: Tue, 25 Feb 2025 18:11:49 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,ryncsn@gmail.com,kasong@tencent.com,ioworker0@gmail.com,david@redhat.com,alex_y_xu@yahoo.ca,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-fix-potential-data-corruption-during-shmem-swapin.patch added to mm-hotfixes-unstable branch
Message-Id: <20250226021150.7292CC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: fix potential data corruption during shmem swapin
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shmem-fix-potential-data-corruption-during-shmem-swapin.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-fix-potential-data-corruption-during-shmem-swapin.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-shmem-fix-potential-data-corruption-during-shmem-swapin.patch
mm-shmem-drop-the-unused-macro.patch
mm-shmem-remove-fadvise-comments.patch
mm-shmem-remove-duplicate-error-validation.patch
mm-shmem-change-the-return-value-of-shmem_find_swap_entries.patch
mm-shmem-factor-out-the-within_size-logic-into-a-new-helper.patch
maintainers-add-myself-as-shmem-reviewer.patch

