From: akpm@linux-foundation.org
Subject: - w1-abort-search-early-on-on-exit.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:19:47 -0700
Message-ID: <200810182319.m9INJlca029555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751874AbYJRX1d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:27:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@fries.net, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     W1: abort search early on on exit
has been removed from the -mm tree.  Its filename was
     w1-abort-search-early-on-on-exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: W1: abort search early on on exit
From: David Fries <david@fries.net>

Early abort if the master driver or the hardware goes away in the middle
of a bus search operation.  The alternative is to spam the print buffer up
to 64*64 times with read errors in the case of USB.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/w1/w1.c~w1-abort-search-early-on-on-exit drivers/w1/w1.c
--- a/drivers/w1/w1.c~w1-abort-search-early-on-on-exit
+++ a/drivers/w1/w1.c
@@ -772,6 +772,11 @@ void w1_search(struct w1_master *dev, u8
 			/* extract the direction taken & update the device number */
 			tmp64 = (triplet_ret >> 2);
 			rn |= (tmp64 << i);
+
+			if (test_bit(W1_MASTER_NEED_EXIT, &dev->flags)) {
+				printk(KERN_INFO "Abort w1_search (exiting)\n");
+				return;
+			}
 		}
 
 		if ( (triplet_ret & 0x03) != 0x03 ) {
_

Patches currently in -mm which might be from david@fries.net are

origin.patch

