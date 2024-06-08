Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A893E79FD
	for <mm-commits@vger.kernel.org>; Sat,  8 Jun 2024 02:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717813091; cv=none; b=qORFpyr4/5EB4QGfV4TBF8+LOALAnIyFf/KjVrwWpbthYS/vKOUZGqQcfFNkjn0hCigvO7qkw66xJGDrYNRLsWkNT/nUemL3nZFKTDST74n7ggBf7Z6bgh/qMeJOCp5a4+vhVVPEgmePXW+acx1lLolDzWLtg19LmE6oVnSB+7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717813091; c=relaxed/simple;
	bh=pMC4tG4r4box8Khfrz4TZ5Ck+Ye2wQ+oK66ne0kp+1o=;
	h=Date:To:From:Subject:Message-Id; b=rtAlrkwfqN+3KpRrIjhvT7kmw1oCssDlQDHNDnti3Ex2u95RIELR4zbxB+kGMMh72eT0qK03WZmd/4w6WyMn+y+HsCDGDnZbg3WgiikeeZsyYMQP3hLh1AhA2R1Hglh60fUUmQoVq5vJAQS/vGksK0tO5mebJD9TF8x4SaX2Xwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zHN8gbQ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zHN8gbQ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113D4C2BBFC;
	Sat,  8 Jun 2024 02:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717813091;
	bh=pMC4tG4r4box8Khfrz4TZ5Ck+Ye2wQ+oK66ne0kp+1o=;
	h=Date:To:From:Subject:From;
	b=zHN8gbQ7NRaCU2PFSsGkZNZQwMx+h6D32H6QIFNzGqqGuabfxKoQl/rPPLnHmIYxc
	 4xZMEpq8ufptwdmvq048F/uSSa7Kz/dFmMQIq+XDi8EufSHLVglCWE0J8FwmmW6uUc
	 2b3VCmUSobWPzIoOCUCzqU0esZSMOfnapHaV8jjA=
Date: Fri, 07 Jun 2024 19:18:10 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,hch@lst.de,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-remove-synchronous-argument-to-swap_read_folio.patch added to mm-unstable branch
Message-Id: <20240608021811.113D4C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: remove 'synchronous' argument to swap_read_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-remove-synchronous-argument-to-swap_read_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-remove-synchronous-argument-to-swap_read_folio.patch

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
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: swap: remove 'synchronous' argument to swap_read_folio()
Date: Fri, 7 Jun 2024 04:55:15 +0000

Commit [1] introduced IO polling support duding swapin to reduce swap read
latency for block devices that can be polled.  However later commit [2]
removed polling support.  Commit [3] removed the remnants of polling
support from read_swap_cache_async() and __read_swap_cache_async(). 
However, it left behind some remnants in swap_read_folio(), the
'synchronous' argument.

swap_read_folio() reads the folio synchronously if synchronous=true or if
SWP_SYNCHRONOUS_IO is set in swap_info_struct.  The only caller that
passes synchronous=true is in do_swap_page() in the SWP_SYNCHRONOUS_IO
case.

Hence, the argument is redundant, it is only set to true when the swap
read would have been synchronous anyway. Remove it.

[1] Commit 23955622ff8d ("swap: add block io poll in swapin path")
[2] Commit 9650b453a3d4 ("block: ignore RWF_HIPRI hint for sync dio")
[3] Commit b243dcbf2f13 ("swap: remove remnants of polling from read_swap_cache_async")

Link: https://lkml.kernel.org/r/20240607045515.1836558-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c     |    2 +-
 mm/page_io.c    |    6 +++---
 mm/swap.h       |    6 ++----
 mm/swap_state.c |   10 +++++-----
 4 files changed, 11 insertions(+), 13 deletions(-)

--- a/mm/memory.c~mm-swap-remove-synchronous-argument-to-swap_read_folio
+++ a/mm/memory.c
@@ -4113,7 +4113,7 @@ vm_fault_t do_swap_page(struct vm_fault
 
 				/* To provide entry to swap_read_folio() */
 				folio->swap = entry;
-				swap_read_folio(folio, true, NULL);
+				swap_read_folio(folio, NULL);
 				folio->private = NULL;
 			}
 		} else {
--- a/mm/page_io.c~mm-swap-remove-synchronous-argument-to-swap_read_folio
+++ a/mm/page_io.c
@@ -493,10 +493,10 @@ static void swap_read_folio_bdev_async(s
 	submit_bio(bio);
 }
 
-void swap_read_folio(struct folio *folio, bool synchronous,
-		struct swap_iocb **plug)
+void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
 {
 	struct swap_info_struct *sis = swp_swap_info(folio->swap);
+	bool synchronous = sis->flags & SWP_SYNCHRONOUS_IO;
 	bool workingset = folio_test_workingset(folio);
 	unsigned long pflags;
 	bool in_thrashing;
@@ -521,7 +521,7 @@ void swap_read_folio(struct folio *folio
 		folio_unlock(folio);
 	} else if (data_race(sis->flags & SWP_FS_OPS)) {
 		swap_read_folio_fs(folio, plug);
-	} else if (synchronous || (sis->flags & SWP_SYNCHRONOUS_IO)) {
+	} else if (synchronous) {
 		swap_read_folio_bdev_sync(folio, sis);
 	} else {
 		swap_read_folio_bdev_async(folio, sis);
--- a/mm/swap.h~mm-swap-remove-synchronous-argument-to-swap_read_folio
+++ a/mm/swap.h
@@ -11,8 +11,7 @@ struct mempolicy;
 /* linux/mm/page_io.c */
 int sio_pool_init(void);
 struct swap_iocb;
-void swap_read_folio(struct folio *folio, bool do_poll,
-		struct swap_iocb **plug);
+void swap_read_folio(struct folio *folio, struct swap_iocb **plug);
 void __swap_read_unplug(struct swap_iocb *plug);
 static inline void swap_read_unplug(struct swap_iocb *plug)
 {
@@ -83,8 +82,7 @@ static inline unsigned int folio_swap_fl
 }
 #else /* CONFIG_SWAP */
 struct swap_iocb;
-static inline void swap_read_folio(struct folio *folio, bool do_poll,
-		struct swap_iocb **plug)
+static inline void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
 {
 }
 static inline void swap_write_unplug(struct swap_iocb *sio)
--- a/mm/swap_state.c~mm-swap-remove-synchronous-argument-to-swap_read_folio
+++ a/mm/swap_state.c
@@ -567,7 +567,7 @@ struct folio *read_swap_cache_async(swp_
 	mpol_cond_put(mpol);
 
 	if (page_allocated)
-		swap_read_folio(folio, false, plug);
+		swap_read_folio(folio, plug);
 	return folio;
 }
 
@@ -684,7 +684,7 @@ struct folio *swap_cluster_readahead(swp
 		if (!folio)
 			continue;
 		if (page_allocated) {
-			swap_read_folio(folio, false, &splug);
+			swap_read_folio(folio, &splug);
 			if (offset != entry_offset) {
 				folio_set_readahead(folio);
 				count_vm_event(SWAP_RA);
@@ -701,7 +701,7 @@ skip:
 					&page_allocated, false);
 	if (unlikely(page_allocated)) {
 		zswap_folio_swapin(folio);
-		swap_read_folio(folio, false, NULL);
+		swap_read_folio(folio, NULL);
 	}
 	return folio;
 }
@@ -834,7 +834,7 @@ static struct folio *swap_vma_readahead(
 		if (!folio)
 			continue;
 		if (page_allocated) {
-			swap_read_folio(folio, false, &splug);
+			swap_read_folio(folio, &splug);
 			if (addr != vmf->address) {
 				folio_set_readahead(folio);
 				count_vm_event(SWAP_RA);
@@ -853,7 +853,7 @@ skip:
 					&page_allocated, false);
 	if (unlikely(page_allocated)) {
 		zswap_folio_swapin(folio);
-		swap_read_folio(folio, false, NULL);
+		swap_read_folio(folio, NULL);
 	}
 	return folio;
 }
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-zswap-use-sg_set_folio-in-zswap_compress-decompress.patch
mm-zswap-use-kmap_local_folio-in-zswap_load.patch
mm-zswap-make-same_filled-functions-folio-friendly.patch
mm-rmap-abstract-updating-per-node-and-per-memcg-stats.patch
mm-zsmalloc-share-slab-caches-for-all-zsmalloc-zpools.patch
mm-swap-remove-synchronous-argument-to-swap_read_folio.patch

