From: akpm@linux-foundation.org
Subject: + synchronize-device-shutdown.patch added to -mm tree
Date: Tue, 13 Jan 2009 14:02:33 -0800
Message-ID: <200901132202.n0DM2XB0009126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754510AbZAMWCs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 17:02:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, James.Bottomley@HansenPartnership.com, arjan@infradead.org, dtor@mail.ru


The patch titled
     synchronize device shutdown
has been added to the -mm tree.  Its filename is
     synchronize-device-shutdown.patch

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
@@ -1618,4 +1619,5 @@ void device_shutdown(void)
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
sd-async-shutdown.patch

