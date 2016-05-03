From: akpm@linux-foundation.org
Subject: + rtsx_usb_ms-use-schedule_timeout_idle-in-polling-loop-v2.patch
 added to -mm tree
Date: Tue, 03 May 2016 15:38:15 -0700
Message-ID: <57292857.1L06qPiMK+iXRBs7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33271 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436AbcECWiQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 May 2016 18:38:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleksandr@natalenko.name, ben@decadent.org.uk, greg@kroah.com, lee.jones@linaro.org, oleg@redhat.com, rogerable@realtek.com, wsa@the-dreams.de, mm-commits@vger.kernel.org


The patch titled
     Subject: rtsx_usb_ms: use schedule_timeout_idle() in polling loop
has been added to the -mm tree.  Its filename is
     rtsx_usb_ms-use-schedule_timeout_idle-in-polling-loop-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtsx_usb_ms-use-schedule_timeout_idle-in-polling-loop-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtsx_usb_ms-use-schedule_timeout_idle-in-polling-loop-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from oleksandr@natalenko.name are

rtsx_usb_ms-use-schedule_timeout_idle-in-polling-loop-v2.patch

