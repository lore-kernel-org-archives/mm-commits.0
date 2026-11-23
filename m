Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795415108;
	b=WKXOfb2WuKypWfQZCVS8m1DY910fO2J1jBXc5ZXCqHxVnGPIEONjj0saXH85FsRUGDaU
	 6lOsSBHzex7nMDTCyu3SCN5ubTVP4/t0LvGdjZ0SnMGITHkvYtooy2UGqyujlCSc0OmFd
	 9b14dlV7ulQdWcZ005ao/STQnfPjHvEgS0J4CId8JyDwGPCg60Mdt3qb20IlMbXa8tnkU
	 zDt5z+mQQ9OAJxM6q7kpcMvqM3fQmcI206p7OLzr6RAVDYQeq0EbXwFZC3NBIUfGxq4ov
	 z4eO0LQc2kKaswOvelIbNm1VOMz0ztP6jDZ5A50DFb5Zjg0K3BBbEp4rnd5UMKeDO9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795415108;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=blgTir2CiNn4nlbvKVYHU3o/G6+SBpSW3BgBXeHYpOA=;
	b=j5IEPVPTsjSWe1HEv0OZD+LnToBab0odlMtKJYu14ll0j5RFUW+Uh9qx6yn3d9n4AeWf
	 SY2Jq/lqoW/Nm81DFQYkwZ6w7HkVwd1RMJoSOMoxbNilIjj+LdBNDOYgQiSIGUhjvugjy
	 1AMqcLI3Gad6VoedezURTU621X4JEi7SN1jIbBdStYtIUIrMMAk2Tvfa9BMKY8xMXJN8U
	 U0LsbG0h5H51pBtCz23uxGKMDrj1lf1GPpoaKj8UDrAjGVaSTc6KXJ35Vi2Bpcm35wluk
	 pvt0+1DFRfkLWYetJmnvo0CqYH1LjDWq4Jn5JXmJrS3UcsHq3rRy0BTj8DPd/HRKXTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Jp+ZKhm0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA5B606A333;
	Mon, 23 Nov 2026 06:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Jp+ZKhm0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FCD1F000D2;
	Mon, 23 Nov 2026 06:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795415108;
	bh=blgTir2CiNn4nlbvKVYHU3o/G6+SBpSW3BgBXeHYpOA=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=Jp+ZKhm02iLxPrZvantG5h4H+aZB8BbTkkcVhW8r0mHb80MjpGgCGgzgiXea+P/vY
	 /aXjZhWtKCgnw+C3AKWCMx/9Pt7iie0m3E90HKqp/+JytNv/+nmkXJI8oUZ82oirML
	 CrzDvmuzpNJuKi5+Keih3Z0UI2wNIJ7Vg8+xG3GM=
Date: Sun, 22 Nov 2026 22:25:07 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,
	roman.gushchin@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,
	mhocko@kernel.org,mason@kernel.org,harry@kernel.org,hannes@cmpxchg.org,
	david@kernel.org,david@fromorbit.com,shakeel.butt@linux.dev,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261112061231.2469026-1-shakeel.butt@linux.dev>
References: <20261112061231.2469026-1-shakeel.butt@linux.dev>
Subject: [merged mm-hotfixes-stable] mm-list_lru-fix-null-deref-when-a-folio-moves-to-the-root-memcg.patch removed from -mm tree
Message-Id: <20261123062507.E5FCD1F000D2@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: list_lru: fix NULL deref when a folio moves to the root memcg
has been removed from the -mm tree.  Its filename was
     mm-list_lru-fix-null-deref-when-a-folio-moves-to-the-root-memcg.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://patch.msgid.link/20261112061231.2469026-1-shakeel.butt@linux.dev
Fixes: ae64f07a6a40 ("mm: list_lru: introduce folio_memcg_list_lru_alloc()")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chris Mason <mason@kernel.org>
Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: <stable@vger.kernel.org>

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

memcg-move-memoryhigh-enforcement-out-of-try_charge_memcg.patch
memcg-force-charges-from-reclaim-before-trying-the-limits.patch
memcg-use-high_work-for-kernel-threads.patch
memcg-use-high_work-for-remote-charges.patch
memcg-simplify-high-limit-handling-after-a-charge.patch

