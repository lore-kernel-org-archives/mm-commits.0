Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793312090;
	b=gD8fwuGYODVpCJPCoxVao57hae+kjd7dzokbCTE7MBGImT+Y81Af+M2QToVFy7N08dhu
	 RAUQLzoX0TJeynNHdEGhZu9Cdm7l2Fmj4DAC6kt2ofk3IhN521gavCb2HmSEmvCZsPZb+
	 2vamEji1YgB+mhRpFzyIBlXiSjSEpShhFNkHHcZUUZuRYsclPDZxbz0EGfr/NDcAQjVty
	 PgPM0gamvZZy6gLWyNn/tINYHu8u50AmXiW1KGkm1N6Oc9c6MZatBv7StLcrxkLDpiTL7
	 hg8ZLi6uYvnbV2zQmlFvimD93atSXXvESgGBIgCFv5CB4LYh+fediyUrzu2SmKI4hqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793312090;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=51rOoRagaUHatRQLhDzPG14lzMw/I17z9A138cqarJI=;
	b=05YHWua0KDP5r1zPGEdY3sRQmTeeZTmIDN2cOF774O9wLd5Ja6yen7+wBgbP1JHIb+Cq
	 oN8P6vtqGkA2aMTQCSuKmEjXx5lipOY04AH8wRyieWRANUUZkJv3Vskb6vDKRURdCeVZF
	 BVziggcm9lLKNR5aQtMKJIZUjxpVs387HIhrYMZm2feBnr21zTfKM/oFa7qEvkVfz/F3q
	 AMzzFGXHMMOR+YDjAOODjmJmT6ocMh+95fEfdtYfG2mMRiUBXhlUs4MW9KYlTi7vPv5VW
	 JVHTc67b2TMalC73WRXCSiBOlpWrAn1y8Lqzux+YtxoT0EW331tLR98NvHCYOJqzn5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=17hriA5H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C987606A31A
	for <mm-commits@vger.kernel.org>; Thu, 29 Oct 2026 22:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=17hriA5H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A61C1F01816;
	Thu, 29 Oct 2026 22:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793312090;
	bh=51rOoRagaUHatRQLhDzPG14lzMw/I17z9A138cqarJI=;
	h=Date:To:From:Subject;
	b=17hriA5Hkiq6jycM3GztQ2SbJsn476eE1z78EuN5LxfjQbbOx8/B9aTuhMISJjnAV
	 0aeiGJAX7sBJzxHIt9eJHV8bGxfAkIPizzACUV/QGZ2lZLcAsDuFwac0PSMMe29kWU
	 Zmq8dk79Vn8vVoeVPVqsLvTelrnGkfUaaI6j88Ss=
Date: Thu, 29 Oct 2026 15:14:49 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,
	hannes@cmpxchg.org,kuniyu@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-uncharge-pages-outside-memcg_stocklock-in-refill_stock.patch added to mm-new branch
Message-Id: <20261029221450.1A61C1F01816@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: memcg: uncharge pages outside memcg_stock.lock in refill_stock().
has been added to the -mm mm-new branch.  Its filename is
     memcg-uncharge-pages-outside-memcg_stocklock-in-refill_stock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-uncharge-pages-outside-memcg_stocklock-in-refill_stock.patch

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
Subject: memcg: uncharge pages outside memcg_stock.lock in refill_stock().
Date: Thu, 29 Oct 2026 19:44:15 +0000

On host w/ AMD EPYC 9B45 128-Core Processor (Zen 5 Turin,
2 sockets, 512 vCPUs), tcp_rr w/ 20000 flows throughput often
degrades by ~50%, 32M -> 17M~27M.

In the bad case, the number of involuntary context switches
was extremely high by 12x (241733 -> 3093367).

In perf record, 96% samples had the same pattern, where the
thread was interrupted during page_counter_uncharge() by softirq,
and later ksoftirqd was woken up:

  # perf record -C 0-15 -e sched:sched_wakeup -g \
      -o /tmp/sched_wakeup.data -- sleep 1
  # perf report -i /tmp/sched_wakeup.data --stdio --no-children
    96.36%  tcp_rr   [kernel.kallsyms]  [k] wake_up_process
            |
            ---wake_up_process
               |
                --96.00%--irq_exit_rcu
                          |
                           --95.82%--sysvec_call_function_single
                                     asm_sysvec_call_function_single
                                     |
                                      --95.58%--page_counter_uncharge
                                                mem_cgroup_sk_uncharge
                                                sock_rfree
                                                tcp_recvmsg
                                                __x64_sys_recvfrom
                                                do_syscall_64
                                                entry_SYSCALL_64_after_hwframe

  # perf script -i /tmp/sched_wakeup.data | grep -A 20 "comm=ksoftirqd"
  tcp_rr  101952 [001]  9679.340985: sched:sched_wakeup: comm=ksoftirqd/1 pid=23 prio=120 target_cpu=001
  	ffffffffb64cd0cc wake_up_process+0xe6c ([kernel.kallsyms])
  	ffffffffb64cb034 irq_exit_rcu+0x264 ([kernel.kallsyms])
  	ffffffffb68ad31c sysvec_call_function_single+0xcc ([kernel.kallsyms])
  	ffffffffb560158a asm_sysvec_call_function_single+0x1a ([kernel.kallsyms])
  	ffffffffb653c4ce page_counter_uncharge+0x2e ([kernel.kallsyms])
  	ffffffffb6541b28 mem_cgroup_sk_uncharge+0x3c8 ([kernel.kallsyms])
  	ffffffffb6561383 sock_rfree+0x83 ([kernel.kallsyms])
  	ffffffffb6577faf tcp_recvmsg+0x2ff ([kernel.kallsyms])
  	ffffffffb65604d9 __x64_sys_recvfrom+0x159 ([kernel.kallsyms])

