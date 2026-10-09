Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0846E407CEF
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525474; cv=none; b=bGaxV3HLdR8NWTjeOUpjHr+W2pV7h0sNIREm5Mta+CHPpNBw9If4RFMUumHy2hn5XmY/TUE6voefJ6xO9AsZW61kF7OSXaJqyrPQ20rH9DUuWTMIItnavBDnHKBKiwS01Jjv0qldc9yaP3o7yn0Lq7U7CS222OnojDYcUDQ0K2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525474; c=relaxed/simple;
	bh=mpt5KWn+8CaHSOeq2CbuNDaumLNj3z5zOY2kccj0jsk=;
	h=Date:To:From:Subject:Message-Id; b=Re4o6Xb1jYgdSltK5Bjj6Ql5YMJn1fmuvhRThaJQUaZKYm/d7biLWCpC8lSc/3nnsI8cyoY7uy/gOrLg0kUGZX0o8/CDGS0mTAFlMIa/GV2smxSNhDG2eqvZqJZzKLrFS//lrz2DwMrASZUeqLdhz9zEZj0lk3iWf9ul32zBOXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=asRkzYZN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="asRkzYZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2FF11F00893;
	Fri,  9 Oct 2026 05:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525472;
	bh=SetZndSN1OL/lWGs3sVi3hzRPaMgogbqWrGfjirxY+c=;
	h=Date:To:From:Subject;
	b=asRkzYZNFifhdZI9ubQwJx+OURwu9OO0JxueZwYVUARKU4ASVboMRMWj1eC6qnxj6
	 BanDj9q64p4LNKXW7ldl1bHEs7NxZwaKDxotbaaAYyA0c60oEVUZ6KAlNQFjYXdE27
	 8N8W+foual6OTP2HoolIZ/EO1+1iFm6YIf0/L568=
Date: Thu, 08 Oct 2026 22:57:52 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,axelrasmussen@google.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-clear-the-reference-counter-for-rejected-folios.patch removed from -mm tree
Message-Id: <20261009055752.D2FF11F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mglru: clear the reference counter for rejected folios
has been removed from the -mm tree.  Its filename was
     mm-mglru-clear-the-reference-counter-for-rejected-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: mglru: clear the reference counter for rejected folios
Date: Mon, 14 Sep 2026 19:29:22 +0800

As per the comment on LRU_REFS_FLAGS, when accessed folios are promoted to
a new generation, LRU_REFS_FLAGS should be cleared so that the reference
counter can start over.

For folios rejected by shrink_folio_list(), we clear LRU_REFS_FLAGS and
set the PG_active flag when lru_gen_folio_seq() would place them in the
oldest generation.  That's fine.

But for rejected folios where lru_gen_folio_seq() returns a generation
other than the oldest one (which can be treated as a promotion), we do not
clear LRU_REFS_FLAGS.  This can violate the promotion mechanism.  And this
means the rejected folio enters the new generation with stale, inflated
tier bits, which can inflate reference counts and distort eviction
statistics for these rejected folios.

Fix this by clearing LRU_REFS_FLAGS for rejected folios.  Of course, I
need to evaluate the impact of the changes, which mainly falls into 3
cases: 1.  When lru_gen_folio_seq() returns the oldest generation for
rejected folios, there are no logic changes, and they will be put back
into the 2nd youngest generation.  2.  For rejected folios with PG_active
set by shrink_folio_list(), we only clear the LRU_REFS_FLAGS and do not
change the generation.  3.  For rejected folios with PG_referenced set,
the original code would put them back into the 2nd oldest generation. 
After this patch, we will put them back into the 2nd youngest generation.

I think case 3 is also reasonable, before commmit 6cbdd9726fb5 ("mm/mglru:
use folio_mark_accessed to replace folio_set_active"), a rejected
referenced folio was also put back to the 2nd youngest gen.  Meanwhile, I
didn't see any noticeable performance impact on my 32-core Arm machine
when running 'make -j32' to build the kernel inside a 3G-limited memcg
with either zram or NVMe swap.

Link: https://lore.kernel.org/7384df363c12e4acdaa2e0428420cd8eed320ee7.1789384831.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
---

 mm/vmscan.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/mm/vmscan.c~mm-mglru-clear-the-reference-counter-for-rejected-folios
+++ a/mm/vmscan.c
@@ -5075,11 +5075,15 @@ retry:
 			continue;
 		}
 
-		/* don't add rejected folios to the oldest generation */
-		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type]) {
-			folio_set_lru_refs(folio, 0);
+		/*
+		 * See the comments on LRU_REFS_FLAGS.
+		 *
+		 * The rejected folios are never added to the oldest generation,
+		 * so this effectively promotes them by at least one generation.
+		 */
+		folio_set_lru_refs(folio, 0);
+		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
 			folio_set_active(folio);
-		}
 	}
 
 	move_folios_to_lru(&list);
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


