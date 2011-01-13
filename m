From: akpm@linux-foundation.org
Subject: [merged] pps-trivial-fixes.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:09:16 -0800
Message-ID: <201101132011.p0DKBvOq030216@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933755Ab1AMUUr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:20:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lasaine@lvk.cs.msu.su, giometti@linux.it, mm-commits@vger.kernel.org


The patch titled
     pps: trivial fixes
has been removed from the -mm tree.  Its filename was
     pps-trivial-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pps: trivial fixes
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>

Here are some very trivial fixes combined:

- add macro definitions to protect header file from including several times

- remove declaration for an unexistent array

- fix typos

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Acked-by: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/kapi.c         |    2 +-
 include/linux/pps_kernel.h |    7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/pps/kapi.c~pps-trivial-fixes drivers/pps/kapi.c
--- a/drivers/pps/kapi.c~pps-trivial-fixes
+++ a/drivers/pps/kapi.c
@@ -324,7 +324,7 @@ void pps_event(int source, struct pps_kt
 		captured = ~0;
 	}
 
-	/* Wake up iif captured somthing */
+	/* Wake up if captured something */
 	if (captured) {
 		pps->go = ~0;
 		wake_up_interruptible(&pps->queue);
diff -puN include/linux/pps_kernel.h~pps-trivial-fixes include/linux/pps_kernel.h
--- a/include/linux/pps_kernel.h~pps-trivial-fixes
+++ a/include/linux/pps_kernel.h
@@ -18,6 +18,9 @@
  *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#ifndef LINUX_PPS_KERNEL_H
+#define LINUX_PPS_KERNEL_H
+
 #include <linux/pps.h>
 
 #include <linux/cdev.h>
@@ -71,7 +74,6 @@ struct pps_device {
 
 extern spinlock_t pps_idr_lock;
 extern struct idr pps_idr;
-extern struct timespec pps_irq_ts[];
 
 extern struct device_attribute pps_attrs[];
 
@@ -87,3 +89,6 @@ extern void pps_unregister_source(int so
 extern int pps_register_cdev(struct pps_device *pps);
 extern void pps_unregister_cdev(struct pps_device *pps);
 extern void pps_event(int source, struct pps_ktime *ts, int event, void *data);
+
+#endif /* LINUX_PPS_KERNEL_H */
+
_

Patches currently in -mm which might be from lasaine@lvk.cs.msu.su are

origin.patch

