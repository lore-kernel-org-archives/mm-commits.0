From: akpm@linux-foundation.org
Subject: [merged] mm-fork-fix-overflow-in-vma-length-when-copying-mmap-on-clone.patch removed from -mm tree
Date: Thu, 31 May 2012 12:14:09 -0700
Message-ID: <20120531191409.719E8A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:51242 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932823Ab2EaTOL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:14:11 -0400
Received: by were53 with SMTP id e53so75801wer.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:14:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: siddhesh.poyarekar@gmail.com, a.p.zijlstra@chello.nl, axboe@kernel.dk, hughd@google.com, oleg@redhat.com, stable@vger.kernel.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/fork: fix overflow in vma length when copying mmap on clone
has been removed from the -mm tree.  Its filename was
     mm-fork-fix-overflow-in-vma-length-when-copying-mmap-on-clone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Subject: mm/fork: fix overflow in vma length when copying mmap on clone

The vma length in dup_mmap is calculated and stored in a unsigned int,
which is insufficient and hence overflows for very large maps (beyond
16TB). The following program demonstrates this:

#include <stdio.h>
#include <unistd.h>
#include <sys/mman.h>

#define GIG 1024 * 1024 * 1024L
#define EXTENT 16393

int main(void)
{
        int i, r;
        void *m;
        char buf[1024];

        for (i = 0; i < EXTENT; i++) {
                m = mmap(NULL, (size_t) 1 * 1024 * 1024 * 1024L,
                         PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);

                if (m == (void *)-1)
                        printf("MMAP Failed: %d\n", m);
                else
                        printf("%d : MMAP returned %p\n", i, m);

                r = fork();

                if (r == 0) {
                        printf("%d: successed\n", i);
                        return 0;
                } else if (r < 0)
                        printf("FORK Failed: %d\n", r);
                else if (r > 0)
                        wait(NULL);
        }
        return 0;
}

Increase the storage size of the result to unsigned long, which is
sufficient for storing the difference between addresses.

Signed-off-by: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/fork.c~mm-fork-fix-overflow-in-vma-length-when-copying-mmap-on-clone kernel/fork.c
--- a/kernel/fork.c~mm-fork-fix-overflow-in-vma-length-when-copying-mmap-on-clone
+++ a/kernel/fork.c
@@ -386,7 +386,8 @@ static int dup_mmap(struct mm_struct *mm
 		}
 		charge = 0;
 		if (mpnt->vm_flags & VM_ACCOUNT) {
-			unsigned int len = (mpnt->vm_end - mpnt->vm_start) >> PAGE_SHIFT;
+			unsigned long len;
+			len = (mpnt->vm_end - mpnt->vm_start) >> PAGE_SHIFT;
 			if (security_vm_enough_memory_mm(oldmm, len)) /* sic */
 				goto fail_nomem;
 			charge = len;
_

Patches currently in -mm which might be from siddhesh.poyarekar@gmail.com are

origin.patch
c-r-prctl-drop-vma-flags-test-on-pr_set_mm_-stack-data-assignment.patch

