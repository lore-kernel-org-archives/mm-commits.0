From: akpm@linux-foundation.org
Subject: - uml-fix-a-memory-leak-in-the-multicast-driver.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:56:01 -0800
Message-ID: <200703152156.l2FLu15W027513@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42218 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbXCOV4D (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:56:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: blaisorblade@yahoo.it, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     um: fix a memory leak in the multicast driver
has been removed from the -mm tree.  Its filename was
     uml-fix-a-memory-leak-in-the-multicast-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: um: fix a memory leak in the multicast driver
From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

Memory allocated by mcast_user_init must be freed in the matching mcast_remove.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Acked-by: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/mcast_user.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN arch/um/drivers/mcast_user.c~uml-fix-a-memory-leak-in-the-multicast-driver arch/um/drivers/mcast_user.c
--- a/arch/um/drivers/mcast_user.c~uml-fix-a-memory-leak-in-the-multicast-driver
+++ a/arch/um/drivers/mcast_user.c
@@ -50,6 +50,14 @@ static void mcast_user_init(void *data, 
 	pri->dev = dev;
 }
 
+static void mcast_remove(void *data)
+{
+	struct mcast_data *pri = data;
+
+	kfree(pri->mcast_addr);
+	pri->mcast_addr = NULL;
+}
+
 static int mcast_open(void *data)
 {
 	struct mcast_data *pri = data;
@@ -157,7 +165,7 @@ const struct net_user_info mcast_user_in
 	.init		= mcast_user_init,
 	.open		= mcast_open,
 	.close	 	= mcast_close,
-	.remove	 	= NULL,
+	.remove	 	= mcast_remove,
 	.set_mtu	= mcast_set_mtu,
 	.add_address	= NULL,
 	.delete_address = NULL,
_

Patches currently in -mm which might be from blaisorblade@yahoo.it are

origin.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
uml-fix-prototypes.patch
git-gccbug.patch
