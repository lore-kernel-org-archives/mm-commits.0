From: akpm@linux-foundation.org
Subject: - resource-add-new-ioresource_clk-type-v2.patch removed from -mm tree
Date: Tue, 12 Aug 2008 22:50:46 -0700
Message-ID: <200808130603.m7D63pVE001653@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752331AbYHMGEo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 02:04:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: damm@igel.co.jp, ben-linux@fluff.org, khali@linux-fr.org, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     resource: add new IORESOURCE_CLK type V2
has been removed from the -mm tree.  Its filename was
     resource-add-new-ioresource_clk-type-v2.patch

This patch was dropped because more thinking seems to be needed

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: resource: add new IORESOURCE_CLK type V2
From: Magnus Damm <damm@igel.co.jp>

So far struct resource has been used with the types IORESOURCE_MEM,
IORESOURCE_IO and IORESOUCE_IRQ to pass I/O and interrupt parameters to
platform drivers.  This patch extends this with IORESOURCE_CLK which
should be used to pass a clock string to the platform driver.  This string
points out which specific clock that should be used with clk_get() for a
certain driver instance.

Using hard coded strings in the device driver won't do since we may have
multiple instances of drivers that need to use different clocks.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ioport.h |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN include/linux/ioport.h~resource-add-new-ioresource_clk-type-v2 include/linux/ioport.h
--- a/include/linux/ioport.h~resource-add-new-ioresource_clk-type-v2
+++ a/include/linux/ioport.h
@@ -34,20 +34,21 @@ struct resource_list {
  */
 #define IORESOURCE_BITS		0x000000ff	/* Bus-specific bits */
 
-#define IORESOURCE_TYPE_BITS	0x00000f00	/* Resource type */
+#define IORESOURCE_TYPE_BITS	0x00001f00	/* Resource type */
 #define IORESOURCE_IO		0x00000100
 #define IORESOURCE_MEM		0x00000200
 #define IORESOURCE_IRQ		0x00000400
 #define IORESOURCE_DMA		0x00000800
+#define IORESOURCE_CLK		0x00001000
 
-#define IORESOURCE_PREFETCH	0x00001000	/* No side effects */
-#define IORESOURCE_READONLY	0x00002000
-#define IORESOURCE_CACHEABLE	0x00004000
-#define IORESOURCE_RANGELENGTH	0x00008000
-#define IORESOURCE_SHADOWABLE	0x00010000
+#define IORESOURCE_PREFETCH	0x00002000	/* No side effects */
+#define IORESOURCE_READONLY	0x00004000
+#define IORESOURCE_CACHEABLE	0x00008000
+#define IORESOURCE_RANGELENGTH	0x00010000
+#define IORESOURCE_SHADOWABLE	0x00020000
 
-#define IORESOURCE_SIZEALIGN	0x00020000	/* size indicates alignment */
-#define IORESOURCE_STARTALIGN	0x00040000	/* start field is alignment */
+#define IORESOURCE_SIZEALIGN	0x00040000	/* size indicates alignment */
+#define IORESOURCE_STARTALIGN	0x00080000	/* start field is alignment */
 
 #define IORESOURCE_DISABLED	0x10000000
 #define IORESOURCE_UNSET	0x20000000
_

Patches currently in -mm which might be from damm@igel.co.jp are

linux-next.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

