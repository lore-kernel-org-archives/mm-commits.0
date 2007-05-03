From: akpm@linux-foundation.org
Subject: + mips-make-resources-for-ds1742-static-__initdata.patch added to -mm tree
Date: Wed, 02 May 2007 21:00:02 -0700
Message-ID: <200705030400.l43402RB004371@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767355AbXECEAI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 00:00:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp


The patch titled
     MIPS: Make resources for ds1742 "static __initdata"
has been added to the -mm tree.  Its filename is
     mips-make-resources-for-ds1742-static-__initdata.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1039,7 +1039,7 @@ void __init toshiba_rbtx4927_timer_setup
 
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
git-kbuild.patch
git-mips.patch
mips-make-resources-for-ds1742-static-__initdata.patch
mips-drop-unnecessary-config_isa-from-rbtx49xx.patch
ne-add-platform_driver.patch
ne-misc-fixes-for-platform-driver.patch
ne-add-needs_portlist-to-control-isa-auto-probe.patch
ne-mips-use-platform_driver-for-ne-on-rbtx49xx.patch
serial_txx9-use-assigned-device-numbers.patch
serial_txx9-zap-changelog-from-source-code.patch
