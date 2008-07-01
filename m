From: akpm@linux-foundation.org
Subject: + sisusbvga-fix-oops-on-disconnect.patch added to -mm tree
Date: Tue, 01 Jul 2008 01:16:31 -0700
Message-ID: <200807010816.m618GVRl016904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756530AbYGAIQ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 04:16:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: will.newton@gmail.com, felipe.lima@indt.org.br, gregkh@suse.de, stable@kernel.org, thomas@winischhofer.net


The patch titled
     sisusbvga: fix oops on disconnect
has been added to the -mm tree.  Its filename is
     sisusbvga-fix-oops-on-disconnect.patch

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
Subject: sisusbvga: fix oops on disconnect
From: Will Newton <will.newton@gmail.com>

Remove the message printed with dev_info on disconnect after sisusb_dev
has potentially been zeroed by sisusb_delete.  The message does not
provide any extra information over that which the USB subsystem prints as
standard so just kill it.

Signed-off-by: Will Newton <will.newton@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Felipe Balbi <felipe.lima@indt.org.br>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/misc/sisusbvga/sisusb.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/usb/misc/sisusbvga/sisusb.c~sisusbvga-fix-oops-on-disconnect drivers/usb/misc/sisusbvga/sisusb.c
--- a/drivers/usb/misc/sisusbvga/sisusb.c~sisusbvga-fix-oops-on-disconnect
+++ a/drivers/usb/misc/sisusbvga/sisusb.c
@@ -3264,8 +3264,6 @@ static void sisusb_disconnect(struct usb
 
 	/* decrement our usage count */
 	kref_put(&sisusb->kref, sisusb_delete);
