Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961B62FB990
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025880; cv=none; b=mSCYS2lZsRbVIPu9TB50+GqXwLj2hICjhlXdOIhW6uictheDp97hbU4VBguKQuoeVdIKzbcYumBk80/vXPuoCVOSqvOtns798lbvbb/hJbvwlvMfJzzsQEir2Ov39/1SoJu7Ywik9wG4xsHtAqcnaK1/uaq4YqjrIpSIvP2QcN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025880; c=relaxed/simple;
	bh=2TKdfnSfH9E3qvy9uOLj5xhFAeeHscNtJ3Z7cgEphzc=;
	h=Date:To:From:Subject:Message-Id; b=JsRqRzb+jXOlNyvihT/cdr5G/gtyZe2F7vs/FGkoNYEi8JYt/3fM8pDTwrc3Gu+OX2x3kI192WzrZhnCV0Z/ZMio36SEeYkROfKydfxyY3Vf49YNyOPYGcM8fqffPAuqmopwRlTzZ3iZVUUjItLMhMYPExAHPxs1nLfszuIXbPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yejyg5yZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yejyg5yZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D363C4CEF1;
	Mon, 24 Nov 2025 23:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025880;
	bh=2TKdfnSfH9E3qvy9uOLj5xhFAeeHscNtJ3Z7cgEphzc=;
	h=Date:To:From:Subject:From;
	b=Yejyg5yZjENa1H0Yx+C67zwIGpcxIV2MBZoEYGnUWBia9z3wbEaYwg8brMxZ+DNBP
	 uqdg3d0LLpZ5txsx7zMwnXj0GqheKow27TCklcNVRYOseC9UzTiA+uEvur2sgMG4Vx
	 NKh/Q9Tg8+epAArF2y4n6wi593ZyyXmXD1/tMf/w=
Date: Mon, 24 Nov 2025 15:11:19 -0800
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-remove-redundant-comment-for-read_swap_cache_async.patch removed from -mm tree
Message-Id: <20251124231120.6D363C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: remove redundant comment for read_swap_cache_async
has been removed from the -mm tree.  Its filename was
     mm-swap-remove-redundant-comment-for-read_swap_cache_async.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Youngjun Park <youngjun.park@lge.com>
Subject: mm, swap: remove redundant comment for read_swap_cache_async
Date: Fri, 31 Oct 2025 15:50:09 +0900

The function now manages get/put_swap_device() internally, making the
comment explaining this behavior to callers unnecessary.

Link: https://lkml.kernel.org/r/20251031065011.40863-4-youngjun.park@lge.com
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/swap_state.c~mm-swap-remove-redundant-comment-for-read_swap_cache_async
+++ a/mm/swap_state.c
@@ -509,10 +509,6 @@ put_and_return:
  * and reading the disk if it is not already cached.
  * A failure return means that either the page allocation failed or that
  * the swap entry is no longer in use.
- *
- * get/put_swap_device() aren't needed to call this function, because
- * __read_swap_cache_async() call them and swap_read_folio() holds the
- * swap cache folio lock.
  */
 struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		struct vm_area_struct *vma, unsigned long addr,
_

Patches currently in -mm which might be from youngjun.park@lge.com are


