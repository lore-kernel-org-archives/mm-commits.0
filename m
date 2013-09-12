From: akpm@linux-foundation.org
Subject: [merged] ipc-shm-guard-against-non-existant-vma-in-shmdt2.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:51:01 -0700
Message-ID: <52321b25.urHBvl4qA6xOcnf6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58826 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200Ab3ILTvd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:51:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sedat.dilek@gmail.com, riel@redhat.com, manfred@colorfullife.com, davidlohr.bueso@hp.com

Subject: [merged] ipc-shm-guard-against-non-existant-vma-in-shmdt2.patch removed from -mm tree
To: davidlohr.bueso@hp.com,manfred@colorfullife.com,riel@redhat.com,sedat.dilek@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:51:01 -0700


The patch titled
     Subject: ipc, shm: guard against non-existant vma in shmdt(2)
has been removed from the -mm tree.  Its filename was
     ipc-shm-guard-against-non-existant-vma-in-shmdt2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: ipc, shm: guard against non-existant vma in shmdt(2)

When !CONFIG_MMU there's a chance we can derefence a NULL pointer when the
VM area isn't found - check the return value of find_vma().

Also, remove the redundant -EINVAL return: retval is set to the proper
return code and *only* changed to 0, when we actually unmap the segments.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN ipc/shm.c~ipc-shm-guard-against-non-existant-vma-in-shmdt2 ipc/shm.c
--- a/ipc/shm.c~ipc-shm-guard-against-non-existant-vma-in-shmdt2
+++ a/ipc/shm.c
@@ -1288,8 +1288,7 @@ SYSCALL_DEFINE1(shmdt, char __user *, sh
 #else /* CONFIG_MMU */
 	/* under NOMMU conditions, the exact address to be destroyed must be
 	 * given */
-	retval = -EINVAL;
-	if (vma->vm_start == addr && vma->vm_ops == &shm_vm_ops) {
+	if (vma && vma->vm_start == addr && vma->vm_ops == &shm_vm_ops) {
 		do_munmap(mm, vma->vm_start, vma->vm_end - vma->vm_start);
 		retval = 0;
 	}
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

origin.patch

