From: akpm@linux-foundation.org
Subject: [merged]
 ipc-shm-kill-the-historical-wrong-mm-start_stack-check.patch removed from
 -mm tree
Date: Tue, 14 Oct 2014 11:21:50 -0700
Message-ID: <543d69be.wIOY842KWed3lVKS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460AbaJNSVt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:21:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, davidlohr.bueso@hp.com, gorcunov@gmail.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/shm: kill the historical/wrong mm->start_stack check
has been removed from the -mm tree.  Its filename was
     ipc-shm-kill-the-historical-wrong-mm-start_stack-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: ipc/shm: kill the historical/wrong mm->start_stack check

do_shmat() is the only user of ->start_stack (proc just reports its
value), and this check looks ugly and wrong.

The reason for this check is not clear at all, and it wrongly assumes that
the stack can only grow down.

But the main problem is that in general mm->start_stack has nothing to do
with stack_vma->vm_start.  Not only the application can switch to another
stack and even unmap this area, setup_arg_pages() expands the stack
without updating mm->start_stack during exec().  This means that in the
likely case "addr > start_stack - size - PAGE_SIZE * 5" is simply
impossible after find_vma_intersection() == F, or the stack can't grow
anyway because of RLIMIT_STACK.

Many thanks to Hugh for his explanations.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN ipc/shm.c~ipc-shm-kill-the-historical-wrong-mm-start_stack-check ipc/shm.c
--- a/ipc/shm.c~ipc-shm-kill-the-historical-wrong-mm-start_stack-check
+++ a/ipc/shm.c
@@ -1172,13 +1172,6 @@ long do_shmat(int shmid, char __user *sh
 
 		if (find_vma_intersection(current->mm, addr, addr + size))
 			goto invalid;
-		/*
-		 * If shm segment goes below stack, make sure there is some
-		 * space left for the stack to grow (at least 4 pages).
-		 */
-		if (addr < current->mm->start_stack &&
-		    addr > current->mm->start_stack - size - PAGE_SIZE * 5)
-			goto invalid;
 	}
 
 	addr = do_mmap_pgoff(file, addr, size, prot, flags, 0, &populate);
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch

