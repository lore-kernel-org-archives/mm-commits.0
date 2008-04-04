From: akpm@linux-foundation.org
Subject: + parport_pc-dont-forget-to-unregister-the-temporarily-registered-region.patch added to -mm tree
Date: Thu, 03 Apr 2008 21:41:57 -0700
Message-ID: <200804040441.m344fvkP006285@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751169AbYDDEmI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2008 00:42:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, jack@suse.cz, petr.cvek@tul.cz, rjw@sisk.pl


The patch titled
     parport_pc: don't forget to unregister the temporarily-registered region
has been added to the -mm tree.  Its filename is
     parport_pc-dont-forget-to-unregister-the-temporarily-registered-region.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: parport_pc: don't forget to unregister the temporarily-registered region
From: Linus Torvalds <torvalds@linux-foundation.org>

Otherwise /proc/ioports goes oops after rmmod.

Addresses:

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10390
> Subject		: Oops while reading /proc/ioports or /proc/iomem
> Submitter	: Jan Kara <jack@suse.cz>
> Date		: 2008-04-03 15:25 (1 days old)
> References	: http://lkml.org/lkml/2008/4/3/149

Fixes a regression added by

commit f63fd7e299ee13da071ecfce2b90b58c5e1562b1
Author: Petr Cvek <petr.cvek@tul.cz>
Date:   Wed Feb 6 01:37:48 2008 -0800

    parport_pc: detection for SuperIO IT87XX POST
    
    Add detection for IT87XX SuperIO chip and disabling its POST feature, which
    made noise on parallel port's pins.
    
    Signed-off-by: Petr Cvek <petr.cvek@tul.cz>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Cc: Petr Cvek <petr.cvek@tul.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_pc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/parport/parport_pc.c~parport_pc-dont-forget-to-unregister-the-temporarily-registered-region drivers/parport/parport_pc.c
--- a/drivers/parport/parport_pc.c~parport_pc-dont-forget-to-unregister-the-temporarily-registered-region
+++ a/drivers/parport/parport_pc.c
@@ -1568,9 +1568,8 @@ static void __devinit detect_and_report_
 		outb(r | 8, 0x2F);
 		outb(0x02, 0x2E);	/* Lock */
 		outb(0x02, 0x2F);
