From: akpm@linux-foundation.org
Subject: - com20020-build-fix.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:44:05 -0800
Message-ID: <200702122244.l1CMi5q7013551@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44958 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030263AbXBLWoU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:44:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, davem@davemloft.net, jeff@garzik.org, linux@dominikbrodowski.net, nielsen.esben@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     com20020 build fix
has been removed from the -mm tree.  Its filename was
     com20020-build-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: com20020 build fix
From: Randy Dunlap <randy.dunlap@oracle.com>

Need to export com20020 symbols for com20020_cs also.

WARNING:  "com20020_found" [drivers/net/pcmcia/com20020_cs.ko] undefined!
WARNING:  "com20020_check" [drivers/net/pcmcia/com20020_cs.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Esben Nielsen <nielsen.esben@googlemail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/arcnet/com20020.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/net/arcnet/com20020.c~com20020-build-fix drivers/net/arcnet/com20020.c
--- a/drivers/net/arcnet/com20020.c~com20020-build-fix
+++ a/drivers/net/arcnet/com20020.c
@@ -338,7 +338,8 @@ static void com20020_set_mc_list(struct 
 }
 
 #if defined(CONFIG_ARCNET_COM20020_PCI_MODULE) || \
-    defined(CONFIG_ARCNET_COM20020_ISA_MODULE)
+    defined(CONFIG_ARCNET_COM20020_ISA_MODULE) || \
+    defined(CONFIG_ARCNET_COM20020_CS_MODULE)
 EXPORT_SYMBOL(com20020_check);
 EXPORT_SYMBOL(com20020_found);
 #endif
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-drm.patch
qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2.patch
git-mtd.patch
git-netdev-all.patch
phy-layer-add-kernel-doc-docbook.patch
parisc-fix-module_param-iommu-permission.patch
ueagle-atmc-needs-schedh.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