The problem is that when stock_pages exceeds MEMCG_STOCK_HIGH
or all slots in struct memcg_stock_pcp are full, refill_stock()
calls memcg_uncharge() or drain_stock() while holding
memcg_stock.lock.

Because local_trylock() only disables preemption and leaves
interrupts and softirqs enabled, an RPS IPI arriving while
refill_stock() stalls on page_counter_uncharge() invokes
NET_RX_SOFTIRQ (process_backlog()) on the same CPU while
memcg_stock.lock is held.

Every incoming packet in process_backlog() then fails
local_trylock() in consume_stock() and falls back to
try_charge_memcg() and refill_stock(), hammering the global
page_counter atomic twice per packet, and slow processing
finally wakes up ksoftirqd.

Let's move memcg_uncharge() and css_put() outside
local_unlock(&memcg_stock.lock) in refill_stock().

With the change, the flakiness disappeared on the 512 vCPU platform.

In addition, on machine w/ AMD EPYC 7B12 64-Core Processor (Zen 2
Rome, 2 sockets, 256 vCPU), tcp_rr w/ 10000 flows achieves 36% more
throughput with lower latency.

  tcp_rr (10000 flows, 128 threads, 60s, average of 3 runs):

  Metric                     |       Baseline |    Patched |    Diff
  ---------------------------+----------------+------------+--------
  Throughput (RPS)           |     20,884,499 | 28,453,051 | +36.24%
  Latency Mean (us)          |         478.46 |     351.07 | -26.63%
  Latency p50 (us)           |         453.96 |     343.04 | -24.43%
  Latency p90 (us)           |         669.00 |     479.57 | -28.32%
  Latency p99 (us)           |         969.38 |     593.92 | -38.73%

Link: https://lore.kernel.org/20261029194452.3189365-5-kuniyu@google.com
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
---

 mm/memcontrol.c |   27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

--- a/mm/memcontrol.c~memcg-uncharge-pages-outside-memcg_stocklock-in-refill_stock
+++ a/mm/memcontrol.c
@@ -2294,23 +2294,31 @@ static void refill_stock(struct mem_cgro
 
 		stock_pages = stock->nr_pages[i] + nr_pages;
 		if (unlikely(stock_pages > MEMCG_STOCK_HIGH)) {
-			memcg_uncharge(memcg,
-				       stock_pages - MEMCG_STOCK_LOW);
-			stock_pages = MEMCG_STOCK_LOW;
+			WRITE_ONCE(stock->nr_pages[i], MEMCG_STOCK_LOW);
+			stock_pages -= MEMCG_STOCK_LOW;
+		} else {
+			WRITE_ONCE(stock->nr_pages[i], stock_pages);
+			stock_pages = 0;
 		}
 
-		WRITE_ONCE(stock->nr_pages[i], stock_pages);
-
 		local_unlock(&memcg_stock.lock);
+
+		if (unlikely(stock_pages))
+			memcg_uncharge(memcg, stock_pages);
 		return;
 	}
 
+	cached = NULL;
+	stock_pages = 0;
+
 	i = empty_slot;
 	if (i == -1) {
 		i = stock->drain_idx++;
 		if (stock->drain_idx == NR_MEMCG_STOCK)
 			stock->drain_idx = 0;
-		drain_stock(stock, i);
+
+		cached = stock->cached[i];
+		stock_pages = stock->nr_pages[i];
 	}
 
 	css_get(&memcg->css);
@@ -2318,6 +2326,13 @@ static void refill_stock(struct mem_cgro
 	WRITE_ONCE(stock->nr_pages[i], nr_pages);
 
 	local_unlock(&memcg_stock.lock);
+
+	if (unlikely(cached)) {
+		if (stock_pages)
+			memcg_uncharge(cached, stock_pages);
+
+		css_put(&cached->css);
+	}
 }
 
 static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
_

Patches currently in -mm which might be from kuniyu@google.com are

mm-kasan-detect-double-free-involving-kfree_rcu_sheaf.patch
mm-kasan-kunit-add-double-free-tests-involving-kfree_rcu_sheaf.patch
memcg-remove-unnecessary-read_once-under-memcg_stocklock.patch
memcg-reduce-nesting-in-consume_stock-and-refill_stock.patch
memcg-annotate-slow-paths-in-consume_stock-and-refill_stock.patch
memcg-uncharge-pages-outside-memcg_stocklock-in-refill_stock.patch

