Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795638959;
	b=owo5kUC2RKYHN7sJq0tPT7yEpwCcEL3h5XvRZjtN1gTW1n/ojJhWSn/j4fYVP0wJ5uhx
	 MN04kE2vAMWoPNjBoYoEAwx/WxQIXt7ZIVQ03oBKbOY93GZDxUYJLu2fqEbQ/ECp2IuFL
	 AZAopPaEX3KKBITAxIKX7VsWrmBJP6ZVlKgcGY9N/bhRbri8lamoUx4z2eVtQ5i9lhmfK
	 LJImp+y6tZfTWQZhrGy6A9SUHw/Hh5+hnsaRuFVL7kkODflXktQ6yGAQAs2eGpVkhpZTo
	 7LnLGOn+tB57UfnDjVz2en4NC2Dp1BhQOOQcDkeU7wn+QyX63eswAKYhttCdKsADgCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795638959;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=5sFFG6vZd7gVTWs2x/NoH7cOXsQRayjMqp6IZcHoTw4=;
	b=2KOYJBzyWDO450mXgLJGrm5ohRFMOlJm4IkfL4EVZ6JsxM+c5MgoGGBC2lEy06zhO+TD
	 YDuEDMSXzK17Kv+VVLN/0WTQ6vlnB2t9IEiC+Z4+JTWdZr5qqEFz4PrU2M3osw1arkuUB
	 ZpLUzDhhq7j7uYsjeJQcCEHij3TgYw3q3jq6SeozX1kucJKnTd7760LEtbTsxbpR78AfI
	 Q1II7eL7TzqxRo6bpQ943Piz+hqKm8YNNk5cIJPNl8FEGloY/wObZXMTeB5LbFl1EoKzD
	 mrcG1HF2SRAKGdCvcvW/Kw7HQkJsraglAcUVD8aojP1vPHsCC2EJCgRYhvXOa5naEEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ELBKzYBF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F8B606A326
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 20:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ELBKzYBF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7441F000C4;
	Wed, 25 Nov 2026 20:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795638958;
	bh=5sFFG6vZd7gVTWs2x/NoH7cOXsQRayjMqp6IZcHoTw4=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=ELBKzYBFKz774fO20qKi/DLPYQLxwciXvf8PDklpCTvt15CFDsiQ+0VKLYBYAvNIw
	 KjR0hxF0IMsb1jc2KGhfmrGJqpZ5zPxBZQKOP9lmg7MdFr7HIPsHCl8UB4weGw66s9
	 9AQ1uIX/XxLpvbRMGXUouj2sc2giLYtLuo1KVgcI=
Date: Wed, 25 Nov 2026 12:35:57 -0800
To: mm-commits@vger.kernel.org,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124-mglru-fg-v6-6-8ffea39934a6@tencent.com>
References: <20261124-mglru-fg-v6-6-8ffea39934a6@tencent.com>
Subject: [to-be-updated] mm-mglru-skip-the-flags-cmpxchg-when-nothing-changes.patch removed from -mm tree
Message-Id: <20261125203558.6F7441F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/mglru: skip the flags cmpxchg when nothing changes
has been removed from the -mm tree.  Its filename was
     mm-mglru-skip-the-flags-cmpxchg-when-nothing-changes.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Ridong Chen <chenridong@xiaomi.com>
Subject: mm/mglru: skip the flags cmpxchg when nothing changes
Date: Tue, 24 Nov 2026 02:52:58 +0800

folio_update_gen() and folio_set_lru_refs() always end with a
try_cmpxchg() on folio->flags, even when the new value equals the old
one. The locked instruction still takes the struct page cacheline in
exclusive state.

That is common in practice: a folio mapped by many processes is visited
once per mm during a page table walk, and after the first visit it is
already in the youngest generation with refs cleared and PG_workingset
set. isolate_folio() and the eviction paths also call
folio_set_lru_refs(folio, 0) on folios whose refs are already zero.

Break out of the loop when the flags would not change. The update is
complete at the point of that read: the flags already hold the target
value, and a concurrent change to them is ordered after it. When the
cmpxchg would have succeeded, the value written is the same, so no new
state becomes reachable.

