Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F0367C4C
	for <mm-commits@vger.kernel.org>; Thu,  8 Feb 2024 05:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707369688; cv=none; b=V2yWFL+AEeVLSnwJXO59QeeoMcIhKgPG8NDpTbRvPTJ1P5Ey8q99+mA6I2fho29lap7XZgpCmu9kN/a8EVLj50fhzIGRyCxCv4Zili5gvoUBmKSB8QLwaS4p72DVoU09xotyNPJpPUfyaRnuPk3QMGnBRe8fTJ8JaTqasK+Sjv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707369688; c=relaxed/simple;
	bh=jIs4mPxzTjIB57k7IKLkIl0HOXUMxpHvmPLFlFQix5c=;
	h=Date:To:From:Subject:Message-Id; b=Dnw+/0FKDqsKKqb2NLRPdb1W7d8RqnV9ecH6UPG0iN52yFd6xsydrpJG0HS6H90CfolBvKaNJ8RXjGYxqdpVScB4NBckwP8WCNGkopRt110fCOmsWJQrCt6mQY3ml6Q7wxtqrmjIXM8cxsuapYXsiKx+15lAG+64mnSH+yUbHFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BCWJdjxR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BCWJdjxR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F15C43394;
	Thu,  8 Feb 2024 05:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707369687;
	bh=jIs4mPxzTjIB57k7IKLkIl0HOXUMxpHvmPLFlFQix5c=;
	h=Date:To:From:Subject:From;
	b=BCWJdjxRP9115q+W3PfKKUrm+ep1NYNXGi4mzw4L2e5gF52t7Dquu2QWvk5DiaKx+
	 FgoVLus8AmLlXkNHxtIiHkxy+uoJx6ToJtKd16B+XFs7K80c6kD4HGOgXDx3swcY2Z
	 0FswZ5dknVM7CcTTfQQiblWIZKrjvkEn03rKoGCc=
Date: Wed, 07 Feb 2024 21:21:27 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,chriscli@google.com,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-zswap-dont-return-lru_skip-if-we-have-dropped-lru-lock.patch removed from -mm tree
Message-Id: <20240208052127.96F15C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: don't return LRU_SKIP if we have dropped lru lock
has been removed from the -mm tree.  Its filename was
     mm-zswap-dont-return-lru_skip-if-we-have-dropped-lru-lock.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: mm/zswap: don't return LRU_SKIP if we have dropped lru lock
Date: Sun, 28 Jan 2024 13:28:49 +0000

LRU_SKIP can only be returned if we don't ever dropped lru lock, or we
need to return LRU_RETRY to restart from the head of lru list.

Otherwise, the iteration might continue from a cursor position that was
freed while the locks were dropped.

Actually we may need to introduce another LRU_STOP to really terminate the
ongoing shrinking scan process, when we encounter a warm page already in
the swap cache.  The current list_lru implementation doesn't have this
function to early break from __list_lru_walk_one.

Link: https://lkml.kernel.org/r/20240126-zswap-writeback-race-v2-1-b10479847099@bytedance.com
Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chris Li <chriscli@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/zswap.c~mm-zswap-dont-return-lru_skip-if-we-have-dropped-lru-lock
+++ a/mm/zswap.c
@@ -895,10 +895,8 @@ static enum lru_status shrink_memcg_cb(s
 		 * into the warmer region. We should terminate shrinking (if we're in the dynamic
 		 * shrinker context).
 		 */
-		if (writeback_result == -EEXIST && encountered_page_in_swapcache) {
-			ret = LRU_SKIP;
+		if (writeback_result == -EEXIST && encountered_page_in_swapcache)
 			*encountered_page_in_swapcache = true;
-		}
 
 		goto put_unlock;
 	}
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

mm-zswap-make-sure-each-swapfile-always-have-zswap-rb-tree.patch
mm-zswap-split-zswap-rb-tree.patch
mm-zswap-fix-race-between-lru-writeback-and-swapoff.patch
mm-list_lru-remove-list_lru_putback.patch
mm-zswap-add-more-comments-in-shrink_memcg_cb.patch
mm-zswap-invalidate-zswap-entry-when-swap-entry-free.patch
mm-zswap-stop-lru-list-shrinking-when-encounter-warm-region.patch
mm-zswap-remove-duplicate_entry-debug-value.patch
mm-zswap-only-support-zswap_exclusive_loads_enabled.patch
mm-zswap-zswap-entry-doesnt-need-refcount-anymore.patch

