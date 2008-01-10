From: akpm@linux-foundation.org
Subject: - sunrpc-spin-svc_rqst-initialization-to-its-own-function.patch removed from -mm tree
Date: Thu, 10 Jan 2008 15:57:30 -0800
Message-ID: <200801102357.m0ANvUMX015828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49234 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755664AbYAJX6h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 18:58:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, bfields@fieldses.org, cel@citi.umich.edu, neilb@suse.de, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     SUNRPC: spin svc_rqst initialization to its own function
has been removed from the -mm tree.  Its filename was
     sunrpc-spin-svc_rqst-initialization-to-its-own-function.patch

This patch was dropped because it keeps on changing

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: SUNRPC: spin svc_rqst initialization to its own function
From: Jeff Layton <jlayton@redhat.com>

Move the initialzation in __svc_create_thread that happens prior to thread
creation to a new function.  Export the function to allow services to have
better control over the svc_rqst structs.

Also rearrange the rqstp initialization to prevent NULL pointer dereferences
in svc_exit_thread in case allocations fail.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Chuck Lever <cel@citi.umich.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sunrpc/svc.h |    2 +
 net/sunrpc/svc.c           |   59 ++++++++++++++++++++++++-----------
 2 files changed, 44 insertions(+), 17 deletions(-)

diff -puN include/linux/sunrpc/svc.h~sunrpc-spin-svc_rqst-initialization-to-its-own-function include/linux/sunrpc/svc.h
--- a/include/linux/sunrpc/svc.h~sunrpc-spin-svc_rqst-initialization-to-its-own-function
+++ a/include/linux/sunrpc/svc.h
@@ -384,6 +384,8 @@ struct svc_procedure {
  */
 struct svc_serv *  svc_create(struct svc_program *, unsigned int,
 			      void (*shutdown)(struct svc_serv*));
+struct svc_rqst *svc_prepare_thread(struct svc_serv *serv,
+					struct svc_pool *pool);
 int		   svc_create_thread(svc_thread_fn, struct svc_serv *);
 void		   svc_exit_thread(struct svc_rqst *);
 struct svc_serv *  svc_create_pooled(struct svc_program *, unsigned int,
diff -puN net/sunrpc/svc.c~sunrpc-spin-svc_rqst-initialization-to-its-own-function net/sunrpc/svc.c
--- a/net/sunrpc/svc.c~sunrpc-spin-svc_rqst-initialization-to-its-own-function
+++ a/net/sunrpc/svc.c
@@ -533,31 +533,17 @@ svc_release_buffer(struct svc_rqst *rqst
 			put_page(rqstp->rq_pages[i]);
 }
 
-/*
- * Create a thread in the given pool.  Caller must hold BKL.
- * On a NUMA or SMP machine, with a multi-pool serv, the thread
- * will be restricted to run on the cpus belonging to the pool.
- */
-static int
-__svc_create_thread(svc_thread_fn func, struct svc_serv *serv,
-		    struct svc_pool *pool)
+struct svc_rqst *
+svc_prepare_thread(struct svc_serv *serv, struct svc_pool *pool)
 {
 	struct svc_rqst	*rqstp;
-	int		error = -ENOMEM;
-	int		have_oldmask = 0;
-	cpumask_t	oldmask;
 
 	rqstp = kzalloc(sizeof(*rqstp), GFP_KERNEL);
 	if (!rqstp)
-		goto out;
+		goto out_enomem;
 
 	init_waitqueue_head(&rqstp->rq_wait);
 
-	if (!(rqstp->rq_argp = kmalloc(serv->sv_xdrsize, GFP_KERNEL))
-	 || !(rqstp->rq_resp = kmalloc(serv->sv_xdrsize, GFP_KERNEL))
-	 || !svc_init_buffer(rqstp, serv->sv_max_mesg))
-		goto out_thread;
-
 	serv->sv_nrthreads++;
 	spin_lock_bh(&pool->sp_lock);
 	pool->sp_nrthreads++;
@@ -566,6 +552,45 @@ __svc_create_thread(svc_thread_fn func, 
 	rqstp->rq_server = serv;
 	rqstp->rq_pool = pool;
 
+	rqstp->rq_argp = kmalloc(serv->sv_xdrsize, GFP_KERNEL);
+	if (!rqstp->rq_argp)
+		goto out_thread;
+
+	rqstp->rq_resp = kmalloc(serv->sv_xdrsize, GFP_KERNEL);
+	if (!rqstp->rq_resp)
+		goto out_thread;
+
+	if (!svc_init_buffer(rqstp, serv->sv_max_mesg))
+		goto out_thread;
+
+	return rqstp;
+out_thread:
+	svc_exit_thread(rqstp);
+out_enomem:
+	return ERR_PTR(-ENOMEM);
+}
+EXPORT_SYMBOL(svc_prepare_thread);
+
+/*
+ * Create a thread in the given pool.  Caller must hold BKL.
+ * On a NUMA or SMP machine, with a multi-pool serv, the thread
+ * will be restricted to run on the cpus belonging to the pool.
+ */
+static int
+__svc_create_thread(svc_thread_fn func, struct svc_serv *serv,
+		    struct svc_pool *pool)
+{
+	struct svc_rqst	*rqstp;
+	int		error = -ENOMEM;
+	int		have_oldmask = 0;
+	cpumask_t	oldmask;
+
+	rqstp = svc_prepare_thread(serv, pool);
+	if (IS_ERR(rqstp)) {
+		error = PTR_ERR(rqstp);
+		goto out;
+	}
+
 	if (serv->sv_nrpools > 1)
 		have_oldmask = svc_pool_map_set_cpumask(pool->sp_id, &oldmask);
 
_

Patches currently in -mm which might be from jlayton@redhat.com are

git-cifs.patch
sunrpc-spin-svc_rqst-initialization-to-its-own-function.patch
sunrpc-export-svc_sock_update_bufs.patch
nlm-initialize-completion-variable-in-lockd_up.patch
nlm-have-lockd-call-try_to_freeze.patch
nlm-convert-lockd-to-use-kthreads.patch
nlm-add-reference-counting-to-lockd.patch
git-unionfs.patch
smbfs-fix-calculation-of-kernel_recvmsg-size-parameter-in-smb_receive.patch
deprecate-smbfs-in-favour-of-cifs.patch
