From: akpm@linux-foundation.org
Subject: [to-be-updated]
 rtsx_usb_ms-use-msleep_interruptible-in-polling-loop.patch removed from -mm tree
Date: Tue, 03 May 2016 15:38:20 -0700
Message-ID: <5729285c.vLMHIlYhaX8C4Ft9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33280 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436AbcECWiV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 May 2016 18:38:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@decadent.org.uk, greg@kroah.com, oleg@redhat.com, oleksandr@natalenko.name, mm-commits@vger.kernel.org


The patch titled
     Subject: rtsx_usb_ms: Use msleep_interruptible() in polling loop
has been removed from the -mm tree.  Its filename was
     rtsx_usb_ms-use-msleep_interruptible-in-polling-loop.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Ben Hutchings <ben@decadent.org.uk>
Subject: rtsx_usb_ms: Use msleep_interruptible() in polling loop

rtsx_usb_ms creates a task that mostly sleeps, but tasks in
uninterruptible sleep still contribute to the load average (for
bug-compatibility with Unix).  A load average of ~1 on a system that
should be idle is somewhat alarming.

Change the sleep to be interruptible, but still ignore signals.

A better fix might be to replace this loop with a delayed work item.

References: https://bugs.debian.org/765717
Link: http://lkml.kernel.org/r/7afcd6e57d09772699ac37b59db98617@natalenko.name
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Greg KH <greg@kroah.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/host/rtsx_usb_ms.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/memstick/host/rtsx_usb_ms.c~rtsx_usb_ms-use-msleep_interruptible-in-polling-loop drivers/memstick/host/rtsx_usb_ms.c
--- a/drivers/memstick/host/rtsx_usb_ms.c~rtsx_usb_ms-use-msleep_interruptible-in-polling-loop
+++ a/drivers/memstick/host/rtsx_usb_ms.c
@@ -706,7 +706,8 @@ poll_again:
 		if (host->eject)
 			break;
 
-		msleep(1000);
+		if (msleep_interruptible(1000))
+			flush_signals(current);
 	}
 
 	complete(&host->detect_ms_exit);
_

Patches currently in -mm which might be from ben@decadent.org.uk are


