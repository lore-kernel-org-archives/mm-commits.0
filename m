Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFE14C432BE
	for <mm-commits@archiver.kernel.org>; Tue, 31 Aug 2021 18:05:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86DC06109D
	for <mm-commits@archiver.kernel.org>; Tue, 31 Aug 2021 18:05:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbhHaSGE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Aug 2021 14:06:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230145AbhHaSGD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 31 Aug 2021 14:06:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2725A6109E;
        Tue, 31 Aug 2021 18:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630433108;
        bh=7JaicFMfVi9sVF8gsWU8DbzOcnwxM4IJahzDoVgD21s=;
        h=Date:From:To:Subject:From;
        b=wqLQP5lvKx2VitbtjetiZ5je2u1+1u2sABCCbt9UwmolVP5f+14VrCpnCNOCd1IaN
         GfatCn5cZ2zCqlHAPj+pe7gjFTPlY9Nol0BP05dooFQ4qfR8Rw/IC7vHh8eNpVROFE
         PySLwvudbDGHuVK53LUw7kcl1bnO8gAU/Kyg2LUM=
Date:   Tue, 31 Aug 2021 11:05:07 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20210831180507.DXbiggqAB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm.c                         |    3 
 drivers/scsi/st.c                       |   16 ---
 fs/Kconfig                              |    7 -
 fs/io-wq.c                              |   99 ----------------------
 fs/io_uring.c                           |    7 -
 include/asm-generic/bitops/non-atomic.h |   28 ------
 net/socket.c                            |    7 -
 7 files changed, 167 deletions(-)

--- a/drivers/md/dm.c~linux-next-git-rejects
+++ a/drivers/md/dm.c
@@ -2001,11 +2001,8 @@ int dm_create(int minor, struct mapped_d
 	if (!md)
 		return -ENXIO;
 
-<<<<<<< HEAD
-=======
 	dm_ima_reset_data(md);
 
->>>>>>> linux-next/akpm-base
 	*result = md;
 	return 0;
 }
--- a/drivers/scsi/st.c~linux-next-git-rejects
+++ a/drivers/scsi/st.c
@@ -3827,27 +3827,11 @@ static long st_ioctl(struct file *file,
 		break;
 	}
 
-<<<<<<< HEAD
-		default:
-			if ((cmd_in == SG_IO ||
-			     cmd_in == SCSI_IOCTL_SEND_COMMAND ||
-			     cmd_in == CDROM_SEND_PACKET) &&
-			    !capable(CAP_SYS_RAWIO))
-				i = -EPERM;
-			else
-				i = scsi_cmd_ioctl(STp->device->request_queue,
-						   NULL, file->f_mode, cmd_in,
-						   p);
-			if (i != -ENOTTY)
-				return i;
-			break;
-=======
 	retval = scsi_ioctl(STp->device, NULL, file->f_mode, cmd_in, p);
 	if (!retval && cmd_in == SCSI_IOCTL_STOP_UNIT) {
 		/* unload */
 		STp->rew_at_close = 0;
 		STp->ready = ST_NO_TAPE;
->>>>>>> linux-next/akpm-base
 	}
 	return retval;
 
