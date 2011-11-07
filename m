From: akpm@linux-foundation.org
Subject: [merged] ida-make-ida_simple_get-put-irq-safe.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:27:49 -0800
Message-ID: <201111072027.pA7KRnMN027277@hpaq1.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:47300 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab1KGU2A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:28:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: ida: make ida_simple_get/put() IRQ safe
has been removed from the -mm tree.  Its filename was
     ida-make-ida_simple_get-put-irq-safe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: ida: make ida_simple_get/put() IRQ safe

It's often convenient to be able to release resource from IRQ context. 
Make ida_simple_*() use irqsave/restore spin ops so that they are IRQ
safe.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN lib/idr.c~ida-make-ida_simple_get-put-irq-safe lib/idr.c
--- a/lib/idr.c~ida-make-ida_simple_get-put-irq-safe
+++ a/lib/idr.c
@@ -944,6 +944,7 @@ int ida_simple_get(struct ida *ida, unsi
 {
 	int ret, id;
 	unsigned int max;
+	unsigned long flags;
 
 	BUG_ON((int)start < 0);
 	BUG_ON((int)end < 0);
@@ -959,7 +960,7 @@ again:
 	if (!ida_pre_get(ida, gfp_mask))
 		return -ENOMEM;
 
-	spin_lock(&simple_ida_lock);
+	spin_lock_irqsave(&simple_ida_lock, flags);
 	ret = ida_get_new_above(ida, start, &id);
 	if (!ret) {
 		if (id > max) {
@@ -969,7 +970,7 @@ again:
 			ret = id;
 		}
 	}
-	spin_unlock(&simple_ida_lock);
+	spin_unlock_irqrestore(&simple_ida_lock, flags);
 
 	if (unlikely(ret == -EAGAIN))
 		goto again;
@@ -985,10 +986,12 @@ EXPORT_SYMBOL(ida_simple_get);
  */
 void ida_simple_remove(struct ida *ida, unsigned int id)
 {
+	unsigned long flags;
+
 	BUG_ON((int)id < 0);
-	spin_lock(&simple_ida_lock);
+	spin_lock_irqsave(&simple_ida_lock, flags);
 	ida_remove(ida, id);
-	spin_unlock(&simple_ida_lock);
+	spin_unlock_irqrestore(&simple_ida_lock, flags);
 }
 EXPORT_SYMBOL(ida_simple_remove);
 
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
drivers-scsi-osd-osd_uldc-use-ida_simple_get-to-handle-id.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update.patch
scatterlist-new-helper-functions-update-fix.patch

