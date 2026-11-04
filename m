Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793818477;
	b=tE/ohXGnyw45EzmQ5wsFf6y12V6DSfVv6tAa4fcs6SOUuVHih+CulCQ6DHdIaRfapTze
	 YDRTkm1ZZ3dWWnXXk6qTijCZa5SUc2khzn0o7fRH/U8eM9csirRe5a4MuF9/9ldnvr3z6
	 ffxXxpEmS77gwtgSiWMZJHBjbWw/y+BQJzHk/LyeywLeiCeXbhbSngOsMzdj7ii/tXFbm
	 1W+7/C/ntKg/3fZHCSdwfZgBxYmH5D1+g9v26+B7Zu9Fv1gDJoFSqg3Aka0jdADIBZ9eQ
	 qxMR3ECLKZpV6/kaZdYeUv3rnz8lwmUZ3PflRE26QHWKef0CgOjYbZWW+QJdSx9/wxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793818477;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=D0+jcytnsWAltUKgYsNswzMmqGZLlaVI/uBJrxtYAjM=;
	b=t1vVxV5vMau+VneJc2TxU6dvjEuCgYT1f7zro6CtCoMkPAE0OZRoHkEgtrQbcC4AxqLy
	 z6gQCt7AEW65l0DjQYh7fTNJkb88iu4nAoFT9bCKEYOyI+0VSOvOTiRV+SdIi2AoOTdtg
	 1+5INdlrCMSfC+STUoe36Akoj4FGV7DXk+eHUUaVd8BReQBWkr8Q3Ux8S6oIeuLpJ92sB
	 aLKnI2cVSpN62JKzEfNyS8M5nvC4+U4lCVtbPd5yeU/oy7o9xYN5pIKx/G3iuPHq9Z/UC
	 FAW2lwyHZ6NDOYww3Yh4NtdMl+zzZFrCDW7uDIhz0e3VRBjLVr4uHwvNirEJXUsP2hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="TIULLVu/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B5A6082BE0
	for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2026 18:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=TIULLVu/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 524EF1F0093A;
	Wed,  4 Nov 2026 18:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793818477;
	bh=D0+jcytnsWAltUKgYsNswzMmqGZLlaVI/uBJrxtYAjM=;
	h=Date:To:From:Subject;
	b=TIULLVu/NThfUgUMMP53GmZIkgf6P/MBWo7dkskAYIFh3fW0+6286dmkQHuD39vMc
	 6dxPH6WIH+lr9FI9AjlISX9GgtxeVKs1wLH+9JmkJVBxHJfpIPVCUNpCdd+jSEDTCY
	 YKITJ5dTvR5tLgPUcmP86ogwq6og3IM0BWA1AsdA=
Date: Wed, 04 Nov 2026 10:54:36 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,
	shakeel.butt@linux.dev,rostedt@goodmis.org,roman.gushchin@linux.dev,
	ridong.chen@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,
	mhocko@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,
	ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,
	david@fromorbit.com,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,
	baohua@kernel.org,axelrasmussen@google.com,chenridong@xiaomi.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-add-tracepoint-for-scan_folios.patch added to mm-new branch
Message-Id: <20261104185437.524EF1F0093A@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mglru: add tracepoint for scan_folios()
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-add-tracepoint-for-scan_folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-add-tracepoint-for-scan_folios.patch

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
Subject: mm/mglru: add tracepoint for scan_folios()
Date: Wed, 04 Nov 2026 21:08:15 +0800

MGLRU's scan_folios() emits the classic-LRU tracepoint
trace_mm_vmscan_lru_isolate(), which predates MGLRU. It reports the
scan/isolate counts and the LRU type, but carries no generation or
memcg context, so a trace of an MGLRU run cannot tell which memcg a
given scan belongs to, nor how far reclaim has progressed through the
generations.

Add mm_mglru_scan_folios next to it, reporting the same counters plus
nr_sorted (folios moved to a younger generation by sort_folio()) and
the context the classic tracepoint lacks: the node id and memcg id of
the lruvec, and the max_seq, tier and min_seq of the type being
scanned.

Now that struct scan_control is visible to the trace header, pass sc,
lruvec, type and tier straight in and derive everything else in
TP_fast_assign(), so nothing is computed at the call site when the
event is disabled. The int fields are grouped at the end of the entry
to avoid padding on 64-bit.

