From: akpm@linux-foundation.org
Subject: [merged]
 mm-fork-make-dup_mmap-wait-for-mmap_sem-for-write-killable.patch removed
 from -mm tree
Date: Fri, 27 May 2016 11:44:51 -0700
Message-ID: <574895a3.VBD5AQ+teg4eXZz0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42644 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbcE0Sow (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:44:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, koct9i@gmail.com, mingo@kernel.org, oleg@redhat.com, peterz@infradead.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, fork: make dup_mmap wait for mmap_sem for write killable
has been removed from the -mm tree.  Its filename was
     mm-fork-make-dup_mmap-wait-for-mmap_sem-for-write-killable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from mhocko@suse.com are

oom_reaper-close-race-with-exiting-task.patch

