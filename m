Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF70B6F2F2
	for <mm-commits@vger.kernel.org>; Thu, 13 Mar 2025 20:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741898462; cv=none; b=MlpV62sXa2KwBZLuVkStWrGhXeSWhPOLG55P0tm7sTjla5j8zoDFQUIqj4PIt+UoV6LWwd69n/c9suQlU1hrEoRd3+w3KzfiDuE/04vPse4vKU/nrvSKEsKkbim3cSe9buI1Aj6EDwSRqFiZl/Z1kjIEUITfrHgc3O8eDNQB1Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741898462; c=relaxed/simple;
	bh=eKHxnp+Ne0ERS0eYGp9CQ7hRT5OhayPcr1jh/NVSSxc=;
	h=Date:To:From:Subject:Message-Id; b=gUD1Bpa52uIJYRNLSnzEbZq2CaIYjQfPoLb/KkvDzfoaP+6omCrDxUkZCUVJeN92igi1ei9LMkixWiG6NyISyPxomtGFsGuts8QXLwat9qNTt9DcDNq5rzvs4gnFYA86sn5uTuKjYWFmo96BAphKAYYys1K/XUOJxgwvhZD8x8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n/DC0ASZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n/DC0ASZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 687A7C4CEDD;
	Thu, 13 Mar 2025 20:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741898462;
	bh=eKHxnp+Ne0ERS0eYGp9CQ7hRT5OhayPcr1jh/NVSSxc=;
	h=Date:To:From:Subject:From;
	b=n/DC0ASZLNkZ403ypQT51A4M2eBPh53q4TQpU1EYT/a9Bc6iyWYqIJeOojI3ng8bz
	 EmuCpBzMJXjBB/IcoK+jrwVnaQw/QJQcI7vuj2+vxSHxesV73bkOpJAa84TP4Re5Pt
	 N4fs1HiElVDs9TE55y6f+RCMI7yZ40TEkdtcw5mA=
Date: Thu, 13 Mar 2025 13:41:01 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,willy@infradead.org,v-songbaohua@oppo.com,nphamcs@gmail.com,kaleshsingh@google.com,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-drop-the-flag-ttrs_direct.patch added to mm-unstable branch
Message-Id: <20250313204102.687A7C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: drop the flag TTRS_DIRECT
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-drop-the-flag-ttrs_direct.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-drop-the-flag-ttrs_direct.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: drop the flag TTRS_DIRECT
Date: Fri, 14 Mar 2025 00:59:30 +0800

This flag exists temporarily to allow the allocator to bypass the slot
cache during freeing, so reclaiming one slot will free the slot
immediately.

But now we have already removed slot cache usage on freeing, so this flag
has no effect now.

Link: https://lkml.kernel.org/r/20250313165935.63303-3-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

--- a/mm/swapfile.c~mm-swap-drop-the-flag-ttrs_direct
+++ a/mm/swapfile.c
@@ -158,8 +158,6 @@ static long swap_usage_in_pages(struct s
 #define TTRS_UNMAPPED		0x2
 /* Reclaim the swap entry if swap is getting full */
 #define TTRS_FULL		0x4
-/* Reclaim directly, bypass the slot cache and don't touch device lock */
-#define TTRS_DIRECT		0x8
 
 static bool swap_only_has_cache(struct swap_info_struct *si,
 			      unsigned long offset, int nr_pages)
@@ -257,23 +255,8 @@ again:
 	if (!need_reclaim)
 		goto out_unlock;
 
-	if (!(flags & TTRS_DIRECT)) {
-		/* Free through slot cache */
-		delete_from_swap_cache(folio);
-		folio_set_dirty(folio);
-		ret = nr_pages;
-		goto out_unlock;
-	}
-
-	xa_lock_irq(&address_space->i_pages);
-	__delete_from_swap_cache(folio, entry, NULL);
-	xa_unlock_irq(&address_space->i_pages);
-	folio_ref_sub(folio, nr_pages);
+	delete_from_swap_cache(folio);
 	folio_set_dirty(folio);
-
-	ci = lock_cluster(si, offset);
-	swap_entry_range_free(si, ci, entry, nr_pages);
-	unlock_cluster(ci);
 	ret = nr_pages;
 out_unlock:
 	folio_unlock(folio);
@@ -697,7 +680,7 @@ static bool cluster_reclaim_range(struct
 			offset++;
 			break;
 		case SWAP_HAS_CACHE:
-			nr_reclaim = __try_to_reclaim_swap(si, offset, TTRS_ANYWAY | TTRS_DIRECT);
+			nr_reclaim = __try_to_reclaim_swap(si, offset, TTRS_ANYWAY);
 			if (nr_reclaim > 0)
 				offset += nr_reclaim;
 			else
@@ -849,7 +832,7 @@ static void swap_reclaim_full_clusters(s
 			if (READ_ONCE(map[offset]) == SWAP_HAS_CACHE) {
 				spin_unlock(&ci->lock);
 				nr_reclaim = __try_to_reclaim_swap(si, offset,
-								   TTRS_ANYWAY | TTRS_DIRECT);
+								   TTRS_ANYWAY);
 				spin_lock(&ci->lock);
 				if (nr_reclaim) {
 					offset += abs(nr_reclaim);
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-avoid-reclaiming-irrelevant-swap-cache.patch
mm-swap-drop-the-flag-ttrs_direct.patch
mm-swap-avoid-redundant-swap-device-pinning.patch
mm-swap-dont-update-the-counter-up-front.patch
mm-swap-use-percpu-cluster-as-allocation-fast-path.patch
mm-swap-remove-swap-slot-cache.patch
mm-swap-simplify-folio-swap-allocation.patch

