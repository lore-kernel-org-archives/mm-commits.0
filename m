From: akpm@linux-foundation.org
Subject: - round_up-macro-cleanup-in-drivers-pci.patch removed from -mm tree
Date: Fri, 24 Aug 2007 22:18:31 -0700
Message-ID: <200708250518.l7P5IVCQ031885@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59398 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754447AbXHYFSg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 25 Aug 2007 01:18:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: milindchoudhary@gmail.com, greg@kroah.com, scottm@somanetworks.com, mm-commits@vger.kernel.org


The patch titled
     ROUND_UP macro cleanup in drivers/pci
has been removed from the -mm tree.  Its filename was
     round_up-macro-cleanup-in-drivers-pci.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: ROUND_UP macro cleanup in drivers/pci
From: Milind Arun Choudhary <milindchoudhary@gmail.com>

ROUND_UP macro cleanup, use ALIGN where ever appropriate

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
Cc: Greg KH <greg@kroah.com>
Acked-by: Scott Murray <scottm@somanetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/cpci_hotplug_pci.c |    2 --
 drivers/pci/setup-bus.c                |    8 +++-----
 2 files changed, 3 insertions(+), 7 deletions(-)

diff -puN drivers/pci/hotplug/cpci_hotplug_pci.c~round_up-macro-cleanup-in-drivers-pci drivers/pci/hotplug/cpci_hotplug_pci.c
--- a/drivers/pci/hotplug/cpci_hotplug_pci.c~round_up-macro-cleanup-in-drivers-pci
+++ a/drivers/pci/hotplug/cpci_hotplug_pci.c
@@ -45,8 +45,6 @@ extern int cpci_debug;
 #define info(format, arg...) printk(KERN_INFO "%s: " format "\n", MY_NAME , ## arg)
 #define warn(format, arg...) printk(KERN_WARNING "%s: " format "\n", MY_NAME , ## arg)
 
-#define ROUND_UP(x, a)		(((x) + (a) - 1) & ~((a) - 1))
-
 
 u8 cpci_get_attention_status(struct slot* slot)
 {
diff -puN drivers/pci/setup-bus.c~round_up-macro-cleanup-in-drivers-pci drivers/pci/setup-bus.c
--- a/drivers/pci/setup-bus.c~round_up-macro-cleanup-in-drivers-pci
+++ a/drivers/pci/setup-bus.c
@@ -34,8 +34,6 @@
 #define DBG(x...)
 #endif
 
-#define ROUND_UP(x, a)		(((x) + (a) - 1) & ~((a) - 1))
-
 static void pbus_assign_resources_sorted(struct pci_bus *bus)
 {
 	struct pci_dev *dev;
@@ -310,7 +308,7 @@ static void pbus_size_io(struct pci_bus 
 #if defined(CONFIG_ISA) || defined(CONFIG_EISA)
 	size = (size & 0xff) + ((size & ~0xffUL) << 2);
 #endif
-	size = ROUND_UP(size + size1, 4096);
+	size = ALIGN(size + size1, 4096);
 	if (!size) {
 		b_res->flags = 0;
 		return;
@@ -378,11 +376,11 @@ static int pbus_size_mem(struct pci_bus 
 
 		if (!align)
 			min_align = align1;
-		else if (ROUND_UP(align + min_align, min_align) < align1)
+		else if (ALIGN(align + min_align, min_align) < align1)
 			min_align = align1 >> 1;
 		align += aligns[order];
 	}
-	size = ROUND_UP(size, min_align);
+	size = ALIGN(size, min_align);
 	if (!size) {
 		b_res->flags = 0;
 		return 1;
_

Patches currently in -mm which might be from milindchoudhary@gmail.com are
