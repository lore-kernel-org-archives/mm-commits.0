Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4DA28DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489799; cv=none; b=OP/K1wyuoBUHydRA+XdKoPsH3UiBr1tH4WucbsalNR3DNl3HYpB9BKA5LVIguQrLf6nzufBjigTUwO7PDd45zwJ1/RgJK2MXGNDl+LIq3nth42ilGMq2om4Ok6as8Z+IYXkGF3IeSknykv5KetnTYBuVyDhRXx71UNbS2/K0NFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489799; c=relaxed/simple;
	bh=k1FY1W0nyb6HjZBiabrsTX5E5NXkxhvkEi1AZSUMpbA=;
	h=Date:To:From:Subject:Message-Id; b=GyFw0qpU1WVktfDWOWk+6m29FYYGsHDNa4PuV6jMkW/J7Mrye1sWV+59Ha8hK3jfVicpOqYT2S0Hs6+044IXbbzPG6C0n6djKQDGzwcTn8nUa9quL9wiTb5DNV3aETu7p3SqNpRiLNWWmTNo1EclzBbWhxLrQ4lccIT11K7jSVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t2MnajnQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t2MnajnQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E928C113D0;
	Sun, 21 Sep 2025 21:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489798;
	bh=k1FY1W0nyb6HjZBiabrsTX5E5NXkxhvkEi1AZSUMpbA=;
	h=Date:To:From:Subject:From;
	b=t2MnajnQJSnP3WXhevjCiVaN48+f6yJ2UP3yfSANfzR8WO6FjvxhsFOBkKvDh6jzo
	 x/wmqMFQIaXoCzhDUqh0mBrqD29ZcZ1+c5BS5KFE/BlIlLX8EO5dEtmXXgUMqOW5c3
	 76KYD950YjcoxZQgvIzaedeaIT2TJWJK4SY2+znE=
Date: Sun, 21 Sep 2025 14:23:17 -0700
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosry.ahmed@linux.dev,vitaly.wool@konsulko.se,sj@kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zpdesc-minor-naming-and-comment-corrections.patch removed from -mm tree
Message-Id: <20250921212318.5E928C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zpdesc: minor naming and comment corrections
has been removed from the -mm tree.  Its filename was
     mm-zpdesc-minor-naming-and-comment-corrections.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zpdesc: minor naming and comment corrections
Date: Fri, 29 Aug 2025 17:15:28 +0100

zpdesc is the page descriptor used by the zsmalloc backend allocator,
which in turn is used by zswap and zram.  The zpool layer is gone.

Link: https://lkml.kernel.org/r/20250829162212.208258-4-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zpdesc.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/zpdesc.h~mm-zpdesc-minor-naming-and-comment-corrections
+++ a/mm/zpdesc.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* zpdesc.h: zswap.zpool memory descriptor
+/* zpdesc.h: zsmalloc pool memory descriptor
  *
  * Written by Alex Shi <alexs@kernel.org>
  *	      Hyeonggon Yoo <42.hyeyoo@gmail.com>
@@ -11,14 +11,14 @@
 #include <linux/pagemap.h>
 
 /*
- * struct zpdesc -	Memory descriptor for zpool memory.
+ * struct zpdesc -	Memory descriptor for zsmalloc pool memory.
  * @flags:		Page flags, mostly unused by zsmalloc.
  * @lru:		Indirectly used by page migration.
  * @movable_ops:	Used by page migration.
- * @next:		Next zpdesc in a zspage in zsmalloc zpool.
- * @handle:		For huge zspage in zsmalloc zpool.
+ * @next:		Next zpdesc in a zspage in zsmalloc pool.
+ * @handle:		For huge zspage in zsmalloc pool.
  * @zspage:		Points to the zspage this zpdesc is a part of.
- * @first_obj_offset:	First object offset in zsmalloc zpool.
+ * @first_obj_offset:	First object offset in zsmalloc pool.
  * @_refcount:		The number of references to this zpdesc.
  *
  * This struct overlays struct page for now. Do not modify without a good
@@ -79,8 +79,8 @@ static_assert(sizeof(struct zpdesc) <= s
  * zpdesc_folio - The folio allocated for a zpdesc
  * @zp: The zpdesc.
  *
- * Zpdescs are descriptors for zpool memory. The zpool memory itself is
- * allocated as folios that contain the zpool objects, and zpdesc uses specific
+ * Zpdescs are descriptors for zsmalloc memory. The memory itself is allocated
+ * as folios that contain the zsmalloc objects, and zpdesc uses specific
  * fields in the first struct page of the folio - those fields are now accessed
  * by struct zpdesc.
  *
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page_alloc-avoid-kswapd-thrashing-due-to-numa-restrictions.patch

