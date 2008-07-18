From: akpm@linux-foundation.org
Subject: - resource-add-new-ioresource_clk-type.patch removed from -mm tree
Date: Fri, 18 Jul 2008 15:25:40 -0700
Message-ID: <200807182225.m6IMPeEj001685@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751808AbYGRW0o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jul 2008 18:26:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: magnus.damm@gmail.com, damm@igel.co.jp, mm-commits@vger.kernel.org


The patch titled
     resource: add new IORESOURCE_CLK type
has been removed from the -mm tree.  Its filename was
     resource-add-new-ioresource_clk-type.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: resource: add new IORESOURCE_CLK type
From: Magnus Damm <magnus.damm@gmail.com>

Rearrange the values of the IORESOURCE_TYPE_BITS from one bit per type to a
4-bit counter.  Also, IORESOURCE_CLK is added.  Not sure if it is better to
start counting from 0 instead of 1.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ioport.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/ioport.h~resource-add-new-ioresource_clk-type include/linux/ioport.h
--- a/include/linux/ioport.h~resource-add-new-ioresource_clk-type
+++ a/include/linux/ioport.h
@@ -37,8 +37,9 @@ struct resource_list {
 #define IORESOURCE_TYPE_BITS	0x00000f00	/* Resource type */
 #define IORESOURCE_IO		0x00000100
 #define IORESOURCE_MEM		0x00000200
-#define IORESOURCE_IRQ		0x00000400
-#define IORESOURCE_DMA		0x00000800
+#define IORESOURCE_IRQ		0x00000300
+#define IORESOURCE_DMA		0x00000400
+#define IORESOURCE_CLK		0x00000500
 
 #define IORESOURCE_PREFETCH	0x00001000	/* No side effects */
 #define IORESOURCE_READONLY	0x00002000
_

Patches currently in -mm which might be from magnus.damm@gmail.com are

linux-next.patch
video-superh-mobile-lcdc-driver.patch
video-superh-mobile-lcdc-driver-update.patch
resource-add-new-ioresource_clk-type.patch