--- a/fs/io_uring.c~linux-next-git-rejects
+++ a/fs/io_uring.c
@@ -1920,17 +1920,10 @@ static struct io_kiocb *io_alloc_req(str
 
 	if (likely(state->free_reqs || io_flush_cached_reqs(ctx)))
 		goto got_req;
-<<<<<<< HEAD
 
 	ret = kmem_cache_alloc_bulk(req_cachep, gfp, IO_REQ_ALLOC_BATCH,
 				    state->reqs);
 
-=======
-
-	ret = kmem_cache_alloc_bulk(req_cachep, gfp, IO_REQ_ALLOC_BATCH,
-				    state->reqs);
-
->>>>>>> linux-next/akpm-base
 	/*
 	 * Bulk alloc is all-or-nothing. If we fail to get a batch,
 	 * retry single alloc to be on the safe side.
--- a/fs/io-wq.c~linux-next-git-rejects
+++ a/fs/io-wq.c
@@ -250,28 +250,6 @@ static void io_wqe_create_worker(struct
 	if (unlikely(!acct->max_workers))
 		pr_warn_once("io-wq is not configured for unbound workers");
 
-<<<<<<< HEAD
-	rcu_read_lock();
-	ret = io_wqe_activate_free_worker(wqe);
-	rcu_read_unlock();
-
-	if (!ret) {
-		bool do_create = false, first = false;
-
-		raw_spin_lock(&wqe->lock);
-		if (acct->nr_workers < acct->max_workers) {
-			if (!acct->nr_workers)
-				first = true;
-			acct->nr_workers++;
-			do_create = true;
-		}
-		raw_spin_unlock(&wqe->lock);
-		if (do_create) {
-			atomic_inc(&acct->nr_running);
-			atomic_inc(&wqe->wq->worker_refs);
-			create_io_worker(wqe->wq, wqe, acct->index, first);
-		}
-=======
 	raw_spin_lock(&wqe->lock);
 	if (acct->nr_workers < acct->max_workers) {
 		if (!acct->nr_workers)
@@ -284,7 +262,6 @@ static void io_wqe_create_worker(struct
 		atomic_inc(&acct->nr_running);
 		atomic_inc(&wqe->wq->worker_refs);
 		create_io_worker(wqe->wq, wqe, acct->index, first);
->>>>>>> linux-next/akpm-base
 	}
 }
 
@@ -423,33 +400,8 @@ static void io_wait_on_hash(struct io_wq
 	spin_unlock(&wq->hash->wait.lock);
 }
 
-<<<<<<< HEAD
-/*
- * We can always run the work if the worker is currently the same type as
- * the work (eg both are bound, or both are unbound). If they are not the
- * same, only allow it if incrementing the worker count would be allowed.
- */
-static bool io_worker_can_run_work(struct io_worker *worker,
-				   struct io_wq_work *work)
-{
-	struct io_wqe_acct *acct;
-
-	if (!(worker->flags & IO_WORKER_F_BOUND) !=
-	    !(work->flags & IO_WQ_WORK_UNBOUND))
-		return true;
-
-	/* not the same type, check if we'd go over the limit */
-	acct = io_work_get_acct(worker->wqe, work);
-	return acct->nr_workers < acct->max_workers;
-}
-
-static struct io_wq_work *io_get_next_work(struct io_wqe *wqe,
-					   struct io_worker *worker,
-					   bool *stalled)
-=======
 static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
 					   struct io_worker *worker)
