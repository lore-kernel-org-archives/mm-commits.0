From: akpm@linux-foundation.org
Subject: [patch 72/84] mm, proc: make clear_refs killable
Date: Mon, 23 May 2016 16:25:45 -0700
Message-ID: <57439179.eE6l4EPMZiM660IF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42397 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbcEWXZq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:25:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, oleg@redhat.com, petrcermak@chromium.org, vbabka@suse.cz

From: Michal Hocko <mhocko@suse.com>
Subject: mm, proc: make clear_refs killable

CLEAR_REFS_MM_HIWATER_RSS and CLEAR_REFS_SOFT_DIRTY are relying on
mmap_sem for write.  If the waiting task gets killed by the oom killer and
it would operate on the current's mm it would block oom_reaper from
asynchronous address space reclaim and reduce the chances of timely OOM
resolving.  Wait for the lock in the killable mode and return with EINTR
if the task got killed while waiting.  This will also expedite the return
to the userspace and do_exit even if the mm is remote.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Petr Cermak <petrcermak@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-proc-make-clear_refs-killable fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-proc-make-clear_refs-killable
+++ a/fs/proc/task_mmu.c
@@ -1027,11 +1027,15 @@ static ssize_t clear_refs_write(struct f
 		};
 
 		if (type == CLEAR_REFS_MM_HIWATER_RSS) {
+			if (down_write_killable(&mm->mmap_sem)) {
+				count = -EINTR;
+				goto out_mm;
+			}
+
 			/*
 			 * Writing 5 to /proc/pid/clear_refs resets the peak
 			 * resident set size to this mm's current rss value.
 			 */
-			down_write(&mm->mmap_sem);
 			reset_mm_hiwater_rss(mm);
 			up_write(&mm->mmap_sem);
 			goto out_mm;
@@ -1043,7 +1047,10 @@ static ssize_t clear_refs_write(struct f
 				if (!(vma->vm_flags & VM_SOFTDIRTY))
 					continue;
 				up_read(&mm->mmap_sem);
-				down_write(&mm->mmap_sem);
+				if (down_write_killable(&mm->mmap_sem)) {
+					count = -EINTR;
+					goto out_mm;
+				}
 				for (vma = mm->mmap; vma; vma = vma->vm_next) {
 					vma->vm_flags &= ~VM_SOFTDIRTY;
 					vma_set_page_prot(vma);
_
