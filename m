From: akpm@osdl.org
Subject: + git-md-accel-fixes.patch added to -mm tree
Date: Fri, 02 Feb 2007 17:44:05 -0800
Message-ID: <200702030145.l131j5Yf024587@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49643 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946209AbXBCBpH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Feb 2007 20:45:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@osdl.org, christopher.leech@intel.com, dan.j.williams@intel.com


The patch titled
     git-md-accel fixes
has been added to the -mm tree.  Its filename is
     git-md-accel-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-md-accel fixes
From: Andrew Morton <akpm@linux-foundation.org>

include/linux/dmaengine.h: In function 'dma_sync_wait':
include/linux/dmaengine.h:508: error: 'jiffies' undeclared (first use in this function)
include/linux/dmaengine.h:508: error: (Each undeclared identifier is reported only once
include/linux/dmaengine.h:508: error: for each function it appears in.)
include/linux/dmaengine.h:508: warning: implicit declaration of function 'msecs_to_jiffies'
include/linux/dmaengine.h:513: warning: implicit declaration of function 'time_after_eq'
In file included from include/linux/sched.h:51,
                 from include/linux/mm.h:4,
                 from crypto/internal.h:18,
                 from crypto/algapi.c:22:
include/linux/jiffies.h: At top level:
include/linux/jiffies.h:266: error: conflicting types for 'msecs_to_jiffies'
include/linux/dmaengine.h:508: error: previous implicit declaration of 'msecs_to_jiffies' was here

That function is too big to e inlined anyway - move it out-of-line.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/dmaengine.c   |   19 +++++++++++++++++++
 include/linux/dmaengine.h |   18 +-----------------
 2 files changed, 20 insertions(+), 17 deletions(-)

diff -puN include/linux/dmaengine.h~git-md-accel-fixes include/linux/dmaengine.h
--- a/include/linux/dmaengine.h~git-md-accel-fixes
+++ a/include/linux/dmaengine.h
@@ -501,23 +501,7 @@ static inline enum dma_status dma_async_
 	return DMA_IN_PROGRESS;
 }
 
-static inline enum dma_status dma_sync_wait(struct dma_chan *chan,
-						dma_cookie_t cookie)
-{
-	enum dma_status status;
-	unsigned long dma_sync_wait_timeout = jiffies + msecs_to_jiffies(5000);
-
-	dma_async_issue_pending(chan);
-	do {
-		status = dma_async_is_tx_complete(chan, cookie, NULL, NULL);
-		if (time_after_eq(jiffies, dma_sync_wait_timeout)) {
-			printk(KERN_ERR "dma_sync_wait_timeout!\n");
-			return DMA_ERROR;
-		}
-	} while (status == DMA_IN_PROGRESS);
-
-	return status;
-}
+enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie);
 
 /* --- DMA device --- */
 
diff -puN drivers/dma/dmaengine.c~git-md-accel-fixes drivers/dma/dmaengine.c
--- a/drivers/dma/dmaengine.c~git-md-accel-fixes
+++ a/drivers/dma/dmaengine.c
@@ -66,6 +66,7 @@
 #include <linux/percpu.h>
 #include <linux/rcupdate.h>
 #include <linux/mutex.h>
+#include <linux/jiffies.h>
 
 static DEFINE_MUTEX(dma_list_mutex);
 static LIST_HEAD(dma_device_list);
@@ -165,6 +166,24 @@ static struct dma_chan *dma_client_chan_
 	return NULL;
 }
 
+enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie)
+{
+	enum dma_status status;
+	unsigned long dma_sync_wait_timeout = jiffies + msecs_to_jiffies(5000);
+
+	dma_async_issue_pending(chan);
+	do {
+		status = dma_async_is_tx_complete(chan, cookie, NULL, NULL);
+		if (time_after_eq(jiffies, dma_sync_wait_timeout)) {
+			printk(KERN_ERR "dma_sync_wait_timeout!\n");
+			return DMA_ERROR;
+		}
+	} while (status == DMA_IN_PROGRESS);
+
+	return status;
+}
+EXPORT_SYMBOL(dma_sync_wait);
+
 /**
  * dma_chan_cleanup - release a DMA channel's resources
  * @kref: kernel reference structure that contains the DMA channel device
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
git-md-accel-fixes.patch
