From: akpm@linux-foundation.org
Subject: - m68knommu-remove-vestiges-of-non-existent-disktel.patch removed from -mm tree
Date: Fri, 01 Feb 2008 14:30:01 -0800
Message-ID: <200802012230.m11MU2wD001856@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58188 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756182AbYBAWqB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 17:46:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, gerg@snapgear.com, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     M68KNOMMU: remove vestiges of non-existent "DISKtel" variable
has been removed from the -mm tree.  Its filename was
     m68knommu-remove-vestiges-of-non-existent-disktel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
git-hwmon.patch
git-xfs.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
uml-delete-some-unused-headers.patch
rd-use-is_power_of_2-in-drivers-block-rdc.patch
log2h-define-order_base_2-macro-for-convenience.patch
ncpfs-update-diagnostic-strings-to-match-routine-names.patch
hfs-update-comment-to-reflect-actual-init-and-exit-routines.patch
synclink-standardize-format-of-linux-header-file-includes-with.patch
remove-superfluous-checks-for-config_blk_dev_initrd-from-initramfsc.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
