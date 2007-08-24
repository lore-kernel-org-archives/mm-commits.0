From: akpm@linux-foundation.org
Subject: - synclink_gt-fix-module-reference.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:56:38 -0700
Message-ID: <200708242056.l7OKucnj014080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57442 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760141AbXHXVIM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulkf@microgate.com, mm-commits@vger.kernel.org


The patch titled
     synclink_gt fix module reference
has been removed from the -mm tree.  Its filename was
     synclink_gt-fix-module-reference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: synclink_gt fix module reference
From: Paul Fulghum <paulkf@microgate.com>

Get module reference on open() by generic HDLC to prevent module from
unloading while interface is active.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/synclink_gt.c |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN drivers/char/synclink_gt.c~synclink_gt-fix-module-reference drivers/char/synclink_gt.c
--- a/drivers/char/synclink_gt.c~synclink_gt-fix-module-reference
+++ a/drivers/char/synclink_gt.c
@@ -1565,6 +1565,9 @@ static int hdlcdev_open(struct net_devic
 	int rc;
 	unsigned long flags;
 
+	if (!try_module_get(THIS_MODULE))
+		return -EBUSY;
+
 	DBGINFO(("%s hdlcdev_open\n", dev->name));
 
 	/* generic HDLC layer open processing */
@@ -1634,6 +1637,7 @@ static int hdlcdev_close(struct net_devi
 	info->netcount=0;
 	spin_unlock_irqrestore(&info->netlock, flags);
 
+	module_put(THIS_MODULE);
 	return 0;
 }
 
_

Patches currently in -mm which might be from paulkf@microgate.com are

origin.patch
char-cyclades-remove-bottom-half-processing.patch
