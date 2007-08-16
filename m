From: akpm@linux-foundation.org
Subject: + synclink_gt-fix-module-reference.patch added to -mm tree
Date: Thu, 16 Aug 2007 13:25:18 -0700
Message-ID: <200708162025.l7GKPIYU005151@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43837 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753018AbXHPUZc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Aug 2007 16:25:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulkf@microgate.com


The patch titled
     synclink_gt fix module reference
has been added to the -mm tree.  Its filename is
     synclink_gt-fix-module-reference.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

synclink_gt-fix-module-reference.patch
char-cyclades-remove-bottom-half-processing.patch
