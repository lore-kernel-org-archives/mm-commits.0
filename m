Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD37134A9
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 18:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720291581; cv=none; b=iBO0HODJx5zq/h3bxS2RHw3UrbeXfWgm6Jn/cDVHCE290HP9Tmp2XPNmSA0Dys/4QlR4i0Dk7kczhKp1uhKlRJHCv8+OAV1L4y/4hU1qPqqtV6wUZUZpgPCvJlt7Dzg7YUggDR98Hcr17wV2Jhzz2HAxxxabABcw7ebuLP9TYoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720291581; c=relaxed/simple;
	bh=WT8cQEJY2Jz7cy0lBfy1tpQHOfWAL/qqWWrW48lvsy4=;
	h=Date:To:From:Subject:Message-Id; b=uF44V22MEZcHuHvVd4IcoC/QlJ+PB2OjGC+W1ePuiiz3J1YaG44PL1NrpuwHHQqzAtdbzrJplXISKnh0Uus4EqkE+Wchj7Lg82+5nWukXfp3jYkl+5DunmDTa6ouXWPZtr9xTHJGHVX4/KUg2Pz5J8hqoe4wYrPGWQU4CsdroRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N3EBlE4F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N3EBlE4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAEB7C32781;
	Sat,  6 Jul 2024 18:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720291580;
	bh=WT8cQEJY2Jz7cy0lBfy1tpQHOfWAL/qqWWrW48lvsy4=;
	h=Date:To:From:Subject:From;
	b=N3EBlE4FnN53TxJektnrcPDrWdgNEZqNkVAephW3wyzdxT9l2bi/8l6UOrzTpoWUR
	 fwJ6dXZUFUZcafmwhR/lKz71v/CdCFPjgg7OMogJ7YndU5hBvEcb2vY23cRRVblI/+
	 Afp5h24IUI6Gnh5oGCeK6R40WYi97JrTdJtrePSs=
Date: Sat, 06 Jul 2024 11:46:20 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,shakeel.butt@linux.dev,nphamcs@gmail.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chengming.zhou@linux.dev,ak@linux.intel.com,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v7.patch removed from -mm tree
Message-Id: <20240706184620.DAEB7C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v7
has been removed from the -mm tree.  Its filename was
     mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v7.patch

This patch was dropped because it was folded into mm-store-zero-pages-to-be-swapped-out-in-a-bitmap.patch

------------------------------------------------------
From: Usama Arif <usamaarif642@gmail.com>
Subject: mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v7
Date: Thu, 27 Jun 2024 11:55:29 +0100

Change to kvmalloc_array for zeromap allocation instead of kvzalloc as it
does an additional overflow check, and use sizeof(unsigned long) for
allocation size calculation to take into account 32 bit kernels.

Link: https://lkml.kernel.org/r/20240627105730.3110705-2-usamaarif642@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v7
+++ a/mm/swapfile.c
@@ -3180,7 +3180,12 @@ SYSCALL_DEFINE2(swapon, const char __use
 		goto bad_swap_unlock_inode;
 	}
 
-	p->zeromap = kvzalloc(DIV_ROUND_UP(maxpages, 8), GFP_KERNEL);
+	/*
+	 * Use kvmalloc_array instead of bitmap_zalloc as the allocation order might
+	 * be above MAX_PAGE_ORDER incase of a large swap file.
+	 */
+	p->zeromap = kvmalloc_array(BITS_TO_LONGS(maxpages), sizeof(unsigned long),
+				    GFP_KERNEL | __GFP_ZERO);
 	if (!p->zeromap) {
 		error = -ENOMEM;
 		goto bad_swap_unlock_inode;
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

mm-store-zero-pages-to-be-swapped-out-in-a-bitmap.patch
mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v8.patch
mm-remove-code-to-handle-same-filled-pages.patch

