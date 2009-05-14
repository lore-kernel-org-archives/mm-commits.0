From: akpm@linux-foundation.org
Subject: [to-be-updated] synchronize-device-shutdown.patch removed from -mm tree
Date: Wed, 13 May 2009 20:49:11 -0700
Message-ID: <200905140349.n4E3nB6H002002@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44949 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754552AbZENDt3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 May 2009 23:49:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, James.Bottomley@HansenPartnership.com, arjan@infradead.org, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     synchronize device shutdown
has been removed from the -mm tree.  Its filename was
     synchronize-device-shutdown.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: synchronize device shutdown
From: Shaohua Li <shaohua.li@intel.com>

A patch series to make .shutdown execute asynchronously.  Some drivers's
shutdown can take a lot of time.  The patches can help save some shutdown
time.  The patches use Arjan's async API.


This patch:

synchronize all tasks submitted by .shutdown

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/base/core.c~synchronize-device-shutdown drivers/base/core.c
--- a/drivers/base/core.c~synchronize-device-shutdown
+++ a/drivers/base/core.c
@@ -22,6 +22,7 @@
 #include <linux/kallsyms.h>
 #include <linux/semaphore.h>
 #include <linux/mutex.h>
+#include <linux/async.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -1714,4 +1715,5 @@ void device_shutdown(void)
 	kobject_put(sysfs_dev_char_kobj);
 	kobject_put(sysfs_dev_block_kobj);
 	kobject_put(dev_kobj);
+	async_synchronize_full();
 }
_

Patches currently in -mm which might be from shaohua.li@intel.com are

linux-next.patch
synchronize-device-shutdown.patch
serios-async-shutdown.patch

