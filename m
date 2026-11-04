Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793818465;
	b=uvsRBpgyZwdVe42D+x+3KAALG8p37BATClzs1mOoCbL3pXwgIXM8XVH9uWds4EIsyivB
	 r1MlLJImiVwCNi7/hGQFQUm3H0NckWYQ81bgaCEwEhdutubSJtV6R5Miys8go+Jv4jvU1
	 ZjZsoOIHPWueWfdHNhKux2EUKs9Vo3uk3aoCwSE/CJjhfbWPiP8rXFEvy1zgYB/s4btFA
	 xr1orSLgXd2DB7fekzCnccb1oiFf+Pj6ecsE6cDHKwnh92+0h4TN5C854X9dmW/I3IGVH
	 ZCYtA+my1vRPQHFfICUn3mz2SAGrE4jMMHDGCw7l6kmeBe1waVdVF7kyS+jRGJ4AekA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793818465;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=gVoe6DIpxxjln2wr9bMjZKf9eyAb4fxeyCFugtHPADQ=;
	b=dbdF1Nbn5BJIVDJH7EeVSvsG0GhKEvoDQn2lyb3Pe3vpLcx3XNrjPkXbTjEC/p+MXrL2
	 OXrMuGt+fH9n/w6Ayrwxl1I2r7woSgG1K1qYXXqJ2F/fvyN+QZD6Dr3gmKFK5dcKkE4tA
	 UM0UrsQtn2SYxLKnY/WhmZNw2nnu/KYc/hTygc7WnTRI7EqytsbCbWA44S0uXCxpYQDXX
	 lGfReIw0slSM2V8K8RL7mZx/fz2FUV5Rw3P3pQ8pO8BP7r3D6gZxerSWvnoyzv5qCpXp3
	 q55QSg2mvxyVDzCe0nEfwXP8CvK85KJR9oF6a1NJJmTCsMo//7swu7miQLB/wJmlRLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=IL4180+U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CBD606D810
	for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2026 18:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=IL4180+U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42BAC1F000C1;
	Wed,  4 Nov 2026 18:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793818464;
	bh=gVoe6DIpxxjln2wr9bMjZKf9eyAb4fxeyCFugtHPADQ=;
	h=Date:To:From:Subject;
	b=IL4180+Uri2jVZdQN8UxqHSSk9ZLOQbP6eawhJxR0/ptn/GaQ8LXu6XnEDbYuQgI6
	 3otua206ufcNMrgtZWVcNiT5B5LpSM9d9l1wOJLtqfHi3I42GuUwzNZj/p4fTBsHE0
	 Uz/BSh2BkrNXhkTpZxCnM7O+IzlruyU8wT0vVSaA=
Date: Wed, 04 Nov 2026 10:54:23 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,
	shakeel.butt@linux.dev,rostedt@goodmis.org,roman.gushchin@linux.dev,
	ridong.chen@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,
	mhocko@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,
	ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,
	david@fromorbit.com,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,
	baohua@kernel.org,axelrasmussen@google.com,chenridong@xiaomi.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-drop-unused-vmscan-tracepoint-include.patch added to mm-new branch
Message-Id: <20261104185424.42BAC1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/memcontrol: drop unused vmscan tracepoint include
has been added to the -mm mm-new branch.  Its filename is
     mm-memcontrol-drop-unused-vmscan-tracepoint-include.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-drop-unused-vmscan-tracepoint-include.patch

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
Subject: mm/memcontrol: drop unused vmscan tracepoint include
Date: Wed, 04 Nov 2026 21:08:11 +0800

Patch series "mm/vmscan: move tracepoints to mm/ and add MGLRU
tracepoints", v7.

Background
==========

MGLRU currently has no tracepoints of its own. The scan and evict paths
reuse the classic-LRU tracepoints (trace_mm_vmscan_lru_isolate() and
trace_mm_vmscan_lru_shrink_inactive()), which predate MGLRU and carry no
generation, sequence or memcg context. A trace of a running system
therefore cannot tell which memcg a given scan belongs to, how far
reclaim has progressed through the generations, or when a new generation
is created.

