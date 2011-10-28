From: akpm@linux-foundation.org
Subject: + ida-make-ida_simple_get-put-irq-safe.patch added to -mm tree
Date: Fri, 28 Oct 2011 16:01:30 -0700
Message-ID: <201110282301.p9SN1UuA008723@hpaq1.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:16392 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932722Ab1J1XBn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2011 19:01:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, rusty@rustcorp.com.au


The patch titled
     Subject: ida: make ida_simple_get/put() IRQ safe
has been added to the -mm tree.  Its filename is
     ida-make-ida_simple_get-put-irq-safe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Subject: Subject: ida: make ida_simple_get/put() IRQ safe

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
drivers-scsi-sdc-use-ida_simple_get-and-ida_simple_remove-in-place-of-boilerplate-code.patch
drivers-scsi-osd-osd_uldc-use-ida_simple_get-to-handle-id.patch
memblock-add-memblock_start_of_dram.patch
memblock-add-no_bootmem-config-symbol.patch
fs-pipec-add-statfs-callback-for-pipefs.patch
hwmon-convert-idr-to-ida-and-use-ida_simple-interface.patch
drivers-hwmon-hwmonc-convert-idr-to-ida-and-use-ida_simple_get.patch
stop_machine-make-stop_machine-safe-and-efficient-to-call-early.patch
stop_machine-make-stop_machine-safe-and-efficient-to-call-early-v3.patch
cgroups-fix-ordering-of-calls-in-cgroup_attach_proc.patch
ida-make-ida_simple_get-put-irq-safe.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update.patch
scatterlist-new-helper-functions-update-fix.patch

