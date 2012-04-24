From: akpm@linux-foundation.org
Subject: + mm-fork-fix-overflow-in-vma-length-when-copying-mmap-on-clone.patch added to -mm tree
Date: Tue, 24 Apr 2012 12:31:56 -0700
Message-ID: <20120424193156.E75C4A05C5@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:35895 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757114Ab2DXTb7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Apr 2012 15:31:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: siddhesh.poyarekar@gmail.com, a.p.zijlstra@chello.nl, axboe@kernel.dk, hughd@google.com, oleg@redhat.com, stable@vger.kernel.org, tj@kernel.org


The patch titled
     Subject: mm/fork: fix overflow in vma length when copying mmap on clone
has been added to the -mm tree.  Its filename is
     mm-fork-fix-overflow-in-vma-length-when-copying-mmap-on-clone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -358,7 +358,8 @@ static int dup_mmap(struct mm_struct *mm
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
Subject: Subject: mm/fork: fix overflow in vma length when copying mmap on clone

Patches currently in -mm which might be from siddhesh.poyarekar@gmail.com are

mm-fork-fix-overflow-in-vma-length-when-copying-mmap-on-clone.patch