While reviewing an earlier version that added two MGLRU tracepoints,
Steven suggested moving include/trace/events/vmscan.h to
mm/trace_vmscan.h [1], as several other subsystems already do. Once the
header lives under mm/, struct scan_control can be moved there too,
letting the trace events access its fields directly instead of having
each callsite copy the scalars out by hand. This version merges the two
efforts into one series: the restructuring first, then the two new
tracepoints built on top of it.

Implementation
==============

Part 1, restructuring (patches 1-4):

  1) drop the unused vmscan trace include from memcontrol.c;
  2) move include/trace/events/vmscan.h to mm/trace_vmscan.h, setting
     TRACE_INCLUDE_PATH to "." and adding -I$(src) for vmscan.o;
  3) move struct scan_control into a dedicated mm/vmscan.h with an
     ordinary include guard, which trace_vmscan.h pulls in;
  4) pass scan_control to the vmscan tracepoints and pick the fields
     out in TP_fast_assign: the reclaim-begin events, the LRU
     isolate/shrink events, mm_vmscan_reclaim_pages and
     mm_vmscan_balance_pgdat_end.

Part 2, MGLRU tracepoints (patches 5-7):

  5) add mm_mglru_scan_folios on the scan path, next to the classic
     mm_vmscan_lru_isolate, reporting the same counters plus nr_sorted
     and the nid, memcg id, max_seq, tier and min_seq of the lruvec;
  6) add lruvec_gen_size() to mm/vmscan.h, returning the number of
     pages of one type in the generation of a given seq, and convert
     the two open-coded users in vmscan.c;
  7) add mm_mglru_aging where aging is triggered in
     try_to_shrink_lruvec(), reporting the nid, memcg id,
     sc->priority, swappiness, max_seq, the anon/file min_seq and the
     per-generation page counts of both types before aging, from the
     oldest generation to the newest as in the debugfs lru_gen file.

Both new events only take pointers (lruvec, sc) plus a few local
values, and derive everything else in TP_fast_assign(), so the reclaim
paths do no extra work when they are disabled.

Effect
======

Part 1 moves the loads of the tracepoint arguments out of the reclaim
paths and into the trace event callbacks, which only run when the event
is enabled. On x86_64 with gcc 11.4, the callers in mm/vmscan.o shrink
accordingly (bytes), e.g.:

  isolate_lru_folios    4499 -> 4335 (-164)
  __node_reclaim        2402 -> 2220 (-182)
  isolate_folios        8706 -> 8577 (-129)
  shrink_active_list    3669 -> 3544 (-125)
  evict_folios          4858 -> 4769  (-89)

There is no functional change in part 1. TP_STRUCT__entry and TP_printk
of the existing events are untouched, so their tracefs format is
identical. This was confirmed by diffing the tracefs format files before
and after, and by capturing the direct/memcg/node reclaim-begin events
under load in a QEMU guest (order, gfp_flags and memcg_id all match).
BPF programs attached via raw_tp/tp_btf do see the new TP_PROTO and need
to be adjusted; tracepoints are not a stable ABI (see
Documentation/bpf/bpf_design_QA.rst).

highest_zoneidx and nr_reclaimed stay separate arguments: the former is
a balance_pgdat() parameter (sc.reclaim_idx may differ from it by the
time the end event fires), and the latter is the return value of
shrink_folio_list(), which does not update sc->nr_reclaimed.

