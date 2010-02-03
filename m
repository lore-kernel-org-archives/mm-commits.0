From: akpm@linux-foundation.org
Subject: + vgaarb-add-user-selectability-of-the-number-of-gpus-in-a-system-fix.patch added to -mm tree
Date: Wed, 03 Feb 2010 14:31:16 -0800
Message-ID: <201002032231.o13MVGFC023145@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756539Ab0BCWcC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 17:32:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com, holt@sgi.com, hpa@zytor.com, jbarnes@virtuousgeek.org, mingo@elte.hu, steiner@sgi.com, tglx@linutronix.de


The patch titled
     vgaarb-add-user-selectability-of-the-number-of-gpus-in-a-system-fix
has been added to the -mm tree.  Its filename is
     vgaarb-add-user-selectability-of-the-number-of-gpus-in-a-system-fix.patch

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
Subject: vgaarb-add-user-selectability-of-the-number-of-gpus-in-a-system-fix
From: Mike Travis <travis@sgi.com>

v2: simplify setting of MAX_USER_CARDS, revert back to original default of 16

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Robin Holt <holt@sgi.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/vga/Kconfig  |    2 +-
 drivers/gpu/vga/vgaarb.c |    4 ----
 2 files changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/gpu/vga/Kconfig~vgaarb-add-user-selectability-of-the-number-of-gpus-in-a-system-fix drivers/gpu/vga/Kconfig
--- a/drivers/gpu/vga/Kconfig~vgaarb-add-user-selectability-of-the-number-of-gpus-in-a-system-fix
+++ a/drivers/gpu/vga/Kconfig
@@ -11,7 +11,7 @@ config VGA_ARB
 
 config VGA_ARB_MAX_GPUS
 	int "Maximum number of GPUs"
-	default 64
+	default 16
 	depends on VGA_ARB
 	help
 	  Reserves space in the kernel to maintain resource locking for
diff -puN drivers/gpu/vga/vgaarb.c~vgaarb-add-user-selectability-of-the-number-of-gpus-in-a-system-fix drivers/gpu/vga/vgaarb.c
--- a/drivers/gpu/vga/vgaarb.c~vgaarb-add-user-selectability-of-the-number-of-gpus-in-a-system-fix
+++ a/drivers/gpu/vga/vgaarb.c
@@ -688,11 +688,7 @@ EXPORT_SYMBOL(vga_client_register);
  * the arbiter.
  */
 
-#ifdef CONFIG_VGA_ARB_MAX_GPUS
 #define MAX_USER_CARDS         CONFIG_VGA_ARB_MAX_GPUS
-#else
-#define MAX_USER_CARDS         16
-#endif
 #define PCI_INVALID_CARD       ((struct pci_dev *)-1UL)
 
 /*
_

Patches currently in -mm which might be from travis@sgi.com are

pci-update-pci_set_vga_state-to-call-arch-functions.patch
x86_64-uv-update-uv-arch-to-target-legacy-vga-i-o-correctly.patch
vgaarb-fix-vga-arbiter-to-accept-pci-domains-other-than-0.patch
vgaarb-add-user-selectability-of-the-number-of-gpus-in-a-system.patch
vgaarb-add-user-selectability-of-the-number-of-gpus-in-a-system-fix.patch

