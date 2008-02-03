From: akpm@linux-foundation.org
Subject: + adb-add-missing-include-linux-platform_deviceh.patch added to -mm tree
Date: Sun, 03 Feb 2008 12:02:54 -0800
Message-ID: <200802032002.m13K2Z09029297@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50344 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751808AbYBCUC5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 3 Feb 2008 15:02:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     ADB: Add missing #include <linux/platform_device.h>
has been added to the -mm tree.  Its filename is
     adb-add-missing-include-linux-platform_deviceh.patch

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
Subject: ADB: Add missing #include <linux/platform_device.h>
From: Geert Uytterhoeven <geert@linux-m68k.org>

ADB: Add missing #include <linux/platform_device.h>

Commit c9f6d3d5c6d4f4cd3a53549a69c92951180e2a76

    [POWERPC] adb: Replace sleep notifier with platform driver suspend/resume hooks

introduced compile errors on m68k because <linux/platform_device.h> is not
explicitly included.  On powerpc, it's pulled in through <asm/prom.h>.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/adb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/macintosh/adb.c~adb-add-missing-include-linux-platform_deviceh drivers/macintosh/adb.c
--- a/drivers/macintosh/adb.c~adb-add-missing-include-linux-platform_deviceh
+++ a/drivers/macintosh/adb.c
@@ -36,6 +36,7 @@
 #include <linux/completion.h>
 #include <linux/device.h>
 #include <linux/kthread.h>
+#include <linux/platform_device.h>
 
 #include <asm/uaccess.h>
 #include <asm/semaphore.h>
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
adb-add-missing-include-linux-platform_deviceh.patch
sdio-fix-module-device-table-definition-for-m68k.patch
atari-falcon-ide-add-missing-hwif-variable.patch
m68k-use-cc-cross-prefix.patch
m68k-array_size-cleanup.patch
dio-array_size-cleanup.patch
dio-array_size-cleanup-update.patch
dio-array_size-cleanup-update-checkpatch-fixes.patch
m68k-balance-ioremap-and-iounmap-in-m68k-atari-hades-pcic.patch
nubus-kill-drivers-nubus-nubus_symsc.patch
m68k-kill-arch-m68k-mac-mac_ksymsc.patch
m68k-kill-arch-m68k-hp300-ksymsc.patch
m68k-kill-arch-m68k-amiga-amiga_ksymsc.patch
m68k-kill-arch-m68k-atari-atari_ksymsc.patch
m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc.patch
mac68k-macii-adb-comment-correction.patch
mac68k-remove-dead-code.patch
mac68k-add-nubus-card-definitions-and-a-typo-fix.patch
mac68k-remove-dead-mac_adbkeycodes.patch
uml-borrow-consth-techniques.patch
remove-pointless-casts-from-void-pointers.patch
cleanup-after-apus-removal.patch
amiga-serial-driver-port_write_mutex-fixup.patch
atari-floppy-rename-disk_type-to-atari_disk_type.patch
pm2fb-big-endian-fix.patch
add-cmpxchg_local-to-m86k.patch
procfs-constify-function-pointer-tables.patch
avoid-overflows-in-kernel-timec.patch
