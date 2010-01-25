From: akpm@linux-foundation.org
Subject: + vgaarb-add-user-selectability-of-the-number-of-gpus-in-a-system.patch added to -mm tree
Date: Mon, 25 Jan 2010 15:57:21 -0800
Message-ID: <201001252357.o0PNvLBY018711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46749 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750939Ab0AYX5k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jan 2010 18:57:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com, holt@sgi.com, hpa@zytor.com, jbarnes@virtuousgeek.org, mingo@elte.hu, steiner@sgi.com, tglx@linutronix.de


The patch titled
     vgaarb: add user selectability of the number of GPUS in a system
has been added to the -mm tree.  Its filename is
     vgaarb-add-user-selectability-of-the-number-of-gpus-in-a-system.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/vga/Kconfig  |    8 ++++++++
 drivers/gpu/vga/vgaarb.c |    4 ++++
 2 files changed, 12 insertions(+)

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
+	default 64
+	depends on VGA_ARB
+	help
+	  Reserves space in the kernel to maintain resource locking for
+	  multiple GPUS.  The overhead for each GPU is very small.
diff -puN drivers/gpu/vga/vgaarb.c~vgaarb-add-user-selectability-of-the-number-of-gpus-in-a-system drivers/gpu/vga/vgaarb.c
--- a/drivers/gpu/vga/vgaarb.c~vgaarb-add-user-selectability-of-the-number-of-gpus-in-a-system
+++ a/drivers/gpu/vga/vgaarb.c
@@ -688,7 +688,11 @@ EXPORT_SYMBOL(vga_client_register);
  * the arbiter.
  */
 
+#ifdef CONFIG_VGA_ARB_MAX_GPUS
+#define MAX_USER_CARDS         CONFIG_VGA_ARB_MAX_GPUS
+#else
 #define MAX_USER_CARDS         16
+#endif
 #define PCI_INVALID_CARD       ((struct pci_dev *)-1UL)
 
 /*
_

Patches currently in -mm which might be from travis@sgi.com are

pci-update-pci_set_vga_state-to-call-arch-functions.patch
x86_64-uv-update-uv-arch-to-target-legacy-vga-i-o-correctly.patch
vgaarb-fix-vga-arbiter-to-accept-pci-domains-other-than-0.patch
vgaarb-add-user-selectability-of-the-number-of-gpus-in-a-system.patch

