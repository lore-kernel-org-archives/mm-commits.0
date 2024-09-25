Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9A8130499
	for <mm-commits@vger.kernel.org>; Wed, 25 Sep 2024 00:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727225250; cv=none; b=UL3rvxHV6XOIm32tbDFCFi3ir9kLD9Wn6d7K5e9iHkfoLPirapuWGVlVN8lxA4genlTCqPMIBcDqpB/NJmJeSvTQzeKAI7l5HEiDlF8KHB6Jml9xursPweuEmh/Cetlytbcv6fjNaT7PBpa9jTPBknB9VivXy71RQfzNyMG3L2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727225250; c=relaxed/simple;
	bh=y4fv2BhC28ShOpVrtl+cCHspwcLnVnlGIbYaOafBQis=;
	h=Date:To:From:Subject:Message-Id; b=tdYQdZUoMcPX6k2gIiOZ5ffHtx2pftkFtbfxH5VBZ2QSpW43XXhKeIGXgNIennW6/Yqq4Eu59TPOeo1qOLFubSviffSyq1g87hLuTprqU3CehD5wvEvTFUdFXjahTZYK47M6MhMaWGVKOeVdk9JnujZtWY/MrfXETkS985eiajM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=umYwgJZx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="umYwgJZx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77636C4CEC4;
	Wed, 25 Sep 2024 00:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727225249;
	bh=y4fv2BhC28ShOpVrtl+cCHspwcLnVnlGIbYaOafBQis=;
	h=Date:To:From:Subject:From;
	b=umYwgJZxQJvZvcgR91umvaqe+WAgJxrAiStK3vsvPmtRMUMiB276RJbqeDl5ww762
	 S36VRzr1cO5Z65XFg878t7uRAjZBTtJdhZnguEDM8QM2CN3N/syarmXzIqTrkbMnsN
	 YU4vsYQhaLiqtLMXi4p/xUSHVQycNKlBFCgSy2vc=
Date: Tue, 24 Sep 2024 17:47:28 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,weixugc@google.com,tjmercier@google.com,kasong@tencent.com,chrisl@kernel.org,linuszeng@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-vmscan-wake-up-flushers-conditionally-to-avoid-cgroup-oom.patch removed from -mm tree
Message-Id: <20240925004729.77636C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: wake up flushers conditionally to avoid cgroup OOM
has been removed from the -mm tree.  Its filename was
     mm-vmscan-wake-up-flushers-conditionally-to-avoid-cgroup-oom.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Zeng Jingxiang <linuszeng@tencent.com>
Subject: mm/vmscan: wake up flushers conditionally to avoid cgroup OOM
Date: Fri, 13 Sep 2024 16:45:06 +0800

Commit 14aa8b2d5c2e ("mm/mglru: don't sync disk for each aging cycle")
removed the opportunity to wake up flushers during the MGLRU page
reclamation process can lead to an increased likelihood of triggering OOM
when encountering many dirty pages during reclamation on MGLRU.

This leads to premature OOM if there are too many dirty pages in cgroup:
Killed

dd invoked oom-killer: gfp_mask=0x101cca(GFP_HIGHUSER_MOVABLE|__GFP_WRITE),
order=0, oom_score_adj=0

Call Trace:
  <TASK>
  dump_stack_lvl+0x5f/0x80
  dump_stack+0x14/0x20
  dump_header+0x46/0x1b0
  oom_kill_process+0x104/0x220
  out_of_memory+0x112/0x5a0
  mem_cgroup_out_of_memory+0x13b/0x150
  try_charge_memcg+0x44f/0x5c0
  charge_memcg+0x34/0x50
  __mem_cgroup_charge+0x31/0x90
  filemap_add_folio+0x4b/0xf0
  __filemap_get_folio+0x1a4/0x5b0
  ? srso_return_thunk+0x5/0x5f
  ? __block_commit_write+0x82/0xb0
  ext4_da_write_begin+0xe5/0x270
  generic_perform_write+0x134/0x2b0
  ext4_buffered_write_iter+0x57/0xd0
  ext4_file_write_iter+0x76/0x7d0
  ? selinux_file_permission+0x119/0x150
  ? srso_return_thunk+0x5/0x5f
  ? srso_return_thunk+0x5/0x5f
  vfs_write+0x30c/0x440
  ksys_write+0x65/0xe0
  __x64_sys_write+0x1e/0x30
  x64_sys_call+0x11c2/0x1d50
  do_syscall_64+0x47/0x110
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

 memory: usage 308224kB, limit 308224kB, failcnt 2589
 swap: usage 0kB, limit 9007199254740988kB, failcnt 0

  ...
  file_dirty 303247360
  file_writeback 0
  ...

