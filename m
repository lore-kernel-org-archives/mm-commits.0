Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFB84D8C6
	for <mm-commits@vger.kernel.org>; Mon, 16 Sep 2024 06:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726467203; cv=none; b=BGPOogk26ao1L5IMmrmo8JZTyOGTNXy/2t2jpn+PWwQsZ1wEC5r5/YofcZjCzwbcvw0ldyw97k/VxyER/RIWe4ANYrn6a1Dj302qHOrXVdz3SkZ2RRGyoljZgLoShS5hWya3u6P9vRZVn6vjQI+0JPtCf1hBfgwnPCIXMp7f/NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726467203; c=relaxed/simple;
	bh=JYZRODKgdxkes/IfTkXRwXFObLdiiDR9HqWImMNHNJY=;
	h=Date:To:From:Subject:Message-Id; b=eK+B5wrVL210lGmpFvklst4HlCZmpWvSxbk1axsFEfgJhzVW3DVV5LpMDBrzbWkN6j6GFOyrop2VP8FXt20hfeU+iHd/vcDVBAcfINylJk4xI0X972ss/ClZOGauJ8NLRKGgSAdmMJ14k4FVi5CY84YaVMio34W64I6AObHboSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KeVlsv5S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KeVlsv5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4347FC4CEC4;
	Mon, 16 Sep 2024 06:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726467202;
	bh=JYZRODKgdxkes/IfTkXRwXFObLdiiDR9HqWImMNHNJY=;
	h=Date:To:From:Subject:From;
	b=KeVlsv5SPrQ8sMNSS+B2oXgeEGuxBNczx0tSZ7TtwfBinDRwfyAAypDIXWJgL/N9q
	 bdaJkv1nrzOaw+l+9Fx51BBCNi0vEY4nexwEwjWVGQJw16pgTz08Kk7Z+5x2S/ZIDT
	 1aqgmpojIAWazC6QJ2QypmminR7bOEgEv8E7AzDo=
Date: Sun, 15 Sep 2024 23:13:19 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,weixugc@google.com,tjmercier@google.com,kasong@tencent.com,linuszeng@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-wake-up-flushers-conditionally-to-avoid-cgroup-oom.patch added to mm-unstable branch
Message-Id: <20240916061322.4347FC4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: wake up flushers conditionally to avoid cgroup OOM
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-wake-up-flushers-conditionally-to-avoid-cgroup-oom.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-wake-up-flushers-conditionally-to-avoid-cgroup-oom.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/mm/vmscan.c~mm-vmscan-wake-up-flushers-conditionally-to-avoid-cgroup-oom
+++ a/mm/vmscan.c
@@ -4284,6 +4284,7 @@ static bool sort_folio(struct lruvec *lr
 		       int tier_idx)
 {
 	bool success;
+	bool dirty, writeback;
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
@@ -4332,6 +4333,9 @@ static bool sort_folio(struct lruvec *lr
 	/* waiting for writeback */
 	if (folio_test_locked(folio) || folio_test_writeback(folio) ||
 	    (type == LRU_GEN_FILE && folio_test_dirty(folio))) {
+		folio_check_dirty_writeback(folio, &dirty, &writeback);
+		if (dirty && !writeback)
+			sc->nr.unqueued_dirty += delta;
 		gen = folio_inc_gen(lruvec, folio, true);
 		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
 		return true;
@@ -4448,6 +4452,7 @@ static int scan_folios(struct lruvec *lr
 				scanned, skipped, isolated,
 				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
+	sc->nr.taken += isolated;
 	/*
 	 * There might not be eligible folios due to reclaim_idx. Check the
 	 * remaining to prevent livelock if it's not making progress.
@@ -4920,6 +4925,14 @@ static void lru_gen_shrink_lruvec(struct
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
mm-vmscan-wake-up-flushers-conditionally-to-avoid-cgroup-oom.patch

