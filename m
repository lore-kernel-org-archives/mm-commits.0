From: akpm@linux-foundation.org
Subject: - usbatm_heavy_init-dont-use-clone_sighand.patch removed from -mm tree
Date: Wed, 09 May 2007 14:52:31 -0700
Message-ID: <200705092152.l49LqVme003004@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759179AbXEIVw6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:52:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, duncan.sands@free.fr, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usbatm_heavy_init: don't use CLONE_SIGHAND
has been removed from the -mm tree.  Its filename was
     usbatm_heavy_init-dont-use-clone_sighand.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: usbatm_heavy_init: don't use CLONE_SIGHAND
From: Oleg Nesterov <oleg@tv-sign.ru>

usbatm_do_heavy_init() calls allow_signal() which plays with parent process's
->sighand.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Duncan Sands <duncan.sands@free.fr>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/atm/usbatm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/atm/usbatm.c~usbatm_heavy_init-dont-use-clone_sighand drivers/usb/atm/usbatm.c
--- a/drivers/usb/atm/usbatm.c~usbatm_heavy_init-dont-use-clone_sighand
+++ a/drivers/usb/atm/usbatm.c
@@ -1033,7 +1033,7 @@ static int usbatm_do_heavy_init(void *ar
 
 static int usbatm_heavy_init(struct usbatm_data *instance)
 {
-	int ret = kernel_thread(usbatm_do_heavy_init, instance, CLONE_KERNEL);
+	int ret = kernel_thread(usbatm_do_heavy_init, instance, CLONE_FS | CLONE_FILES);
 
 	if (ret < 0) {
 		usb_err(instance, "%s: failed to create kernel_thread (%d)!\n", __func__, ret);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
fix-pf_nofreeze-and-freezeable-race-2.patch
freezer-document-task_lock-in-thaw_process.patch
move-frozen_process-to-kernel-power-processc.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
libata-core-convert-to-use-cancel_rearming_delayed_work.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch
dont-init-pgrp-and-__session-in-init_signals.patch
