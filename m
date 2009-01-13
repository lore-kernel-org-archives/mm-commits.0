From: akpm@linux-foundation.org
Subject: + serios-async-shutdown.patch added to -mm tree
Date: Tue, 13 Jan 2009 14:02:36 -0800
Message-ID: <200901132202.n0DM2a23009143@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754709AbZAMWC5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 17:02:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, arjan@infradead.org, dtor@mail.ru


The patch titled
     serios: async shutdown
has been added to the -mm tree.  Its filename is
     serios-async-shutdown.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -798,11 +799,17 @@ static void serio_cleanup(struct serio *
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
synchronize-device-shutdown.patch
serios-async-shutdown.patch
sd-async-shutdown.patch

