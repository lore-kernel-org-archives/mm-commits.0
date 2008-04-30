From: akpm@linux-foundation.org
Subject: - fs-aioc-make-3-functions-static.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:39:30 -0700
Message-ID: <200804300539.m3U5dUEZ028852@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754426AbYD3FkH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:40:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, bcrl@kvack.org, pbadari@us.ibm.com, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     fs/aio.c: make 3 functions static
has been removed from the -mm tree.  Its filename was
     fs-aioc-make-3-functions-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/aio.c: make 3 functions static
From: Adrian Bunk <bunk@kernel.org>

Make the following needlessly global functions static:

- __put_ioctx()
- lookup_ioctx()
- io_submit_one()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c            |   67 ++++++++++++++++++++++++------------------
 include/linux/aio.h |   19 -----------
 2 files changed, 39 insertions(+), 47 deletions(-)

diff -puN fs/aio.c~fs-aioc-make-3-functions-static fs/aio.c
--- a/fs/aio.c~fs-aioc-make-3-functions-static
+++ a/fs/aio.c
@@ -191,6 +191,43 @@ static int aio_setup_ring(struct kioctx 
 	kunmap_atomic((void *)((unsigned long)__event & PAGE_MASK), km); \
 } while(0)
 
+
+/* __put_ioctx
+ *	Called when the last user of an aio context has gone away,
+ *	and the struct needs to be freed.
+ */
+static void __put_ioctx(struct kioctx *ctx)
+{
+	unsigned nr_events = ctx->max_reqs;
+
+	BUG_ON(ctx->reqs_active);
+
+	cancel_delayed_work(&ctx->wq);
+	cancel_work_sync(&ctx->wq.work);
+	aio_free_ring(ctx);
+	mmdrop(ctx->mm);
+	ctx->mm = NULL;
+	pr_debug("__put_ioctx: freeing %p\n", ctx);
+	kmem_cache_free(kioctx_cachep, ctx);
+
+	if (nr_events) {
+		spin_lock(&aio_nr_lock);
+		BUG_ON(aio_nr - nr_events > aio_nr);
+		aio_nr -= nr_events;
+		spin_unlock(&aio_nr_lock);
+	}
+}
+
+#define get_ioctx(kioctx) do {						\
+	BUG_ON(atomic_read(&(kioctx)->users) <= 0);			\
+	atomic_inc(&(kioctx)->users);					\
+} while (0)
+#define put_ioctx(kioctx) do {						\
+	BUG_ON(atomic_read(&(kioctx)->users) <= 0);			\
+	if (unlikely(atomic_dec_and_test(&(kioctx)->users))) 		\
+		__put_ioctx(kioctx);					\
+} while (0)
+
 /* ioctx_alloc
  *	Allocates and initializes an ioctx.  Returns an ERR_PTR if it failed.
  */
@@ -361,32 +398,6 @@ void exit_aio(struct mm_struct *mm)
 	}
 }
 
-/* __put_ioctx
- *	Called when the last user of an aio context has gone away,
- *	and the struct needs to be freed.
- */
-void __put_ioctx(struct kioctx *ctx)
-{
-	unsigned nr_events = ctx->max_reqs;
-
-	BUG_ON(ctx->reqs_active);
-
-	cancel_delayed_work(&ctx->wq);
-	cancel_work_sync(&ctx->wq.work);
-	aio_free_ring(ctx);
-	mmdrop(ctx->mm);
-	ctx->mm = NULL;
-	pr_debug("__put_ioctx: freeing %p\n", ctx);
-	kmem_cache_free(kioctx_cachep, ctx);
-
-	if (nr_events) {
-		spin_lock(&aio_nr_lock);
-		BUG_ON(aio_nr - nr_events > aio_nr);
-		aio_nr -= nr_events;
-		spin_unlock(&aio_nr_lock);
-	}
-}
-
 /* aio_get_req
  *	Allocate a slot for an aio request.  Increments the users count
  * of the kioctx so that the kioctx stays around until all requests are
@@ -545,7 +556,7 @@ int aio_put_req(struct kiocb *req)
 /*	Lookup an ioctx id.  ioctx_list is lockless for reads.
  *	FIXME: this is O(n) and is only suitable for development.
  */
-struct kioctx *lookup_ioctx(unsigned long ctx_id)
+static struct kioctx *lookup_ioctx(unsigned long ctx_id)
 {
 	struct kioctx *ioctx;
 	struct mm_struct *mm;
@@ -1552,7 +1563,7 @@ static int aio_wake_function(wait_queue_
 	return 1;
 }
 
-int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
+static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 			 struct iocb *iocb)
 {
 	struct kiocb *req;
diff -puN include/linux/aio.h~fs-aioc-make-3-functions-static include/linux/aio.h
--- a/include/linux/aio.h~fs-aioc-make-3-functions-static
+++ a/include/linux/aio.h
@@ -209,27 +209,8 @@ extern ssize_t wait_on_sync_kiocb(struct
 extern int aio_put_req(struct kiocb *iocb);
 extern void kick_iocb(struct kiocb *iocb);
 extern int aio_complete(struct kiocb *iocb, long res, long res2);
-extern void __put_ioctx(struct kioctx *ctx);
 struct mm_struct;
 extern void exit_aio(struct mm_struct *mm);
-extern struct kioctx *lookup_ioctx(unsigned long ctx_id);
-extern int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
-			 struct iocb *iocb);
-
-/* semi private, but used by the 32bit emulations: */
-struct kioctx *lookup_ioctx(unsigned long ctx_id);
-int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
-		  struct iocb *iocb);
-
-#define get_ioctx(kioctx) do {						\
-	BUG_ON(atomic_read(&(kioctx)->users) <= 0);			\
-	atomic_inc(&(kioctx)->users);					\
-} while (0)
-#define put_ioctx(kioctx) do {						\
-	BUG_ON(atomic_read(&(kioctx)->users) <= 0);			\
-	if (unlikely(atomic_dec_and_test(&(kioctx)->users))) 		\
-		__put_ioctx(kioctx);					\
-} while (0)
 
 #define io_wait_to_kiocb(wait) container_of(wait, struct kiocb, ki_wait)
 
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
mm-filemapc-generic_write_checks-mustnt-be-inline.patch
fs-block_devc-i_bdev-mustnt-be-inline.patch
frv-fix-arch-frv-mm-unalignedo-build-error.patch
reiserfs-some-functions-mustnt-be-inline.patch
git-acpi.patch
git-x86.patch
arch-x86-video-fbdevc-add-module_license.patch
md-make-dm_dirty_log_initexit-static.patch
drm-make-drm_minors_cleanup-static.patch
git-m32r.patch
net-ipv4-ip_outputc-ip_send_check-mustnt-be-inline.patch
nfs-make-nfs4_drop_state_owner-static.patch
git-ocfs2.patch
show_schedstat-fix-memleak.patch
git-sh.patch
if-0-ses_match_host.patch
git-watchdog.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
make-marker_debug-static.patch
reiser4.patch

