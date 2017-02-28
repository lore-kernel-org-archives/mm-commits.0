From: akpm@linux-foundation.org
Subject: + userfaultfd-non-cooperative-rollback-userfaultfd_exit.patch
 added to -mm tree
Date: Tue, 28 Feb 2017 14:13:31 -0800
Message-ID: <58b5f60b.ChmVytXgNnuWdatK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35804 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751446AbdCACMQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 21:12:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: non-cooperative: rollback userfaultfd_exit
has been added to the -mm tree.  Its filename is
     userfaultfd-non-cooperative-rollback-userfaultfd_exit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-non-cooperative-rollback-userfaultfd_exit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-non-cooperative-rollback-userfaultfd_exit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: non-cooperative: rollback userfaultfd_exit

Patch series "userfaultfd non-cooperative further update for 4.11 merge window".

Unfortunately I noticed one relevant bug in userfaultfd_exit while doing
more testing.  I've been doing testing before and this was also tested by
kbuild bot and exercised by the selftest, but this bug never reproduced
before.

I dropped userfaultfd_exit as result.  I dropped it because of
implementation difficulty in receiving signals in __mmput and because I
think -ENOSPC as result from the background UFFDIO_COPY should be enough
already.

Before I decided to remove userfaultfd_exit, I noticed userfaultfd_exit
wasn't exercised by the selftest and when I tried to exercise it, after
moving it to a more correct place in __mmput where it would make more
sense and where the vma list is stable, it resulted in the
event_wait_completion in D state.  So then I added the second patch to be
sure even if we call userfaultfd_event_wait_completion too late during
task exit(), we won't risk to generate tasks in D state.  The same check
exists in handle_userfault() for the same reason, except it makes a
difference there, while here is just a robustness check and it's run under
WARN_ON_ONCE.

While looking at the userfaultfd_event_wait_completion() function I looked
back at its callers too while at it and I think it's not ok to stop
executing dup_fctx on the fcs list because we relay on
userfaultfd_event_wait_completion to execute
userfaultfd_ctx_put(fctx->orig) which is paired against
userfaultfd_ctx_get(fctx->orig) in dup_userfault just before
list_add(fcs).  This change only takes care of fctx->orig but this area
also needs further review looking for similar problems in fctx->new.

The only patch that is urgent is the first because it's an use after free
during a SMP race condition that affects all processes if
CONFIG_USERFAULTFD=y.  Very hard to reproduce though and probably
impossible without SLUB poisoning enabled.


This patch (of 3):

I once reproduced this oops with the userfaultfd selftest, it's not easily
reproducible and it requires SLUB poisoning to reproduce.

