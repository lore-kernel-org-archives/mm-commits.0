From: akpm@osdl.org
Subject: - aio-remove-ki_retried-debugging-member.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:17:11 -0800
Message-ID: <200612072317.kB7NHBqW030905@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53841 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163830AbWLGXRc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:17:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bcrl@kvack.org, kenneth.w.chen@intel.com, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     aio: remove ki_retried debugging member
has been removed from the -mm tree.  Its filename was
     aio-remove-ki_retried-debugging-member.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: aio: remove ki_retried debugging member
From: Benjamin LaHaise <bcrl@kvack.org>

Remove the ki_retried member from struct kiocb.  I think the idea was
bounced around a while back, but Arnaldo pointed out another reason that we
should dig it up when he pointed out that the last cacheline of struct
kiocb only contains 4 bytes.  By removing the debugging member, we save
more than the 8 byte on 64 bit machines.

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Acked-by: Ken Chen <kenneth.w.chen@intel.com>
Acked-by: Zach Brown <zach.brown@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/aio.c            |   15 ---------------
 include/linux/aio.h |    2 --
 2 files changed, 17 deletions(-)

diff -puN fs/aio.c~aio-remove-ki_retried-debugging-member fs/aio.c
--- a/fs/aio.c~aio-remove-ki_retried-debugging-member
+++ a/fs/aio.c
@@ -666,17 +666,6 @@ static ssize_t aio_run_iocb(struct kiocb
 	ssize_t (*retry)(struct kiocb *);
 	ssize_t ret;
 
-	if (iocb->ki_retried++ > 1024*1024) {
-		printk("Maximal retry count.  Bytes done %Zd\n",
-			iocb->ki_nbytes - iocb->ki_left);
-		return -EAGAIN;
-	}
-
-	if (!(iocb->ki_retried & 0xff)) {
-		pr_debug("%ld retry: %zd of %zd\n", iocb->ki_retried,
-			iocb->ki_nbytes - iocb->ki_left, iocb->ki_nbytes);
-	}
-
 	if (!(retry = iocb->ki_retry)) {
 		printk("aio_run_iocb: iocb->ki_retry = NULL\n");
 		return 0;
@@ -1005,9 +994,6 @@ int fastcall aio_complete(struct kiocb *
 	kunmap_atomic(ring, KM_IRQ1);
 
 	pr_debug("added to ring %p at [%lu]\n", iocb, tail);
-
-	pr_debug("%ld retries: %zd of %zd\n", iocb->ki_retried,
-		iocb->ki_nbytes - iocb->ki_left, iocb->ki_nbytes);
 put_rq:
 	/* everything turned out well, dispose of the aiocb. */
 	ret = __aio_put_req(ctx, iocb);
@@ -1590,7 +1576,6 @@ int fastcall io_submit_one(struct kioctx
 	req->ki_opcode = iocb->aio_lio_opcode;
 	init_waitqueue_func_entry(&req->ki_wait, aio_wake_function);
 	INIT_LIST_HEAD(&req->ki_wait.task_list);
-	req->ki_retried = 0;
 
 	ret = aio_setup_iocb(req);
 
diff -puN include/linux/aio.h~aio-remove-ki_retried-debugging-member include/linux/aio.h
--- a/include/linux/aio.h~aio-remove-ki_retried-debugging-member
+++ a/include/linux/aio.h
@@ -111,7 +111,6 @@ struct kiocb {
 	size_t			ki_nbytes; 	/* copy of iocb->aio_nbytes */
 	char 			__user *ki_buf;	/* remaining iocb->aio_buf */
 	size_t			ki_left; 	/* remaining bytes */
-	long			ki_retried; 	/* just for testing */
 	struct iovec		ki_inline_vec;	/* inline vector */
  	struct iovec		*ki_iovec;
  	unsigned long		ki_nr_segs;
@@ -238,7 +237,6 @@ do {									\
 } while (0)
 
 #define io_wait_to_kiocb(wait) container_of(wait, struct kiocb, ki_wait)
-#define is_retried_kiocb(iocb) ((iocb)->ki_retried > 1)
 
 #include <linux/aio_abi.h>
 
_

Patches currently in -mm which might be from bcrl@kvack.org are

origin.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch

