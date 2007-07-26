From: akpm@linux-foundation.org
Subject: - mips-make-resources-for-ds1742-static-__initdata.patch removed from -mm tree
Date: Wed, 25 Jul 2007 21:23:46 -0700
Message-ID: <200707260423.l6Q4NkWU013732@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34783 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750953AbXGZEXz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 00:23:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, mm-commits@vger.kernel.org


The patch titled
     MIPS: Make resources for ds1742 "static __initdata"
has been removed from the -mm tree.  Its filename was
     mips-make-resources-for-ds1742-static-__initdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: MIPS: Make resources for ds1742 "static __initdata"
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

We can make resources for platform_device_register_simple() "static
__initdata".

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/jmr3927/rbhma3100/setup.c                        |    2 +-
 arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/mips/jmr3927/rbhma3100/setup.c~mips-make-resources-for-ds1742-static-__initdata arch/mips/jmr3927/rbhma3100/setup.c
--- a/arch/mips/jmr3927/rbhma3100/setup.c~mips-make-resources-for-ds1742-static-__initdata
+++ a/arch/mips/jmr3927/rbhma3100/setup.c
@@ -434,7 +434,7 @@ EXPORT_SYMBOL(__swizzle_addr_b);
 
 static int __init jmr3927_rtc_init(void)
 {
-	struct resource res = {
+	static struct resource __initdata res = {
 		.start	= JMR3927_IOC_NVRAMB_ADDR - IO_BASE,
 		.end	= JMR3927_IOC_NVRAMB_ADDR - IO_BASE + 0x800 - 1,
 		.flags	= IORESOURCE_MEM,
diff -puN arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c~mips-make-resources-for-ds1742-static-__initdata arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c
--- a/arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c~mips-make-resources-for-ds1742-static-__initdata
+++ a/arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c
@@ -1020,7 +1020,7 @@ void __init toshiba_rbtx4927_timer_setup
 
 static int __init toshiba_rbtx4927_rtc_init(void)
 {
-	struct resource res = {
+	static struct resource __initdata res = {
 		.start	= 0x1c010000,
 		.end	= 0x1c010000 + 0x800 - 1,
 		.flags	= IORESOURCE_MEM,
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
serial_txx9-fix-modem-control-line-handling.patch
serial_txx9-cleanup-includes.patch
