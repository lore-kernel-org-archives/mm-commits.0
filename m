From: akpm@linux-foundation.org
Subject: [nacked] scsi_libc-avoid-calling-scsi_device_put-from-under-host_lock.patch removed from -mm tree
Date: Mon, 21 Dec 2009 15:36:09 -0800
Message-ID: <200912212336.nBLNa9FC002759@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51859 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751085AbZLUXgk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Dec 2009 18:36:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: strakh@ispras.ru, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     scsi_lib.c: avoid calling scsi_device_put() from under ->host_lock
has been removed from the -mm tree.  Its filename was
     scsi_libc-avoid-calling-scsi_device_put-from-under-host_lock.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi_lib.c: avoid calling scsi_device_put() from under ->host_lock
From: Alexander Strakh <strakh@ispras.ru>

Driver scsi_lib.c might sleep in atomic context, because it calls
scsi_device_put under spin_lock_irqsave.

drivers/scsi/scsi_lib.c:356:
	spin_lock_irqsave(shost->host_lock, flags);
	scsi_device_put(sdev);
Path to might_sleep macro from scsi_device_put:
1. scsi_device_put calls put_device at ./drivers/scsi/scsi.c:1111
2. put_device calls kobject_put at ./drivers/base/core.c:1038
3. kobject_put calls kref_put at ./lib/kobject.c
4. kref_put may call callback function kobject_release at ./lib/kref.c if
refcount becomes zero, which might_sleep because it calls user event. Details:
	4.1 kobject_cleanup calls kobject_uevent at ./lib/kobject.c:555
	4.2 kobject_uevent calls kobject_uevent_env at  ./lib/kobject_uevent.c:282
	4.3 kobject_uevent_env calls call_usermodehelper_exec at
./include/linux/kmod.h:83
	4.4 call_usermodehelper_exec calls wait_for_completion at
./kernel/kmod.c:481
	4.5 wait_for_completion calls wait_for_common at ./kernel/sched.c:5710
	4.5 wait_for_common calls might_sleep at ./kernels/sched.c:5692

Found by Linux Driver Verification project.

Delete wrong sleeping function calls.

Signed-off-by: Alexander Strakh <strakh@ispras.ru>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/scsi_lib.c~scsi_libc-avoid-calling-scsi_device_put-from-under-host_lock drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c~scsi_libc-avoid-calling-scsi_device_put-from-under-host_lock
+++ a/drivers/scsi/scsi_lib.c
@@ -353,9 +353,9 @@ static void scsi_single_lun_run(struct s
 
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		blk_run_queue(sdev->request_queue);
-		spin_lock_irqsave(shost->host_lock, flags);
 	
 		scsi_device_put(sdev);
+		spin_lock_irqsave(shost->host_lock, flags);
 	}
  out:
 	spin_unlock_irqrestore(shost->host_lock, flags);
_

Patches currently in -mm which might be from strakh@ispras.ru are

scsi_libc-avoid-calling-scsi_device_put-from-under-host_lock.patch