general protection fault: 0000 [#1] SMP
Modules linked in:
CPU: 2 PID: 18421 Comm: userfaultfd Tainted: G               ------------ T 3.10.0+ #15
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.10.1-0-g8891697-prebuilt.qemu-project.org 04/01/2014
task: ffff8801f83b9440 ti: ffff8801f833c000 task.ti: ffff8801f833c000
RIP: 0010:[<ffffffff81451299>]  [<ffffffff81451299>] userfaultfd_exit+0x29/0xa0
RSP: 0018:ffff8801f833fe80  EFLAGS: 00010202
RAX: ffff8801f833ffd8 RBX: 6b6b6b6b6b6b6b6b RCX: ffff8801f83b9440
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8800baf18600
RBP: ffff8801f833fee8 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000000 R11: ffffffff8127ceb3 R12: 0000000000000000
R13: ffff8800baf186b0 R14: ffff8801f83b99f8 R15: 00007faed746c700
FS:  0000000000000000(0000) GS:ffff88023fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007faf0966f028 CR3: 0000000001bc6000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Stack:
 ffffffff8127cec6 0000000000000001 0000000000000286 ffff8801f833fed0
 0000000000000286 ffff8801f83b99f8 ffff8800baf18600 ffff8800baf186b0
 ffff8801f83b99f8 ffff8801f83b99f8 ffff8801f833fee8 ffff8801f83b9440
Call Trace:
 [<ffffffff8127cec6>] ? do_exit+0x276/0xd10
 [<ffffffff8127cee7>] do_exit+0x297/0xd10
 [<ffffffff8137d113>] ? context_tracking_user_exit+0x13/0x20
 [<ffffffff8121c5ed>] ? syscall_trace_enter+0x13d/0x300
 [<ffffffff8127eda7>] SyS_exit+0x17/0x20
 [<ffffffff8183edeb>] tracesys+0xdd/0xe2
Code: 00 00 66 66 66 66 90 55 48 89 e5 41 54 53 48 83 ec 58 48 8b 1f 48 85 db 75 11 eb 73 66 0f 1f 44 00 00 48 8b 5b 10 48 85 db 74 64 <4c> 8b a3 b8 00 00 00 4d 85 e4 74 eb 41 f6 84 24 2c 01 00 00 80
RIP  [<ffffffff81451299>] userfaultfd_exit+0x29/0xa0
 RSP <ffff8801f833fe80>
---[ end trace 9fecd6dcb442846a ]---

In the debugger I located the "mm" pointer in the stack and walking
mm->mmap->vm_next through the end shows the vma->vm_next list is fully
consistent and it is null terminated list as expected. So this has to
be an SMP race condition where userfaultfd_exit was running while the
vma list was being modified by another CPU.

When userfaultfd_exit() run one of the ->vm_next pointers pointed to
SLAB_POISON (RBX is the vma pointer and is 0x6b6b..).

The reason is that it's not running in __mmput but while there are
still other threads running and it's not holding the mmap_sem (it
can't as it has to wait the even to be received by the manager). So
this is an use after free that was happening for all processes.

One more implementation problem aside from the race condition:
userfaultfd_exit has really to check a flag in mm->flags before
walking the vma or it's going to slowdown the exit() path for regular
tasks.

One more implementation problem: at that point signals can't be
delivered so it would also create a task in D state if the manager
doesn't read the event.

The major design issue: it overall looks superfluous as the manager
can check for -ENOSPC in the background transfer:

	if (mmget_not_zero(ctx->mm)) {
[..]
	} else {
		return -ENOSPC;
	}

It's safer to roll it back and re-introduce it later if at all.

Link: http://lkml.kernel.org/r/20170224181957.19736-2-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c                 |   28 ----------------------------
 include/linux/userfaultfd_k.h    |    6 ------
 include/uapi/linux/userfaultfd.h |    5 +----
 kernel/exit.c                    |    1 -
 4 files changed, 1 insertion(+), 39 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-non-cooperative-rollback-userfaultfd_exit fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-non-cooperative-rollback-userfaultfd_exit
+++ a/fs/userfaultfd.c
@@ -774,34 +774,6 @@ void userfaultfd_unmap_complete(struct m
 	}
 }
 
