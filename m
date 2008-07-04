From: akpm@linux-foundation.org
Subject: - sisusbvga-fix-oops-on-disconnect.patch removed from -mm tree
Date: Fri, 04 Jul 2008 00:26:42 -0700
Message-ID: <200807040726.m647QgFW019298@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755459AbYGDH1j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jul 2008 03:27:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: will.newton@gmail.com, felipe.lima@indt.org.br, gregkh@suse.de, stable@kernel.org, thomas@winischhofer.net, mm-commits@vger.kernel.org


The patch titled
     sisusbvga: fix oops on disconnect
has been removed from the -mm tree.  Its filename was
     sisusbvga-fix-oops-on-disconnect.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
