From: akpm@linux-foundation.org
Subject: [merged]
 sh-always-link-in-helper-functions-extracted-from-libgcc.patch removed from -mm tree
Date: Thu, 19 Dec 2013 11:53:53 -0800
Message-ID: <52b34ed1.W568DAKvFF1ISYgm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45523 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157Ab3LSTxy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Dec 2013 14:53:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, nobuhiro.iwamatsu.yj@renesas.com, lethal@linux-sh.org, geert@linux-m68k.org

Subject: [merged] sh-always-link-in-helper-functions-extracted-from-libgcc.patch removed from -mm tree
To: geert@linux-m68k.org,lethal@linux-sh.org,nobuhiro.iwamatsu.yj@renesas.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 19 Dec 2013 11:53:53 -0800


The patch titled
     Subject: sh: always link in helper functions extracted from libgcc
has been removed from the -mm tree.  Its filename was
     sh-always-link-in-helper-functions-extracted-from-libgcc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: sh: always link in helper functions extracted from libgcc

E.g. landisk_defconfig, which has CONFIG_NTFS_FS=m:

ERROR: "__ashrdi3" [fs/ntfs/ntfs.ko] undefined!

For "lib-y", if no symbols in a compilation unit are referenced by other
units, the compilation unit will not be included in vmlinux.
This breaks modules that do reference those symbols.

Use "obj-y" instead to fix this.

http://kisskb.ellerman.id.au/kisskb/buildresult/8838077/

This doesn't fix all cases. There are others, e.g. udivsi3.
This is also not limited to sh, many architectures handle this in the same
way.

A simple solution is to unconditionally include all helper functions.
A more complex solution is to make the choice of "lib-y" or "obj-y" depend
on CONFIG_MODULES:
  obj-$(CONFIG_MODULES) += ...
  lib-y($CONFIG_MODULES) += ...

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Tested-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Reviewed-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/lib/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sh/lib/Makefile~sh-always-link-in-helper-functions-extracted-from-libgcc arch/sh/lib/Makefile
--- a/arch/sh/lib/Makefile~sh-always-link-in-helper-functions-extracted-from-libgcc
+++ a/arch/sh/lib/Makefile
@@ -6,7 +6,7 @@ lib-y  = delay.o memmove.o memchr.o \
 	 checksum.o strlen.o div64.o div64-generic.o
 
 # Extracted from libgcc
-lib-y += movmem.o ashldi3.o ashrdi3.o lshrdi3.o \
+obj-y += movmem.o ashldi3.o ashrdi3.o lshrdi3.o \
 	 ashlsi3.o ashrsi3.o ashiftrt.o lshrsi3.o \
 	 udiv_qrnnd.o
 
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
futex-switch-to-user_ds-for-futex-test.patch
sh-add-export_symbolmin_low_pfn-and-export_symbolmax_low_pfn-to-sh_ksyms_32c.patch
asm-typesh-remove-include-asm-generic-int-l64h.patch
maintainers-add-an-entry-for-the-macintosh-hfsplus-filesystem.patch
init-mainc-remove-unused-declaration-of-tc_init.patch
rtc-rtc-cmos-remove-superfluous-name-cast.patch
rtc-disable-rtc_drv_cmos-on-atari.patch
proc-cleanup-simplify-get_task_state-task_state_array.patch
linux-next.patch

