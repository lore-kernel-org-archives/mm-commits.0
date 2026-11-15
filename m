Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794709332;
	b=aWYxLyQtypLMVA9B3ZV9p/+uBpTuEVmCi+uZgqRcLo+PVZaALyOLF8uIQOzqym8LoT82
	 Ell5wK4Cy9f2FS+BWDMTS7Qkt0M7qINjGD8IOcVxUyCQAObZBGedCpcowPqwi1tGcZ8pk
	 0qOmCRd18kbYtOTsdxK1bI/XtyX9Hw3P7rnXXCnXa1hAHh6kkO2sZ5gn6O2L2AhJ+zjQa
	 LsJ0ocJ+VHmnFHkNPvctm2UQnxWnNosaxeN6JvhytDwl3rPpVFRKZIjtkp413sNEbDRul
	 DCksrXnkHBS+az1EiyJtVlwm0+4lXmFbV65329N776SmJC0L8CTDEVtNKXAdIf+wnKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794709332;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=IfTWypLcVl6tA97zFL+kaePGR2SJw+Mg/zWm4wpfJ8Y=;
	b=aJo3kiNMqTkkrW+oJTti4VNlpN31eQAsT7QCl3+2ylBvoFUjfv7qENuJ2liXHnglS+5p
	 TKHGrkla4kyaUqH1+Oi6Bm7cqihzf+YQG6UvxVvKLvPh6Pw58LNoX5aoAz/rfhWaL5nDr
	 D8768QSerA91t/ILRThqt0Dy/1X63/pW8bauBwj8+p784VT24NWqmVNxVQXKRnCYfpMYE
	 fkpY3lSmUPpf2iDwPN95yd00rQo09C5VMaIKPWOJW41jqr6EB3ngFpZRRm27DMBRLZN9q
	 sDnnvB4EHP/q2Kg5nn9lAduDfnnakJmzzdcskgZv/k+erOTIOhY0kWj4oxgwBLUIu9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MHFdZKtp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2D2606A323;
	Sun, 15 Nov 2026 02:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MHFdZKtp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127BA1F000C4;
	Sun, 15 Nov 2026 02:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794709332;
	bh=IfTWypLcVl6tA97zFL+kaePGR2SJw+Mg/zWm4wpfJ8Y=;
	h=Date:To:From:Subject;
	b=MHFdZKtp2V7e7okXCeFUB6hr9rLQk5evTUicZelXGAeCXm1GT4eCi2wF3Aao0y8qH
	 P2Dnim2CWRG/qdZu/JEo0mXfDzwaDQ/hVZfwuVbJ/jyPGbsjrcn9YtqhUXxFUUmPCT
	 BMN+ouJbREGgV57MWsciFtns+wi/lUePOS6G/hcw=
Date: Sat, 14 Nov 2026 18:22:11 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,
	moonafterrain@outlook.com,mark@fasheh.com,kurt.hackel@oracle.com,
	kees@kernel.org,julia.lawall@inria.fr,joseph.qi@linux.alibaba.com,
	jlbec@evilplan.org,jjzuming@gmail.com,brauner@kernel.org,
	baijiaju1990@gmail.com,zzzccc427@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-drain-domain-handlers-before-destroying-the-dlm-worker.patch added to mm-nonmm-unstable branch
Message-Id: <20261115022212.127BA1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: drain domain handlers before destroying the DLM worker
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-drain-domain-handlers-before-destroying-the-dlm-worker.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-drain-domain-handlers-before-destroying-the-dlm-worker.patch

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
Subject: ocfs2: drain domain handlers before destroying the DLM worker
Date: Fri,  9 Oct 2026 16:11:23 +0800

The domain workqueue must remain usable until every network handler that
can submit work has finished.  dlm_unregister_domain_handlers() removes
handlers from the o2net lookup tree, but an already referenced handler can
still run.  Its dlm_grab() reference pins the context, not dlm_worker.

