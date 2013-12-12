From: akpm@linux-foundation.org
Subject: + sh-always-link-in-helper-functions-extracted-from-libgcc.patch
 added to -mm tree
Date: Wed, 11 Dec 2013 16:22:28 -0800
Message-ID: <52a901c4.WLui5H/oLoBksMum%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab3LLAW3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Dec 2013 19:22:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, nobuhiro.iwamatsu.yj@renesas.com, lethal@linux-sh.org, geert@linux-m68k.org

Subject: + sh-always-link-in-helper-functions-extracted-from-libgcc.patch added to -mm tree
To: geert@linux-m68k.org,lethal@linux-sh.org,nobuhiro.iwamatsu.yj@renesas.com
From: akpm@linux-foundation.org
Date: Wed, 11 Dec 2013 16:22:28 -0800


The patch titled
     Subject: sh: always link in helper functions extracted from libgcc
has been added to the -mm tree.  Its filename is
     sh-always-link-in-helper-functions-extracted-from-libgcc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-always-link-in-helper-functions-extracted-from-libgcc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-always-link-in-helper-functions-extracted-from-libgcc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
drivers-rtc-rtc-s5mc-fix-info-rtc-assignment.patch
rtc-s5m-fix-unsuccesful-irq-request-during-probe.patch
rtc-s5m-limit-endless-loop-waiting-for-register-update.patch
rtc-s5m-enable-irq-wake-during-suspend.patch
mfd-rtc-s5m-fix-register-updating-by-adding-regmap-for-rtc.patch
inith-add-missing-initcall-variants.patch
futex-switch-to-user_ds-for-futex-test.patch
sh-always-link-in-helper-functions-extracted-from-libgcc.patch
drivers-gpu-drm-drm_edid_loadc-make-edid_load-return-a-void.patch
asm-typesh-remove-include-asm-generic-int-l64h.patch
maintainers-add-an-entry-for-the-macintosh-hfsplus-filesystem.patch
init-mainc-remove-unused-declaration-of-tc_init.patch
proc-cleanup-simplify-get_task_state-task_state_array.patch
linux-next.patch

