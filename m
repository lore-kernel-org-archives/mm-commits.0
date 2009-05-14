From: akpm@linux-foundation.org
Subject: [to-be-updated] serios-async-shutdown.patch removed from -mm tree
Date: Wed, 13 May 2009 20:49:14 -0700
Message-ID: <200905140349.n4E3nE4w002047@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754646AbZENDta (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 May 2009 23:49:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, arjan@infradead.org, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     serios: async shutdown
has been removed from the -mm tree.  Its filename was
     serios-async-shutdown.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serios: async shutdown
From: Shaohua Li <shaohua.li@intel.com>

serio shutdown is quite slow. It sometimes will take 0.2s for each port.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/serio/serio.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN drivers/input/serio/serio.c~serios-async-shutdown drivers/input/serio/serio.c
--- a/drivers/input/serio/serio.c~serios-async-shutdown
+++ a/drivers/input/serio/serio.c
@@ -36,6 +36,7 @@
 #include <linux/kthread.h>
 #include <linux/mutex.h>
 #include <linux/freezer.h>
+#include <linux/async.h>
 
 MODULE_AUTHOR("Vojtech Pavlik <vojtech@ucw.cz>");
 MODULE_DESCRIPTION("Serio abstraction core");
@@ -792,11 +793,17 @@ static void serio_cleanup(struct serio *
 	mutex_unlock(&serio->drv_mutex);
 }
 
+static void serio_async_shutdown(void *data, async_cookie_t cookie)
+{
+	struct serio *serio = data;
+	serio_cleanup(serio);
+}
+
 static void serio_shutdown(struct device *dev)
 {
 	struct serio *serio = to_serio_port(dev);
 
-	serio_cleanup(serio);
+	async_schedule(serio_async_shutdown, serio);
 }
 
 static void serio_attach_driver(struct serio_driver *drv)
_

Patches currently in -mm which might be from shaohua.li@intel.com are

linux-next.patch
serios-async-shutdown.patch

