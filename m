From: akpm@linux-foundation.org
Subject: + inith-add-missing-initcall-variants.patch added to -mm tree
Date: Tue, 03 Dec 2013 13:27:05 -0800
Message-ID: <529e4ca9.c2TrMZcx0W92MfxS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54449 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755Ab3LCV1G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Dec 2013 16:27:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, timur@freescale.com, geert@linux-m68k.org, benh@kernel.crashing.org, rdunlap@infradead.org

Subject: + inith-add-missing-initcall-variants.patch added to -mm tree
To: rdunlap@infradead.org,benh@kernel.crashing.org,geert@linux-m68k.org,timur@freescale.com
From: akpm@linux-foundation.org
Date: Tue, 03 Dec 2013 13:27:05 -0800


The patch titled
     Subject: init.h: add missing initcall variants
has been added to the -mm tree.  Its filename is
     inith-add-missing-initcall-variants.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/inith-add-missing-initcall-variants.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/inith-add-missing-initcall-variants.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

origin.patch
inith-add-missing-initcall-variants.patch
drm-nouveau-make-vga_switcheroo-code-depend-on-vga_switcheroo.patch
mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

