From: akpm@linux-foundation.org
Subject: - sunrpc-spin-svc_rqst-initialization-to-its-own-function.patch removed from -mm tree
Date: Tue, 08 Jan 2008 15:56:08 -0800
Message-ID: <200801082356.m08Nu82l006365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42320 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752947AbYAHX6M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2008 18:58:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, bfields@fieldses.org, cel@citi.umich.edu, hch@lst.de, neilb@suse.de, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     SUNRPC: spin svc_rqst initialization to its own function
has been removed from the -mm tree.  Its filename was
     sunrpc-spin-svc_rqst-initialization-to-its-own-function.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: SUNRPC: spin svc_rqst initialization to its own function
From: Jeff Layton <jlayton@redhat.com>

Move the initialization in __svc_create_thread that happens prior to thread
creation to a new function.  Export the function to allow services to have
better control over the svc_rqst structs.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Cc: Chuck Lever <cel@citi.umich.edu>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sunrpc/svc.h |    2 +
 net/sunrpc/svc.c           |   43 +++++++++++++++++++++++++----------
 2 files changed, 33 insertions(+), 12 deletions(-)

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
@@ -533,23 +533,14 @@ svc_release_buffer(struct svc_rqst *rqst
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
 
@@ -565,6 +556,34 @@ __svc_create_thread(svc_thread_fn func, 
 	spin_unlock_bh(&pool->sp_lock);
 	rqstp->rq_server = serv;
 	rqstp->rq_pool = pool;
+	return rqstp;
+
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
