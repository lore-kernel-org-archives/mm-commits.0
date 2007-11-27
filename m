From: akpm@linux-foundation.org
Subject: - isdn-avoid-copying-an-overly-long-string.patch removed from -mm tree
Date: Tue, 27 Nov 2007 12:32:58 -0800
Message-ID: <200711272032.lARKWwiM028943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53459 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755385AbXK0UdV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 15:33:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kkeil@suse.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     isdn: avoid copying an overly-long string
has been removed from the -mm tree.  Its filename was
     isdn-avoid-copying-an-overly-long-string.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: isdn: avoid copying an overly-long string
From: Karsten Keil <kkeil@suse.de>

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=9416

Signed-off-by: Karsten Keil <kkeil@suse.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/i4l/isdn_net.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/isdn/i4l/isdn_net.c~isdn-avoid-copying-an-overly-long-string drivers/isdn/i4l/isdn_net.c
--- a/drivers/isdn/i4l/isdn_net.c~isdn-avoid-copying-an-overly-long-string
+++ a/drivers/isdn/i4l/isdn_net.c
@@ -2104,7 +2104,7 @@ isdn_net_find_icall(int di, int ch, int 
 	u_long flags;
 	isdn_net_dev *p;
 	isdn_net_phone *n;
-	char nr[32];
+	char nr[ISDN_MSNLEN];
 	char *my_eaz;
 
 	/* Search name in netdev-chain */
@@ -2113,7 +2113,7 @@ isdn_net_find_icall(int di, int ch, int 
 		nr[1] = '\0';
 		printk(KERN_INFO "isdn_net: Incoming call without OAD, assuming '0'\n");
 	} else
-		strcpy(nr, setup->phone);
+		strlcpy(nr, setup->phone, ISDN_MSNLEN);
 	si1 = (int) setup->si1;
 	si2 = (int) setup->si2;
 	if (!setup->eazmsn[0]) {
@@ -2789,7 +2789,7 @@ isdn_net_setcfg(isdn_net_ioctl_cfg * cfg
 				chidx = -1;
 			}
 		}
-		strcpy(lp->msn, cfg->eaz);
+		strlcpy(lp->msn, cfg->eaz, sizeof(lp->msn));
 		lp->pre_device = drvidx;
 		lp->pre_channel = chidx;
 		lp->onhtime = cfg->onhtime;
@@ -2936,7 +2936,7 @@ isdn_net_addphone(isdn_net_ioctl_phone *
 	if (p) {
 		if (!(n = kmalloc(sizeof(isdn_net_phone), GFP_KERNEL)))
 			return -ENOMEM;
-		strcpy(n->num, phone->phone);
+		strlcpy(n->num, phone->phone, sizeof(n->num));
 		n->next = p->local->phone[phone->outgoing & 1];
 		p->local->phone[phone->outgoing & 1] = n;
 		return 0;
_

Patches currently in -mm which might be from kkeil@suse.de are

origin.patch
fix-versus-precedence-in-various-places.patch
remove-warnings-for-longstanding-conditions-fix.patch
remove-pointless-casts-from-void-pointers.patch
cleanup-after-apus-removal.patch
gigaset-clean-up-urb-status-usage.patch
gigaset-code-cleanups.patch
bas_gigaset-suspend-support-v2.patch
usb_gigaset-suspend-support-v3.patch
