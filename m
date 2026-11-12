Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794450334;
	b=DgPIMXKD7DdIMzJ50/tTfkRU0v59CAmvu40/y27khpPgZBvRxEE0ovJLgdSqq8tZ7a6n
	 qx65O41l1nun+YOaM4UBe/rQaT4FGySFoX2U1c/b+Cy4xzjaeC4zWg4MVN9pJ7Euloftw
	 ZwU/bL1Wn20zh+n+hkEp69pIB9vji9tobReaI10fSyq/JLMgriIqgZIY+V8GsPO5cTBoT
	 KGKNf31kANS/rrCUnmPiyG5iIwpTLEcKwrele5QKxqfpAgRGS8R7lAJ6Dn3TkR+LiJVqk
	 z4Hmy07+0GMNcRGkgYls3eYKPLFn2tOxQ2lnqbN0eaiApmNjSnclpkNKF7KaDooxctg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794450334;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=4m4uhpMWv0+Mi7zl6gts2mt/A3IIwSoxuV63tdgX8bo=;
	b=ZRfPsqCZjret1ZCozlpDclWSslmfgdB+lN/SMPUP9Ue6/vv59HuJfrtk3EpTO/dK27Kx
	 72H9btXtjtA45OCrZjvXGYz1tHj68M/6Q8mzdvsObi3Njfpy22URo0ZOaINW+bLgvhlio
	 o5/bnl4HFruyb8yS4dWBfEJNxnpE2fBwzAVdgXVbXJWmhV87VkqUeOm2AI18YcEdsKM8N
	 ROTJOpw0ZJBckZcnnbCgJesikCEIR2n1j5gAvR7RTIN8sFZVuQHBF3LQel+Pa+fUULUun
	 7PbyfSTKMlnT/zZctGYQ5++c53iRyxXxpYFiuxssQxWW4AxixuSwvPCvFgTcnGLiqfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=p+v2aXIc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059AB606A31C;
	Thu, 12 Nov 2026 02:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=p+v2aXIc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA401F00A05;
	Thu, 12 Nov 2026 02:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794450333;
	bh=4m4uhpMWv0+Mi7zl6gts2mt/A3IIwSoxuV63tdgX8bo=;
	h=Date:To:From:Subject;
	b=p+v2aXIcSpul4jUPiqh53dWZP6E5J7Ov8HmEjS1k6WCG0LH6KaXtDHG/PC7Lnkk5Y
	 n3J+4rmxvZpaIyG/GtM8Wcins/2QwPRC0d14uRcmcSK5Sfv8BSlTlg1iZuRt0wRzyx
	 rRl7zXhA0cRBogGlN3QQtLvMGN5uUXkqhEap3JI8=
Date: Wed, 11 Nov 2026 18:25:32 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,
	roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,
	mason@kernel.org,hannes@cmpxchg.org,david@kernel.org,shakeel.butt@linux.dev,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-flush-nr_charged_bytes-when-the-obj-stock-trylock-fails.patch added to mm-hotfixes-unstable branch
Message-Id: <20261112022533.4FA401F00A05@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: memcg: flush nr_charged_bytes when the obj stock trylock fails
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     memcg-flush-nr_charged_bytes-when-the-obj-stock-trylock-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-flush-nr_charged_bytes-when-the-obj-stock-trylock-fails.patch

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
Subject: memcg: flush nr_charged_bytes when the obj stock trylock fails
Date: Wed, 11 Nov 2026 17:32:20 -0800

When interrupt code, such as an RCU callback in softirq, runs on top of a
task that holds the obj stock lock, its trylock fails and the bytes go to
objcg->nr_charged_bytes.  Nothing empties that counter while every CPU
using the objcg keeps it in its stock, so it can grow without limit.

Users see memory.current and the "kernel" field of memory.stat keep
growing while the cgroup's real usage does not.  With memory.high or
memory.max set, the cgroup is reclaimed, throttled or even OOM-killed for
memory it does not use.  The counter is 32-bit, so after 4 GiB it wraps,
and those 4 GiB stay charged to the cgroup and its ancestors until reboot,
even after the cgroup is removed.

Fix it by uncharging the whole pages in nr_charged_bytes whenever the
trylock fails.

Link: https://lore.kernel.org/20261112013220.4064478-1-shakeel.butt@linux.dev
Fixes: 200577f69f29 ("memcg: objcg stock trylock without irq disabling")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chris Mason <mason@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/memcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memcontrol.c~memcg-flush-nr_charged_bytes-when-the-obj-stock-trylock-fails
+++ a/mm/memcontrol.c
@@ -3532,6 +3532,8 @@ static void __refill_obj_stock(struct ob
 	int i, slot = -1, empty_slot = -1;
 
 	if (!stock) {
+		nr_bytes += atomic_read(&objcg->nr_charged_bytes)
+			? atomic_xchg(&objcg->nr_charged_bytes, 0) : 0;
 		nr_pages = nr_bytes >> PAGE_SHIFT;
 		nr_bytes = nr_bytes & (PAGE_SIZE - 1);
 		atomic_add(nr_bytes, &objcg->nr_charged_bytes);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

mm-mglru-splice-all-generations-when-reparenting-a-memcg.patch
memcg-flush-nr_charged_bytes-when-the-obj-stock-trylock-fails.patch
memcg-move-memoryhigh-enforcement-out-of-try_charge_memcg.patch
memcg-force-charges-from-reclaim-before-trying-the-limits.patch
memcg-use-high_work-for-kernel-threads.patch
memcg-use-high_work-for-remote-charges.patch
memcg-simplify-high-limit-handling-after-a-charge.patch

