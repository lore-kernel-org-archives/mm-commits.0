Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793312085;
	b=dC44kWE/Nk3DI6Z/xikpeg+JMsGBgAmXPDfbE4Qq+sd3tWg+XGGZbEdbZeuwWwiP1StE
	 evU0xZTMTaOkaz/Qs3EH2uT7g8zoelniXodjvnv0TJbq8u1ZWJv/j2YCvkpggvWfD/Vdt
	 JqxfZZJ60MtMcMF/bQrd852RXCmlhfoj3/EP3GG/OSdii+yUpaXU6XWfW6tui2zbm1XwF
	 /uSeyqbc/szjdcE8v5cdxXjorn6NTX58ATMUbXN/UYvTHiLRiDmRBa1GQGeXAl8az2UCP
	 AWGen9ZaLT14XmtSMMnfhxSrIOpldLKwpxnZD9WJgs0grG7LsgXbsWyUyOYEZrLFM0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793312085;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=jgsNiyGVA6BKWsOLraiGovXKLDg2PCXLMv7OZVWZLc0=;
	b=U6lbXiziCOP0r89lbPtnSzXKEhugk1+hW7TrdjukqHkT3KOfRQCyQOW7PJRRNH53qhKK
	 abJ8R0JOvtBpmnHQOQqo0nQ5DggQG4fOlWxyRS7qrgiqIJy+vTSOit5HkF0Cf4teL7RBN
	 IFOVavSUAzhgXONAYm5H5mj6ddOc6VlDuD87RHo0iT/M9VkdfRbcIfqH/S5abXyb2JJcL
	 R0qQKiCj+F1QFyl/v996ICkdXlyrCfc7KdEG6V9xMKKKRklJ+xCm+UojkE9e9okevqYLY
	 n3uSzGo/k9+6U6rKNqxug8Fcv0JR8eOLjwmKAFKdvd979+OW3MaUAm+hl/Do4u1VF4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="rXtb/UjH";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7EA606A31A
	for <mm-commits@vger.kernel.org>; Thu, 29 Oct 2026 22:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rXtb/UjH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6241F01816;
	Thu, 29 Oct 2026 22:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793312084;
	bh=jgsNiyGVA6BKWsOLraiGovXKLDg2PCXLMv7OZVWZLc0=;
	h=Date:To:From:Subject;
	b=rXtb/UjHoVwI2POXqU0a/lXHAmPa1hHyFSdlObhTOQpYX1fTTiyH84c+EF7+H0sUH
	 cJ99hYI/aDN4fSa6A4VWhe6AwRckRnSN9Si1FPEF1po7IVp55QCZJrSmSDl/fNf7A3
	 6wxKoMfA2yMjr9Gf6EZBOvUG9vuE+BC21VEGK/eg=
Date: Thu, 29 Oct 2026 15:14:43 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,
	hannes@cmpxchg.org,kuniyu@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-remove-unnecessary-read_once-under-memcg_stocklock.patch added to mm-new branch
Message-Id: <20261029221444.5C6241F01816@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: memcg: remove unnecessary READ_ONCE() under memcg_stock.lock.
has been added to the -mm mm-new branch.  Its filename is
     memcg-remove-unnecessary-read_once-under-memcg_stocklock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-remove-unnecessary-read_once-under-memcg_stocklock.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Kuniyuki Iwashima <kuniyu@google.com>
Subject: memcg: remove unnecessary READ_ONCE() under memcg_stock.lock.
Date: Thu, 29 Oct 2026 19:44:12 +0000

Patch series "memcg: Misc cleanup and perf improvement for TCP.", v3.

On host w/ AMD EPYC 9B45 128-Core Processor (Zen 5 Turin,
2 sockets, 512 vCPUs), tcp_rr w/ 20000 flows throughput often
degrades by ~50%, 32M -> 17M~27M.

In the bad case, the number of involuntary context switches
was extremely high by 12x (241733 -> 3093367).

The root cause was that refill_stock() calls memcg_uncharge()
or drain_stock() while holding memcg_stock.lock.

Patch 1~3 are misc cleanup for better asm output and patch 4
moves heavy operations to out of local_lock(&memcg_stock.lock).

This series removes the flakiness and gives ~3% gain on the
512 vCPU platform.

In addition, on machine w/ AMD EPYC 7B12 64-Core Processor
(Zen 2 Rome, 2 sockets, 256 vCPU), tcp_rr w/ 10000 flows achieves
36% more throughput with lower latency.

  tcp_rr (10000 flows, 128 threads, 60s, average of 3 runs):

  Metric                     |       Baseline |    Patched |    Diff
  ---------------------------+----------------+------------+--------


