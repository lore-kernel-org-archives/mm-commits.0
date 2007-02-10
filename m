From: akpm@linux-foundation.org
Subject: - drivers-add-lcd-support-update-7.patch removed from -mm tree
Date: Sat, 10 Feb 2007 00:10:33 -0800
Message-ID: <200702100810.l1A8AX1O006944@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39268 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965AbXBJIKg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 03:10:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maxextreme@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers: add LCD support (update 7)
has been removed from the -mm tree.  Its filename was
     drivers-add-lcd-support-update-7.patch

This patch was dropped because it was folded into drivers-add-lcd-support-3.patch

------------------------------------------------------
Subject: drivers: add LCD support (update 7)
From: Miguel Ojeda Sandonis <maxextreme@gmail.com>

 - cfag12864b_work should be static
 - spelling
 - coding style

Signed-off-by: Miguel Ojeda Sandonis <maxextreme@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/auxdisplay/cfag12864b.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/auxdisplay/cfag12864b.c~drivers-add-lcd-support-update-7 drivers/auxdisplay/cfag12864b.c
--- a/drivers/auxdisplay/cfag12864b.c~drivers-add-lcd-support-update-7
+++ a/drivers/auxdisplay/cfag12864b.c
@@ -63,10 +63,10 @@ unsigned int cfag12864b_getrate(void)
  *		cfag12864b/ks0108 reads the command/data.
  *
  *	CS1 = First ks0108controller.
- *		If high, the first ks0108 receives commands/data.
+ *		If high, the first ks0108 controller receives commands/data.
  *
  *	CS2 = Second ks0108 controller
- *		If high, the second ks0108 receives commands/data.
+ *		If high, the second ks0108 controller receives commands/data.
  *
  *	DI = Data/Instruction
  *		If low, cfag12864b will expect commands.
@@ -223,7 +223,7 @@ static DEFINE_MUTEX(cfag12864b_mutex);
 static unsigned char cfag12864b_updating;
 static void cfag12864b_update(void *arg);
 static struct workqueue_struct *cfag12864b_workqueue;
-DECLARE_WORK(cfag12864b_work, cfag12864b_update, NULL);
+static DECLARE_WORK(cfag12864b_work, cfag12864b_update, NULL);
 
 static void cfag12864b_queue(void)
 {
@@ -241,8 +241,7 @@ unsigned char cfag12864b_enable(void)
 		cfag12864b_updating = 1;
 		cfag12864b_queue();
 		ret = 0;
-	}
-	else
+	} else
 		ret = 1;
 
 	mutex_unlock(&cfag12864b_mutex);
_

Patches currently in -mm which might be from maxextreme@gmail.com are

drivers-add-lcd-support-3.patch
drivers-add-lcd-support-update-7.patch
drivers-add-lcd-support-update-8.patch
drivers-add-lcd-support-update-9.patch
drivers-add-lcd-support-workqueue-fixups.patch