->>>>>>> linux-next/akpm-base
 	__must_hold(wqe->lock)
 {
 	struct io_wq_work_node *node, *prev;
@@ -541,21 +493,12 @@ get_next:
 		 * can't make progress, any work completion or insertion will
 		 * clear the stalled flag.
 		 */
-<<<<<<< HEAD
-		stalled = false;
-		work = io_get_next_work(wqe, worker, &stalled);
-		if (work)
-			__io_worker_busy(wqe, worker, work);
-		else if (stalled)
-			wqe->flags |= IO_WQE_FLAG_STALLED;
-=======
 		acct = io_wqe_get_acct(worker);
 		work = io_get_next_work(acct, worker);
 		if (work)
 			__io_worker_busy(wqe, worker, work);
 		else if (!wq_list_empty(&acct->work_list))
 			acct->flags |= IO_ACCT_FLAG_STALLED;
->>>>>>> linux-next/akpm-base
 
 		raw_spin_unlock(&wqe->lock);
 		if (!work)
@@ -590,11 +533,7 @@ get_next:
 				if (wq_has_sleeper(&wq->hash->wait))
 					wake_up(&wq->hash->wait);
 				raw_spin_lock(&wqe->lock);
-<<<<<<< HEAD
-				wqe->flags &= ~IO_WQE_FLAG_STALLED;
-=======
 				acct->flags &= ~IO_ACCT_FLAG_STALLED;
->>>>>>> linux-next/akpm-base
 				/* skip unnecessary unlock-lock wqe->lock */
 				if (!work)
 					goto get_next;
@@ -626,11 +565,7 @@ static int io_wqe_worker(void *data)
 		set_current_state(TASK_INTERRUPTIBLE);
 loop:
 		raw_spin_lock(&wqe->lock);
-<<<<<<< HEAD
-		if (io_wqe_run_queue(wqe)) {
-=======
 		if (io_acct_run_queue(acct)) {
->>>>>>> linux-next/akpm-base
 			io_worker_handle_work(worker);
 			goto loop;
 		}
@@ -820,11 +755,7 @@ append:
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 {
 	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
-<<<<<<< HEAD
-	bool do_wake;
-=======
 	bool do_create;
->>>>>>> linux-next/akpm-base
 
 	/*
 	 * If io-wq is exiting for this task, or if the request has explicitly
@@ -838,15 +769,6 @@ static void io_wqe_enqueue(struct io_wqe
 
 	raw_spin_lock(&wqe->lock);
 	io_wqe_insert_work(wqe, work);
-<<<<<<< HEAD
-	wqe->flags &= ~IO_WQE_FLAG_STALLED;
-	do_wake = (work->flags & IO_WQ_WORK_CONCURRENT) ||
-			!atomic_read(&acct->nr_running);
-	raw_spin_unlock(&wqe->lock);
-
-	if (do_wake)
-		io_wqe_wake_worker(wqe, acct);
-=======
 	acct->flags &= ~IO_ACCT_FLAG_STALLED;
 
 	rcu_read_lock();
@@ -857,7 +779,6 @@ static void io_wqe_enqueue(struct io_wqe
 
 	if (do_create)
 		io_wqe_create_worker(wqe, acct);
->>>>>>> linux-next/akpm-base
 }
 
 void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
@@ -922,28 +843,12 @@ static void io_wqe_cancel_pending_work(s
 {
 	struct io_wq_work_node *node, *prev;
 	struct io_wq_work *work;
-<<<<<<< HEAD
-
-retry:
-	raw_spin_lock(&wqe->lock);
-	wq_list_for_each(node, prev, &wqe->work_list) {
-		work = container_of(node, struct io_wq_work, list);
-		if (!match->fn(work, match->data))
-			continue;
-		io_wqe_remove_pending(wqe, work, prev);
-		raw_spin_unlock(&wqe->lock);
-		io_run_cancel(work, wqe);
-		match->nr_pending++;
-		if (!match->cancel_all)
-			return;
-=======
 	int i;
 
 retry:
 	raw_spin_lock(&wqe->lock);
 	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
 		struct io_wqe_acct *acct = io_get_acct(wqe, i == 0);
->>>>>>> linux-next/akpm-base
 
 		wq_list_for_each(node, prev, &acct->work_list) {
 			work = container_of(node, struct io_wq_work, list);
@@ -1259,11 +1164,7 @@ int io_wq_max_workers(struct io_wq *wq,
 	for_each_node(node) {
 		struct io_wqe_acct *acct;
 
-<<<<<<< HEAD
-		for (i = 0; i < 2; i++) {
-=======
 		for (i = 0; i < IO_WQ_ACCT_NR; i++) {
->>>>>>> linux-next/akpm-base
 			acct = &wq->wqes[node]->acct[i];
 			prev = max_t(int, acct->max_workers, prev);
 			if (new_count[i])
--- a/fs/Kconfig~linux-next-git-rejects
+++ a/fs/Kconfig
@@ -366,20 +366,13 @@ source "net/sunrpc/Kconfig"
 source "fs/ceph/Kconfig"
 
 source "fs/cifs/Kconfig"
-<<<<<<< HEAD
-source "fs/ksmbd/Kconfig"
-=======
->>>>>>> linux-next/akpm-base
 
 config CIFS_COMMON
 	tristate
 	default y if CIFS=y
 	default m if CIFS=m
 
-<<<<<<< HEAD
-=======
 source "fs/ksmbd/Kconfig"
->>>>>>> linux-next/akpm-base
 source "fs/coda/Kconfig"
 source "fs/afs/Kconfig"
 source "fs/9p/Kconfig"
--- a/include/asm-generic/bitops/non-atomic.h~linux-next-git-rejects
+++ a/include/asm-generic/bitops/non-atomic.h
@@ -14,11 +14,7 @@
  * may be that only one operation succeeds.
  */
 static __always_inline void
-<<<<<<< HEAD
-arch___set_bit(int nr, volatile unsigned long *addr)
-=======
 arch___set_bit(unsigned int nr, volatile unsigned long *addr)
->>>>>>> linux-next/akpm-base
 {
 	unsigned long mask = BIT_MASK(nr);
 	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
@@ -28,11 +24,7 @@ arch___set_bit(unsigned int nr, volatile
 #define __set_bit arch___set_bit
 
 static __always_inline void
-<<<<<<< HEAD
-arch___clear_bit(int nr, volatile unsigned long *addr)
-=======
 arch___clear_bit(unsigned int nr, volatile unsigned long *addr)
->>>>>>> linux-next/akpm-base
 {
 	unsigned long mask = BIT_MASK(nr);
 	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
@@ -51,11 +43,7 @@ arch___clear_bit(unsigned int nr, volati
  * may be that only one operation succeeds.
  */
 static __always_inline
-<<<<<<< HEAD
-void arch___change_bit(int nr, volatile unsigned long *addr)
-=======
 void arch___change_bit(unsigned int nr, volatile unsigned long *addr)
->>>>>>> linux-next/akpm-base
 {
 	unsigned long mask = BIT_MASK(nr);
 	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
@@ -74,11 +62,7 @@ void arch___change_bit(unsigned int nr,
  * but actually fail.  You must protect multiple accesses with a lock.
  */
 static __always_inline int
-<<<<<<< HEAD
-arch___test_and_set_bit(int nr, volatile unsigned long *addr)
-=======
 arch___test_and_set_bit(unsigned int nr, volatile unsigned long *addr)
->>>>>>> linux-next/akpm-base
 {
 	unsigned long mask = BIT_MASK(nr);
 	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
@@ -99,11 +83,7 @@ arch___test_and_set_bit(unsigned int nr,
  * but actually fail.  You must protect multiple accesses with a lock.
  */
 static __always_inline int
-<<<<<<< HEAD
-arch___test_and_clear_bit(int nr, volatile unsigned long *addr)
-=======
 arch___test_and_clear_bit(unsigned int nr, volatile unsigned long *addr)
->>>>>>> linux-next/akpm-base
 {
 	unsigned long mask = BIT_MASK(nr);
 	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
@@ -116,11 +96,7 @@ arch___test_and_clear_bit(unsigned int n
 
 /* WARNING: non atomic and it can be reordered! */
 static __always_inline int
-<<<<<<< HEAD
-arch___test_and_change_bit(int nr, volatile unsigned long *addr)
-=======
 arch___test_and_change_bit(unsigned int nr, volatile unsigned long *addr)
->>>>>>> linux-next/akpm-base
 {
 	unsigned long mask = BIT_MASK(nr);
 	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
@@ -137,11 +113,7 @@ arch___test_and_change_bit(unsigned int
  * @addr: Address to start counting from
  */
 static __always_inline int
-<<<<<<< HEAD
-arch_test_bit(int nr, const volatile unsigned long *addr)
-=======
 arch_test_bit(unsigned int nr, const volatile unsigned long *addr)
->>>>>>> linux-next/akpm-base
 {
 	return 1UL & (addr[BIT_WORD(nr)] >> (nr & (BITS_PER_LONG-1)));
 }
--- a/net/socket.c~linux-next-git-rejects
+++ a/net/socket.c
@@ -1802,17 +1802,10 @@ int __sys_accept4_file(struct file *file
 {
 	struct file *newfile;
 	int newfd;
-<<<<<<< HEAD
 
 	if (flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
 		return -EINVAL;
 
-=======
-
-	if (flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
-		return -EINVAL;
-
->>>>>>> linux-next/akpm-base
 	if (SOCK_NONBLOCK != O_NONBLOCK && (flags & SOCK_NONBLOCK))
 		flags = (flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix.patch
mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix-fix.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-compaction-optimize-proactive-compaction-deferrals-fix.patch
mm-compaction-support-triggering-of-proactive-compaction-by-user-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-idle_page_tracking-make-pg_idle-reusable-fix-fix.patch
mm-damon-implement-primitives-for-the-virtual-memory-address-spaces-fix.patch
mm-damon-implement-a-debugfs-based-user-space-interface-fix.patch
mm-damon-implement-a-debugfs-based-user-space-interface-fix-fix.patch
checkpatch-improve-git_commit_id-test-fix.patch
fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix-fix.patch
log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch

