Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDE3192B8F;
	Fri,  6 Dec 2024 03:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733457340; cv=none; b=HeLP9t6zmDdV2JK37C/wouSauUmumd/bMMFHWLPiEA9GzFE0j9h6sfw4X0+BOS353Zbl1iKLRB6Xty0mn4qUuuh/hKXWxALMU/Gp8a91jhjWq9MqAgJLnRFfyT8I/DYjM0mo06s1aJiCeutq6e+gHoxMSnRyylFBR7fU7DYPzQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733457340; c=relaxed/simple;
	bh=Dh/eGzXc5wluzYLzlFtJSaV9/en8u1GHFxV/ZbKbwTY=;
	h=Date:To:From:Subject:Message-Id; b=TBpY9L9szfvtvn4VlftD2Z/gsOPzYoJODJ5zOEnI0aaXPppLTYpFEkQjz9BaRwbvwat8kC/TcD/YQXVMdFx/rf6Ebg6srBnDOTt/hjxBVBZZyuZMwt5evMf7bRBv4hDD0wsI4uXqQ3LPqFDDwbafdSA5rz8nIYQdPnWBTxtglqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oraNsZ0a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oraNsZ0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A242FC4CED1;
	Fri,  6 Dec 2024 03:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733457340;
	bh=Dh/eGzXc5wluzYLzlFtJSaV9/en8u1GHFxV/ZbKbwTY=;
	h=Date:To:From:Subject:From;
	b=oraNsZ0ao/pS3OZYH2JnHBaevOphe4sqTWLkcTzrlQtEPrO6YqjDZGpWgZEna9tdF
	 Xc7a41WUmTuYUHeaGNgVvht69cg60mHI+tWMMwqBjR5G0hfJiu8oYXXQh7EW3Vofjs
	 8M1j52riuSl+cECUKIJzAaYEa3elQaSw04G7MECU=
Date: Thu, 05 Dec 2024 19:55:40 -0800
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@suse.cz,sunjw10@lenovo.com,stable@vger.kernel.org,rostedt@goodmis.org,raghavendra.kt@amd.com,peterz@infradead.org,mingo@redhat.com,mgorman@suse.de,juri.lelli@redhat.com,dietmar.eggemann@arm.com,bsegall@google.com,ahuang12@lenovo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] sched-numa-fix-memory-leak-due-to-the-overwritten-vma-numab_state.patch removed from -mm tree
Message-Id: <20241206035540.A242FC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sched/numa: fix memory leak due to the overwritten vma->numab_state
has been removed from the -mm tree.  Its filename was
     sched-numa-fix-memory-leak-due-to-the-overwritten-vma-numab_state.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Adrian Huang <ahuang12@lenovo.com>
Subject: sched/numa: fix memory leak due to the overwritten vma->numab_state
Date: Wed, 13 Nov 2024 18:21:46 +0800

[Problem Description]
When running the hackbench program of LTP, the following memory leak is
reported by kmemleak.

  # /opt/ltp/testcases/bin/hackbench 20 thread 1000
  Running with 20*40 (== 800) tasks.

  # dmesg | grep kmemleak
  ...
  kmemleak: 480 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
  kmemleak: 665 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

  # cat /sys/kernel/debug/kmemleak
  unreferenced object 0xffff888cd8ca2c40 (size 64):
    comm "hackbench", pid 17142, jiffies 4299780315
    hex dump (first 32 bytes):
      ac 74 49 00 01 00 00 00 4c 84 49 00 01 00 00 00  .tI.....L.I.....
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    backtrace (crc bff18fd4):
      [<ffffffff81419a89>] __kmalloc_cache_noprof+0x2f9/0x3f0
      [<ffffffff8113f715>] task_numa_work+0x725/0xa00
      [<ffffffff8110f878>] task_work_run+0x58/0x90
      [<ffffffff81ddd9f8>] syscall_exit_to_user_mode+0x1c8/0x1e0
      [<ffffffff81dd78d5>] do_syscall_64+0x85/0x150
      [<ffffffff81e0012b>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
  ...

This issue can be consistently reproduced on three different servers:
  * a 448-core server
  * a 256-core server
  * a 192-core server

[Root Cause]
Since multiple threads are created by the hackbench program (along with
the command argument 'thread'), a shared vma might be accessed by two or
more cores simultaneously. When two or more cores observe that
vma->numab_state is NULL at the same time, vma->numab_state will be
overwritten.

Although current code ensures that only one thread scans the VMAs in a
single 'numa_scan_period', there might be a chance for another thread
to enter in the next 'numa_scan_period' while we have not gotten till
numab_state allocation [1].

Note that the command `/opt/ltp/testcases/bin/hackbench 50 process 1000`
cannot the reproduce the issue. It is verified with 200+ test runs.

[Solution]
Use the cmpxchg atomic operation to ensure that only one thread executes
the vma->numab_state assignment.

[1] https://lore.kernel.org/lkml/1794be3c-358c-4cdc-a43d-a1f841d91ef7@amd.com/

Link: https://lkml.kernel.org/r/20241113102146.2384-1-ahuang12@lenovo.com
Fixes: ef6a22b70f6d ("sched/numa: apply the scan delay to every new vma")
Signed-off-by: Adrian Huang <ahuang12@lenovo.com>
Reported-by: Jiwei Sun <sunjw10@lenovo.com>
Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Ben Segall <bsegall@google.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/fair.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/kernel/sched/fair.c~sched-numa-fix-memory-leak-due-to-the-overwritten-vma-numab_state
+++ a/kernel/sched/fair.c
@@ -3399,10 +3399,16 @@ retry_pids:
 
 		/* Initialise new per-VMA NUMAB state. */
 		if (!vma->numab_state) {
-			vma->numab_state = kzalloc(sizeof(struct vma_numab_state),
-				GFP_KERNEL);
-			if (!vma->numab_state)
+			struct vma_numab_state *ptr;
+
+			ptr = kzalloc(sizeof(*ptr), GFP_KERNEL);
+			if (!ptr)
+				continue;
+
+			if (cmpxchg(&vma->numab_state, NULL, ptr)) {
+				kfree(ptr);
 				continue;
+			}
 
 			vma->numab_state->start_scan_seq = mm->numa_scan_seq;
 
_

Patches currently in -mm which might be from ahuang12@lenovo.com are


