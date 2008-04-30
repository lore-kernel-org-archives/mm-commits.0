From: akpm@linux-foundation.org
Subject: - basic-braille-screen-reader-support-ppc-fix.patch removed from -mm tree
Date: Tue, 29 Apr 2008 23:24:18 -0700
Message-ID: <200804300624.m3U6OI8p031661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757686AbYD3GZ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:25:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, dtor@mail.ru, jikos@jikos.cz, paulus@samba.org, samuel.thibault@ens-lyon.org, mm-commits@vger.kernel.org


The patch titled
     basic-braille-screen-reader-support-ppc-fix
has been removed from the -mm tree.  Its filename was
     basic-braille-screen-reader-support-ppc-fix.patch

This patch was dropped because it was folded into basic-braille-screen-reader-support.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: basic-braille-screen-reader-support-ppc-fix
From: Andrew Morton <akpm@linux-foundation.org>

- As this patch exports kd_mksound we remove the pc-private esports.

- switch the export to non-gpl, as that was what powerpc was using.

Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jiri Kosina <jikos@jikos.cz>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/ppc_ksyms.c |    3 ---
 arch/ppc/kernel/ppc_ksyms.c     |    3 ---
 drivers/char/keyboard.c         |    2 +-
 3 files changed, 1 insertion(+), 7 deletions(-)

diff -puN arch/powerpc/kernel/ppc_ksyms.c~basic-braille-screen-reader-support-ppc-fix arch/powerpc/kernel/ppc_ksyms.c
--- a/arch/powerpc/kernel/ppc_ksyms.c~basic-braille-screen-reader-support-ppc-fix
+++ a/arch/powerpc/kernel/ppc_ksyms.c
@@ -137,9 +137,6 @@ EXPORT_SYMBOL(adb_try_handler_change);
 EXPORT_SYMBOL(cuda_request);
 EXPORT_SYMBOL(cuda_poll);
 #endif /* CONFIG_ADB_CUDA */
-#ifdef CONFIG_VT
-EXPORT_SYMBOL(kd_mksound);
-#endif
 EXPORT_SYMBOL(to_tm);
 
 #ifdef CONFIG_PPC32
diff -puN arch/ppc/kernel/ppc_ksyms.c~basic-braille-screen-reader-support-ppc-fix arch/ppc/kernel/ppc_ksyms.c
--- a/arch/ppc/kernel/ppc_ksyms.c~basic-braille-screen-reader-support-ppc-fix
+++ a/arch/ppc/kernel/ppc_ksyms.c
@@ -182,9 +182,6 @@ EXPORT_SYMBOL(cuda_poll);
 #if defined(CONFIG_BOOTX_TEXT)
 EXPORT_SYMBOL(btext_update_display);
 #endif
-#ifdef CONFIG_VT
-EXPORT_SYMBOL(kd_mksound);
-#endif
 EXPORT_SYMBOL(to_tm);
 
 EXPORT_SYMBOL(pm_power_off);
diff -puN drivers/char/keyboard.c~basic-braille-screen-reader-support-ppc-fix drivers/char/keyboard.c
--- a/drivers/char/keyboard.c~basic-braille-screen-reader-support-ppc-fix
+++ a/drivers/char/keyboard.c
@@ -260,7 +260,7 @@ void kd_mksound(unsigned int hz, unsigne
 	} else
 		kd_nosound(0);
 }
-EXPORT_SYMBOL_GPL(kd_mksound);
+EXPORT_SYMBOL(kd_mksound);
 
 /*
  * Setting the keyboard rate.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
isicom-bring-into-coding-style.patch
tty-the-big-operations-rework.patch
devpts-factor-out-pty-index-allocation.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
fuse-fix-race-in-llseek.patch
basic-braille-screen-reader-support.patch
basic-braille-screen-reader-support-ppc-fix.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
add-macros-similar-to-min-max-min_t-max_t.patch
rename-div64_64-to-div64_u64-fix.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
x86-ioremap-add-checks-for-virtual-addresses-fix.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