On the final local domain disconnect, a migration receive callback can
have passed dlm_joined() before shutdown changes the domain state, yet
still be preparing its work item when teardown destroys the queue:

  o2net receive worker             Final domain teardown
  --------------------             ---------------------
  Get the handler reference
  dlm_grab(); pass dlm_joined()
                                   Unregister domain handlers
                                   Stop the DLM threads
                                   destroy_workqueue(dlm_worker)
                                   dlm_worker = NULL
  Publish the migration work item
  queue_work(dlm_worker, ...)

The handler lookup reference lets the callback continue after unregister. 
The work-list lock does not protect the queue lifetime, and destroying the
queue drains submitted work without waiting for this producer.  The late
queue_work() therefore passes NULL to __queue_work() and crashes.

Use o2net_unregister_and_flush_handler_list() at the existing domain
handler unregister point.  Removing the handlers prevents new lookups, and
flushing o2net receive work waits for already referenced callbacks and
their post handlers.  They can finish submitting while dlm_worker is still
live; the subsequent destroy_workqueue() drains those submissions.  The
same unregister helper covers failed registration and join cleanup,
without changing the DLM thread or workqueue teardown order.

KASAN report as below:

    Oops: general protection fault, probably for non-canonical address 0xdffffc0000000038: 0000 [#1] SMP KASAN NOPTI
    KASAN: null-ptr-deref in range [0x00000000000001c0-0x00000000000001c7]
    CPU: 0 UID: 0 PID: 14 Comm: kworker/u8:1 Not tainted 7.3.0-rc4-next-20260921-pmb-bt-functional-v1+ #1 PREEMPT(lazy)

[Hardware details omitted.]

    Workqueue: o2net o2net_rx_until_empty
    RIP: 0010:__queue_work+0x9b/0x1600

[Instruction and register dump omitted.]

    Call Trace:
     <TASK>
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx___queue_work+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? clear_pending_if_disabled+0x83/0x1c0
     ? __pfx_clear_pending_if_disabled+0x10/0x10
     ? __pfx_pmbd_probe_hit_cookie+0x10/0x10
     ? dlm_mig_lockres_handler+0x984/0x1500
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_release+0xc8/0x290
     queue_work_on+0xda/0xf0
     dlm_mig_lockres_handler+0x9d5/0x1500
     ? percpu_rwsem_wake_function+0x10/0x480
     ? __pfx_dlm_mig_lockres_handler+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? trace_hardirqs_on+0x18/0x160
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? kvm_clock_get_cycles+0x31/0x60
     ? srso_alias_return_thunk+0x5/0xfbef5
     o2net_rx_until_empty+0x1a55/0x32f0
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

[Empty module list omitted.]

    ---[ end trace 0000000000000000 ]---

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0056-v2-57239c657ac017b50fa1@gmail.com
Fixes: 3156d2670166 ("ocfs2: move dlm work to a private work queue")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Junrui Luo <moonafterrain@outlook.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Julia Lawall <julia.lawall@inria.fr>
Cc: Kurt Hackel <kurt.hackel@oracle.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>

 fs/ocfs2/dlm/dlmdomain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-drain-domain-handlers-before-destroying-the-dlm-worker
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -1708,7 +1708,7 @@ static void dlm_unregister_domain_handle
 {
 	o2hb_unregister_callback(dlm->name, &dlm->dlm_hb_up);
 	o2hb_unregister_callback(dlm->name, &dlm->dlm_hb_down);
-	o2net_unregister_handler_list(&dlm->dlm_domain_handlers);
+	o2net_unregister_and_flush_handler_list(&dlm->dlm_domain_handlers);
 }
 
 static int dlm_register_domain_handlers(struct dlm_ctxt *dlm)
_

Patches currently in -mm which might be from zzzccc427@gmail.com are

ocfs2-serialize-inode-journal-access-with-shutdown.patch
ocfs2-dlmfs-keep-the-superblock-alive-during-lock-work.patch
ocfs2-advance-locking_state-through-the-live-cursor.patch
ocfs2-drain-domain-handlers-before-destroying-the-dlm-worker.patch