oom-kill:constraint=CONSTRAINT_MEMCG,nodemask=(null),cpuset=test,
mems_allowed=0,oom_memcg=/test,task_memcg=/test,task=dd,pid=4404,uid=0
Memory cgroup out of memory: Killed process 4404 (dd) total-vm:10512kB,
anon-rss:1152kB, file-rss:1824kB, shmem-rss:0kB, UID:0 pgtables:76kB
oom_score_adj:0

The flusher wake up was removed to decrease SSD wearing, but if we are
seeing all dirty folios at the tail of an LRU, not waking up the flusher
could lead to thrashing easily.  So wake it up when a mem cgroups is about
to OOM due to dirty caches.

Link: https://lkml.kernel.org/r/20240829102543.189453-1-jingxiangzeng.cas@gmail.com
Link: https://lkml.kernel.org/r/20240913084506.3606292-1-jingxiangzeng.cas@gmail.com
Fixes: 14aa8b2d5c2e ("mm/mglru: don't sync disk for each aging cycle")
Signed-off-by: Zeng Jingxiang <linuszeng@tencent.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: T.J. Mercier <tjmercier@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Chris Li <chrisl@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/mm/vmscan.c~mm-vmscan-wake-up-flushers-conditionally-to-avoid-cgroup-oom
+++ a/mm/vmscan.c
@@ -4285,6 +4285,7 @@ static bool sort_folio(struct lruvec *lr
 		       int tier_idx)
 {
 	bool success;
+	bool dirty, writeback;
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
@@ -4333,6 +4334,9 @@ static bool sort_folio(struct lruvec *lr
 	/* waiting for writeback */
 	if (folio_test_locked(folio) || folio_test_writeback(folio) ||
 	    (type == LRU_GEN_FILE && folio_test_dirty(folio))) {
+		folio_check_dirty_writeback(folio, &dirty, &writeback);
+		if (dirty && !writeback)
+			sc->nr.unqueued_dirty += delta;
 		gen = folio_inc_gen(lruvec, folio, true);
 		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
 		return true;
@@ -4449,6 +4453,7 @@ static int scan_folios(struct lruvec *lr
 				scanned, skipped, isolated,
 				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
+	sc->nr.taken += isolated;
 	/*
 	 * There might not be eligible folios due to reclaim_idx. Check the
 	 * remaining to prevent livelock if it's not making progress.
@@ -4921,6 +4926,14 @@ static void lru_gen_shrink_lruvec(struct
 	if (try_to_shrink_lruvec(lruvec, sc))
 		lru_gen_rotate_memcg(lruvec, MEMCG_LRU_YOUNG);
 
+	/*
+	 * If too many pages failed to evict due to page being dirty,
+	 * memory pressure have pushed dirty pages to oldest gen,
+	 * wake up flusher.
+	 */
+	if (sc->nr.unqueued_dirty > sc->nr.taken)
+		wakeup_flusher_threads(WB_REASON_VMSCAN);
+
 	clear_mm_walk();
 
 	blk_finish_plug(&plug);
_

Patches currently in -mm which might be from linuszeng@tencent.com are

mm-memcontrol-add-per-memcg-pgpgin-pswpin-counter.patch
mm-memcontrol-add-per-memcg-pgpgin-pswpin-counter-v2.patch

