From: akpm@linux-foundation.org
Subject: +
 fork-fix-incorrect-fput-of-exe_file-causing-use-after-free.patch added to
 -mm tree
Date: Wed, 23 Aug 2017 14:42:38 -0700
Message-ID: <599df6ce.5uMYbFyhgGY+BGEb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42684 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751156AbdHWVmj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Aug 2017 17:42:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiggers@google.com, dvyukov@google.com, koct9i@gmail.com, mhocko@suse.com, mingo@kernel.org, oleg@redhat.com, peterz@infradead.org, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: fork: fix incorrect fput of ->exe_file causing use-after-free
has been added to the -mm tree.  Its filename is
     fork-fix-incorrect-fput-of-exe_file-causing-use-after-free.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fork-fix-incorrect-fput-of-exe_file-causing-use-after-free.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fork-fix-incorrect-fput-of-exe_file-causing-use-after-free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Biggers <ebiggers@google.com>
Subject: fork: fix incorrect fput of ->exe_file causing use-after-free

7c051267931a ("mm, fork: make dup_mmap wait for mmap_sem for write
killable") made it possible to kill a forking task while it is waiting to
acquire its ->mmap_sem for write, in dup_mmap().  However, it was
overlooked that this introduced an new error path before a reference is
taken on the mm_struct's ->exe_file.  Since the ->exe_file of the new
mm_struct was already set to the old ->exe_file by the memcpy() in
dup_mm(), it was possible for the mmput() in the error path of dup_mm() to
drop a reference to ->exe_file which was never taken.  This caused the
struct file to later be freed prematurely.

Fix it by updating mm_init() to NULL out the ->exe_file, in the same place
it clears other things like the list of mmaps.

This bug was found by syzkaller.  It can be reproduced using the
following C program:

    #define _GNU_SOURCE
    #include <pthread.h>
    #include <stdlib.h>
    #include <sys/mman.h>
    #include <sys/syscall.h>
    #include <sys/wait.h>
    #include <unistd.h>

    static void *mmap_thread(void *_arg)
    {
        for (;;) {
            mmap(NULL, 0x1000000, PROT_READ,
                 MAP_POPULATE|MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
        }
    }

    static void *fork_thread(void *_arg)
    {
        usleep(rand() % 10000);
        fork();
    }

    int main(void)
    {
        fork();
        fork();
        fork();
        for (;;) {
            if (fork() == 0) {
                pthread_t t;

                pthread_create(&t, NULL, mmap_thread, NULL);
                pthread_create(&t, NULL, fork_thread, NULL);
                usleep(rand() % 10000);
                syscall(__NR_exit_group, 0);
            }
            wait(NULL);
        }
    }

No special kernel config options are needed.  It usually causes a NULL
pointer dereference in __remove_shared_vm_struct() during exit, or in
dup_mmap() (which is usually inlined into copy_process()) during fork. 
Both are due to a vm_area_struct's ->vm_file being used after it's already
been freed.

Google Bug Id: 64772007

Link: http://lkml.kernel.org/r/20170823211408.31198-1-ebiggers3@gmail.com
Fixes: 7c051267931a ("mm, fork: make dup_mmap wait for mmap_sem for write killable")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>	[v4.7+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/fork.c~fork-fix-incorrect-fput-of-exe_file-causing-use-after-free kernel/fork.c
--- a/kernel/fork.c~fork-fix-incorrect-fput-of-exe_file-causing-use-after-free
+++ a/kernel/fork.c
@@ -806,6 +806,7 @@ static struct mm_struct *mm_init(struct
 	mm_init_cpumask(mm);
 	mm_init_aio(mm);
 	mm_init_owner(mm, p);
+	RCU_INIT_POINTER(mm->exe_file, NULL);
 	mmu_notifier_mm_init(mm);
 	init_tlb_flush_pending(mm);
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && !USE_SPLIT_PMD_PTLOCKS
_

Patches currently in -mm which might be from ebiggers@google.com are

mm-madvise-fix-freeing-of-locked-page-with-madv_free.patch
fork-fix-incorrect-fput-of-exe_file-causing-use-after-free.patch

