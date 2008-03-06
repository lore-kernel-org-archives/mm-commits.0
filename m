From: akpm@linux-foundation.org
Subject: - omap-register-the-l4-io-bus-to-boot-omap2.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:21:24 -0800
Message-ID: <200803062221.m26MLOiE020717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751867AbYCFWWk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:22:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kyungmin.park@samsung.com, rmk@arm.linux.org.uk, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     omap: register the L4 io bus to boot OMAP2
has been removed from the -mm tree.  Its filename was
     omap-register-the-l4-io-bus-to-boot-omap2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: omap: register the L4 io bus to boot OMAP2
From: Kyungmin Park <kyungmin.park@samsung.com>

This patch enables the OMAP2 boot

It is already fixed in OMAP tree. It syncs the mainline tree too.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-omap2/io.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN arch/arm/mach-omap2/io.c~omap-register-the-l4-io-bus-to-boot-omap2 arch/arm/mach-omap2/io.c
--- a/arch/arm/mach-omap2/io.c~omap-register-the-l4-io-bus-to-boot-omap2
+++ a/arch/arm/mach-omap2/io.c
@@ -42,6 +42,12 @@ static struct map_desc omap2_io_desc[] _
 		.length		= L3_24XX_SIZE,
 		.type		= MT_DEVICE
 	},
+	{
+		.virtual        = L4_24XX_VIRT,
+		.pfn            = __phys_to_pfn(L4_24XX_PHYS),
+		.length         = L4_24XX_SIZE,
+		.type           = MT_DEVICE
+	},
 #ifdef CONFIG_ARCH_OMAP2430
 	{
 		.virtual	= L4_WK_243X_VIRT,
_

Patches currently in -mm which might be from kyungmin.park@samsung.com are

git-arm-master.patch
git-mtd.patch

