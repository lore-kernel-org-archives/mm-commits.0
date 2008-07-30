From: akpm@linux-foundation.org
Subject: - introduce-lower_32_bits-macro.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:15:15 -0700
Message-ID: <200807301915.m6UJFFDf011008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752243AbYG3TYT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:24:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joerg.roedel@amd.com, hpa@zytor.com, mm-commits@vger.kernel.org


The patch titled
     introduce lower_32_bits() macro
has been removed from the -mm tree.  Its filename was
     introduce-lower_32_bits-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: introduce lower_32_bits() macro
From: Joerg Roedel <joerg.roedel@amd.com>

The file kernel.h contains the upper_32_bits macro.  This patch adds the
other part, the lower_32_bits macro.  Its first use will be in the driver
for AMD IOMMU.

Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/kernel.h~introduce-lower_32_bits-macro include/linux/kernel.h
--- a/include/linux/kernel.h~introduce-lower_32_bits-macro
+++ a/include/linux/kernel.h
@@ -75,6 +75,12 @@ extern const char linux_proc_banner[];
  */
 #define upper_32_bits(n) ((u32)(((n) >> 16) >> 16))
 
+/**
+ * lower_32_bits - return bits 0-31 of a number
+ * @n: the number we're accessing
+ */
+#define lower_32_bits(n) ((u32)(n))
+
 #define	KERN_EMERG	"<0>"	/* system is unusable			*/
 #define	KERN_ALERT	"<1>"	/* action must be taken immediately	*/
 #define	KERN_CRIT	"<2>"	/* critical conditions			*/
_

Patches currently in -mm which might be from joerg.roedel@amd.com are

origin.patch
linux-next.patch
x86-calgary-replace-num_dma_pages-with-iommu_num_pages.patch

