Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A12FC433E0
	for <mm-commits@archiver.kernel.org>; Tue, 16 Mar 2021 19:11:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50EC265027
	for <mm-commits@archiver.kernel.org>; Tue, 16 Mar 2021 19:11:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240325AbhCPTK5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 Mar 2021 15:10:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236915AbhCPTKZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Mar 2021 15:10:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07AE96513D;
        Tue, 16 Mar 2021 19:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615921825;
        bh=+6vB5BTIxTjtXC9j5C4m6QRBsML6DUuXoplWBwaXZ68=;
        h=Date:From:To:Subject:From;
        b=ts4hwrKs8WawWmjRdEy0fCtgiaPRuzeJ96pQefmnZS0xl7tzjW+oTNirYhIGnRuGq
         E5qfFjXQeKAw25r20Kv92zyMgS8NL7ahnr27xTTX73beAs2lunJhGk+bHri7p4WJAA
         NxvzrIa+FNu2F3UmNjxcyL26wKdnQHPrerp/B7N8=
Date:   Tue, 16 Mar 2021 12:10:24 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20210316191024.BFdlulfc_%akpm@linux-foundation.org>
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
linux-next-git-rejects.patch

