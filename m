From: akpm@linux-foundation.org
Subject: - fix-cycladesh-for-x86_64-and-probably-others.patch removed from -mm tree
Date: Tue, 08 May 2007 19:46:41 -0700
Message-ID: <200705090246.l492kfBL008890@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54505 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031793AbXEICqq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:46:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: klaus.kudielka@gmx.net, mm-commits@vger.kernel.org


The patch titled
     fix cyclades.h for x86_64 (and probably others)
has been removed from the -mm tree.  Its filename was
     fix-cycladesh-for-x86_64-and-probably-others.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix cyclades.h for x86_64 (and probably others)
From: Klaus Kudielka <klaus.kudielka@gmx.net>

At least on x86_64 the present cyclades.h is broken due to the wrong size
of uclong.  This affects, of course, both the kernel and the user-level
utilities.  The symptom is that cyzload refuses to load the firmware.  I
also managed to freeze the machine when unloading the module.

The patch below fixes this in an architecture-independent way.  I have
tested it with 2.6.19 and the driver works fine again with a Cyclades-Z on
an Athlon 64 X2.

[akpm@linux-foundation.org: fix warnings]

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c  |    2 +-
 include/linux/cyclades.h |   14 ++++++--------
 2 files changed, 7 insertions(+), 9 deletions(-)

diff -puN drivers/char/cyclades.c~fix-cycladesh-for-x86_64-and-probably-others drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~fix-cycladesh-for-x86_64-and-probably-others
+++ a/drivers/char/cyclades.c
@@ -1533,7 +1533,7 @@ cyz_issue_cmd(struct cyclades_card *cinf
 	struct FIRM_ID __iomem *firm_id;
 	struct ZFW_CTRL __iomem *zfw_ctrl;
 	struct BOARD_CTRL __iomem *board_ctrl;
-	unsigned long __iomem *pci_doorbell;
+	uclong __iomem *pci_doorbell;
 	int index;
 
 	firm_id = cinfo->base_addr + ID_ADDRESS;
diff -puN include/linux/cyclades.h~fix-cycladesh-for-x86_64-and-probably-others include/linux/cyclades.h
--- a/include/linux/cyclades.h~fix-cycladesh-for-x86_64-and-probably-others
+++ a/include/linux/cyclades.h
@@ -149,14 +149,12 @@ struct CYZ_BOOT_CTRL {
  *	architectures and compilers.
  */
 
-#if defined(__alpha__)
-typedef unsigned long	ucdouble;	/* 64 bits, unsigned */
-typedef unsigned int	uclong;		/* 32 bits, unsigned */
-#else
-typedef unsigned long	uclong;		/* 32 bits, unsigned */
-#endif
-typedef unsigned short	ucshort;	/* 16 bits, unsigned */
-typedef unsigned char	ucchar;		/* 8 bits, unsigned */
+#include <asm/types.h>
+
+typedef __u64  ucdouble;		/* 64 bits, unsigned */
+typedef __u32  uclong;			/* 32 bits, unsigned */
+typedef __u16  ucshort;		/* 16 bits, unsigned */
+typedef __u8   ucchar;			/* 8 bits, unsigned */
 
 /*
  *	Memory Window Sizes
_

Patches currently in -mm which might be from klaus.kudielka@gmx.net are

origin.patch
