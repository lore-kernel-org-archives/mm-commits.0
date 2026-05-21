Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056553AE1B1;
	Thu, 21 May 2026 23:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779407740; cv=none; b=qkBALQDl0VkZh66dfkJavZrSc1c2mXCSg3rn6ws/fr34HesWsvemXms8Pkk+LqKJXozvBu7qLpKk2/1CgKz94krm7fmpKKH3M1bZY4r8djn3cDYZdbBLfr4pXuB3QS09k2rN1Y2cPd7QdgXfI9VyEoHFZ7ItrANI+p8lF3Ehx/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779407740; c=relaxed/simple;
	bh=dhyUXiB2ZhDq63IpjY62aARgjqWSY8Me0llVup90P4s=;
	h=Date:To:From:Subject:Message-Id; b=F6ay0c8eU28ggRmmO8Xwche2jH+HPQrAYb7pUY+ch9ZL0dlN0c4fcvPj6Jhz0RSOsYSvxFM7UaEIlcL9rzQYkofFSeJIQ9xaC5ByJ1S2JmLWURNhTuo+KQFGbCPMzNuFIPOvPxmaihkSx0VlwPdCwod3sSq74yVTGvCcW+GErHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bxn9gjTR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bxn9gjTR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1909C1F000E9;
	Thu, 21 May 2026 23:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779407733;
	bh=u4oR8z/pfRd47RpMQjTQ/Koe578zCVBqyZlw8FktE/s=;
	h=Date:To:From:Subject;
	b=Bxn9gjTROjyW/KmbDUuF45JmuCw9GpgEvab5mHg6CO9BlMmfEochJ35Na2FItDoOf
	 kXUTOBRTGV4pKdcj965bmvT6hiJ/36H52HJhOoqLqs+Uh6ytLQhGNwjvpurlctW99v
	 L7rGhDm2rDK1ZQotS4J9F0HpZ4aYfjI/YhjWlfZA=
Date: Thu, 21 May 2026 16:55:32 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,harry@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-use-round-robin-victim-selection-in-refill_stock.patch added to mm-hotfixes-unstable branch
Message-Id: <20260521235533.1909C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: use round-robin victim selection in refill_stock
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     memcg-use-round-robin-victim-selection-in-refill_stock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-use-round-robin-victim-selection-in-refill_stock.patch

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
Subject: memcg: use round-robin victim selection in refill_stock
Date: Thu, 21 May 2026 15:37:51 -0700

Harry Yoo reported that get_random_u32_below() is not safe to call in the
nmi context and memcg charge draining can happen in nmi context.

More specifically get_random_u32_below() is neither reentrant- nor
NMI-safe: it acquires a per-cpu local_lock via local_lock_irqsave() on the
batched_entropy_u32 state.  An NMI that lands on a CPU mid-update of the
ChaCha batch state and recurses into the random subsystem would corrupt
that state.  The memcg_stock local_trylock prevents re-entry on the percpu
stock itself, but cannot protect an unrelated subsystem's per-cpu lock.

Replace the random pick with a per-cpu round-robin counter stored in
memcg_stock_pcp and serialized by the same local_trylock that already
guards cached[] and nr_pages[].  No atomics, no random calls, no extra
locks needed.

Link: https://lore.kernel.org/20260521223751.3794625-1-shakeel.butt@linux.dev
Fixes: f735eebe55f8f ("memcg: multi-memcg percpu charge cache")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: Harry Yoo <harry@kernel.org>
Closes: https://lore.kernel.org/4e20f643-6983-4b6e-b12d-c6c4eb20ae0c@kernel.org/
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-use-round-robin-victim-selection-in-refill_stock
+++ a/mm/memcontrol.c
@@ -2031,6 +2031,7 @@ struct memcg_stock_pcp {
 
 	struct work_struct work;
 	unsigned long flags;
+	uint8_t drain_idx;
 };
 
 static DEFINE_PER_CPU_ALIGNED(struct memcg_stock_pcp, memcg_stock) = {
@@ -2214,7 +2215,9 @@ static void refill_stock(struct mem_cgro
 	if (!success) {
 		i = empty_slot;
 		if (i == -1) {
-			i = get_random_u32_below(NR_MEMCG_STOCK);
+			i = stock->drain_idx++;
+			if (stock->drain_idx == NR_MEMCG_STOCK)
+				stock->drain_idx = 0;
 			drain_stock(stock, i);
 		}
 		css_get(&memcg->css);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-cache-obj_stock-by-memcg-not-by-objcg-pointer.patch
memcg-use-round-robin-victim-selection-in-refill_stock.patch

