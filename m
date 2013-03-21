From: akpm@linux-foundation.org
Subject: [to-be-updated] aio-dprintk-pr_debug.patch removed from -mm tree
Date: Thu, 21 Mar 2013 15:27:51 -0700
Message-ID: <20130321222751.A25785A42C2@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:62778 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932796Ab3CUW1x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 18:27:53 -0400
Received: by mail-ye0-f201.google.com with SMTP id m12so310484yen.2
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 15:27:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, tytso@mit.edu, viro@zeniv.linux.org.uk, zab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aio: dprintk() -> pr_debug()
has been removed from the -mm tree.  Its filename was
     aio-dprintk-pr_debug.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kent Overstreet <koverstreet@google.com>
Subject: aio: dprintk() -> pr_debug()

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Zach Brown <zab@redhat.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Selvan Mani <smani@micron.com>
Cc: Sam Bradshaw <sbradshaw@micron.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |   57 ++++++++++++++++++++++-------------------------------
 1 file changed, 24 insertions(+), 33 deletions(-)

diff -puN fs/aio.c~aio-dprintk-pr_debug fs/aio.c
--- a/fs/aio.c~aio-dprintk-pr_debug
+++ a/fs/aio.c
@@ -8,6 +8,8 @@
  *
  *	See ../COPYING for licensing terms.
  */
+#define pr_fmt(fmt) "%s: " fmt, __func__
+
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/errno.h>
@@ -18,8 +20,6 @@
 #include <linux/backing-dev.h>
 #include <linux/uio.h>
 
-#define DEBUG 0
-
 #include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/file.h>
@@ -39,12 +39,6 @@
 #include <asm/kmap_types.h>
 #include <asm/uaccess.h>
 
-#if DEBUG > 1
-#define dprintk		printk
-#else
-#define dprintk(x...)	do { ; } while (0)
-#endif
-
 #define AIO_RING_MAGIC			0xa10a10a1
 #define AIO_RING_COMPAT_FEATURES	1
 #define AIO_RING_INCOMPAT_FEATURES	0
@@ -124,7 +118,7 @@ static int __init aio_setup(void)
 	kiocb_cachep = KMEM_CACHE(kiocb, SLAB_HWCACHE_ALIGN|SLAB_PANIC);
 	kioctx_cachep = KMEM_CACHE(kioctx,SLAB_HWCACHE_ALIGN|SLAB_PANIC);
 
-	pr_debug("aio_setup: sizeof(struct page) = %d\n", (int)sizeof(struct page));
+	pr_debug("sizeof(struct page) = %zu\n", sizeof(struct page));
 
 	return 0;
 }
@@ -178,7 +172,7 @@ static int aio_setup_ring(struct kioctx
 	}
 
 	info->mmap_size = nr_pages * PAGE_SIZE;
-	dprintk("attempting mmap of %lu bytes\n", info->mmap_size);
+	pr_debug("attempting mmap of %lu bytes\n", info->mmap_size);
 	down_write(&mm->mmap_sem);
 	info->mmap_base = do_mmap_pgoff(NULL, 0, info->mmap_size, 
 					PROT_READ|PROT_WRITE,
@@ -191,7 +185,7 @@ static int aio_setup_ring(struct kioctx
 		return -EAGAIN;
 	}
 
-	dprintk("mmap address: 0x%08lx\n", info->mmap_base);
+	pr_debug("mmap address: 0x%08lx\n", info->mmap_base);
 	info->nr_pages = get_user_pages(current, mm, info->mmap_base, nr_pages,
 					1, 0, info->ring_pages, NULL);
 	up_write(&mm->mmap_sem);
@@ -265,7 +259,7 @@ static void __put_ioctx(struct kioctx *c
 		aio_nr -= nr_events;
 		spin_unlock(&aio_nr_lock);
 	}
-	pr_debug("__put_ioctx: freeing %p\n", ctx);
+	pr_debug("freeing %p\n", ctx);
 	call_rcu(&ctx->rcu_head, ctx_rcu_free);
 }
 
