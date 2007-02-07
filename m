From: akpm@linux-foundation.org
Subject: - workqueue-dont-save-interrupts-in-run_workqueue-update.patch removed from -mm tree
Date: Wed, 07 Feb 2007 15:26:57 -0800
Message-ID: <200702072326.l17NQvID031049@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45184 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161472AbXBGX1c (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 18:27:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mingo@elte.hu, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     workqueue-dont-save-interrupts-in-run_workqueue-update
has been removed from the -mm tree.  Its filename was
     workqueue-dont-save-interrupts-in-run_workqueue-update.patch

This patch was dropped because an updated version will be merged

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

origin.patch
fix-warning-in-device_add_attrs.patch
git-dvb.patch
kthread-api-conversion-for-dvb_frontend-and-av7110-fix.patch
git-libata-all.patch
sis-warning-fixes.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-sh.patch
git-block.patch
git-cryptodev-fixup.patch
mm-vm_insert_pfn-tidy.patch
swiotlb-uninlinings.patch
spi-filesystem-api-tweaks.patch
workqueue-dont-save-interrupts-in-run_workqueue-update.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