What the patch drops is the retry. A retry re-reads the flags and
recomputes new_flags from the newer value, so it overwrites a concurrent
update with what this CPU wanted. For folio_update_gen(), a walker that
read an older max_seq can lose the cmpxchg against a promotion done by
another CPU, and then write its older generation back on the retry.
folio_set_lru_refs() can likewise clear a refs increment that raced with
it. Breaking out keeps the newer state.

No caller relies on the full barrier that the locked instruction
implied on the skipped path: the eviction and isolation callers run
under the LRU lock, and the others (page table walks,
folio_mark_accessed(), lru_gen_clear_refs()) only care about the
resulting flags value, which is already in place. Note that
lru_gen_inc_refs() already returns without any atomic when refs is at
LRU_REFS_MAX and the folio is in the workingset.

Tested on an i7-13700HX with turbo disabled and the performance
governor. N processes map the same 2GiB tmpfs file (huge=never) and
read every page, then one aging pass is triggered on their memcg
through /sys/kernel/debug/lru_gen ("+ <memcg_id> 0 <max_seq> 200 1").
Time per aging pass in ms, median of 5 runs of 10 passes each, averaged
over 2 boots of each kernel:

  processes    base   patched
          1    32.9      31.7   -3.5%
          8   195.1     160.2  -17.9%
         32   755.8     592.2  -21.7%
         64  1597.2    1260.6  -21.1%

With one process, every visit changes the generation, so there is
nothing to skip. Before the patch, perf annotate attributes 53-58% of
the walk_update_folio() samples to the lock cmpxchg in the inlined
folio_update_gen() in this test.

[kasong@tencent.com: adapted and rebased for the series]
Link: https://patch.msgid.link/20261124-mglru-fg-v6-6-8ffea39934a6@tencent.com
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Christopher Li <chrisl@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: SJ Park <sj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: wangzicheng <wangzicheng@honor.com>
Cc: Tal Zussman <tz2294@columbia.edu>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Xiang Liu <liuxiang.277@bytedance.com>
Cc: Ehab Ababneh <ehab.ababneh@intel.com>
Cc: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Cc: wang lian <lianux.mm@gmail.com>
Cc: Joanne Koong <joannelkoong@gmail.com>
Cc: Hui Zhu <hui.zhu@linux.dev>
Cc: Maxim Muzafarov <maxmuzaf@gmail.com>
Cc: Tianyi Chen <hi@tychen.cc>
Cc: Harry Yoo <harry@kernel.org>

 include/linux/mm_inline.h |    2 ++
 mm/vmscan.c               |    2 ++
 2 files changed, 4 insertions(+)

--- a/include/linux/mm_inline.h~mm-mglru-skip-the-flags-cmpxchg-when-nothing-changes
+++ a/include/linux/mm_inline.h
@@ -233,6 +233,8 @@ static inline void folio_set_lru_refs(st
 	do {
 		new_flags = old_flags;
 		lru_set_refs_flags(&new_flags, refs);
+		if (new_flags == old_flags)
+			break;
 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 }
 
--- a/mm/vmscan.c~mm-mglru-skip-the-flags-cmpxchg-when-nothing-changes
+++ a/mm/vmscan.c
@@ -3274,6 +3274,8 @@ static int folio_update_gen(struct folio
 		lru_set_gen_flags(&new_flags, new_gen);
 		lru_set_refs_flags(&new_flags, 0);
 		new_flags |= BIT(PG_workingset);
+		if (new_flags == old_flags)
+			break;
 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 
 	*type = folio_flags_is_file_lru(&old_flags);
_

Patches currently in -mm which might be from chenridong@xiaomi.com are

mm-memcontrol-drop-unused-vmscan-tracepoint-include.patch
mm-vmscan-move-vmscan-tracepoints-to-a-local-header.patch
mm-vmscan-move-struct-scan_control-to-a-dedicated-header.patch
mm-vmscan-pass-scan_control-to-the-vmscan-tracepoints.patch
mm-mglru-add-tracepoint-for-scan_folios.patch
mm-mglru-add-lruvec_gen_size-helper.patch
mm-mglru-add-tracepoint-for-aging.patch

