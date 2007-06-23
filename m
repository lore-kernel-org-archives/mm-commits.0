From: akpm@linux-foundation.org
Subject: - s390-spinlock-initializer-cleanup.patch removed from -mm tree
Date: Sat, 23 Jun 2007 12:28:19 -0700
Message-ID: <200706231928.l5NJSJ3E022135@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59758 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755646AbXFWTf0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 15:35:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, heiko.carstens@de.ibm.com, jeff@garzik.org, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     S390: Spinlock initializer cleanup
has been removed from the -mm tree.  Its filename was
     s390-spinlock-initializer-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: S390: Spinlock initializer cleanup
From: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/net/netiucv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/s390/net/netiucv.c~s390-spinlock-initializer-cleanup drivers/s390/net/netiucv.c
--- a/drivers/s390/net/netiucv.c~s390-spinlock-initializer-cleanup
+++ a/drivers/s390/net/netiucv.c
@@ -212,7 +212,7 @@ struct iucv_connection {
  */
 static struct list_head iucv_connection_list =
 	LIST_HEAD_INIT(iucv_connection_list);
-static rwlock_t iucv_connection_rwlock = RW_LOCK_UNLOCKED;
+DEFINE_RWLOCK(iucv_connection_rwlock);
 
 /**
  * Representation of event-data for the
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-acpi-add-exports.patch
git-arm.patch
i386-hpet-check-if-the-counter-works.patch
remove-clockevents_releaserequest_device.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
improve-behaviour-of-spurious-irq-detect.patch
improve-behaviour-of-spurious-irq-detect-fix.patch
lguest-the-host-code.patch
