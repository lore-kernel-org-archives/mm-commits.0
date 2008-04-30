From: akpm@linux-foundation.org
Subject: - rapidio-change-rapidio-doorbell-source-and-target-id-field-to-16-bit.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:51:26 -0700
Message-ID: <200804300551.m3U5pQdQ030219@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55448 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758734AbYD3Fv7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:51:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wei.zhang@freescale.com, mm-commits@vger.kernel.org


The patch titled
     rapidio: change RapidIO doorbell source and target ID field to 16-bit
has been removed from the -mm tree.  Its filename was
     rapidio-change-rapidio-doorbell-source-and-target-id-field-to-16-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rapidio: change RapidIO doorbell source and target ID field to 16-bit
From: Zhang Wei <wei.zhang@freescale.com>

Change RapidIO doorbell source and target ID field to 16-bit for
support large system size, which max rio devid is 65535.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/powerpc/sysdev/fsl_rio.c~rapidio-change-rapidio-doorbell-source-and-target-id-field-to-16-bit arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~rapidio-change-rapidio-doorbell-source-and-target-id-field-to-16-bit
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -75,13 +75,13 @@
 #define DOORBELL_DSR_TE		0x00000080
 #define DOORBELL_DSR_QFI	0x00000010
 #define DOORBELL_DSR_DIQI	0x00000001
-#define DOORBELL_TID_OFFSET	0x03
-#define DOORBELL_SID_OFFSET	0x05
+#define DOORBELL_TID_OFFSET	0x02
+#define DOORBELL_SID_OFFSET	0x04
 #define DOORBELL_INFO_OFFSET	0x06
 
 #define DOORBELL_MESSAGE_SIZE	0x08
-#define DBELL_SID(x)		(*(u8 *)(x + DOORBELL_SID_OFFSET))
-#define DBELL_TID(x)		(*(u8 *)(x + DOORBELL_TID_OFFSET))
+#define DBELL_SID(x)		(*(u16 *)(x + DOORBELL_SID_OFFSET))
+#define DBELL_TID(x)		(*(u16 *)(x + DOORBELL_TID_OFFSET))
 #define DBELL_INF(x)		(*(u16 *)(x + DOORBELL_INFO_OFFSET))
 
 struct rio_atmu_regs {
_

Patches currently in -mm which might be from wei.zhang@freescale.com are

origin.patch
rapidio-add-memory-mapping-driver-to-rapidio.patch
rapidio-add-rapidio-space-allocation-bitmap-arithmetic.patch
rapidio-add-fsl-rapidio-controller-memory-ops-functions.patch
rapidio-add-the-rapidio-master-port-maintance-and-doorbell-window-to-space-resources.patch
rapidio-add-rapidio-proc-fs-for-memory-mapping-debugging.patch
rapidio-add-the-memory-mapping-support-in-rionet-driver.patch
rapidio-fix-docbook-references.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch

