From: akpm@linux-foundation.org
Subject: + usb-libusual-kthread_run-called-with-wrong-format.patch added to -mm tree
Date: Sun, 27 Apr 2008 12:11:25 -0700
Message-ID: <200804271911.m3RJBPui020581@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33163 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755554AbYD0TMC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 15:12:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, greg@kroah.com


The patch titled
     usb: libusual kthread_run() called with wrong format.
has been added to the -mm tree.  Its filename is
     usb-libusual-kthread_run-called-with-wrong-format.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
usb-libusual-kthread_run-called-with-wrong-format.patch
revert-rusty-misc-timer-typesafe.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
git-semaphore.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
kbuild-move-files-that-dont-check-__kernel__.patch
docbook-some-kernel-locking-fixes.patch
reiser4.patch

