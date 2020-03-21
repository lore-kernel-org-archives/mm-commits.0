From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated]
 usb-core-kcov-collect-coverage-from-usb-complete-callback.patch removed
 from -mm tree
Date: Fri, 20 Mar 2020 17:23:22 -0700
Message-ID: <20200321002322.zwpF5fdaH%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbgCUAXX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 20 Mar 2020 20:23:23 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, dvyukov@google.com, elver@google.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org, stern@rowland.harvard.edu


The patch titled
     Subject: usb: core: kcov: collect coverage from usb complete callback
has been removed from the -mm tree.  Its filename was
     usb-core-kcov-collect-coverage-from-usb-complete-callback.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: usb: core: kcov: collect coverage from usb complete callback

This patch adds kcov_remote_start/stop() callbacks around the urb
complete() callback that is executed in softirq context when dummy_hcd is
in use.  As the result, kcov can be used to collect coverage from those
those callbacks, which is used to facilitate coverage-guided fuzzing with
syzkaller.

Link: http://lkml.kernel.org/r/32bce32c8b88c2f88cd0a8acfcdb5d3a6e894632.1583778264.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/hcd.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/hcd.c~usb-core-kcov-collect-coverage-from-usb-complete-callback
+++ a/drivers/usb/core/hcd.c
@@ -31,6 +31,7 @@
 #include <linux/types.h>
 #include <linux/genalloc.h>
 #include <linux/io.h>
+#include <linux/kcov.h>
 
 #include <linux/phy/phy.h>
 #include <linux/usb.h>
@@ -1645,7 +1646,9 @@ static void __usb_hcd_giveback_urb(struc
 
 	/* pass ownership to the completion handler */
 	urb->status = status;
+	kcov_remote_start_usb((u64)urb->dev->bus->busnum);
 	urb->complete(urb);
+	kcov_remote_stop();
 
 	usb_anchor_resume_wakeups(anchor);
 	atomic_dec(&urb->use_count);
_

Patches currently in -mm which might be from andreyknvl@google.com are
