From: akpm@linux-foundation.org
Subject: [patch 80/84] uprobes: wait for mmap_sem for write killable
Date: Mon, 23 May 2016 16:26:08 -0700
Message-ID: <57439190.h6B75UG/kz54gvSu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42446 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbcEWX0J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:26:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, oleg@redhat.com, vbabka@suse.cz

From: Michal Hocko <mhocko@suse.com>
Subject: uprobes: wait for mmap_sem for write killable

xol_add_vma needs mmap_sem for write.  If the waiting task gets killed by
the oom killer it would block oom_reaper from asynchronous address space
reclaim and reduce the chances of timely OOM resolving.  Wait for the lock
in the killable mode and return with EINTR if the task got killed while
waiting.

Do not warn in dup_xol_work if __create_xol_area failed due to fatal
signal pending because this is usually considered a kernel issue.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/uprobes.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN kernel/events/uprobes.c~uprobes-wait-for-mmap_sem-for-write-killable kernel/events/uprobes.c
--- a/kernel/events/uprobes.c~uprobes-wait-for-mmap_sem-for-write-killable
+++ a/kernel/events/uprobes.c
@@ -1130,7 +1130,9 @@ static int xol_add_vma(struct mm_struct
 	struct vm_area_struct *vma;
 	int ret;
 
-	down_write(&mm->mmap_sem);
+	if (down_write_killable(&mm->mmap_sem))
+		return -EINTR;
+
 	if (mm->uprobes_state.xol_area) {
 		ret = -EALREADY;
 		goto fail;
@@ -1469,7 +1471,8 @@ static void dup_xol_work(struct callback
 	if (current->flags & PF_EXITING)
 		return;
 
-	if (!__create_xol_area(current->utask->dup_xol_addr))
+	if (!__create_xol_area(current->utask->dup_xol_addr) &&
+			!fatal_signal_pending(current))
 		uprobe_warn(current, "dup xol area");
 }
 
_
