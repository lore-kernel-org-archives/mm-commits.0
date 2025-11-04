Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4941FFC6D;
	Tue,  4 Nov 2025 02:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762224995; cv=none; b=Pm80zvpWoS36Hw4G9LR70FMkpHiVMxPstXvwYwEhN33mJeyWkp8jzC7IIFhKYaLv3XNeRQZiSULrFwLKDop+EVYo9xAPXdOdd2GFZTUw+rMJGyMWX7IRQ3iq+RgidOnx5anWol3tstVjgJpzz9e4uENjnsCPVL9lar9UK3CIIfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762224995; c=relaxed/simple;
	bh=4VqIHlFwqNUDSrq9/GBg8Qg5x+RYOaG8VD9lOz5AFYY=;
	h=Date:To:From:Subject:Message-Id; b=S2Gcgtyz7Udlk9HUkNgBrxMkPfXEWr0SQcQg6H2MNpeTDmHAeaKitLVNKzN/hBUsETKo3rUNAMY6vD8hECxJJa5QvFxAVuwNRk9L259weE0T8jQoWeeGXmJMENwHpucF6OfgGv4a9GkRPnRBUPBvhibRpllioPNL/e5eb/5RmXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KIKleBAn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KIKleBAn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37878C4CEE7;
	Tue,  4 Nov 2025 02:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762224995;
	bh=4VqIHlFwqNUDSrq9/GBg8Qg5x+RYOaG8VD9lOz5AFYY=;
	h=Date:To:From:Subject:From;
	b=KIKleBAncYLvyu3QszqwL4iefpBpiRMQTaDkAl0LKJPuz/UA4qCSemGV4tnVxQ85O
	 mWSoV9b2jHzS+yzEG2yv/33iHgYHsIoURAr8eU1gN7tLKtQ1+jVtAE3pV5m+qoifNH
	 dhwNreuyI8r+Q3mrjZadx1wyI11ux/pdpfSp37q4=
Date: Mon, 03 Nov 2025 18:56:34 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-remove-duplicate-nr_swap_pages-decrement-in-get_swap_page_of_type.patch added to mm-hotfixes-unstable branch
Message-Id: <20251104025635.37878C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: remove duplicate nr_swap_pages decrement in get_swap_page_of_type()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-swap-remove-duplicate-nr_swap_pages-decrement-in-get_swap_page_of_type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-remove-duplicate-nr_swap_pages-decrement-in-get_swap_page_of_type.patch

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
From: Youngjun Park <youngjun.park@lge.com>
Subject: mm: swap: remove duplicate nr_swap_pages decrement in get_swap_page_of_type()
Date: Sun, 2 Nov 2025 17:24:56 +0900

After commit 4f78252da887, nr_swap_pages is decremented in
swap_range_alloc(). Since cluster_alloc_swap_entry() calls
swap_range_alloc() internally, the decrement in get_swap_page_of_type()
causes double-decrementing.

Remove the duplicate decrement.

Link: https://lkml.kernel.org/r/20251102082456.79807-1-youngjun.park@lge.com
Fixes: 4f78252da887 ("mm: swap: move nr_swap_pages counter decrement from folio_alloc_swap() to swap_range_alloc()")
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Acked-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org> [6.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swap-remove-duplicate-nr_swap_pages-decrement-in-get_swap_page_of_type
+++ a/mm/swapfile.c
@@ -2005,10 +2005,8 @@ swp_entry_t get_swap_page_of_type(int ty
 			local_lock(&percpu_swap_cluster.lock);
 			offset = cluster_alloc_swap_entry(si, 0, 1);
 			local_unlock(&percpu_swap_cluster.lock);
-			if (offset) {
+			if (offset)
 				entry = swp_entry(si->type, offset);
-				atomic_long_dec(&nr_swap_pages);
-			}
 		}
 		put_swap_device(si);
 	}
_

Patches currently in -mm which might be from youngjun.park@lge.com are

mm-swap-remove-duplicate-nr_swap_pages-decrement-in-get_swap_page_of_type.patch
mm-swap-fix-memory-leak-in-setup_clusters-error-path.patch
mm-swap-use-swp_solidstate-to-determine-if-swap-is-rotational.patch
mm-swap-remove-redundant-comment-for-read_swap_cache_async.patch
mm-swap-change-swap_alloc_slow-to-void.patch
mm-swap-remove-scan_swap_map_slots-references-from-comments.patch

