Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CB738D;
	Mon, 24 Nov 2025 22:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764023161; cv=none; b=XkWaa+sLC+NoRbQDeN47kQ1D6dcE7BxO+aDs/1pYxSq3wfUh7l0nwWDYd+AsxQqVdhxGQ2L5d0Zc07lwMwBMrn+dAft/ekckeqZBSCBiNDlIGbDSGlyxRgn2iYzoTyFJWlMazbCReGDOiUK9hWz0RrghvXiFxSlBi7UBGKm1KFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764023161; c=relaxed/simple;
	bh=2/Ywoq6+Yj5XD3NyIeJyjZRTL/eCKZAFCoa9T4hrKO8=;
	h=Date:To:From:Subject:Message-Id; b=q1NcgkAdKSCzwwcxVMTBa9gr6NIsQ4+/83NsZMaxTDMzCGZf7BwxklZYgt646vk0oKwVHedt3bc6+1VvWK7x+S+ImywCuIJpeJnsmMYdK8IDdpslqXpTgfx2uRuqLPm7p9GffqHMOxFG4lBcRuDzePw37NadVz6tYOFB2h4BszQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WoxYGvxk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WoxYGvxk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3C7C4CEF1;
	Mon, 24 Nov 2025 22:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764023160;
	bh=2/Ywoq6+Yj5XD3NyIeJyjZRTL/eCKZAFCoa9T4hrKO8=;
	h=Date:To:From:Subject:From;
	b=WoxYGvxksjstBzZ9dbaH2vkvNibLllgmwE3g33u54ZfeXXOVcnyOYDuHAdCplU5eK
	 HP+bwoZiHV43c8Tsk5XrWo08V79K723nZ7tE0l2fJ6fM1NFKhWxwSVte6riIVL5IWJ
	 FgRPk9gtDqgMNGKVLX46zqjulpMr76d+mxXHvhAQ=
Date: Mon, 24 Nov 2025 14:25:59 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-swap-remove-duplicate-nr_swap_pages-decrement-in-get_swap_page_of_type.patch removed from -mm tree
Message-Id: <20251124222600.7E3C7C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: remove duplicate nr_swap_pages decrement in get_swap_page_of_type()
has been removed from the -mm tree.  Its filename was
     mm-swap-remove-duplicate-nr_swap_pages-decrement-in-get_swap_page_of_type.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Youngjun Park <youngjun.park@lge.com>
Subject: mm: swap: remove duplicate nr_swap_pages decrement in get_swap_page_of_type()
Date: Sun, 2 Nov 2025 17:24:56 +0900

After commit 4f78252da887, nr_swap_pages is decremented in
swap_range_alloc(). Since cluster_alloc_swap_entry() calls
swap_range_alloc() internally, the decrement in get_swap_page_of_type()
causes double-decrementing.

As a representative userspace-visible runtime example of the impact,
/proc/meminfo reports increasingly inaccurate SwapFree values.  The
discrepancy grows with each swap allocation, and during hibernation
when large amounts of memory are written to swap, the reported value
can deviate significantly from actual available swap space, misleading
users and monitoring tools.  

Remove the duplicate decrement.

Link: https://lkml.kernel.org/r/20251102082456.79807-1-youngjun.park@lge.com
Fixes: 4f78252da887 ("mm: swap: move nr_swap_pages counter decrement from folio_alloc_swap() to swap_range_alloc()")
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Acked-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
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

mm-swap-fix-wrong-plist-empty-check-in-swap_alloc_slow.patch
mm-swap-fix-memory-leak-in-setup_clusters-error-path.patch
mm-swap-use-swp_solidstate-to-determine-if-swap-is-rotational.patch
mm-swap-remove-redundant-comment-for-read_swap_cache_async.patch
mm-swap-change-swap_alloc_slow-to-void.patch
mm-swap-remove-scan_swap_map_slots-references-from-comments.patch

