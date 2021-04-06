Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B0C0C433B4
	for <mm-commits@archiver.kernel.org>; Tue,  6 Apr 2021 19:17:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFBDA61399
	for <mm-commits@archiver.kernel.org>; Tue,  6 Apr 2021 19:17:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234325AbhDFTRW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Apr 2021 15:17:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232650AbhDFTRW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Apr 2021 15:17:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94C4F6138B;
        Tue,  6 Apr 2021 19:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617736632;
        bh=fQzhed06NwcOJYkdlFY4BuNwhV7LtcYEa5U0DqnxXi0=;
        h=Date:From:To:Subject:From;
        b=bkdx4qZ1AwOMdQ2yLMk5jzfcuESACiJnGFyQ2ACHuZ5v+pKP0CQbJ6h6FuLOdwIHV
         3RL9zg7nD57bqENH00WsguTu+VizDtPs8KuTK3xXubN6E/7yYlCSzPPEM0iPWktjIQ
         Z7RnaJwgHSbslOpai+4mdVDgddktBVD4GvS66lGc=
Date:   Tue, 06 Apr 2021 12:17:12 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20210406191712.ghXAhdZ1g%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kvm/svm/nested.c |   27 --------------
 fs/io-wq.c                |   65 ------------------------------------
 fs/io_uring.c             |   25 -------------
 3 files changed, 117 deletions(-)

--- a/arch/x86/kvm/svm/nested.c~linux-next-git-rejects
+++ a/arch/x86/kvm/svm/nested.c
@@ -247,12 +247,8 @@ static bool nested_vmcb_check_controls(s
 	return true;
 }
 
-<<<<<<< HEAD
-static bool nested_vmcb_check_save(struct vcpu_svm *svm, struct vmcb *vmcb12)
-=======
 static bool nested_vmcb_check_cr3_cr4(struct kvm_vcpu *vcpu,
 				      struct vmcb_save_area *save)
->>>>>>> linux-next/akpm-base
 {
 	/*
 	 * These checks are also performed by KVM_SET_SREGS,
@@ -266,18 +262,7 @@ static bool nested_vmcb_check_cr3_cr4(st
 			return false;
 	}
 
-<<<<<<< HEAD
-	/*
-	 * FIXME: these should be done after copying the fields,
-	 * to avoid TOC/TOU races.  For these save area checks
-	 * the possible damage is limited since kvm_set_cr0 and
-	 * kvm_set_cr4 handle failure; EFER_SVME is an exception
-	 * so it is force-set later in nested_prepare_vmcb_save.
-	 */
-	if ((vmcb12->save.efer & EFER_SVME) == 0)
-=======
 	if (CC(!kvm_is_valid_cr4(vcpu, save->cr4)))
->>>>>>> linux-next/akpm-base
 		return false;
 
 	return true;
@@ -582,10 +567,6 @@ int enter_svm_guest_mode(struct kvm_vcpu
 
 
 	svm->nested.vmcb12_gpa = vmcb12_gpa;
-<<<<<<< HEAD
-	nested_prepare_vmcb_control(svm);
-	nested_prepare_vmcb_save(svm, vmcb12);
-=======
 
 	WARN_ON(svm->vmcb == svm->nested.vmcb02.ptr);
 
@@ -595,7 +576,6 @@ int enter_svm_guest_mode(struct kvm_vcpu
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
 	nested_vmcb02_prepare_control(svm);
 	nested_vmcb02_prepare_save(svm, vmcb12);
->>>>>>> linux-next/akpm-base
 
 	ret = nested_svm_load_cr3(&svm->vcpu, vmcb12->save.cr3,
 				  nested_npt_enabled(svm));
@@ -641,14 +621,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vc
 	if (WARN_ON_ONCE(!svm->nested.initialized))
 		return -EINVAL;
 
-<<<<<<< HEAD
-	load_nested_vmcb_control(svm, &vmcb12->control);
-
-	if (!nested_vmcb_check_save(svm, vmcb12) ||
-	    !nested_vmcb_check_controls(&svm->nested.ctl)) {
-=======
 	if (!nested_vmcb_checks(vcpu, vmcb12)) {
->>>>>>> linux-next/akpm-base
 		vmcb12->control.exit_code    = SVM_EXIT_ERR;
 		vmcb12->control.exit_code_hi = 0;
 		vmcb12->control.exit_info_1  = 0;
--- a/fs/io_uring.c~linux-next-git-rejects
+++ a/fs/io_uring.c
@@ -708,15 +708,11 @@ enum {
 	REQ_F_BUFFER_SELECTED_BIT,
 	REQ_F_LTIMEOUT_ACTIVE_BIT,
 	REQ_F_COMPLETE_INLINE_BIT,
-<<<<<<< HEAD
-	REQ_F_REISSUE_BIT,
-=======
 	REQ_F_DONT_REISSUE_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_ASYNC_READ_BIT,
 	REQ_F_ASYNC_WRITE_BIT,
 	REQ_F_ISREG_BIT,
->>>>>>> linux-next/akpm-base
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -756,10 +752,6 @@ enum {
 	REQ_F_LTIMEOUT_ACTIVE	= BIT(REQ_F_LTIMEOUT_ACTIVE_BIT),
 	/* completion is deferred through io_comp_state */
 	REQ_F_COMPLETE_INLINE	= BIT(REQ_F_COMPLETE_INLINE_BIT),
-<<<<<<< HEAD
-	/* caller should reissue async */
-	REQ_F_REISSUE		= BIT(REQ_F_REISSUE_BIT),
-=======
 	/* don't attempt request reissue, see io_rw_reissue() */
 	REQ_F_DONT_REISSUE	= BIT(REQ_F_DONT_REISSUE_BIT),
 	/* supports async reads */
@@ -768,7 +760,6 @@ enum {
 	REQ_F_ASYNC_WRITE	= BIT(REQ_F_ASYNC_WRITE_BIT),
 	/* regular file */
 	REQ_F_ISREG		= BIT(REQ_F_ISREG_BIT),
->>>>>>> linux-next/akpm-base
 };
 
 struct async_poll {
@@ -2513,17 +2504,9 @@ static void __io_complete_rw(struct io_k
 
 	if (req->rw.kiocb.ki_flags & IOCB_WRITE)
 		kiocb_end_write(req);
-<<<<<<< HEAD
-	if ((res == -EAGAIN || res == -EOPNOTSUPP) && io_rw_should_reissue(req)) {
-		req->flags |= REQ_F_REISSUE;
-		return;
-	}
-	if (res != req->result)
-=======
 	if (unlikely(res != req->result)) {
 		if ((res == -EAGAIN || res == -EOPNOTSUPP) && io_rw_reissue(req))
 			return;
->>>>>>> linux-next/akpm-base
 		req_set_fail_links(req);
 	}
 	if (req->flags & REQ_F_BUFFER_SELECTED)
@@ -3301,13 +3284,9 @@ static int io_read(struct io_kiocb *req,
 
 	ret = io_iter_do_read(req, iter);
 
-<<<<<<< HEAD
-	if (ret == -EAGAIN || (req->flags & REQ_F_REISSUE)) {
-=======
 	if (ret == -EIOCBQUEUED) {
 		goto out_free;
 	} else if (ret == -EAGAIN) {
->>>>>>> linux-next/akpm-base
 		/* IOPOLL retry should happen for io-wq threads */
 		if (!force_nonblock && !(req->ctx->flags & IORING_SETUP_IOPOLL))
 			goto done;
@@ -6861,10 +6840,6 @@ static int io_sq_thread(void *data)
 
 				did_sig = get_signal(&ksig);
 			}
-<<<<<<< HEAD
-			cond_resched();
-=======
->>>>>>> linux-next/akpm-base
 			mutex_lock(&sqd->lock);
 			if (did_sig)
 				break;
--- a/fs/io-wq.c~linux-next-git-rejects
+++ a/fs/io-wq.c
@@ -532,11 +532,7 @@ static int io_wqe_worker(void *data)
 
 	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
 
-<<<<<<< HEAD
-	snprintf(buf, sizeof(buf), "iou-wrk-%d", wq->task_pid);
-=======
 	sprintf(buf, "iou-wrk-%d", wq->task->pid);
->>>>>>> linux-next/akpm-base
 	set_task_comm(current, buf);
 
 	while (!test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
@@ -715,67 +711,6 @@ static bool io_wq_work_match_all(struct
 	return true;
 }
 
-<<<<<<< HEAD
-static void io_wq_cancel_pending(struct io_wq *wq)
-{
-	struct io_cb_cancel_data match = {
-		.fn		= io_wq_work_match_all,
-		.cancel_all	= true,
-	};
-	int node;
-
-	for_each_node(node)
-		io_wqe_cancel_pending_work(wq->wqes[node], &match);
-}
-
-/*
- * Manager thread. Tasked with creating new workers, if we need them.
- */
-static int io_wq_manager(void *data)
-{
-	struct io_wq *wq = data;
-	char buf[TASK_COMM_LEN];
-	int node;
-
-	snprintf(buf, sizeof(buf), "iou-mgr-%d", wq->task_pid);
-	set_task_comm(current, buf);
-
-	do {
-		set_current_state(TASK_INTERRUPTIBLE);
-		io_wq_check_workers(wq);
-		schedule_timeout(HZ);
-		if (signal_pending(current)) {
-			struct ksignal ksig;
-
-			if (!get_signal(&ksig))
-				continue;
-			set_bit(IO_WQ_BIT_EXIT, &wq->state);
-		}
-	} while (!test_bit(IO_WQ_BIT_EXIT, &wq->state));
-
-	io_wq_check_workers(wq);
-
-	rcu_read_lock();
-	for_each_node(node)
-		io_wq_for_each_worker(wq->wqes[node], io_wq_worker_wake, NULL);
-	rcu_read_unlock();
-
-	if (atomic_dec_and_test(&wq->worker_refs))
-		complete(&wq->worker_done);
-	wait_for_completion(&wq->worker_done);
-
-	spin_lock_irq(&wq->hash->wait.lock);
-	for_each_node(node)
-		list_del_init(&wq->wqes[node]->wait.entry);
-	spin_unlock_irq(&wq->hash->wait.lock);
-
-	io_wq_cancel_pending(wq);
-	complete(&wq->exited);
-	do_exit(0);
-}
-
-=======
->>>>>>> linux-next/akpm-base
 static void io_run_cancel(struct io_wq_work *work, struct io_wqe *wqe)
 {
 	struct io_wq *wq = wqe->wq;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-remove-redundant-config-option-fix.patch
mm-gup-check-page-posion-status-for-coredump-fix.patch
lib-test_kasan_modulec-suppress-unused-var-warning.patch
scripts-a-new-script-for-checking-duplicate-struct-declaration-fix.patch
mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
mm-vmalloc-remove-unmap_kernel_range-fix-fix.patch
mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix.patch
mm-vmscan-add-shrinker_info_protected-helper-fix.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

