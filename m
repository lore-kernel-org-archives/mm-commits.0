Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D0C9C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 17:10:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BECB64E61
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 17:10:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhCQRKD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Mar 2021 13:10:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:42874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229796AbhCQRJp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Mar 2021 13:09:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A695B64EE7;
        Wed, 17 Mar 2021 17:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616000984;
        bh=ijeOpcXbEpHtHBtLf1MhuBSaeyrIQhea+WYxGoOAQIA=;
        h=Date:From:To:Subject:From;
        b=WrVcBfxBqBooH7OzFEmMK9pA3XZhj/0lwf3UnRym0I7fU26UFdT6pOjjhTl1D9u50
         7PqP3xP3XPBlSR5j1q7CGm7GVESn5HY3dC6O5zdTjBSGgpTBArQ7+cD97wbACg4nYy
         esgtzwGJRvZ3gpyeIMb5f2Hf9IwU0aGvQyK+RSNU=
Date:   Wed, 17 Mar 2021 10:09:44 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20210317170944.tfwkeo5_j%akpm@linux-foundation.org>
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

 fs/nfsd/nfs4state.c                     |    4 --
 include/linux/sunrpc/svc_rdma.h         |    4 --
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |   37 ----------------------
 3 files changed, 45 deletions(-)

--- a/fs/nfsd/nfs4state.c~linux-next-git-rejects
+++ a/fs/nfsd/nfs4state.c
@@ -5382,11 +5382,7 @@ nfs4_laundromat(struct nfsd_net *nn)
 	idr_for_each_entry(&nn->s2s_cp_stateids, cps_t, i) {
 		cps = container_of(cps_t, struct nfs4_cpntf_state, cp_stateid);
 		if (cps->cp_stateid.sc_type == NFS4_COPYNOTIFY_STID &&
-<<<<<<< HEAD
-				cps->cpntf_time < cutoff)
-=======
 				state_expired(&lt, cps->cpntf_time))
->>>>>>> linux-next/akpm-base
 			_free_cpntf_state_locked(nn, cps);
 	}
 	spin_unlock(&nn->s2s_cp_lock);
--- a/include/linux/sunrpc/svc_rdma.h~linux-next-git-rejects
+++ a/include/linux/sunrpc/svc_rdma.h
@@ -106,10 +106,6 @@ struct svcxprt_rdma {
 
 	wait_queue_head_t    sc_send_wait;	/* SQ exhaustion waitlist */
 	unsigned long	     sc_flags;
-<<<<<<< HEAD
-	struct list_head     sc_read_complete_q;
-=======
->>>>>>> linux-next/akpm-base
 	struct work_struct   sc_work;
 
 	struct llist_head    sc_recv_ctxts;
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c~linux-next-git-rejects
+++ a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -263,30 +263,6 @@ static int __svc_rdma_post_recv(struct s
 {
 	int ret;
 
-<<<<<<< HEAD
-	trace_svcrdma_post_recv(ctxt);
-	ret = ib_post_recv(rdma->sc_qp, &ctxt->rc_recv_wr, NULL);
-	if (ret)
-		goto err_post;
-	return 0;
-
-err_post:
-	trace_svcrdma_rq_post_err(rdma, ret);
-	svc_rdma_recv_ctxt_put(rdma, ctxt);
-	return ret;
-}
-
-static int svc_rdma_post_recv(struct svcxprt_rdma *rdma)
-{
-	struct svc_rdma_recv_ctxt *ctxt;
-
-	if (test_bit(XPT_CLOSE, &rdma->sc_xprt.xpt_flags))
-		return 0;
-	ctxt = svc_rdma_recv_ctxt_get(rdma);
-	if (!ctxt)
-		return -ENOMEM;
-	return __svc_rdma_post_recv(rdma, ctxt);
-=======
 	if (test_bit(XPT_CLOSE, &rdma->sc_xprt.xpt_flags))
 		return false;
 
@@ -321,7 +297,6 @@ err_free:
 	/* Since we're destroying the xprt, no need to reset
 	 * sc_pending_recvs. */
 	return false;
->>>>>>> linux-next/akpm-base
 }
 
 /**
@@ -369,10 +344,6 @@ static void svc_rdma_wc_receive(struct i
 	if (wc->status != IB_WC_SUCCESS)
 		goto flushed;
 
-<<<<<<< HEAD
-	if (svc_rdma_post_recv(rdma))
-		goto post_err;
-=======
 	/* If receive posting fails, the connection is about to be
 	 * lost anyway. The server will not be able to send a reply
 	 * for this RPC, and the client will retransmit this RPC
@@ -385,7 +356,6 @@ static void svc_rdma_wc_receive(struct i
 	if (rdma->sc_pending_recvs < rdma->sc_max_requests)
 		if (!svc_rdma_refresh_recvs(rdma, rdma->sc_recv_batch, false))
 			goto flushed;
->>>>>>> linux-next/akpm-base
 
 	/* All wc fields are now known to be valid */
 	ctxt->rc_byte_len = wc->byte_len;
@@ -400,15 +370,8 @@ static void svc_rdma_wc_receive(struct i
 	return;
 
 flushed:
-<<<<<<< HEAD
-post_err:
-	svc_rdma_recv_ctxt_put(rdma, ctxt);
-	set_bit(XPT_CLOSE, &rdma->sc_xprt.xpt_flags);
-	svc_xprt_enqueue(&rdma->sc_xprt);
-=======
 	svc_rdma_recv_ctxt_put(rdma, ctxt);
 	svc_xprt_deferred_close(&rdma->sc_xprt);
->>>>>>> linux-next/akpm-base
 }
 
 /**
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
kasan-remove-redundant-config-option-fix.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

