Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F389199EB0
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 03:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741233272; cv=none; b=NY+gmVNPZR2FGAFWfxoPC8i1cPlrUutUmB+Av3kEtX8Rk4YtQMEK9ItumHvTeoaKOxgo73gl+BxfkKIErA8Ey4rIYUhZtWW3s6QOwFZav9CbHvX4SkUOiQ1Y3vgpvLcHy+5dwA1Jai1FeqbviMhpYwJAJEGYP4igs0hKrXZgE/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741233272; c=relaxed/simple;
	bh=ntfq6Td1/kGWHAd78NyKXXFA4bW8i3CIwCCJf6XQNqU=;
	h=Date:To:From:Subject:Message-Id; b=oYSsvTII8SH5KDbHrjGkLLBJOEtELCY95YGd7gJbwoCce4mxOmYIm5AaeaRMzi+8rCDa6UjSmjnXF7ckIQfhNMD4kAdCFqLO3hcLjcW6TxPKFNsp7AiauxNGs8sdHa8AP9rac7/CI3bId/Y+BaxAuo8gxARl1yXGNFMsbLCEwnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uecYEUy0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uecYEUy0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27F8C4CEE4;
	Thu,  6 Mar 2025 03:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741233271;
	bh=ntfq6Td1/kGWHAd78NyKXXFA4bW8i3CIwCCJf6XQNqU=;
	h=Date:To:From:Subject:From;
	b=uecYEUy06cLSRR24qTqB3PjIUFqUKHs7ESrL3xh+dnnBo2QRRU+bqOUK2u8EYkJam
	 +bGgaMa5PSEOqaSp08FJVaWnraxZ2A9dFohyzl2xyc9PK5WVdDujebVrm6jpF1B4ns
	 15Lr09uhVMSJEwzPJef10XSzua73aqXRNErZG0AU=
Date: Wed, 05 Mar 2025 19:54:31 -0800
To: mm-commits@vger.kernel.org,peterx@redhat.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-fix-kernel-bug-when-userfaultfd_move-encounters-swapcache-fix.patch removed from -mm tree
Message-Id: <20250306035431.B27F8C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: minor cleanup according to Peter Xu
has been removed from the -mm tree.  Its filename was
     mm-fix-kernel-bug-when-userfaultfd_move-encounters-swapcache-fix.patch

This patch was dropped because it was folded into mm-fix-kernel-bug-when-userfaultfd_move-encounters-swapcache.patch

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: minor cleanup according to Peter Xu
Date: Wed, 26 Feb 2025 15:22:17 +1300

According to Peter Xu:
1. Unnecessary line move.
2. Can drop this folio check as it just did check
   "!IS_ERR_OR_NULL(folio)"
3. Not sure if it can do any harm, but maybe still nicer
   to put swap before locking folio.

Link: https://lkml.kernel.org/r/20250226024411.47092-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/userfaultfd.c~mm-fix-kernel-bug-when-userfaultfd_move-encounters-swapcache-fix
+++ a/mm/userfaultfd.c
@@ -1105,8 +1105,8 @@ static int move_swap_pte(struct mm_struc
 
 	orig_src_pte = ptep_get_and_clear(mm, src_addr, src_pte);
 	set_pte_at(mm, dst_addr, dst_pte, orig_src_pte);
-
 	double_pt_unlock(dst_ptl, src_ptl);
+
 	return 0;
 }
 
@@ -1373,7 +1373,7 @@ retry:
 			folio = filemap_get_folio(swap_address_space(entry),
 					swap_cache_index(entry));
 		if (!IS_ERR_OR_NULL(folio)) {
-			if (folio && folio_test_large(folio)) {
+			if (folio_test_large(folio)) {
 				err = -EBUSY;
 				folio_put(folio);
 				goto out;
@@ -1384,10 +1384,10 @@ retry:
 				pte_unmap(&orig_src_pte);
 				pte_unmap(&orig_dst_pte);
 				src_pte = dst_pte = NULL;
-				/* now we can block and wait */
-				folio_lock(src_folio);
 				put_swap_device(si);
 				si = NULL;
+				/* now we can block and wait */
+				folio_lock(src_folio);
 				goto retry;
 			}
 		}
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-fix-kernel-bug-when-userfaultfd_move-encounters-swapcache.patch
mm-set-folio-swapbacked-iff-folios-are-dirty-in-try_to_unmap_one.patch
mm-support-tlbbatch-flush-for-a-range-of-ptes.patch
mm-support-batched-unmap-for-lazyfree-large-folios-during-reclamation.patch
mm-avoid-splitting-pmd-for-lazyfree-pmd-mapped-thp-in-try_to_unmap.patch

