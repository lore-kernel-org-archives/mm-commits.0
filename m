Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832548;
	b=aHk4PuM2D50u0ge3z4Q5NjO7uTUACoa16dF1dRpTs0qhbGWSG0ofPIKEtSvhC/M4Ef9H
	 rCsRL4hgPcMfwvn4+mtJ9ongBcAHVom/yDCobesq0m7SY1VZSIQxUYtKOv2HyBkKdaByK
	 gHyCgEjojQIoZtdA2mIF0ICG0A+QRkrgi+N1SJ6Rcwun3AnOinSvnvtTmbR7rt0lDxCD/
	 FGP/FcIyC/aaGg9h/VtgSd/FtHWpPArt4BIHbm9cKP4Ts9rF6fS/db9Rg21u2xD8/U5tJ
	 6l3RkvaO7AwdbFlETYXBJ7+yBm00QbxPjxB6KSeVuXXeWjw+qDdqUX6cTHZOnV/kIyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832548;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=gN9b7xkUfPpMiOsH5eB2g9TFXCpp2/w7OuDz8CZMAgg=;
	b=lvKd+0glmGnc42d0rZ+J8isZCADtI8eCli6bEs4s1HNvLHLyaUwWWJAl2QlcRvp+uJjj
	 1XLvEIKMEnEIWtpMg1wMn2UYiaHQHrBCiT50KITKh6WIJgeRjEMITpZvV3ZlrwrVzdjVe
	 qIW29GP8huQ8Wjnp69vSUgUjxWWVbyOBZP2xw36Yagr7BeWv0Nh3FFQL036VF6Qelt24S
	 lC8KKk0S5HPuW1dngOrm++s1t4xhNxywZOIr2rWXWrHXigpVOivWfBhHGZDS1T2xoHTj8
	 GyG8Y8x/xWoelZ4Cd5vq3F97RQmzldM9otUFkn9eUYjR2I53vIR/1BvkiKPSU8m0Ocw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="XYmcW1/g";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84324606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XYmcW1/g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE8B1F01828;
	Sat, 24 Oct 2026 09:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832548;
	bh=gN9b7xkUfPpMiOsH5eB2g9TFXCpp2/w7OuDz8CZMAgg=;
	h=Date:To:From:Subject;
	b=XYmcW1/geQRppm3npWtGKBUBxTOmH0bhjYBgyFNjq1lt7BqutuoiuWUN2oWaQgfxO
	 +8qrFJjDyqY84Kgrz2q6nv6DKT1zGJZjgjcij5CgNhMRSoKVYWvXWjazF5EzxQeYnw
	 xcsLlAoRwpBluDtHjQ8sjzO2RooKWjiEDuQ3pB2c=
Date: Sat, 24 Oct 2026 02:02:27 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,sashiko-bot@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,gourry@gourry.net,chris@chrisdown.name,anshuman.khandual@arm.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_counter-use-write_once-for-emin-elow-when-parent-is-the-root.patch removed from -mm tree
Message-Id: <20261024090228.4CE8B1F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/page_counter: use WRITE_ONCE() for emin/elow when parent is the root
has been removed from the -mm tree.  Its filename was
     mm-page_counter-use-write_once-for-emin-elow-when-parent-is-the-root.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: mm/page_counter: use WRITE_ONCE() for emin/elow when parent is the root
Date: Wed, 21 Oct 2026 13:48:18 -0700

page_counter_calculate_protection() runs without locks.  Several
reclaimers can update the same counter's emin and elow at the same time,
and readers such as mem_cgroup_below_min(), mem_cgroup_protection() and
the dmem eviction code load them with READ_ONCE().

Commit b3a7822e5e75 ("mm, memcg: prevent mem_cgroup_protected store
tearing") made the main path store emin and elow with WRITE_ONCE(), but it
missed the early return for a counter whose parent is the reclaim root. 
Those two stores are the only plain accesses to emin and elow left.

With CONFIG_KCSAN_STRICT=y, a few tasks writing to the same cgroup's
memory.reclaim trigger reports like this within seconds:

  BUG: KCSAN: data-race in page_counter_calculate_protection / shrink_node

  read (marked) to 0xff1f91b146d40e40 of 8 bytes by task 163 on cpu 4:
   shrink_node+0x57a/0x1210
   do_try_to_free_pages+0x194/0x930
   try_to_free_mem_cgroup_pages+0x204/0x3f0
   user_proactive_reclaim+0x28a/0x4d0
   memory_reclaim+0x35/0x50
   ...

  write to 0xff1f91b146d40e40 of 8 bytes by task 167 on cpu 6:
   page_counter_calculate_protection+0x1fa/0x360
   mem_cgroup_calculate_protection+0x4e/0x70
   shrink_node+0x53e/0x1210
   ...

The default KCSAN config does not report it, because it treats aligned
word-sized plain writes as atomic.

Use WRITE_ONCE() for these two stores as well.

There is no functional change.  Readers already accept stale values, and
compilers emit a single word-sized store either way: with GCC 14 the
x86-64 object code is the same before and after this change.

Link: https://lore.kernel.org/20261021204818.3431099-1-shakeel.butt@linux.dev
Fixes: b3a7822e5e75 ("mm, memcg: prevent mem_cgroup_protected store tearing")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: SJ Park <sj@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Chris Down <chris@chrisdown.name>
---

 mm/page_counter.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_counter.c~mm-page_counter-use-write_once-for-emin-elow-when-parent-is-the-root
+++ a/mm/page_counter.c
@@ -472,8 +472,8 @@ void page_counter_calculate_protection(s
 		return;
 
 	if (parent == root) {
-		counter->emin = READ_ONCE(counter->min);
-		counter->elow = READ_ONCE(counter->low);
+		WRITE_ONCE(counter->emin, READ_ONCE(counter->min));
+		WRITE_ONCE(counter->elow, READ_ONCE(counter->low));
 		return;
 	}
 
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