scan_folios() is the MGLRU-specific layer where folios are actually
scanned, so it has no classic-LRU counterpart. The existing tracepoint
is left unchanged.

Link: https://lore.kernel.org/20261104130817.849089-6-ridong.chen@linux.dev
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Barry Song <baohua@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
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
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Ridong Chen <ridong.chen@linux.dev>
---

 mm/trace_vmscan.h |   66 ++++++++++++++++++++++++++++++++++++++++++++
 mm/vmscan.c       |    2 +
 2 files changed, 68 insertions(+)

--- a/mm/trace_vmscan.h~mm-mglru-add-tracepoint-for-scan_folios
+++ a/mm/trace_vmscan.h
@@ -392,6 +392,72 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 		__print_symbolic(__entry->lru, LRU_NAMES))
 );
 
+#ifdef CONFIG_LRU_GEN
+TRACE_EVENT(mm_mglru_scan_folios,
+
+	TP_PROTO(struct lruvec *lruvec,
+		 struct scan_control *sc,
+		 unsigned long nr_requested,
+		 unsigned long nr_scanned,
+		 unsigned long nr_sorted,
+		 unsigned long nr_skipped,
+		 unsigned long nr_taken,
+		 int type,
+		 int tier),
+
+	TP_ARGS(lruvec, sc, nr_requested, nr_scanned, nr_sorted, nr_skipped,
+		nr_taken, type, tier),
+
+	TP_STRUCT__entry(
+		__field(u64, memcg_id)
+		__field(unsigned long, nr_requested)
+		__field(unsigned long, nr_scanned)
+		__field(unsigned long, nr_sorted)
+		__field(unsigned long, nr_skipped)
+		__field(unsigned long, nr_taken)
+		__field(unsigned long, max_seq)
+		__field(unsigned long, min_seq)
+		__field(int, nid)
+		__field(int, highest_zoneidx)
+		__field(int, order)
+		__field(int, lru)
+		__field(int, tier)
+	),
+
+	TP_fast_assign(
+		__entry->memcg_id = mem_cgroup_id(lruvec_memcg(lruvec));
+		__entry->nr_requested = nr_requested;
+		__entry->nr_scanned = nr_scanned;
+		__entry->nr_sorted = nr_sorted;
+		__entry->nr_skipped = nr_skipped;
+		__entry->nr_taken = nr_taken;
+		__entry->max_seq = lruvec->lrugen.max_seq;
+		__entry->min_seq = lruvec->lrugen.min_seq[type];
+		__entry->nid = lruvec_pgdat(lruvec)->node_id;
+		__entry->highest_zoneidx = sc->reclaim_idx;
+		__entry->order = sc->order;
+		__entry->lru = type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON;
+		__entry->tier = tier;
+	),
+
+	TP_printk("nid=%d memcg_id=%llu classzone=%d order=%d nr_requested=%lu nr_scanned=%lu nr_sorted=%lu nr_skipped=%lu nr_taken=%lu lru=%s max_seq=%lu tier=%d min_seq=%lu",
+		__entry->nid,
+		__entry->memcg_id,
+		__entry->highest_zoneidx,
+		__entry->order,
+		__entry->nr_requested,
+		__entry->nr_scanned,
+		__entry->nr_sorted,
+		__entry->nr_skipped,
+		__entry->nr_taken,
+		__print_symbolic(__entry->lru, LRU_NAMES),
+		__entry->max_seq,
+		__entry->tier,
+		__entry->min_seq)
+);
+
+#endif /* CONFIG_LRU_GEN */
+
 TRACE_EVENT(mm_vmscan_write_folio,
 
 	TP_PROTO(struct folio *folio),
--- a/mm/vmscan.c~mm-mglru-add-tracepoint-for-scan_folios
+++ a/mm/vmscan.c
@@ -4802,6 +4802,8 @@ static int scan_folios(unsigned long nr_
 	trace_mm_vmscan_lru_isolate(sc, nr_to_scan,
 				    scanned, skipped, isolated,
 				    type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
+	trace_mm_mglru_scan_folios(lruvec, sc, nr_to_scan, scanned, sorted,
+				   skipped, isolated, type, tier);
 
 	*isolatedp = isolated;
 	return scanned;
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

