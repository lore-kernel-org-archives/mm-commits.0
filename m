Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52EED2D8DDF;
	Fri, 22 May 2026 02:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779415619; cv=none; b=sr17l3eXH10RIagJLyc/coQJcMRgStPkYd8XWv2rteDzb+FztF67spLKlrVaqBDU6AUMYqyCnRFFtcUopsQ3PrjhGLssJ8OJQ052vb2YCjjxxh/s0eArkd2Ne2bBd7mLX9dVUcptMDzhFxWENWI/2ZlsTMfWERQN0RYEsq6ecis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779415619; c=relaxed/simple;
	bh=v2H2gPm13rZITG5qaRb54LWDslrNiIa4cv9+eIAOl5g=;
	h=Date:To:From:Subject:Message-Id; b=Ao2Nfk3loDlH7HRrryzIRMCebS3/lsQ0RnprqlzR1mQHWhhpqJXnZ2hteSLnSu1KZrxj7E0z5krpv+xdeIC94tEZIk9I4bPdunB4r9lHZImA2xiu26mvZeBpb096jJkNWQ+UxpFSeikZHjLONCcgM4hrAW3YURmtc5Z5se1taFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ye7ZSdgH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ye7ZSdgH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271FD1F000E9;
	Fri, 22 May 2026 02:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779415618;
	bh=FnvqrIaHgVQBpXX6/CL1m0NWjTrNoxymKaKMcW77u78=;
	h=Date:To:From:Subject;
	b=Ye7ZSdgHri4pdCxd7OSIKckspOSugh5lPypG+lvGamJ/oe9E+OE92YOFlLaDFBQAO
	 o+HdEyAwoQFvRuW21uym1Y6berpnMGLtOAl/P/i1hQg5DYpFICxJvcvVMGfoaschnS
	 O0bM4EJBV+ugfnpv7H9t1iUtI27DnN6vyCsL+9oc=
Date: Thu, 21 May 2026 19:06:57 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,liumartin@google.com,bgeffon@google.com,axboe@kernel.dk,a929244872@163.com,richardycc@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] zram-fix-use-after-free-in-zram_writeback_endio.patch removed from -mm tree
Message-Id: <20260522020658.271FD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: fix use-after-free in zram_writeback_endio
has been removed from the -mm tree.  Its filename was
     zram-fix-use-after-free-in-zram_writeback_endio.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Richard Chang <richardycc@google.com>
Subject: zram: fix use-after-free in zram_writeback_endio
Date: Tue, 12 May 2026 07:49:18 +0000

A crash was observed in zram_writeback_endio due to a NULL pointer
dereference in wake_up.  The root cause is a race condition between the
bio completion handler (zram_writeback_endio) and the writeback task.

In zram_writeback_endio, wake_up() is called on &wb_ctl->done_wait after
releasing wb_ctl->done_lock.  This creates a race window where the
writeback task can see num_inflight become 0, return, and free wb_ctl
before zram_writeback_endio calls wake_up().

CPU 0 (zram_writeback_endio)     CPU 1 (writeback_store)
============================     ============================
                                 zram_writeback_slots
                                   zram_submit_wb_request
                                   zram_submit_wb_request
                                   wait_event(wb_ctl->done_wait)
spin_lock(&wb_ctl->done_lock);
list_add(&req->entry, &wb_ctl->done_reqs);
spin_unlock(&wb_ctl->done_lock);
wake_up(&wb_ctl->done_wait);
                                   zram_complete_done_reqs
spin_lock(&wb_ctl->done_lock);
list_add(&req->entry, &wb_ctl->done_reqs);
spin_unlock(&wb_ctl->done_lock);
                                   while (num_inflight) > 0)
                                     spin_lock(&wb_ctl->done_lock);
                                     list_del(&req->entry);
                                     spin_unlock(&wb_ctl->done_lock);
                                     // num_inflight becomes 0
                                     atomic_dec(num_inflight);

                                 // Leave zram_writeback_slots
                                 // Free wb_ctl
                                 release_wb_ctl(wb_ctl);
// UAF crash!
wake_up(&wb_ctl->done_wait);

This patch fixes this race by using RCU.  By protecting wb_ctl with
rcu_read_lock() in zram_writeback_endio and using kfree_rcu() to free it,
we ensure that wb_ctl remains valid during the execution of
zram_writeback_endio.

Link: https://lore.kernel.org/20260512074918.2606208-1-richardycc@google.com
Fixes: f405066a1f0d ("zram: introduce writeback bio batching")
Signed-off-by: Richard Chang <richardycc@google.com>
Suggested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Suggested-by: Minchan Kim <minchan@kernel.org>
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Martin Liu <liumartin@google.com>
Cc: wang wei <a929244872@163.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-fix-use-after-free-in-zram_writeback_endio
+++ a/drivers/block/zram/zram_drv.c
@@ -33,6 +33,7 @@
 #include <linux/cpuhotplug.h>
 #include <linux/part_stat.h>
 #include <linux/kernel_read_file.h>
+#include <linux/rcupdate.h>
 
 #include "zram_drv.h"
 
@@ -504,6 +505,7 @@ struct zram_wb_ctl {
 	wait_queue_head_t done_wait;
 	spinlock_t done_lock;
 	atomic_t num_inflight;
+	struct rcu_head rcu;
 };
 
 struct zram_wb_req {
@@ -847,7 +849,7 @@ static void release_wb_ctl(struct zram_w
 		release_wb_req(req);
 	}
 
-	kfree(wb_ctl);
+	kfree_rcu(wb_ctl, rcu);
 }
 
 static struct zram_wb_ctl *init_wb_ctl(struct zram *zram)
@@ -964,11 +966,13 @@ static void zram_writeback_endio(struct
 	struct zram_wb_ctl *wb_ctl = bio->bi_private;
 	unsigned long flags;
 
+	rcu_read_lock();
 	spin_lock_irqsave(&wb_ctl->done_lock, flags);
 	list_add(&req->entry, &wb_ctl->done_reqs);
 	spin_unlock_irqrestore(&wb_ctl->done_lock, flags);
 
 	wake_up(&wb_ctl->done_wait);
+	rcu_read_unlock();
 }
 
 static void zram_submit_wb_request(struct zram *zram,
_

Patches currently in -mm which might be from richardycc@google.com are


