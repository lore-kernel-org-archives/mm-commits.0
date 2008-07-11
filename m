From: akpm@linux-foundation.org
Subject: + resource-add-new-ioresource_clk-type.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:45:11 -0700
Message-ID: <200807111850.m6BIoqf4031274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50252 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754983AbYGKSuz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:50:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: magnus.damm@gmail.com, damm@igel.co.jp


The patch titled
     resource: add new IORESOURCE_CLK type
has been added to the -mm tree.  Its filename is
     resource-add-new-ioresource_clk-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
resource-add-resource_size.patch
resource-add-resource_size-fix.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-resource_type-and-ioresource_type_bits-fix.patch
resource-use-new-resource-type-changes.patch
resource-add-new-ioresource_clk-type.patch

