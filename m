Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA593818
	for <mm-commits@vger.kernel.org>; Tue,  6 Feb 2024 00:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707178524; cv=none; b=JHJ3lSmYDMTSW6QglXa6nsDVWwqy+/SqBTmK58qiiq2AffyqRh7ZVtSc0OwGrMbPVug6Jj65zwUgxz96EiCKHF+Z1AH/ulsClx9YwvFCGyUNC98lDNrIJEukB2LQU08WUI/15RTMEnzjDR0oDtgffPOFyY0dZWzW5403Xd5N0xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707178524; c=relaxed/simple;
	bh=Sh7MEuavkxuVVvlOHUWMdCUluvfvetyha7RBK3A+eIo=;
	h=Date:To:From:Subject:Message-Id; b=C0r5meM5WHDTtx4EsG6k3GwGnu9dX8y9GedX5gGRj1X6W6QVGU6TGMa+GvDdlqZ6gN0pBFPtlQ7TAHRauHkUKCpemSsTPKEv9EIR4qz8pbgEsHt8PNTCFUHJOT8qIZmooj1PKpA4bJBFTu+HbXacWzKOW1qFK5PiQaeQ9FFX8sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NQ/RCKKX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NQ/RCKKX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB52C433C7;
	Tue,  6 Feb 2024 00:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707178524;
	bh=Sh7MEuavkxuVVvlOHUWMdCUluvfvetyha7RBK3A+eIo=;
	h=Date:To:From:Subject:From;
	b=NQ/RCKKX5V+8kUH7vtymZK1cb2FICWxdWGy3fHuag60bZQDohvU3Qt6D4TG3tNxq1
	 lXxUFKsQ8jnJ2S6vCYl6vnHl2vgoEXF/JsK6PxhAB+dfbyEuisHzMH8ULLASbqisjZ
	 1oQZ5rJI9SOt7efHf6JoMAPSVkuT1ICCK+QD6s/w=
Date: Mon, 05 Feb 2024 16:15:23 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-stop-lru-list-shrinking-when-encounter-warm-region.patch added to mm-unstable branch
Message-Id: <20240206001524.5AB52C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: stop lru list shrinking when encounter warm region
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-stop-lru-list-shrinking-when-encounter-warm-region.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-stop-lru-list-shrinking-when-encounter-warm-region.patch

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
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: mm/zswap: stop lru list shrinking when encounter warm region
Date: Sun, 04 Feb 2024 03:06:01 +0000

When the shrinker encounter an existing folio in swap cache, it means we
are shrinking into the warmer region.  We should terminate shrinking if
we're in the dynamic shrinker context.

This patch add LRU_STOP to support this, to avoid overshrinking.

Link: https://lkml.kernel.org/r/20240201-b4-zswap-invalidate-entry-v2-3-99d4084260a0@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_lru.h |    2 ++
 mm/list_lru.c            |    3 +++
 mm/zswap.c               |    4 +++-
 3 files changed, 8 insertions(+), 1 deletion(-)

--- a/include/linux/list_lru.h~mm-zswap-stop-lru-list-shrinking-when-encounter-warm-region
+++ a/include/linux/list_lru.h
@@ -24,6 +24,8 @@ enum lru_status {
 	LRU_SKIP,		/* item cannot be locked, skip */
 	LRU_RETRY,		/* item not freeable. May drop the lock
 				   internally, but has to return locked. */
+	LRU_STOP,		/* stop lru list walking. May drop the lock
+				   internally, but has to return locked. */
 };
 
 struct list_lru_one {
--- a/mm/list_lru.c~mm-zswap-stop-lru-list-shrinking-when-encounter-warm-region
+++ a/mm/list_lru.c
@@ -243,6 +243,9 @@ restart:
 			 */
 			assert_spin_locked(&nlru->lock);
 			goto restart;
+		case LRU_STOP:
+			assert_spin_locked(&nlru->lock);
+			goto out;
 		default:
 			BUG();
 		}
--- a/mm/zswap.c~mm-zswap-stop-lru-list-shrinking-when-encounter-warm-region
+++ a/mm/zswap.c
@@ -1315,8 +1315,10 @@ static enum lru_status shrink_memcg_cb(s
 		 * into the warmer region. We should terminate shrinking (if we're in the dynamic
 		 * shrinker context).
 		 */
-		if (writeback_result == -EEXIST && encountered_page_in_swapcache)
+		if (writeback_result == -EEXIST && encountered_page_in_swapcache) {
+			ret = LRU_STOP;
 			*encountered_page_in_swapcache = true;
+		}
 	} else {
 		zswap_written_back_pages++;
 	}
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

mm-zswap-dont-return-lru_skip-if-we-have-dropped-lru-lock.patch
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