This patch (of 4):

this_cpu_ptr(&memcg_stock)->{cached[],nr_pages[]} are always
modified under local_lock(&memcg_stock.lock).

Unlike is_memcg_drain_needed() under RCU, consume_stock(),
drain_stock(), and refill_stock() do not need READ_ONCE().

Especially, in refill_stock(), READ_ONCE() is used twice for
stock->cached[i], which forces the compiler to emit two volatile
loads from stock->cached[i].

Let's remove the unnecessary READ_ONCE() and eliminate the
redundant loads in refill_stock():

Before:

  cached = READ_ONCE(stock->cached[i]);
   4c 8b 80 88 d7 bd 84 	movq	-0x7b422878(%rax), %r8
  if (memcg == READ_ONCE(stock->cached[i])) {
   48 3b 98 88 d7 bd 84 	cmpq	-0x7b422878(%rax), %rbx
   0f 84 86 01 00 00    	je	0xffffffff817d01e0 <refill_stock+0x210>

After:

  cached = stock->cached[i];
   4c 8b 88 88 d7 bd 84 	movq	-0x7b422878(%rax), %r9
  if (memcg == stock->cached[i]) {
   4c 39 cb             	cmpq	%r9, %rbx
   0f 84 7a 01 00 00    	je	0xffffffff817d01d0 <refill_stock+0x200>

Link: https://lore.kernel.org/20261029194452.3189365-1-kuniyu@google.com
Link: https://lore.kernel.org/20261029194452.3189365-2-kuniyu@google.com
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
---

 mm/memcontrol.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/memcontrol.c~memcg-remove-unnecessary-read_once-under-memcg_stocklock
+++ a/mm/memcontrol.c
@@ -2164,10 +2164,10 @@ static bool consume_stock(struct mem_cgr
 	stock = this_cpu_ptr(&memcg_stock);
 
 	for (i = 0; i < NR_MEMCG_STOCK; ++i) {
-		if (memcg != READ_ONCE(stock->cached[i]))
+		if (memcg != stock->cached[i])
 			continue;
 
-		stock_pages = READ_ONCE(stock->nr_pages[i]);
+		stock_pages = stock->nr_pages[i];
 		if (stock_pages >= nr_pages) {
 			stock_pages -= nr_pages;
 			WRITE_ONCE(stock->nr_pages[i], stock_pages);
@@ -2197,13 +2197,13 @@ static void memcg_uncharge(struct mem_cg
  */
 static void drain_stock(struct memcg_stock_pcp *stock, int i)
 {
-	struct mem_cgroup *old = READ_ONCE(stock->cached[i]);
+	struct mem_cgroup *old = stock->cached[i];
 	uint8_t stock_pages;
 
 	if (!old)
 		return;
 
-	stock_pages = READ_ONCE(stock->nr_pages[i]);
+	stock_pages = stock->nr_pages[i];
 	if (stock_pages) {
 		memcg_uncharge(old, stock_pages);
 		WRITE_ONCE(stock->nr_pages[i], 0);
@@ -2284,11 +2284,11 @@ static void refill_stock(struct mem_cgro
 
 	stock = this_cpu_ptr(&memcg_stock);
 	for (i = 0; i < NR_MEMCG_STOCK; ++i) {
-		cached = READ_ONCE(stock->cached[i]);
+		cached = stock->cached[i];
 		if (!cached && empty_slot == -1)
 			empty_slot = i;
-		if (memcg == READ_ONCE(stock->cached[i])) {
-			stock_pages = READ_ONCE(stock->nr_pages[i]) + nr_pages;
+		if (memcg == stock->cached[i]) {
+			stock_pages = stock->nr_pages[i] + nr_pages;
 			if (stock_pages > MEMCG_STOCK_HIGH) {
 				memcg_uncharge(memcg,
 					       stock_pages - MEMCG_STOCK_LOW);
_

Patches currently in -mm which might be from kuniyu@google.com are

mm-kasan-detect-double-free-involving-kfree_rcu_sheaf.patch
mm-kasan-kunit-add-double-free-tests-involving-kfree_rcu_sheaf.patch
memcg-remove-unnecessary-read_once-under-memcg_stocklock.patch
memcg-reduce-nesting-in-consume_stock-and-refill_stock.patch
memcg-annotate-slow-paths-in-consume_stock-and-refill_stock.patch
memcg-uncharge-pages-outside-memcg_stocklock-in-refill_stock.patch

