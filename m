Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99CB3955EB;
	Wed, 14 Oct 2026 03:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791948660; cv=none; b=qFd8sxBIqnO7f3Xl8ob8wGbp5bDZEfFYJTqcNkT9NI5p5ekcT/NqE/21ajsOKnKtx2DdkvPJa0N1A3VY0cZAOdqOrYwcWvcy1zEvb/zmoXiwqLX2qH4m4BRPMj3ORpH0Z6ExjE0Hgo/GldtzTeOlaMFM+ULwRRQD9QwBLD93PDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791948660; c=relaxed/simple;
	bh=ktpjSlgEr0jrayxvMGbvWwLreEoD8U03jS4+D2Q5RQ0=;
	h=Date:To:From:Subject:Message-Id; b=rP3jOK1C7XqdZHzmlCZCONHNd57HxuWXHKL0wT5+JTEVqDtIMEfmd7QwNdTvIVjyWz2BK9p8pGfX7fC8RhJFRcqdr6xPFbY4FGfe2YrMw4Uge3+/1OJJY6f7NtREWth3xf32uZnTwAW1HSl6SNfKvSrs45zQRaPRLWn1YlnW8ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ESCRtI/t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ESCRtI/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59CEC1F000FF;
	Wed, 14 Oct 2026 03:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791948658;
	bh=b0S7yxWpPrrRz5Qq2W7qhsV9xUwqFYGzl7wz5NRz2QA=;
	h=Date:To:From:Subject;
	b=ESCRtI/tgRMALcp6JwYvGN71yv8l5OHOeoALLhqShXYTsthpjO4ezeCt5F9g6kDSM
	 /TflmR+ugyYYfPbzd5W8VLoVLhHcHSmw40tqGDWUykGyLvk0ekpy173YFAvmwDNiUh
	 6ygWw5Ybtb4FmkybCwJ3fDl1X/z8xYfuBDbPk/mM=
Date: Tue, 13 Oct 2026 20:30:57 -0700
To: mm-commits@vger.kernel.org,sunil.mushran@oracle.com,stable@vger.kernel.org,mark@fasheh.com,kees@kernel.org,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jjzuming@gmail.com,heming.zhao@suse.com,baijiaju1990@gmail.com,zzzccc427@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-dlm-hold-a-lock-reference-across-grant-ast-enqueue.patch added to mm-nonmm-unstable branch
Message-Id: <20261014033058.59CEC1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2/dlm: hold a lock reference across grant AST enqueue
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-dlm-hold-a-lock-reference-across-grant-ast-enqueue.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-dlm-hold-a-lock-reference-across-grant-ast-enqueue.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Cen Zhang <zzzccc427@gmail.com>
Subject: ocfs2/dlm: hold a lock reference across grant AST enqueue
Date: Tue, 13 Oct 2026 23:39:29 +0800

A newly granted remote lock must remain alive until its grant AST is
queued.  dlmlock_master() publishes the lock on res->granted with its base
and queue references, then drops res->spinlock before calling
dlm_queue_ast().  The resource's reserved AST count does not retain the
lock itself.

This can fail when a peer dies with an immediately grantable CREATE
buffered on its socket.  O2NET's node-down callback flushes receive work
before DLM cleanup, but the flush only waits for work queued on entry.  A
data-ready callback that already selected the socket container can queue
new receive work after the flush advances its work color.  Socket shutdown
does not discard bytes already queued for TCP receive.

The late receive work and DLM node-down cleanup can interleave as
follows (the lock reference operations shown are before this fix):

  Socket data-ready        Node-down thread         Receive worker
  -----------------        ----------------         --------------
  o2net_data_ready()
    select sc under
    callback read lock
                           o2net_disconnect_node()
                             queue shutdown
                             begin flush; new color
    queue sc_rx_work
    in the new color
    release callback lock
                             shutdown socket
                             flush returns
                                                    read buffered CREATE
                                                    dlmlock_master()
                                                      lock res->spinlock
                                                      add lock to granted
                                                      unlock res->spinlock
                           DLM node-down cleanup
                             lock res->spinlock
                             dlm_free_dead_locks()
                               unlink lock
                               put queue/base refs
                               free lock
                             unlock res->spinlock
                                                    dlm_queue_ast()
                                                      __dlm_queue_ast()
                                                      read lock->lockres
                                                      (use-after-free)

DLM cleanup holds res->spinlock while dlm_free_dead_locks() drops the
queue and base references.  The CREATE handler no longer holds that
spinlock when __dlm_queue_ast() reads the lock, before taking its AST list
reference.

Take a temporary lock reference under res->spinlock when a grant AST will
be queued, and drop it after dlm_queue_ast().  This keeps the lock alive
across cleanup until the AST path has taken its own reference, without
reversing the existing AST/resource lock order.

