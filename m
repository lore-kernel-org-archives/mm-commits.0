Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793818482;
	b=fqr95ba0I74dT39OoBC0c2Fblv2ftE9Rrc3h3s+18+JsZJnqWGpprqQEFoaxPG63+EvJ
	 VHOzXWrCm/J3vhdm+X0+JHokSC37EY8OCL2Si+IB6NU+/qFhhR9vmW1h0J8/DuQJt/8Bp
	 PLastudu6n5NbdfG/KlmT2wbhjdif57H0K7D1N/GlGl16VeL1E5pzj0CN6Ltozi4aRln1
	 SZ94CHcsRBM+T4F1lmLuFgA8XG4jNxAc3bNZAnBnbAVKJXEv+ARpwlgZRJKUYegUbPh+M
	 JvfrsCI3Clm46zQSKSWnTYiWXWxokZBfJce3NvWj5GcpJ2lDKoyg7q9G2/A19tc5IIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793818482;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=j+zQCs1ENsfQ8BJFHynIrKXwQOOXEhPkP2pM9h+ni1s=;
	b=MQDMjSipWvImkgjxsPU+MtQlTV7i7jF4KWT4PkFfTcrkdRwt/FA6G1mLn8z4zRMnBcHR
	 zi1r+43xIjhOosftu9K08PHWdDUX3cdSQB3jy5a39tVjjvr22/ZlX/5Z/mBBbN1VQYyK7
	 bG68r9BxCimdSBWPMjkIVAQjGD/UitLcvJINzAIL2DZsbSKEXQwrdpkkFHzzm+zqY9Kaj
	 Xiynai2rtyJGwM47bT9X8AMXj2sILwVEQK39tyKhmtmAUGgQobfD8d+AVtuJmM/3NYg9V
	 UYpwiqAMBMJCnUgJVsXVLjFawLOLsczswh+C4jGRjCoXJDWoWKsYlCJNW9JQuH9YahQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fCiMsuSE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0785A606D838
	for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2026 18:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fCiMsuSE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1701F00A18;
	Wed,  4 Nov 2026 18:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793818481;
	bh=j+zQCs1ENsfQ8BJFHynIrKXwQOOXEhPkP2pM9h+ni1s=;
	h=Date:To:From:Subject;
	b=fCiMsuSEtLtKwwSkRtUImYjpZxw7fphOi5NE/mLx0tqopS0RvbcDo5EMgcuz41PMV
	 jpd0ytK4dF5M5eaKPhS0RyQo/aVarzsFJSTxo5B8rLgK049Axg1cQe9SIx+USA0vh/
	 FbsDMy0/9civ8HWOXR/0wB5GiT215VetIfk4ie3o=
Date: Wed, 04 Nov 2026 10:54:41 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,
	shakeel.butt@linux.dev,rostedt@goodmis.org,roman.gushchin@linux.dev,
	ridong.chen@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,
	mhocko@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,
	ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,
	david@fromorbit.com,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,
	baohua@kernel.org,axelrasmussen@google.com,chenridong@xiaomi.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-add-tracepoint-for-aging.patch added to mm-new branch
Message-Id: <20261104185441.CA1701F00A18@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mglru: add tracepoint for aging
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-add-tracepoint-for-aging.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-add-tracepoint-for-aging.patch

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
From: Ridong Chen <chenridong@xiaomi.com>
Subject: mm/mglru: add tracepoint for aging
Date: Wed, 04 Nov 2026 21:08:17 +0800

Aging in MGLRU advances max_seq to create a new youngest generation.
It is triggered from try_to_shrink_lruvec() when should_run_aging()
finds that eviction is no longer possible, or that it would be better
to age first at the current priority. There is currently no tracepoint
on this path, so it cannot be observed when and why aging is needed.

Add mm_mglru_aging, emitted in try_to_shrink_lruvec() right before
try_to_inc_max_seq(), with the node id, memcg id, sc->priority,
swappiness, max_seq, the anon and file min_seq, and the number of pages
in each generation for both types, as computed by lruvec_gen_size().

The reason for aging is not reported explicitly, as the logic in
should_run_aging() may change, e.g. for imbalance-based aging. It can
be derived from the generation window and the per-generation sizes,
which are taken before aging, so the youngest generation is populated
as well.

The nr_anon/nr_file arrays are ordered by seq rather than by generation
slot: entry i holds the generation max_seq - MAX_NR_GENS + 1 + i, i.e.
they go from the oldest generation to the newest, the same order as the
debugfs lru_gen file, so the output can be read directly without mapping
slots back to seqs. The arrays are printed with __print_array(), so the
output is hex and its length follows MAX_NR_GENS automatically.

Only the lruvec, sc and swappiness are passed in; everything else,
including max_seq, is read in TP_fast_assign(), so try_to_shrink_lruvec()
does no extra work when the event is disabled. Reading max_seq there
rather than using the caller's copy keeps the window consistent with
the per-generation sizes read right after it, should another reclaimer
age the lruvec in between.

The event marks the aging decision, not its result: the following
try_to_inc_max_seq() may find that aging is already in progress or
done by another reclaimer, so concurrent reclaimers can each emit it
for the same max_seq. Whether max_seq was advanced can be seen from the
following mm_mglru_scan_folios.

Link: https://lore.kernel.org/20261104130817.849089-8-ridong.chen@linux.dev
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Barry Song <baohua@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Ridong Chen <ridong.chen@linux.dev>
---

 mm/trace_vmscan.h |   52 ++++++++++++++++++++++++++++++++++++++++++++
 mm/vmscan.c       |    1 
 2 files changed, 53 insertions(+)

--- a/mm/trace_vmscan.h~mm-mglru-add-tracepoint-for-aging
+++ a/mm/trace_vmscan.h
@@ -456,6 +456,58 @@ TRACE_EVENT(mm_mglru_scan_folios,
 		__entry->min_seq)
 );
 
+TRACE_EVENT(mm_mglru_aging,
+
+	TP_PROTO(struct lruvec *lruvec, struct scan_control *sc, int swappiness),
+
+	TP_ARGS(lruvec, sc, swappiness),
+
+	TP_STRUCT__entry(
+		__field(u64, memcg_id)
+		__field(unsigned long, max_seq)
+		__field(unsigned long, anon_min_seq)
+		__field(unsigned long, file_min_seq)
+		__array(unsigned long, nr_anon, MAX_NR_GENS)
+		__array(unsigned long, nr_file, MAX_NR_GENS)
+		__field(int, nid)
+		__field(int, priority)
+		__field(int, swappiness)
+	),
+
+	TP_fast_assign(
+		struct lru_gen_folio *lrugen = &lruvec->lrugen;
+		unsigned long max_seq = READ_ONCE(lrugen->max_seq);
+		int i;
+
+		__entry->memcg_id = mem_cgroup_id(lruvec_memcg(lruvec));
+		__entry->max_seq = max_seq;
+		__entry->anon_min_seq = READ_ONCE(lrugen->min_seq[LRU_GEN_ANON]);
+		__entry->file_min_seq = READ_ONCE(lrugen->min_seq[LRU_GEN_FILE]);
+		/* from the oldest generation to the newest, as debugfs lru_gen does */
+		for (i = 0; i < MAX_NR_GENS; i++) {
+			unsigned long seq = max_seq - MAX_NR_GENS + 1 + i;
+
+			__entry->nr_anon[i] =
+				lruvec_gen_size(lrugen, LRU_GEN_ANON, seq);
+			__entry->nr_file[i] =
+				lruvec_gen_size(lrugen, LRU_GEN_FILE, seq);
+		}
+		__entry->nid = lruvec_pgdat(lruvec)->node_id;
+		__entry->priority = sc->priority;
+		__entry->swappiness = swappiness;
+	),
+
+	TP_printk("nid=%d memcg_id=%llu priority=%d swappiness=%d max_seq=%lu anon_min_seq=%lu file_min_seq=%lu nr_anon=%s nr_file=%s",
+		__entry->nid,
+		__entry->memcg_id,
+		__entry->priority,
+		__entry->swappiness,
+		__entry->max_seq,
+		__entry->anon_min_seq,
+		__entry->file_min_seq,
+		__print_array(__entry->nr_anon, MAX_NR_GENS, sizeof(unsigned long)),
+		__print_array(__entry->nr_file, MAX_NR_GENS, sizeof(unsigned long)))
+);
 #endif /* CONFIG_LRU_GEN */
 
 TRACE_EVENT(mm_vmscan_write_folio,
--- a/mm/vmscan.c~mm-mglru-add-tracepoint-for-aging
+++ a/mm/vmscan.c
@@ -5099,6 +5099,7 @@ static bool try_to_shrink_lruvec(struct
 		}
 
 		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
+			trace_mm_mglru_aging(lruvec, sc, swappiness);
 			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
 				need_rotate = true;
 			should_age = true;
_

Patches currently in -mm which might be from chenridong@xiaomi.com are

mm-migrate-move-nr_file_thps-on-cross-node-migration.patch
mm-migrate-move-nr_kernel_file_pages-on-cross-node-migration.patch
mm-memcontrol-drop-unused-vmscan-tracepoint-include.patch
mm-vmscan-move-vmscan-tracepoints-to-a-local-header.patch
mm-vmscan-move-struct-scan_control-to-a-dedicated-header.patch
mm-vmscan-pass-scan_control-to-the-vmscan-tracepoints.patch
mm-mglru-add-tracepoint-for-scan_folios.patch
mm-mglru-add-lruvec_gen_size-helper.patch
mm-mglru-add-tracepoint-for-aging.patch

