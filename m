Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794465715;
	b=WXIitbUXRDmPu6AB5hSA/Ey+oMiXcWglRdCwMIF3Wz+Q6/HV6AnVlrWNKFulk5tWfmlL
	 aeoEy6HbWiovh/NfRq0e1j72m9pEfg+pjl+NlVSCxPUBgatRv/QyF6duwW6tk18VCL+Xk
	 2uDXzxtKy3PJtU+pogTEzsSRhypmLW5NvFXoW16sycAQj3ggy604PLOQIjOYX/KECb3EO
	 EKuTvqv4DXFFpZpjg4aUhuZkENRbmJCWb11jWYTTcWlA7VeagAFdDkHWg8UUiJxHeiDh8
	 vXEq9RZAAPtC4TdtcBZ2Qy0GLD50HRNvoK9o8MaA2xr1shAz+xMXEdSbYTmmENEOLbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794465715;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=4FnRBTbB0AthbVHDCjLXKfCG8PI1JQBN1CMbbE4SFYI=;
	b=qcELYxQ9k1ohgK0B5ORtFrsO4RvQyJQhwPwwQo/cx+1r5Hdw/l9fBYwWcU/DSsITp2ce
	 a4Xl8zRtNVz6vpIe38mnyuQCv0sAtGySN6ltJbGfXPBUY6fzL3AlBIA5Iri/fc3lAcp1i
	 FNsA0+7ryz/FsJJjSyviGBj572f9OlyHA5TlbUbeykDwYMPtVQEQERDldWO1Xskqb1Y8P
	 Vi/JYh7M8QiI+ZNAIP2h7sOe3kVEzIUgkpokDoB+YIw5LlHnIyU6ST0ZIWlOCdvubDxaT
	 9oUdT2o2pE/TZN+Z1Hz1auntk2GjabYgpD1g0YSjVZBwUjis1dmPi2LZFbngL1yhnyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Pvl4mC0l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7356A606A31C;
	Thu, 12 Nov 2026 06:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Pvl4mC0l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077A51F00A05;
	Thu, 12 Nov 2026 06:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794465715;
	bh=4FnRBTbB0AthbVHDCjLXKfCG8PI1JQBN1CMbbE4SFYI=;
	h=Date:To:From:Subject;
	b=Pvl4mC0loe718faEKOs0sxJi8B+hTBCFdbi/rCj7ZMAn7GNASB7zm/L8716AF1Q+G
	 yD1+CIHs8MJbfLNcy4AGLwpJ4u5thB3MpSL+h0hkWZOI5ULdLCNHLas4QhZvBsFzsW
	 X7JDUBskAHdGo/fpeaprZUMmvBQGmB491hcPxCeI=
Date: Wed, 11 Nov 2026 22:41:54 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,
	roman.gushchin@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,
	mhocko@kernel.org,mason@kernel.org,hannes@cmpxchg.org,david@kernel.org,
	david@fromorbit.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-list_lru-fix-null-deref-when-a-folio-moves-to-the-root-memcg.patch added to mm-hotfixes-unstable branch
Message-Id: <20261112064155.077A51F00A05@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: list_lru: fix NULL deref when a folio moves to the root memcg
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-list_lru-fix-null-deref-when-a-folio-moves-to-the-root-memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-list_lru-fix-null-deref-when-a-folio-moves-to-the-root-memcg.patch

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: mm: list_lru: fix NULL deref when a folio moves to the root memcg
Date: Wed, 11 Nov 2026 22:12:31 -0800

folio_memcg_list_lru_alloc() makes sure that a folio's memcg has its own
lists in a list_lru, such as the THP deferred split queue.  It looks up
the folio's memcg twice: a fast path under RCU checks if the lists exist,
and a slow path takes a reference and allocates them.  The fast path
returns early for the root memcg, which uses the global lists.  The slow
path does not check for the root.

The memcg can change between the two lookups: when a cgroup is removed,
its folios are moved to the parent memcg.  If the folio is moved up to the
root in between, the slow path gets the root, and __memcg_list_lru_alloc()
dereferences the root's parent, which is NULL.

Users see a NULL pointer dereference oops while a THP is allocated, such
as in a page fault, in khugepaged or at swap-in.  tmpfs huge pages are
affected too, and for them the oops can also happen in reclaim, for
example in kswapd.  The task that hits the oops is killed, or the machine
panics if panic_on_oops is set.

The race is narrow: the folio has to be moved up to the root right between
the two lookups.  For example, its cgroup is directly below the root and
is removed, or has its memory controller disabled, at that moment.

Fix it by checking memcg_list_lru_allocated() again in the slow path, like
the fast path does.  It returns true for the root, which needs no lists of
its own.

Link: https://lore.kernel.org/20261112061231.2469026-1-shakeel.butt@linux.dev
Fixes: ae64f07a6a40 ("mm: list_lru: introduce folio_memcg_list_lru_alloc()")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chris Mason <mason@kernel.org>
Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: <stable@vger.kernel.org>
---

 mm/list_lru.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/mm/list_lru.c~mm-list_lru-fix-null-deref-when-a-folio-moves-to-the-root-memcg
+++ a/mm/list_lru.c
@@ -645,9 +645,16 @@ int folio_memcg_list_lru_alloc(struct fo
 	if (likely(res))
 		return 0;
 
-	/* Allocation may block, pin the memcg */
+	/*
+	 * Allocation may block, so pin the memcg. If the folio's cgroup
+	 * was removed after the check above, the folio has moved up to a
+	 * parent memcg. That memcg may already have its lists, or may be
+	 * the root, which uses the global lists and has no parent. So
+	 * check again before allocating.
+	 */
 	memcg = get_mem_cgroup_from_folio(folio);
-	res = __memcg_list_lru_alloc(memcg, lru, gfp);
+	if (!memcg_list_lru_allocated(memcg, lru))
+		res = __memcg_list_lru_alloc(memcg, lru, gfp);
 	mem_cgroup_put(memcg);
 	return res;
 }
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

mm-mglru-splice-all-generations-when-reparenting-a-memcg.patch
memcg-flush-nr_charged_bytes-when-the-obj-stock-trylock-fails.patch
mm-list_lru-fix-null-deref-when-a-folio-moves-to-the-root-memcg.patch
memcg-move-memoryhigh-enforcement-out-of-try_charge_memcg.patch
memcg-force-charges-from-reclaim-before-trying-the-limits.patch
memcg-use-high_work-for-kernel-threads.patch
memcg-use-high_work-for-remote-charges.patch
memcg-simplify-high-limit-handling-after-a-charge.patch

