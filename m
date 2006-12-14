From: akpm@osdl.org
Subject: - lockd-endianness-annotations-rebased.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:12:06 -0800
Message-ID: <200612140612.kBE6C58Q002059@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52258 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945AbWLNGM1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:12:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viro@ftp.linux.org.uk, Trond.Myklebust@netapp.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     lockd endianness annotations
has been removed from the -mm tree.  Its filename was
     lockd-endianness-annotations-rebased.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockd endianness annotations
From: Al Viro <viro@ftp.linux.org.uk>

Annotated, all places switched to keeping status net-endian.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/lockd/clntlock.c            |   10 +++----
 fs/lockd/clntproc.c            |   39 +++++++++++++++----------------
 fs/lockd/svclock.c             |    4 +--
 fs/lockd/xdr.c                 |    8 +++---
 fs/lockd/xdr4.c                |    8 +++---
 fs/nfsd/lockd.c                |    2 -
 include/linux/lockd/bind.h     |    2 -
 include/linux/lockd/lockd.h    |    2 -
 include/linux/lockd/sm_inter.h |    2 -
 include/linux/lockd/xdr.h      |    8 +++---
 10 files changed, 43 insertions(+), 42 deletions(-)

diff -puN fs/lockd/clntlock.c~lockd-endianness-annotations-rebased fs/lockd/clntlock.c
--- a/fs/lockd/clntlock.c~lockd-endianness-annotations-rebased
+++ a/fs/lockd/clntlock.c
@@ -36,7 +36,7 @@ struct nlm_wait {
 	struct nlm_host *	b_host;
 	struct file_lock *	b_lock;		/* local file lock */
 	unsigned short		b_reclaim;	/* got to reclaim lock */
-	u32			b_status;	/* grant callback status */
+	__be32			b_status;	/* grant callback status */
 };
 
 static LIST_HEAD(nlm_blocked);
@@ -53,7 +53,7 @@ struct nlm_wait *nlmclnt_prepare_block(s
 		block->b_host = host;
 		block->b_lock = fl;
 		init_waitqueue_head(&block->b_wait);
-		block->b_status = NLM_LCK_BLOCKED;
+		block->b_status = nlm_lck_blocked;
 		list_add(&block->b_list, &nlm_blocked);
 	}
 	return block;
@@ -89,7 +89,7 @@ int nlmclnt_block(struct nlm_wait *block
 	 * nlmclnt_lock for an explanation.
 	 */
 	ret = wait_event_interruptible_timeout(block->b_wait,
-			block->b_status != NLM_LCK_BLOCKED,
+			block->b_status != nlm_lck_blocked,
 			timeout);
 	if (ret < 0)
 		return -ERESTARTSYS;
@@ -131,7 +131,7 @@ __be32 nlmclnt_grant(const struct sockad
 		/* Alright, we found a lock. Set the return status
 		 * and wake up the caller
 		 */
-		block->b_status = NLM_LCK_GRANTED;
+		block->b_status = nlm_granted;
 		wake_up(&block->b_wait);
 		res = nlm_granted;
 	}
@@ -211,7 +211,7 @@ restart:
 	/* Now, wake up all processes that sleep on a blocked lock */
 	list_for_each_entry(block, &nlm_blocked, b_list) {
 		if (block->b_host == host) {
-			block->b_status = NLM_LCK_DENIED_GRACE_PERIOD;
+			block->b_status = nlm_lck_denied_grace_period;
 			wake_up(&block->b_wait);
 		}
 	}
diff -puN fs/lockd/clntproc.c~lockd-endianness-annotations-rebased fs/lockd/clntproc.c
--- a/fs/lockd/clntproc.c~lockd-endianness-annotations-rebased
+++ a/fs/lockd/clntproc.c
@@ -27,7 +27,7 @@
 static int	nlmclnt_test(struct nlm_rqst *, struct file_lock *);
 static int	nlmclnt_lock(struct nlm_rqst *, struct file_lock *);
 static int	nlmclnt_unlock(struct nlm_rqst *, struct file_lock *);
-static int	nlm_stat_to_errno(u32 stat);
+static int	nlm_stat_to_errno(__be32 stat);
 static void	nlmclnt_locks_init_private(struct file_lock *fl, struct nlm_host *host);
 static int	nlmclnt_cancel(struct nlm_host *, int , struct file_lock *);
 
@@ -325,7 +325,7 @@ nlmclnt_call(struct nlm_rqst *req, u32 p
 			}
 			break;
 		} else