-void userfaultfd_exit(struct mm_struct *mm)
-{
-	struct vm_area_struct *vma = mm->mmap;
-
-	/*
-	 * We can do the vma walk without locking because the caller
-	 * (exit_mm) knows it now has exclusive access
-	 */
-	while (vma) {
-		struct userfaultfd_ctx *ctx = vma->vm_userfaultfd_ctx.ctx;
-
-		if (ctx && (ctx->features & UFFD_FEATURE_EVENT_EXIT)) {
-			struct userfaultfd_wait_queue ewq;
-
-			userfaultfd_ctx_get(ctx);
-
-			msg_init(&ewq.msg);
-			ewq.msg.event = UFFD_EVENT_EXIT;
-
-			userfaultfd_event_wait_completion(ctx, &ewq);
-
-			ctx->features &= ~UFFD_FEATURE_EVENT_EXIT;
-		}
-
-		vma = vma->vm_next;
-	}
-}
-
 static int userfaultfd_release(struct inode *inode, struct file *file)
 {
 	struct userfaultfd_ctx *ctx = file->private_data;
diff -puN include/linux/userfaultfd_k.h~userfaultfd-non-cooperative-rollback-userfaultfd_exit include/linux/userfaultfd_k.h
--- a/include/linux/userfaultfd_k.h~userfaultfd-non-cooperative-rollback-userfaultfd_exit
+++ a/include/linux/userfaultfd_k.h
@@ -72,8 +72,6 @@ extern int userfaultfd_unmap_prep(struct
 extern void userfaultfd_unmap_complete(struct mm_struct *mm,
 				       struct list_head *uf);
 
-extern void userfaultfd_exit(struct mm_struct *mm);
-
 #else /* CONFIG_USERFAULTFD */
 
 /* mm helpers */
@@ -139,10 +137,6 @@ static inline void userfaultfd_unmap_com
 {
 }
 
-static inline void userfaultfd_exit(struct mm_struct *mm)
-{
-}
-
 #endif /* CONFIG_USERFAULTFD */
 
 #endif /* _LINUX_USERFAULTFD_K_H */
diff -puN include/uapi/linux/userfaultfd.h~userfaultfd-non-cooperative-rollback-userfaultfd_exit include/uapi/linux/userfaultfd.h
--- a/include/uapi/linux/userfaultfd.h~userfaultfd-non-cooperative-rollback-userfaultfd_exit
+++ a/include/uapi/linux/userfaultfd.h
@@ -18,8 +18,7 @@
  * means the userland is reading).
  */
 #define UFFD_API ((__u64)0xAA)
-#define UFFD_API_FEATURES (UFFD_FEATURE_EVENT_EXIT |		\
-			   UFFD_FEATURE_EVENT_FORK |		\
+#define UFFD_API_FEATURES (UFFD_FEATURE_EVENT_FORK |		\
 			   UFFD_FEATURE_EVENT_REMAP |		\
 			   UFFD_FEATURE_EVENT_REMOVE |	\
 			   UFFD_FEATURE_EVENT_UNMAP |		\
@@ -113,7 +112,6 @@ struct uffd_msg {
 #define UFFD_EVENT_REMAP	0x14
 #define UFFD_EVENT_REMOVE	0x15
 #define UFFD_EVENT_UNMAP	0x16
-#define UFFD_EVENT_EXIT		0x17
 
 /* flags for UFFD_EVENT_PAGEFAULT */
 #define UFFD_PAGEFAULT_FLAG_WRITE	(1<<0)	/* If this was a write fault */
@@ -163,7 +161,6 @@ struct uffdio_api {
 #define UFFD_FEATURE_MISSING_HUGETLBFS		(1<<4)
 #define UFFD_FEATURE_MISSING_SHMEM		(1<<5)
 #define UFFD_FEATURE_EVENT_UNMAP		(1<<6)
-#define UFFD_FEATURE_EVENT_EXIT			(1<<7)
 	__u64 features;
 
 	__u64 ioctls;
diff -puN kernel/exit.c~userfaultfd-non-cooperative-rollback-userfaultfd_exit kernel/exit.c
--- a/kernel/exit.c~userfaultfd-non-cooperative-rollback-userfaultfd_exit
+++ a/kernel/exit.c
@@ -548,7 +548,6 @@ static void exit_mm(void)
 	enter_lazy_tlb(mm, current);
 	task_unlock(current);
 	mm_update_next_owner(mm);
-	userfaultfd_exit(mm);
 	mmput(mm);
 	if (test_thread_flag(TIF_MEMDIE))
 		exit_oom_victim();
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-shmem-__do_fault-requires-vm_fault_nopage.patch
userfaultfd-non-cooperative-rollback-userfaultfd_exit.patch
userfaultfd-non-cooperative-robustness-check.patch
userfaultfd-non-cooperative-release-all-ctx-in-dup_userfaultfd_complete.patch

