From: akpm@linux-foundation.org
Subject: + forcedeth-no-link-is-informational.patch added to -mm tree
Date: Thu, 20 Sep 2007 16:01:54 -0700
Message-ID: <200709202301.l8KN1s0Q007245@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42116 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751230AbXITXCC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 19:02:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eswierk@arastra.com, aabdulla@nvidia.com, jeff@garzik.org


The patch titled
     forcedeth: "no link" is informational
has been added to the -mm tree.  Its filename is
     forcedeth-no-link-is-informational.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: forcedeth: "no link" is informational
From: "Ed Swierk" <eswierk@arastra.com>

Log "no link during initialization" at KERN_INFO as it's not an error, and
occurs every time the interface comes up (when the forcedeth-phy-power-down
patch is applied).

Signed-off-by: Ed Swierk <eswierk@arastra.com>
Cc: Ayaz Abdulla <aabdulla@nvidia.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/forcedeth.c~forcedeth-no-link-is-informational drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-no-link-is-informational
+++ a/drivers/net/forcedeth.c
@@ -4921,7 +4921,7 @@ static int nv_open(struct net_device *de
 	if (ret) {
 		netif_carrier_on(dev);
 	} else {
-		printk("%s: no link during initialization.\n", dev->name);
+		printk(KERN_INFO "%s: no link during initialization.\n", dev->name);
 		netif_carrier_off(dev);
 	}
 	if (oom)
_

Patches currently in -mm which might be from eswierk@arastra.com are

git-net.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-no-link-is-informational.patch
