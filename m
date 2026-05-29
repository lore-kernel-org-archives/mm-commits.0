Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7EA34BA20;
	Fri, 29 May 2026 03:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780026667; cv=none; b=B+iRpUBsiz6C3W5GP9DetZEyMcbxfs5m+vkXni2deMOJAkEsTgxo29sMemC8JKUsKB/7MkpCyIL5umD3wVza82qy8H5I+wwEKKwLdB9wRwh0ly5ryV4Uw5tBdJs9btQU2kVWqew3q6y0TqcK8riL0SNliXHdN+nh9pRoHZ04qJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780026667; c=relaxed/simple;
	bh=rzHbB8VqvFzhRzyjOjxtBT8g95/hY2Zk5I756/j20gE=;
	h=Date:To:From:Subject:Message-Id; b=EJh/g14oi5JCBwp4epktV/ZKvFopnv4Gq0NWNNXgLxM619HWXCMsv9iyaBGk2oFvqkTItFkpgYYAPGmGF08ItGR1/k4gbFEPoAz0wrCTGjjocFT07vHvpAAQ2VaGSTz31X/fe8X1wqqZJAMzE7mqsTbX9e6Pbsc633qHaZfAiho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zsWX29Ih; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zsWX29Ih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE8F1F000E9;
	Fri, 29 May 2026 03:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780026666;
	bh=bSKjpRtPhh6pk4lnXCQ7tP+u4oXGtpSUXZfgR/slSJY=;
	h=Date:To:From:Subject;
	b=zsWX29Ih/TnWwa8wr2zOCQT/tpULL5wcpAF82Cw4/4441KkNgs+k85yiDKe1BNh4d
	 oSF7RNkp5qgscb6/pdFsMmygVUAkx8maG4IOyu0LoU+fzwcTScCWOkaFP746NdmuyX
	 e9ZHNPfzEuJn1DQqdKWquX6AZAjRxGHvShROMU7c=
Date: Thu, 28 May 2026 20:51:05 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,harry@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] memcg-use-round-robin-victim-selection-in-refill_stock.patch removed from -mm tree
Message-Id: <20260529035106.1BE8F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: use round-robin victim selection in refill_stock
has been removed from the -mm tree.  Its filename was
     memcg-use-round-robin-victim-selection-in-refill_stock.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-use-round-robin-victim-selection-in-refill_stock
+++ a/mm/memcontrol.c
@@ -2011,6 +2011,7 @@ struct memcg_stock_pcp {
 
 	struct work_struct work;
 	unsigned long flags;
+	uint8_t drain_idx;
 };
 
 static DEFINE_PER_CPU_ALIGNED(struct memcg_stock_pcp, memcg_stock) = {
@@ -2194,7 +2195,9 @@ static void refill_stock(struct mem_cgro
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

memcg-store-node_id-instead-of-pglist_data-pointer.patch
memcg-uint16_t-for-nr_bytes-in-obj_stock_pcp.patch
memcg-int16_t-for-cached-slab-stats.patch
memcg-multi-objcg-charge-support.patch

