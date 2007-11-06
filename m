From: akpm@linux-foundation.org
Subject: + m68knommu-remove-vestiges-of-non-existent-disktel.patch added to -mm tree
Date: Mon, 05 Nov 2007 16:06:10 -0800
Message-ID: <200711060006.lA606JGx026773@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38218 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754544AbXKFAHG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 19:07:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, gerg@snapgear.com, gerg@uclinux.org


The patch titled
     M68KNOMMU: remove vestiges of non-existent "DISKtel" variable
has been added to the -mm tree.  Its filename is
     m68knommu-remove-vestiges-of-non-existent-disktel.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: M68KNOMMU: remove vestiges of non-existent "DISKtel" variable
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Since commit fabc7f66ee022ff6e27ba25aafb237996f440536 allegedly
removed the DISKtel Kconfig variable:

commit fabc7f66ee022ff6e27ba25aafb237996f440536
Author: Greg Ungerer <gerg@snapgear.com>
Date:   Tue Oct 16 01:26:30 2007 -0700

    M68KNOMMU: remove unused config symbol CONFIG_DISKtel

let's really get rid of the final traces.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/platform/5307/config.c |    3 +--
 include/asm-m68knommu/mcfuart.h       |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/m68knommu/platform/5307/config.c~m68knommu-remove-vestiges-of-non-existent-disktel arch/m68knommu/platform/5307/config.c
--- a/arch/m68knommu/platform/5307/config.c~m68knommu-remove-vestiges-of-non-existent-disktel
+++ a/arch/m68knommu/platform/5307/config.c
@@ -104,8 +104,7 @@ void config_BSP(char *commandp, int size
 	mcf_setimr(MCFSIM_IMR_MASKALL);
 
 #if defined(CONFIG_NETtel) || defined(CONFIG_eLIA) || \
-      defined(CONFIG_DISKtel) || defined(CONFIG_SECUREEDGEMP3) || \
-      defined(CONFIG_CLEOPATRA)
+      defined(CONFIG_SECUREEDGEMP3) || defined(CONFIG_CLEOPATRA)
 	/* Copy command line from FLASH to local buffer... */
 	memcpy(commandp, (char *) 0xf0004000, size);
 	commandp[size-1] = 0;
diff -puN include/asm-m68knommu/mcfuart.h~m68knommu-remove-vestiges-of-non-existent-disktel include/asm-m68knommu/mcfuart.h
--- a/include/asm-m68knommu/mcfuart.h~m68knommu-remove-vestiges-of-non-existent-disktel
+++ a/include/asm-m68knommu/mcfuart.h
@@ -33,7 +33,7 @@
 #define MCFUART_BASE2		0x240           /* Base address of UART2 */
 #define MCFUART_BASE3		0x280           /* Base address of UART3 */
 #elif defined(CONFIG_M5249) || defined(CONFIG_M5307) || defined(CONFIG_M5407)
-#if defined(CONFIG_NETtel) || defined(CONFIG_DISKtel) || defined(CONFIG_SECUREEDGEMP3)
+#if defined(CONFIG_NETtel) || defined(CONFIG_SECUREEDGEMP3)
 #define MCFUART_BASE1		0x200           /* Base address of UART1 */
 #define MCFUART_BASE2		0x1c0           /* Base address of UART2 */
 #else
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
arm-remove-reference-to-non-existent-mtd_obsolete_chips.patch
blackfin-typo-config_rtc_bfin_module.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
m68knommu-remove-vestiges-of-non-existent-disktel.patch
