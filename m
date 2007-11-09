From: akpm@linux-foundation.org
Subject: + omap-register-the-l4-io-bus-to-boot-omap2.patch added to -mm tree
Date: Fri, 09 Nov 2007 11:56:33 -0800
Message-ID: <200711091956.lA9JuXUd029455@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54125 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753668AbXKIT5J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 14:57:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyungmin.park@samsung.com, rmk@arm.linux.org.uk, tony@atomide.com


The patch titled
     omap: register the L4 io bus to boot OMAP2
has been added to the -mm tree.  Its filename is
     omap-register-the-l4-io-bus-to-boot-omap2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: omap: register the L4 io bus to boot OMAP2
From: Kyungmin Park <kyungmin.park@samsung.com>

This patch enables the OMAP2 boot

It is already fixed in OMAP tree. It syncs the mainline tree too.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Tony Lindgren <tony@atomide.com>
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

omap-register-the-l4-io-bus-to-boot-omap2.patch
