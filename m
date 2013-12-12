From: akpm@linux-foundation.org
Subject: [merged] inith-add-missing-initcall-variants.patch removed from
 -mm tree
Date: Thu, 12 Dec 2013 12:47:44 -0800
Message-ID: <52aa20f0.hxZa7KMi+lAuKTxy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab3LLUrp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Dec 2013 15:47:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, timur@tabi.org, geert@linux-m68k.org, benh@kernel.crashing.org, rdunlap@infradead.org

Subject: [merged] inith-add-missing-initcall-variants.patch removed from -mm tree
To: rdunlap@infradead.org,benh@kernel.crashing.org,geert@linux-m68k.org,timur@tabi.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Dec 2013 12:47:44 -0800


The patch titled
     Subject: init.h: add missing initcall variants
has been removed from the -mm tree.  Its filename was
     inith-add-missing-initcall-variants.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: init.h: add missing initcall variants

Add missing initcall variants when building for loadable modules.  This
fixes this build error on powerpc allmodconfig:

drivers/tty/ehv_bytechan.c: error: type defaults to 'int' in declaration of 'console_initcall' [-Werror=implicit-int]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Timur Tabi <timur@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/init.h~inith-add-missing-initcall-variants include/linux/init.h
--- a/include/linux/init.h~inith-add-missing-initcall-variants
+++ a/include/linux/init.h
@@ -286,9 +286,11 @@ void __init parse_early_options(char *cm
 #define arch_initcall(fn)		module_init(fn)
 #define subsys_initcall(fn)		module_init(fn)
 #define fs_initcall(fn)			module_init(fn)
+#define rootfs_initcall(fn)		module_init(fn)
 #define device_initcall(fn)		module_init(fn)
 #define late_initcall(fn)		module_init(fn)
 
+#define console_initcall(fn)		module_init(fn)
 #define security_initcall(fn)		module_init(fn)
 
 /* Each module must use one module_init(). */
_

Patches currently in -mm which might be from rdunlap@infradead.org are

drm-nouveau-make-vga_switcheroo-code-depend-on-vga_switcheroo.patch
mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix.patch
drivers-block-kconfig-update-ram-block-device-module-name.patch
documentation-blockdev-ramdisktxt-updates.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

