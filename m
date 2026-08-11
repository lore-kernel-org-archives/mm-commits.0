Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E2A3A4F5B;
	Tue, 11 Aug 2026 18:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786474072; cv=none; b=nhNoXbxflZLiv0B1RaVHHq7oqoM6b4bUHJSkuHgPIxRaUY8tAsmhyhtnPszG6vKhYWuUP+7kpnbuMM1nE/BFdFBfWr6HoCJmyOkY9FbsImr/YfsBs7kQldHYE6qy6c4IM4HKqfdI6EhC2snJtTeb3wT0v66XT9SsvH5D59onA6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786474072; c=relaxed/simple;
	bh=+0CnjeQILP8XToCEaBM6mbLxbyGJHSdXLNVrYjAqFko=;
	h=Date:To:From:Subject:Message-Id; b=VP9vHm4G7aKHY83j5Wnr5w5b4Ot6SOPKtrOjFKrkzSrkofz1X3YQGOeutmyyTP0XiRmMCS//WiIdrOAUkSe+dUko9TPyQHt0r4YmH7vZ6/VmsOG0hjPhd8UPWZBSaE+9XPcWBd8Rcwq3Y1UJ8kHAzsQ/RzO09af5WmVzSP/Owho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iPY2eUTG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iPY2eUTG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA781F000E9;
	Tue, 11 Aug 2026 18:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786474070;
	bh=Rv8bhvJp4nyAkCPp0U3mhaFLBK2pN4mgurXSkg9+jRQ=;
	h=Date:To:From:Subject;
	b=iPY2eUTGxfRqeDC2mldWt01zD+VzjDFHDD4c+/QI5SAhTVjgTUuHTlmY67i3OpetT
	 83o/5twhSpahKMFKXq84dWKQJQTvZ/j4UJot7pb+A2Nx9jX3tEkBxA0X+RdbQK9SmS
	 wGk3o4giFmj2UUTIp8LfBPLTopgWmCOaXdzJnLg4=
Date: Tue, 11 Aug 2026 11:47:50 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-dont-free-a-hibernation-slot-that-is-in-the-swap-cache.patch added to mm-hotfixes-unstable branch
Message-Id: <20260811184750.9DA781F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: don't free a hibernation slot that is in the swap cache
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-swap-dont-free-a-hibernation-slot-that-is-in-the-swap-cache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-dont-free-a-hibernation-slot-that-is-in-the-swap-cache.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Youngjun Park <youngjun.park@lge.com>
Subject: mm, swap: don't free a hibernation slot that is in the swap cache
Date: Tue, 11 Aug 2026 22:22:06 +0900

A slot with a folio in the swap cache is freed when the folio leaves the
cache, not when its count drops.  swap_put_entries_cluster() follows that
rule.  swap_free_hibernation_slot() does not, it calls
__swap_cluster_free_entries() whether or not a folio sits on the slot.

Cluster readahead can put one there.  It walks a raw page_cluster sized
window of offsets around the faulting entry, and a hibernation slot passes
__swap_cache_add_check() because it is not a folio and its count is not
zero.  Freeing the slot then clears the entry under that folio.

The folio is now unreachable from the swap table, and the offset goes back
to the allocator.  The folio is still on the LRU though, so reclaim can
pick it up later.  It then takes the old offset out of folio->swap and
overwrites the table entry there, which by then may belong to someone
else.

This bug can trigger silent memory corruption, process crashes, or data
instability across completely unrelated userspace applications - typically
occurring after a system resumes from hibernation (suspend-to-disk).

Check for a cached folio before freeing.  The slot is then left in the
ordinary state where only the swap cache holds it, and it is freed when
the folio leaves the cache, either through the reclaim below or through
normal reclaim later.

Link: https://lore.kernel.org/20260811132209.2862708-2-youngjun.park@lge.com
Fixes: 0d6af9bcf383 ("mm, swap: use the swap table to track the swap count")
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Acked-by: Kairui Song <kasong@tencent.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-dont-free-a-hibernation-slot-that-is-in-the-swap-cache
+++ a/mm/swapfile.c
@@ -2196,7 +2196,14 @@ void swap_free_hibernation_slot(swp_entr
 
 	ci = swap_cluster_lock(si, offset);
 	__swap_cluster_put_entry(ci, offset % SWAPFILE_CLUSTER);
-	__swap_cluster_free_entries(si, ci, offset % SWAPFILE_CLUSTER, 1);
+	/*
+	 * A slot with a folio in the swap cache is freed when the folio
+	 * leaves the cache, the same rule swap_put_entries_cluster() follows.
+	 * Readahead can put a folio here, and freeing the slot now would
+	 * leave that folio with no entry behind it.
+	 */
+	if (!swp_tb_is_folio(__swap_table_get(ci, offset % SWAPFILE_CLUSTER)))
+		__swap_cluster_free_entries(si, ci, offset % SWAPFILE_CLUSTER, 1);
 	swap_cluster_unlock(ci);
 
 	/* In theory readahead might add it to the swap cache by accident */
_

Patches currently in -mm which might be from youngjun.park@lge.com are

mm-swap-dont-free-a-hibernation-slot-that-is-in-the-swap-cache.patch

