From: akpm@linux-foundation.org
Subject: [patch 73/84] mm, fork: make dup_mmap wait for mmap_sem for write killable
Date: Mon, 23 May 2016 16:25:48 -0700
Message-ID: <5743917c.+htHwXctIAx8Qx3H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42407 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbcEWXZt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:25:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, koct9i@gmail.com, mingo@kernel.org, oleg@redhat.com, peterz@infradead.org, vbabka@suse.cz

From: Michal Hocko <mhocko@suse.com>
Subject: mm, fork: make dup_mmap wait for mmap_sem for write killable

dup_mmap needs to lock current's mm mmap_sem for write.  If the waiting
task gets killed by the oom killer it would block oom_reaper from
asynchronous address space reclaim and reduce the chances of timely OOM
resolving.  Wait for the lock in the killable mode and return with EINTR
if the task got killed while waiting.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN kernel/fork.c~mm-fork-make-dup_mmap-wait-for-mmap_sem-for-write-killable kernel/fork.c
--- a/kernel/fork.c~mm-fork-make-dup_mmap-wait-for-mmap_sem-for-write-killable
+++ a/kernel/fork.c
@@ -414,7 +414,10 @@ static int dup_mmap(struct mm_struct *mm
 	unsigned long charge;
 
 	uprobe_start_dup_mmap();
-	down_write(&oldmm->mmap_sem);
+	if (down_write_killable(&oldmm->mmap_sem)) {
+		retval = -EINTR;
+		goto fail_uprobe_end;
+	}
 	flush_cache_dup_mm(oldmm);
 	uprobe_dup_mmap(oldmm, mm);
 	/*
@@ -526,6 +529,7 @@ out:
 	up_write(&mm->mmap_sem);
 	flush_tlb_mm(oldmm);
 	up_write(&oldmm->mmap_sem);
+fail_uprobe_end:
 	uprobe_end_dup_mmap();
 	return retval;
 fail_nomem_anon_vma_fork:
_