-		if (resp->status == NLM_LCK_DENIED_GRACE_PERIOD) {
+		if (resp->status == nlm_lck_denied_grace_period) {
 			dprintk("lockd: server in grace period\n");
 			if (argp->reclaim) {
 				printk(KERN_WARNING
@@ -411,10 +411,10 @@ nlmclnt_test(struct nlm_rqst *req, struc
 		goto out;
 
 	switch (req->a_res.status) {
-		case NLM_LCK_GRANTED:
+		case nlm_granted:
 			fl->fl_type = F_UNLCK;
 			break;
-		case NLM_LCK_DENIED:
+		case nlm_lck_denied:
 			/*
 			 * Report the conflicting lock back to the application.
 			 */
@@ -524,9 +524,9 @@ again:
 		if (!req->a_args.block)
 			break;
 		/* Did a reclaimer thread notify us of a server reboot? */
-		if (resp->status ==  NLM_LCK_DENIED_GRACE_PERIOD)
+		if (resp->status ==  nlm_lck_denied_grace_period)
 			continue;
-		if (resp->status != NLM_LCK_BLOCKED)
+		if (resp->status != nlm_lck_blocked)
 			break;
 		/* Wait on an NLM blocking lock */
 		status = nlmclnt_block(block, req, NLMCLNT_POLL_TIMEOUT);
@@ -535,11 +535,11 @@ again:
 		 */
 		if (status < 0)
 			goto out_unblock;
-		if (resp->status != NLM_LCK_BLOCKED)
+		if (resp->status != nlm_lck_blocked)
 			break;
 	}
 
-	if (resp->status == NLM_LCK_GRANTED) {
+	if (resp->status == nlm_granted) {
 		down_read(&host->h_rwsem);
 		/* Check whether or not the server has rebooted */
 		if (fl->fl_u.nfs_fl.state != host->h_state) {
@@ -556,7 +556,7 @@ again:
 out_unblock:
 	nlmclnt_finish_block(block);
 	/* Cancel the blocked request if it is still pending */
-	if (resp->status == NLM_LCK_BLOCKED)
+	if (resp->status == nlm_lck_blocked)
 		nlmclnt_cancel(host, req->a_args.block, fl);
 out:
 	nlm_release_call(req);
@@ -585,12 +585,12 @@ nlmclnt_reclaim(struct nlm_host *host, s
 	req->a_args.reclaim = 1;
 
 	if ((status = nlmclnt_call(req, NLMPROC_LOCK)) >= 0
-	 && req->a_res.status == NLM_LCK_GRANTED)
+	 && req->a_res.status == nlm_granted)
 		return 0;
 
 	printk(KERN_WARNING "lockd: failed to reclaim lock for pid %d "
 				"(errno %d, status %d)\n", fl->fl_pid,
-				status, req->a_res.status);
+				status, ntohl(req->a_res.status));
 
 	/*
 	 * FIXME: This is a serious failure. We can
@@ -637,10 +637,10 @@ nlmclnt_unlock(struct nlm_rqst *req, str
 	if (status < 0)
 		goto out;
 
-	if (resp->status == NLM_LCK_GRANTED)
+	if (resp->status == nlm_granted)
 		goto out;
 
-	if (resp->status != NLM_LCK_DENIED_NOLOCKS)
+	if (resp->status != nlm_lck_denied_nolocks)
 		printk("lockd: unexpected unlock status: %d\n", resp->status);
 	/* What to do now? I'm out of my depth... */
 	status = -ENOLCK;
@@ -652,7 +652,7 @@ out:
 static void nlmclnt_unlock_callback(struct rpc_task *task, void *data)
 {
 	struct nlm_rqst	*req = data;
-	int		status = req->a_res.status;
+	u32 status = ntohl(req->a_res.status);
 
 	if (RPC_ASSASSINATED(task))
 		goto die;
@@ -720,6 +720,7 @@ static int nlmclnt_cancel(struct nlm_hos
 static void nlmclnt_cancel_callback(struct rpc_task *task, void *data)
 {
 	struct nlm_rqst	*req = data;
+	u32 status = ntohl(req->a_res.status);
 
 	if (RPC_ASSASSINATED(task))
 		goto die;
@@ -731,9 +732,9 @@ static void nlmclnt_cancel_callback(stru
 	}
 
 	dprintk("lockd: cancel status %u (task %u)\n",
-			req->a_res.status, task->tk_pid);
+			status, task->tk_pid);
 
-	switch (req->a_res.status) {
+	switch (status) {
 	case NLM_LCK_GRANTED:
 	case NLM_LCK_DENIED_GRACE_PERIOD:
 	case NLM_LCK_DENIED:
@@ -744,7 +745,7 @@ static void nlmclnt_cancel_callback(stru
 		goto retry_cancel;
 	default:
 		printk(KERN_NOTICE "lockd: weird return %d for CANCEL call\n",
-			req->a_res.status);
+			status);
 	}
 
 die:
@@ -768,9 +769,9 @@ static const struct rpc_call_ops nlmclnt
  * Convert an NLM status code to a generic kernel errno
  */
 static int
-nlm_stat_to_errno(u32 status)
+nlm_stat_to_errno(__be32 status)
 {
-	switch(status) {
+	switch(ntohl(status)) {
 	case NLM_LCK_GRANTED:
 		return 0;
 	case NLM_LCK_DENIED:
diff -puN fs/lockd/svclock.c~lockd-endianness-annotations-rebased fs/lockd/svclock.c
--- a/fs/lockd/svclock.c~lockd-endianness-annotations-rebased
+++ a/fs/lockd/svclock.c
@@ -645,7 +645,7 @@ static const struct rpc_call_ops nlmsvc_
  * block.
  */
 void
-nlmsvc_grant_reply(struct nlm_cookie *cookie, u32 status)
+nlmsvc_grant_reply(struct nlm_cookie *cookie, __be32 status)
 {
 	struct nlm_block	*block;
 
@@ -655,7 +655,7 @@ nlmsvc_grant_reply(struct nlm_cookie *co
 		return;
 
 	if (block) {
-		if (status == NLM_LCK_DENIED_GRACE_PERIOD) {
+		if (status == nlm_lck_denied_grace_period) {
 			/* Try again in a couple of seconds */
 			nlmsvc_insert_block(block, 10 * HZ);
 		} else {
diff -puN fs/lockd/xdr.c~lockd-endianness-annotations-rebased fs/lockd/xdr.c
--- a/fs/lockd/xdr.c~lockd-endianness-annotations-rebased
+++ a/fs/lockd/xdr.c
@@ -361,7 +361,7 @@ nlmsvc_decode_res(struct svc_rqst *rqstp
 {
 	if (!(p = nlm_decode_cookie(p, &resp->cookie)))
 		return 0;
-	resp->status = ntohl(*p++);
+	resp->status = *p++;
 	return xdr_argsize_check(rqstp, p);
 }
 
@@ -407,8 +407,8 @@ nlmclt_decode_testres(struct rpc_rqst *r
 {
 	if (!(p = nlm_decode_cookie(p, &resp->cookie)))
 		return -EIO;
-	resp->status = ntohl(*p++);
-	if (resp->status == NLM_LCK_DENIED) {
+	resp->status = *p++;
+	if (resp->status == nlm_lck_denied) {
 		struct file_lock	*fl = &resp->lock.fl;
 		u32			excl;
 		s32			start, len, end;
@@ -506,7 +506,7 @@ nlmclt_decode_res(struct rpc_rqst *req, 
 {
 	if (!(p = nlm_decode_cookie(p, &resp->cookie)))
 		return -EIO;
-	resp->status = ntohl(*p++);
+	resp->status = *p++;
 	return 0;
 }
 
diff -puN fs/lockd/xdr4.c~lockd-endianness-annotations-rebased fs/lockd/xdr4.c
--- a/fs/lockd/xdr4.c~lockd-endianness-annotations-rebased
+++ a/fs/lockd/xdr4.c
@@ -367,7 +367,7 @@ nlm4svc_decode_res(struct svc_rqst *rqst
 {
 	if (!(p = nlm4_decode_cookie(p, &resp->cookie)))
 		return 0;
-	resp->status = ntohl(*p++);
+	resp->status = *p++;
 	return xdr_argsize_check(rqstp, p);
 }
 
@@ -413,8 +413,8 @@ nlm4clt_decode_testres(struct rpc_rqst *
 {
 	if (!(p = nlm4_decode_cookie(p, &resp->cookie)))
 		return -EIO;
-	resp->status = ntohl(*p++);
-	if (resp->status == NLM_LCK_DENIED) {
+	resp->status = *p++;
+	if (resp->status == nlm_lck_denied) {
 		struct file_lock	*fl = &resp->lock.fl;
 		u32			excl;
 		s64			start, end, len;
@@ -512,7 +512,7 @@ nlm4clt_decode_res(struct rpc_rqst *req,
 {
 	if (!(p = nlm4_decode_cookie(p, &resp->cookie)))
 		return -EIO;
-	resp->status = ntohl(*p++);
+	resp->status = *p++;
 	return 0;
 }
 
diff -puN fs/nfsd/lockd.c~lockd-endianness-annotations-rebased fs/nfsd/lockd.c
--- a/fs/nfsd/lockd.c~lockd-endianness-annotations-rebased
+++ a/fs/nfsd/lockd.c
@@ -22,7 +22,7 @@
 /*
  * Note: we hold the dentry use count while the file is open.
  */
-static u32
+static __be32
 nlm_fopen(struct svc_rqst *rqstp, struct nfs_fh *f, struct file **filp)
 {
 	__be32		nfserr;
diff -puN include/linux/lockd/bind.h~lockd-endianness-annotations-rebased include/linux/lockd/bind.h
--- a/include/linux/lockd/bind.h~lockd-endianness-annotations-rebased
+++ a/include/linux/lockd/bind.h
@@ -23,7 +23,7 @@ struct svc_rqst;
  * This is the set of functions for lockd->nfsd communication
  */
 struct nlmsvc_binding {
-	u32			(*fopen)(struct svc_rqst *,
+	__be32			(*fopen)(struct svc_rqst *,
 						struct nfs_fh *,
 						struct file **);
 	void			(*fclose)(struct file *);
diff -puN include/linux/lockd/lockd.h~lockd-endianness-annotations-rebased include/linux/lockd/lockd.h
--- a/include/linux/lockd/lockd.h~lockd-endianness-annotations-rebased
+++ a/include/linux/lockd/lockd.h
@@ -191,7 +191,7 @@ __be32		  nlmsvc_cancel_blocked(struct n
 unsigned long	  nlmsvc_retry_blocked(void);
 void		  nlmsvc_traverse_blocks(struct nlm_host *, struct nlm_file *,
 					nlm_host_match_fn_t match);
-void		  nlmsvc_grant_reply(struct nlm_cookie *, u32);
+void		  nlmsvc_grant_reply(struct nlm_cookie *, __be32);
 
 /*
  * File handling for the server personality
diff -puN include/linux/lockd/sm_inter.h~lockd-endianness-annotations-rebased include/linux/lockd/sm_inter.h
--- a/include/linux/lockd/sm_inter.h~lockd-endianness-annotations-rebased
+++ a/include/linux/lockd/sm_inter.h
@@ -24,7 +24,7 @@
  * Arguments for all calls to statd
  */
 struct nsm_args {
-	u32		addr;		/* remote address */
+	__be32		addr;		/* remote address */
 	u32		prog;		/* RPC callback info */
 	u32		vers;
 	u32		proc;
diff -puN include/linux/lockd/xdr.h~lockd-endianness-annotations-rebased include/linux/lockd/xdr.h
--- a/include/linux/lockd/xdr.h~lockd-endianness-annotations-rebased
+++ a/include/linux/lockd/xdr.h
@@ -69,7 +69,7 @@ typedef struct nlm_args nlm_args;
  */
 struct nlm_res {
 	struct nlm_cookie	cookie;
-	u32			status;
+	__be32			status;
 	struct nlm_lock		lock;
 };
 
@@ -80,9 +80,9 @@ struct nlm_reboot {
 	char *		mon;
 	int		len;
 	u32		state;
-	u32		addr;
-	u32		vers;
-	u32		proto;
+	__be32		addr;
+	__be32		vers;
+	__be32		proto;
 };
 
 /*
_

Patches currently in -mm which might be from viro@ftp.linux.org.uk are

m68k-work-around-binutils-tokenizer-change.patch
slab-leaks3-default-y.patch

