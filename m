From: akpm@linux-foundation.org
Subject: [merged]
 usb-core-kcov-collect-coverage-from-usb-complete-callback.patch removed
 from -mm tree
Date: Fri, 05 Jun 2020 13:16:30 -0700
Message-ID: <20200605201630.R9FHnucA5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727087AbgFEUQc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:16:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@gmail.com, andreyknvl@google.com, dvyukov@google.com, elver@google.com, glider@google.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org, stern@rowland.harvard.edu


The patch titled
     Subject: usb: core: kcov: collect coverage from usb complete callback
has been removed from the -mm tree.  Its filename was
     usb-core-kcov-collect-coverage-from-usb-complete-callback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: usb: core: kcov: collect coverage from usb complete callback

This patch adds kcov_remote_start/stop() callbacks around the urb
complete() callback that is executed in softirq context when dummy_hcd is
in use.  As the result, kcov can be used to collect coverage from those
callbacks, which is used to facilitate coverage-guided fuzzing with
syzkaller.

Link: http://lkml.kernel.org/r/4520671eeb604adbc2432c248b0c07fbaa5519ef.1585233617.git.andreyknvl@google.com
Link: http://lkml.kernel.org/r/2821d497ac1cdc0efb5e00df30271e4a67fc8009.1584655448.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