Part 2 makes the full aging-to-eviction window observable per memcg:
aging advances max_seq (the leading edge), scanning consumes the oldest
generations, and the min_seq/max_seq pair on each event shows how the
generation window moves over time. A sample trace, captured under
memory.reclaim of a test memcg, with the classic-LRU tracepoints left
enabled to show how they interleave:

  mm_vmscan_lru_isolate: classzone=4 order=0 nr_requested=64 nr_scanned=36 nr_skipped=0 nr_taken=36 lru=inactive_file
  mm_mglru_scan_folios: nid=0 memcg_id=1833 classzone=4 order=0 nr_requested=64 nr_scanned=36 nr_sorted=0 nr_skipped=0 nr_taken=36 lru=inactive_file max_seq=3 tier=3 min_seq=0
  mm_vmscan_lru_shrink_inactive: nid=0 nr_scanned=36 nr_reclaimed=31 nr_dirty=1 nr_writeback=0 nr_congested=0 nr_immediate=0 nr_activate_anon=0 nr_activate_file=1 nr_ref_keep=4 nr_unmap_fail=0 priority=2 flags=RECLAIM_WB_FILE|RECLAIM_WB_ASYNC
  mm_mglru_aging: nid=0 memcg_id=1833 priority=2 swappiness=0 max_seq=3 anon_min_seq=0 file_min_seq=2 nr_anon={0x0,0x0,0x802,0x0} nr_file={0x0,0x0,0x357,0x0}
  mm_vmscan_lru_isolate: classzone=4 order=0 nr_requested=64 nr_scanned=64 nr_skipped=0 nr_taken=64 lru=inactive_file
  mm_mglru_scan_folios: nid=0 memcg_id=1833 classzone=4 order=0 nr_requested=64 nr_scanned=64 nr_sorted=0 nr_skipped=0 nr_taken=64 lru=inactive_file max_seq=4 tier=3 min_seq=2
  mm_vmscan_lru_shrink_inactive: nid=0 nr_scanned=64 nr_reclaimed=64 nr_dirty=0 nr_writeback=0 nr_congested=0 nr_immediate=0 nr_activate_anon=0 nr_activate_file=0 nr_ref_keep=0 nr_unmap_fail=0 priority=2 flags=RECLAIM_WB_FILE|RECLAIM_WB_ASYNC
  mm_mglru_aging: nid=0 memcg_id=1833 priority=2 swappiness=0 max_seq=4 anon_min_seq=1 file_min_seq=2 nr_anon={0x0,0x802,0x0,0x0} nr_file={0x0,0x317,0x0,0x0}

The mm_mglru_scan_folios lines carry the node, memcg id and the
generation window (max_seq/min_seq) that the bare mm_vmscan_lru_isolate
lines above them cannot - those cannot even say which memcg they came
from. The mm_mglru_aging lines show when and why aging is triggered:
the first one has only two file generations left (file_min_seq=2,
max_seq=3, swappiness=0), so eviction is not possible anymore; the
second one has three left, and aging runs again as the priority is
below DEF_PRIORITY. The scans in between already report the new window
(max_seq=4 min_seq=2).

Testing
=======

The output of mm_mglru_aging matches the debugfs lru_gen_full file
dumped right before the aging. As the sizes are taken before aging, the
youngest generation is populated too, e.g. for a test memcg whose anon
pages are being accessed while it is aged:

  mm_mglru_aging: nid=0 memcg_id=1833 priority=11 swappiness=60 max_seq=13 anon_min_seq=12 file_min_seq=12 nr_anon={0x0,0x0,0x1925,0x15ef} nr_file={0x0,0x0,0x411,0x0}

  # cat /sys/kernel/debug/lru_gen_full    (generation lines only)
  memcg 1833 /tpy
   node     0
           10       4539          0           0x
           11       2904          0           0x
           12       2757       6437        1041
           13       1564       5615           0



This series was developed with the assistance of an LLM-based coding
assistant.


This patch (of 7):

memcontrol.c includes <trace/events/vmscan.h> but does not use any of
the tracepoints or macros it defines: all tracepoints invoked here come
from memcg.h and writeback.h.

Drop it ahead of moving the vmscan trace header under mm/, after which
<trace/events/vmscan.h> will no longer exist.

No functional change.

Link: https://lore.kernel.org/20261104130817.849089-1-ridong.chen@linux.dev
Link: https://lore.kernel.org/20261104130817.849089-2-ridong.chen@linux.dev
Link: https://lore.kernel.org/linux-mm/20260916095122.50cbb620@robin/ [1]
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
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
Cc: Kairui Song <kasong@tencent.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Ridong Chen <ridong.chen@linux.dev>
---

 mm/memcontrol.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-drop-unused-vmscan-tracepoint-include
+++ a/mm/memcontrol.c
@@ -77,8 +77,6 @@
 #include <trace/events/memcg.h>
 #undef CREATE_TRACE_POINTS
 
-#include <trace/events/vmscan.h>
-
 struct cgroup_subsys memory_cgrp_subsys __read_mostly;
 EXPORT_SYMBOL(memory_cgrp_subsys);
 
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

