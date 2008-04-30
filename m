From: akpm@linux-foundation.org
Subject: - usb-libusual-kthread_run-called-with-wrong-format.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:51:59 -0700
Message-ID: <200804300551.m3U5pxOs030262@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759351AbYD3Fwd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:52:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb: libusual kthread_run() called with wrong format.
has been removed from the -mm tree.  Its filename was
     usb-libusual-kthread_run-called-with-wrong-format.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: libusual kthread_run() called with wrong format.
From: Rusty Russell <rusty@rustcorp.com.au>

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/storage/libusual.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/storage/libusual.c~usb-libusual-kthread_run-called-with-wrong-format drivers/usb/storage/libusual.c
--- a/drivers/usb/storage/libusual.c~usb-libusual-kthread_run-called-with-wrong-format
+++ a/drivers/usb/storage/libusual.c
@@ -135,7 +135,7 @@ static int usu_probe(struct usb_interfac
 	stat[type].fls |= USU_MOD_FL_THREAD;
 	spin_unlock_irqrestore(&usu_lock, flags);
 
-	task = kthread_run(usu_probe_thread, (void*)type, "libusual_%d", type);
+	task = kthread_run(usu_probe_thread, (void*)type, "libusual_%ld", type);
 	if (IS_ERR(task)) {
 		rc = PTR_ERR(task);
 		printk(KERN_WARNING "libusual: "
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
git-kvm.patch
revert-rusty-misc-timer-typesafe.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
git-semaphore.patch
docbook-some-kernel-locking-fixes.patch
reiser4.patch