@@ -354,7 +348,7 @@ static struct kioctx *ioctx_alloc(unsign
 	hlist_add_head_rcu(&ctx->list, &mm->ioctx_list);
 	spin_unlock(&mm->ioctx_lock);
 
-	dprintk("aio: allocated ioctx %p[%ld]: mm=%p mask=0x%x\n",
+	pr_debug("allocated ioctx %p[%ld]: mm=%p mask=0x%x\n",
 		ctx, ctx->user_id, mm, ctx->ring_info.nr);
 	return ctx;
 
@@ -363,7 +357,7 @@ out_cleanup:
 	aio_free_ring(ctx);
 out_freectx:
 	kmem_cache_free(kioctx_cachep, ctx);
-	dprintk("aio: error allocating ioctx %d\n", err);
+	pr_debug("error allocating ioctx %d\n", err);
 	return ERR_PTR(err);
 }
 
@@ -611,8 +605,8 @@ static inline void really_put_req(struct
  */
 static void __aio_put_req(struct kioctx *ctx, struct kiocb *req)
 {
-	dprintk(KERN_DEBUG "aio_put(%p): f_count=%ld\n",
-		req, atomic_long_read(&req->ki_filp->f_count));
+	pr_debug("(%p): f_count=%ld\n",
+		 req, atomic_long_read(&req->ki_filp->f_count));
 
 	assert_spin_locked(&ctx->ctx_lock);
 
@@ -722,9 +716,9 @@ void aio_complete(struct kiocb *iocb, lo
 	event->res = res;
 	event->res2 = res2;
 
-	dprintk("aio_complete: %p[%lu]: %p: %p %Lx %lx %lx\n",
-		ctx, tail, iocb, iocb->ki_obj.user, iocb->ki_user_data,
-		res, res2);
+	pr_debug("%p[%lu]: %p: %p %Lx %lx %lx\n",
+		 ctx, tail, iocb, iocb->ki_obj.user, iocb->ki_user_data,
+		 res, res2);
 
 	/* after flagging the request as done, we
 	 * must never even look at it again
@@ -780,9 +774,7 @@ static int aio_read_evt(struct kioctx *i
 	int ret = 0;
 
 	ring = kmap_atomic(info->ring_pages[0]);
-	dprintk("in aio_read_evt h%lu t%lu m%lu\n",
-		 (unsigned long)ring->head, (unsigned long)ring->tail,
-		 (unsigned long)ring->nr);
+	pr_debug("h%u t%u m%u\n", ring->head, ring->tail, ring->nr);
 
 	if (ring->head == ring->tail)
 		goto out;
@@ -803,8 +795,7 @@ static int aio_read_evt(struct kioctx *i
 
 out:
 	kunmap_atomic(ring);
-	dprintk("leaving aio_read_evt: %d  h%lu t%lu\n", ret,
-		 (unsigned long)ring->head, (unsigned long)ring->tail);
+	pr_debug("%d  h%u t%u\n", ret, ring->head, ring->tail);
 	return ret;
 }
 
@@ -867,13 +858,13 @@ static int read_events(struct kioctx *ct
 		if (unlikely(ret <= 0))
 			break;
 
-		dprintk("read event: %Lx %Lx %Lx %Lx\n",
-			ent.data, ent.obj, ent.res, ent.res2);
+		pr_debug("%Lx %Lx %Lx %Lx\n",
+			 ent.data, ent.obj, ent.res, ent.res2);
 
 		/* Could we split the check in two? */
 		ret = -EFAULT;
 		if (unlikely(copy_to_user(event, &ent, sizeof(ent)))) {
-			dprintk("aio: lost an event due to EFAULT.\n");
+			pr_debug("lost an event due to EFAULT.\n");
 			break;
 		}
 		ret = 0;
@@ -936,7 +927,7 @@ static int read_events(struct kioctx *ct
 
 		ret = -EFAULT;
 		if (unlikely(copy_to_user(event, &ent, sizeof(ent)))) {
-			dprintk("aio: lost an event due to EFAULT.\n");
+			pr_debug("lost an event due to EFAULT.\n");
 			break;
 		}
 
@@ -967,7 +958,7 @@ static void io_destroy(struct kioctx *io
 	hlist_del_rcu(&ioctx->list);
 	spin_unlock(&mm->ioctx_lock);
 
-	dprintk("aio_release(%p)\n", ioctx);
+	pr_debug("(%p)\n", ioctx);
 	if (likely(!was_dead))
 		put_ioctx(ioctx);	/* twice for the list */
 
@@ -1260,7 +1251,7 @@ static ssize_t aio_setup_iocb(struct kio
 			kiocb->ki_retry = aio_fsync;
 		break;
 	default:
-		dprintk("EINVAL: io_submit: no operation provided\n");
+		pr_debug("EINVAL: no operation provided\n");
 		ret = -EINVAL;
 	}
 
@@ -1280,7 +1271,7 @@ static int io_submit_one(struct kioctx *
 
 	/* enforce forwards compatibility on users */
 	if (unlikely(iocb->aio_reserved1 || iocb->aio_reserved2)) {
-		pr_debug("EINVAL: io_submit: reserve field set\n");
+		pr_debug("EINVAL: reserve field set\n");
 		return -EINVAL;
 	}
 
@@ -1321,7 +1312,7 @@ static int io_submit_one(struct kioctx *
 
 	ret = put_user(req->ki_key, &user_iocb->aio_key);
 	if (unlikely(ret)) {
-		dprintk("EFAULT: aio_key\n");
+		pr_debug("EFAULT: aio_key\n");
 		goto out_put_req;
 	}
 
@@ -1402,7 +1393,7 @@ long do_io_submit(aio_context_t ctx_id,
 
 	ctx = lookup_ioctx(ctx_id);
 	if (unlikely(!ctx)) {
-		pr_debug("EINVAL: io_submit: invalid context id\n");
+		pr_debug("EINVAL: invalid context id\n");
 		return -EINVAL;
 	}
 
_

Patches currently in -mm which might be from koverstreet@google.com are

aio-do-fget-after-aio_get_req.patch
aio-make-aio_put_req-lockless.patch
aio-refcounting-cleanup.patch
wait-add-wait_event_hrtimeout.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers.patch
aio-use-flush_dcache_page.patch
aio-use-cancellation-list-lazily.patch
aio-change-reqs_active-to-include-unreaped-completions.patch
aio-kill-batch-allocation.patch
aio-kill-struct-aio_ring_info.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
aio-reqs_active-reqs_available.patch
aio-percpu-reqs_available.patch
generic-dynamic-per-cpu-refcounting.patch
aio-percpu-ioctx-refcount.patch
aio-use-xchg-instead-of-completion_lock.patch
aio-dont-include-aioh-in-schedh.patch
aio-kill-ki_key.patch
aio-kill-ki_retry.patch
block-aio-batch-completion-for-bios-kiocbs.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-fix-aio_read_events_ring-types.patch
aio-document-clarify-aio_read_events-and-shadow_tail.patch
aio-correct-calculation-of-available-events.patch
aio-v2-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch
aio-fix-ringbuffer-calculation-so-we-dont-wrap.patch