KASAN report as below:

    BUG: KASAN: slab-use-after-free in __dlm_queue_ast+0x8a4/0xc00
    Read of size 8 at addr ffff88810ead5940 by task kworker/u16:3/52

    CPU: 3 UID: 0 PID: 52 Comm: kworker/u16:3 Not tainted 7.3.0-rc4-next-20260921-pmb-bt-functional-v1+ #1 PREEMPT(lazy)
    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
    Workqueue: o2net o2net_rx_until_empty
    Call Trace:
     <TASK>
     dump_stack_lvl+0x93/0xd0
     print_report+0xce/0x630
     ? __dlm_queue_ast+0x8a4/0xc00
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __virt_addr_valid+0x20e/0x420
     ? __dlm_queue_ast+0x8a4/0xc00
     kasan_report+0xe0/0x110
     ? __dlm_queue_ast+0x8a4/0xc00
     __dlm_queue_ast+0x8a4/0xc00
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? do_raw_spin_lock+0x130/0x270
     ? __pfx___dlm_queue_ast+0x10/0x10
     ? __pfx_do_raw_spin_lock+0x10/0x10
     ? _raw_spin_unlock_irqrestore+0x45/0x60
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lockdep_hardirqs_on_prepare+0xeb/0x1a0
     dlm_queue_ast+0x46/0x70
     dlmlock_master+0x51f/0xf50
     ? __pfx_dlmlock_master+0x10/0x10
     ? dlm_create_lock_handler+0x2b2/0x870
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_release+0xc8/0x290
     dlm_create_lock_handler+0x35b/0x870
     ? __pfx_dlm_create_lock_handler+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? trace_hardirqs_on+0x18/0x160
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? kvm_clock_get_cycles+0x31/0x60
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_dlm_create_lock_handler+0x10/0x10
     o2net_rx_until_empty+0x1dae/0x32c0
     ? reacquire_held_locks+0xdd/0x200
     ? __pfx_o2net_rx_until_empty+0x10/0x10
     ? lock_acquire+0x190/0x300
     ? process_one_work+0x935/0x1b40
     ? process_one_work+0x834/0x1b40
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_release+0xc8/0x290
     ? srso_alias_return_thunk+0x5/0xfbef5
     process_one_work+0x9a8/0x1b40
     ? __pfx_process_one_work+0x10/0x10
     ? lock_acquire+0x190/0x300
     ? lock_is_held_type+0x8f/0x100
     ? srso_alias_return_thunk+0x5/0xfbef5
     worker_thread+0x65c/0xe40
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __kthread_parkme+0x177/0x220
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_worker_thread+0x10/0x10
     kthread+0x351/0x460
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_kthread+0x10/0x10
     ret_from_fork+0x659/0x940
     ? __pfx_ret_from_fork+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __switch_to+0x74f/0xf70
     ? __pfx_kthread+0x10/0x10
     ret_from_fork_asm+0x1a/0x30
     </TASK>

    Allocated by task 52:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     __kasan_slab_alloc+0x89/0x90
     kmem_cache_alloc_noprof+0x20b/0x5c0
     dlm_new_lock+0x39/0x5f0
     dlm_create_lock_handler+0x16e/0x870
     o2net_rx_until_empty+0x1dae/0x32c0
     process_one_work+0x9a8/0x1b40
     worker_thread+0x65c/0xe40
     kthread+0x351/0x460
     ret_from_fork+0x659/0x940
     ret_from_fork_asm+0x1a/0x30

    Freed by task 603:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     kasan_save_free_info+0x3b/0x60
     __kasan_slab_free+0x5f/0x80
     kmem_cache_free+0x242/0x580
     dlm_lock_release+0x1df/0x2f0
     dlm_lock_put+0x51/0x80
     __dlm_hb_node_down+0x15be/0x2710
     dlm_hb_node_down_cb+0x6c/0xa0
     o2hb_run_event_list+0x34a/0x500
     o2hb_do_disk_heartbeat+0x1a07/0x2950
     o2hb_thread+0x1ed/0xdc0
     kthread+0x351/0x460
     ret_from_fork+0x659/0x940
     ret_from_fork_asm+0x1a/0x30

    The buggy address belongs to the object at ffff88810ead5900
     which belongs to the cache o2dlm_lock of size 184
    The buggy address is located 64 bytes inside of
     freed 184-byte region [ffff88810ead5900, ffff88810ead59b8)

    [Page and shadow memory dumps omitted.]

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0043-v5-1ad07df761ff49638789@gmail.com
Fixes: 2c5c54aca9d0 ("ocfs2/dlm: Add missing dlm_lock_put()s")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Sunil Mushran <sunil.mushran@oracle.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/dlm/dlmlock.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/dlm/dlmlock.c~ocfs2-dlm-hold-a-lock-reference-across-grant-ast-enqueue
+++ a/fs/ocfs2/dlm/dlmlock.c
@@ -138,6 +138,8 @@ static enum dlm_status dlmlock_master(st
 					  res->lockname.len)) {
 			kick_thread = 1;
 			call_ast = 1;
+			/* Keep the lock alive through AST enqueue. */
+			dlm_lock_get(lock);
 		} else {
 			mlog(0, "%s: returning DLM_NORMAL to "
 			     "node %u for reco lock\n", dlm->name,
@@ -166,10 +168,12 @@ static enum dlm_status dlmlock_master(st
 	wake_up(&res->wq);
 
 	/* either queue the ast or release it */
-	if (call_ast)
+	if (call_ast) {
 		dlm_queue_ast(dlm, lock);
-	else
+		dlm_lock_put(lock);
+	} else {
 		dlm_lockres_release_ast(dlm, res);
+	}
 
 	dlm_lockres_calc_usage(dlm, res);
 	if (kick_thread)
_

Patches currently in -mm which might be from zzzccc427@gmail.com are

ocfs2-heartbeat-unlink-live-slots-when-their-node-is-missing.patch
ocfs2-initialize-status-waiters-before-publishing-them.patch
ocfs2-publish-the-filecheck-owner-before-adding-sysfs-attributes.patch
ocfs2-dlm-hold-a-lock-reference-across-grant-ast-enqueue.patch

