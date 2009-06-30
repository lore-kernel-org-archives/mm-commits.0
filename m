From: akpm@linux-foundation.org
Subject: + vt6655-fix-build-when-config_wireless_ext.patch added to -mm tree
Date: Tue, 30 Jun 2009 12:39:51 -0700
Message-ID: <200906301939.n5UJdpeb000497@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752165AbZF3TkZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jun 2009 15:40:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.beregalov@gmail.com, forest@alittletooquiet.net, greg@kroah.com


The patch titled
     vt6655: fix build when !CONFIG_WIRELESS_EXT
has been added to the -mm tree.  Its filename is
     vt6655-fix-build-when-config_wireless_ext.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vt6655: fix build when !CONFIG_WIRELESS_EXT
From: Alexander Beregalov <a.beregalov@gmail.com>

Fix this build error when CONFIG_WIRELESS_EXT is not set:
drivers/staging/vt6655/device_main.c:1153: error: 'struct net_device'
	has no member named 'wireless_handlers'

Cc: Forest Bond <forest@alittletooquiet.net>
Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/vt6655/device_main.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN drivers/staging/vt6655/device_main.c~vt6655-fix-build-when-config_wireless_ext drivers/staging/vt6655/device_main.c
--- a/drivers/staging/vt6655/device_main.c~vt6655-fix-build-when-config_wireless_ext
+++ a/drivers/staging/vt6655/device_main.c
@@ -1146,14 +1146,9 @@ device_found1(struct pci_dev *pcid, cons
     dev->irq                = pcid->irq;
     dev->netdev_ops         = &device_netdev_ops;
 
-#ifdef WIRELESS_EXT
-//Einsn Modify for ubuntu-7.04
-//	dev->wireless_handlers->get_wireless_stats = iwctl_get_wireless_stats;
-#if WIRELESS_EXT > 12
+#ifdef CONFIG_WIRELESS_EXT
 	dev->wireless_handlers = (struct iw_handler_def *)&iwctl_handler_def;
-//	netdev->wireless_handlers = NULL;
-#endif /* WIRELESS_EXT > 12 */
-#endif /* WIRELESS_EXT */
+#endif
 
     rc = register_netdev(dev);
     if (rc)
_

Patches currently in -mm which might be from a.beregalov@gmail.com are

linux-next.patch
comedi-jr3_pcic-add-required-includes.patch
vt6655-fix-build-when-config_wireless_ext.patch

