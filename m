From: akpm@linux-foundation.org
Subject: [merged] vgaarb-add-user-selectability-of-the-number-of-gpus-in-a-system.patch removed from -mm tree
Date: Wed, 24 Feb 2010 11:39:54 -0800
Message-ID: <201002241939.o1OJdsi3016326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757844Ab0BXTmX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 14:42:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: travis@sgi.com, airlied@linux.ie, holt@sgi.com, hpa@zytor.com, jbarnes@virtuousgeek.org, mingo@elte.hu, steiner@sgi.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     vgaarb: add user selectability of the number of GPUS in a system
has been removed from the -mm tree.  Its filename was
     vgaarb-add-user-selectability-of-the-number-of-gpus-in-a-system.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vgaarb: add user selectability of the number of GPUS in a system
From: Mike Travis <travis@sgi.com>

Update the VGA Arbiter to allow the user to select the number of GPU's
supported in a system.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Robin Holt <holt@sgi.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/vga/Kconfig  |    8 ++++++++
 drivers/gpu/vga/vgaarb.c |    2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff -puN drivers/gpu/vga/Kconfig~vgaarb-add-user-selectability-of-the-number-of-gpus-in-a-system drivers/gpu/vga/Kconfig
--- a/drivers/gpu/vga/Kconfig~vgaarb-add-user-selectability-of-the-number-of-gpus-in-a-system
+++ a/drivers/gpu/vga/Kconfig
@@ -8,3 +8,11 @@ config VGA_ARB
 	  are accessed at same time they need some kind of coordination. Please
 	  see Documentation/vgaarbiter.txt for more details. Select this to
 	  enable VGA arbiter.
+
+config VGA_ARB_MAX_GPUS
+	int "Maximum number of GPUs"
+	default 16
+	depends on VGA_ARB
+	help
+	  Reserves space in the kernel to maintain resource locking for
+	  multiple GPUS.  The overhead for each GPU is very small.
diff -puN drivers/gpu/vga/vgaarb.c~vgaarb-add-user-selectability-of-the-number-of-gpus-in-a-system drivers/gpu/vga/vgaarb.c
--- a/drivers/gpu/vga/vgaarb.c~vgaarb-add-user-selectability-of-the-number-of-gpus-in-a-system
+++ a/drivers/gpu/vga/vgaarb.c
@@ -688,7 +688,7 @@ EXPORT_SYMBOL(vga_client_register);
  * the arbiter.
  */
 
-#define MAX_USER_CARDS         16
+#define MAX_USER_CARDS         CONFIG_VGA_ARB_MAX_GPUS
 #define PCI_INVALID_CARD       ((struct pci_dev *)-1UL)
 
 /*
_

Patches currently in -mm which might be from travis@sgi.com are

linux-next.patch

