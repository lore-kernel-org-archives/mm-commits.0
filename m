From: akpm@linux-foundation.org
Subject: [patch 45/84] rtsx_usb_ms: use schedule_timeout_idle() in polling loop
Date: Mon, 23 May 2016 16:24:28 -0700
Message-ID: <5743912c.uKGOeJyp7El5A4+8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42251 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbcEWXYa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:24:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, oleksandr@natalenko.name, ben@decadent.org.uk, greg@kroah.com, lee.jones@linaro.org, oleg@redhat.com, rogerable@realtek.com, wsa@the-dreams.de

From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: rtsx_usb_ms: use schedule_timeout_idle() in polling loop

First version of this patch has already been posted to LKML by Ben
Hutchings ~6 months ago, but no further action were performed.

Ben's original message:

: rtsx_usb_ms creates a task that mostly sleeps, but tasks in
: uninterruptible sleep still contribute to the load average (for
: bug-compatibility with Unix).  A load average of ~1 on a system that
: should be idle is somewhat alarming.
: 
: Change the sleep to be interruptible, but still ignore signals.

References: https://bugs.debian.org/765717
Link: http://lkml.kernel.org/r/b49f95ae83057efa5d96f532803cba47@natalenko.name
Signed-off-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Wolfram Sang <wsa@the-dreams.de>
Cc: Roger Tseng <rogerable@realtek.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/host/rtsx_usb_ms.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/memstick/host/rtsx_usb_ms.c~rtsx_usb_ms-use-schedule_timeout_idle-in-polling-loop-v2 drivers/memstick/host/rtsx_usb_ms.c
--- a/drivers/memstick/host/rtsx_usb_ms.c~rtsx_usb_ms-use-schedule_timeout_idle-in-polling-loop-v2
+++ a/drivers/memstick/host/rtsx_usb_ms.c
@@ -706,7 +706,7 @@ poll_again:
 		if (host->eject)
 			break;
 
-		msleep(1000);
+		schedule_timeout_idle(HZ);
 	}
 
 	complete(&host->detect_ms_exit);
_
