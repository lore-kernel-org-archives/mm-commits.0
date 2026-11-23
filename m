Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795465385;
	b=e/k6Mj6sX9cF3X4R8FID2514sbNIfMqAClsaG38lkJOA/klIV0mpBpqzVipN2Kqcz1Ay
	 E0/lm3ociqe6Ns2dWdB7/dIRnZ4kRM46W/WVJscuJe7OGHScetq9RayYn83zideFz0aYn
	 IOv29/MZf72SUXfYUFx8Mj4mOPTUI7QUvAEu//lQdNhoDP+NoUKxX5CtZj2lerbqcmB1x
	 R0FOoHhwddhiluNk+gvWBfXQ6uNFikQMwJFIobHj3H5tB0bcsdIfpb3bZgsShjpeOskRi
	 d+0nC6wMP8Rr15BPkCfwZFihHwyRd/w8T4ax7SRIW/adCvY2TI9QC/gByuyj+Zu/sgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795465385;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=uwvY0RcKtDp5OUY1RJS/68udeB85MbBnPBZQEQFo7Fc=;
	b=Msrjqe6hz8yH5PFxgFMUF/cuhIWr3t0NPqx1bDpDSjeJQaThGc1sXjjmW/XZhLWf3G0d
	 cfYLNhZGZV8fU+GshE87/jZubv+XyNhLX2UHXQOF7J49OfbkLr259QMJhtjrHPl2mOCKC
	 3DVRnN1RBbfbxem7Fm709cScQQ5P576cPHz0zAYGA2tb5Jz1cbhQDGPjtAVbGuv3LtdE7
	 Ol3lZr3945HFwSjvhCH+tip3JOxUvw5hDguVuDPIxbz3xtxzxj4phuE27cBQJ5S7UMzxL
	 f2DAdz1GsAGqALz2Eed0DUwqLWK04PL7sk67p5ypQz3fcaBlENqs7mYRNvTDd6qyNUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pyop8A2U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4A0606A339
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 20:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pyop8A2U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964181F000D3;
	Mon, 23 Nov 2026 20:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795465384;
	bh=uwvY0RcKtDp5OUY1RJS/68udeB85MbBnPBZQEQFo7Fc=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=pyop8A2UAfU6VLh2PNdi4ZgEKdwKBenOy4leI2QnrsogPv2S+rm99wwcIHcrt+msq
	 fHOIrQ19fX83iNeVHmRBIcRnlDvWTYkZsRJoxnFYyhairoXMStChTzhByd1xU5eAJm
	 lHnMFuLiFilC11D0JY6F3lRYJUWJ+F1Qo4SFRxEo=
Date: Mon, 23 Nov 2026 12:23:04 -0800
To: mm-commits@vger.kernel.org,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124-mglru-fg-v6-6-8ffea39934a6@tencent.com>
References: <20261124-mglru-fg-v6-6-8ffea39934a6@tencent.com>
Subject: + mm-mglru-skip-the-flags-cmpxchg-when-nothing-changes.patch added to mm-new branch
Message-Id: <20261123202304.964181F000D3@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mglru: skip the flags cmpxchg when nothing changes
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-skip-the-flags-cmpxchg-when-nothing-changes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-skip-the-flags-cmpxchg-when-nothing-changes.patch

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
mm-mglru-rename-the-generation-offset-in-lru_gen_folio_seq.patch
mm-mglru-skip-the-flags-cmpxchg-when-nothing-changes.patch

