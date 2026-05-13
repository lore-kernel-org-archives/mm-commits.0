Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08ED314B63;
	Wed, 13 May 2026 02:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778640960; cv=none; b=mejUGF1y7I6Aamps4VC/teZN26GnlRHde/DVlrAzhaSI43lNMdRcvyyneIR56GMFmWBc7B/EduIPcb7dIGyPTL65z0wRfuisTtzcGK6z4qWzZzHpvNq1KHTH5oVFjO+VUqw67KWNrYhyGbY9ZPcnRJqJAtrzJmUIFDis0dVZSb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778640960; c=relaxed/simple;
	bh=xmbP2ZRR7oNJJfF6MEuwvtZUdx9LzlwAAsLx2mdK7nY=;
	h=Date:To:From:Subject:Message-Id; b=eFn1ZYl3BsTNQEFGv7mkmMNZfgY5j6mw7L03j96dASCDF7TttEe0L2nN+t7FZHbPZK7YaNyEeFWmhZ5Rhr7e+pKMlOUhSPUkA4HeH7pZWDjqvPTBjbhdP8OvNNLtwwObVEGmkPVuIBcB+EZiG5i0tEIfbMrrvEVyiwtyYH4Ho34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lVihkmXD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lVihkmXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78696C2BCB8;
	Wed, 13 May 2026 02:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778640960;
	bh=xmbP2ZRR7oNJJfF6MEuwvtZUdx9LzlwAAsLx2mdK7nY=;
	h=Date:To:From:Subject:From;
	b=lVihkmXDh86IDbTRfoxWPiRMCLh0PSduciQcAy6N+eSIeDB2sZO36NfkgNDMOspG0
	 EjiGNTteuJDZFALpk4xDjwqGf641qP4b+zEoJOpgt7CpFqILXY5ylywjlj9AJtgpuI
	 +Y6u/MhV0FR0ZDIqtEW+OksJDVIRMQpaCLY55ocE=
Date: Tue, 12 May 2026 19:55:59 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,liumartin@google.com,bgeffon@google.com,axboe@kernel.dk,richardycc@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-fix-use-after-free-in-zram_writeback_endio.patch added to mm-hotfixes-unstable branch
Message-Id: <20260513025600.78696C2BCB8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: fix use-after-free in zram_writeback_endio
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     zram-fix-use-after-free-in-zram_writeback_endio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-fix-use-after-free-in-zram_writeback_endio.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

zram-fix-use-after-free-in-zram_writeback_endio.patch

