From: akpm@linux-foundation.org
Subject: + workqueue-dont-save-interrupts-in-run_workqueue-update.patch added to -mm tree
Date: Tue, 06 Feb 2007 17:45:24 -0800
Message-ID: <200702070145.l171jOpe003624@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58663 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbXBGBph (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 20:45:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, oleg@tv-sign.ru


The patch titled
     workqueue-dont-save-interrupts-in-run_workqueue-update
has been added to the -mm tree.  Its filename is
     workqueue-dont-save-interrupts-in-run_workqueue-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: workqueue-dont-save-interrupts-in-run_workqueue-update
From: Andrew Morton <akpm@linux-foundation.org>

yes?

Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN kernel/workqueue.c~workqueue-dont-save-interrupts-in-run_workqueue-update kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-dont-save-interrupts-in-run_workqueue-update
+++ a/kernel/workqueue.c
@@ -227,6 +227,7 @@ EXPORT_SYMBOL_GPL(queue_delayed_work_on)
 
 static void run_workqueue(struct cpu_workqueue_struct *cwq)
 {
+	might_sleep();
 	spin_lock_irq(&cwq->lock);
 	cwq->run_depth++;
 	if (cwq->run_depth > 3) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

git-libata-all-forward-declare-struct-device.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
mm-vm_insert_pfn-tidy.patch
workqueue-dont-save-interrupts-in-run_workqueue-update.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
