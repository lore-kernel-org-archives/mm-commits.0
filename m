From: akpm@linux-foundation.org
Subject: - add-is_power_of_2-checking-to-log2h.patch removed from -mm tree
Date: Wed, 07 Feb 2007 11:53:27 -0800
Message-ID: <200702071953.l17JrRBx025321@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33760 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422907AbXBGTxg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 14:53:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, benh@kernel.crashing.org, galak@kernel.crashing.org, jeff@garzik.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Add "is_power_of_2" checking to log2.h.
has been removed from the -mm tree.  Its filename was
     add-is_power_of_2-checking-to-log2h.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add "is_power_of_2" checking to log2.h.
From: "Robert P. J. Day" <rpjday@mindspring.com>

Add the inline function "is_power_of_2()" to log2.h, where the value zero
is *not* considered to be a power of two.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jeff Garzik <jeff@garzik.org>
Acked-by: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/powerpc/mm/pgtable_32.c  |    5 +----
 arch/ppc/mm/pgtable.c         |    5 +----
 arch/ppc/syslib/ppc85xx_rio.c |    2 --
 drivers/net/gianfar_ethtool.c |    2 --
 include/linux/log2.h          |   11 +++++++++++
 5 files changed, 13 insertions(+), 12 deletions(-)

diff -puN arch/powerpc/mm/pgtable_32.c~add-is_power_of_2-checking-to-log2h arch/powerpc/mm/pgtable_32.c
--- a/arch/powerpc/mm/pgtable_32.c~add-is_power_of_2-checking-to-log2h
+++ a/arch/powerpc/mm/pgtable_32.c
@@ -294,11 +294,8 @@ void __init mapin_ram(void)
 	}
 }
 
-/* is x a power of 2? */
-#define is_power_of_2(x)	((x) != 0 && (((x) & ((x) - 1)) == 0))
-
 /* is x a power of 4? */
-#define is_power_of_4(x)	((x) != 0 && (((x) & (x-1)) == 0) && (ffs(x) & 1))
+#define is_power_of_4(x)	is_power_of_2(x) && (ffs(x) & 1))
 
 /*
  * Set up a mapping for a block of I/O.
diff -puN arch/ppc/mm/pgtable.c~add-is_power_of_2-checking-to-log2h arch/ppc/mm/pgtable.c
--- a/arch/ppc/mm/pgtable.c~add-is_power_of_2-checking-to-log2h
+++ a/arch/ppc/mm/pgtable.c
@@ -313,11 +313,8 @@ void __init mapin_ram(void)
 	}
 }
 
-/* is x a power of 2? */
-#define is_power_of_2(x)	((x) != 0 && (((x) & ((x) - 1)) == 0))
-
 /* is x a power of 4? */
-#define is_power_of_4(x)	((x) != 0 && (((x) & (x-1)) == 0) && (ffs(x) & 1))
+#define is_power_of_4(x)	is_power_of_2(x) && (ffs(x) & 1))
 
 /*
  * Set up a mapping for a block of I/O.
diff -puN arch/ppc/syslib/ppc85xx_rio.c~add-is_power_of_2-checking-to-log2h arch/ppc/syslib/ppc85xx_rio.c
--- a/arch/ppc/syslib/ppc85xx_rio.c~add-is_power_of_2-checking-to-log2h
+++ a/arch/ppc/syslib/ppc85xx_rio.c
@@ -59,8 +59,6 @@
 #define DBELL_TID(x)		(*(u8 *)(x + DOORBELL_TID_OFFSET))
 #define DBELL_INF(x)		(*(u16 *)(x + DOORBELL_INFO_OFFSET))
 
-#define is_power_of_2(x)	(((x) & ((x) - 1)) == 0)
-
 struct rio_atmu_regs {
 	u32 rowtar;
 	u32 pad1;
diff -puN drivers/net/gianfar_ethtool.c~add-is_power_of_2-checking-to-log2h drivers/net/gianfar_ethtool.c
--- a/drivers/net/gianfar_ethtool.c~add-is_power_of_2-checking-to-log2h
+++ a/drivers/net/gianfar_ethtool.c
@@ -42,8 +42,6 @@
 
 #include "gianfar.h"
 
-#define is_power_of_2(x)        ((x) != 0 && (((x) & ((x) - 1)) == 0))
-
 extern void gfar_start(struct net_device *dev);
 extern int gfar_clean_rx_ring(struct net_device *dev, int rx_work_limit);
 
diff -puN include/linux/log2.h~add-is_power_of_2-checking-to-log2h include/linux/log2.h
--- a/include/linux/log2.h~add-is_power_of_2-checking-to-log2h
+++ a/include/linux/log2.h
@@ -44,6 +44,17 @@ int __ilog2_u64(u64 n)
 #endif
 
 /*
+ *  Determine whether some value is a power of two, where zero is
+ * *not* considered a power of two.
+ */
+
+static inline __attribute__((const))
+bool is_power_of_2(unsigned long n)
+{
+	return (n != 0 && ((n & (n - 1)) == 0));
+}
+
+/*
  * round up to nearest power of two
  */
 static inline __attribute__((const))
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-acpi.patch
git-alsa.patch
git-powerpc.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
git-dvb.patch
change-incorrect-config_input_atixl-to-config_mouse_atixl.patch
kbuild-remove-references-to-deprecated-prepare-all-target.patch
git-netdev-all.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
fix-misspelled-usbnet_mii-kernel-config-option.patch
fix-apparent-typo-config_usb_cdcether.patch
git-wireless.patch
replace-incorrect-macro-name-wireless_ext-with.patch
remove-unused-kernel-config-option-x86_xadd.patch
remove-final-references-to-deprecated-map_anon-page-protection-flag.patch
uml-fix-apparent-config_64_bit-typo.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
get-rid-of-double-zeroing-of-allocated-pages.patch
remove-unnecessary-memset0-calls-after-kzalloc-calls.patch
discuss-a-couple-common-errors-in-kernel-doc-usage.patch
numerous-fixes-to-kernel-doc-info-in-source-files.patch
remove-a-couple-final-references-to-obsolete-verify_area.patch
remove-the-last-reference-to-rwlock_is_locked-macro.patch
extend-the-set-of-__attribute__-shortcut-macros.patch
remove-final-reference-to-superfluous-smp_commence.patch
replace-regular-code-with-appropriate-calls-to-container_of.patch
remove-dead-kernel-config-option-aedsp16_mpu401.patch
remove-references-to-obsolete-kernel-config-option-debug_rwsems.patch
remove-unused-kernel-config-option-zisofs_fs.patch
remove-unused-kernel-config-option-lcd_device.patch
remove-unused-kernel-config-option-paride_parport.patch
fix-apparent-typo-config_lockdep_debug.patch
ntfs-rename-incorrect-check-of-ntfs_debug-with-just-debug.patch
quota-have-linux-quotah-include-linux-rwsemh-explicitly.patch
isdn-fix-typo-config_hisax_quadro-config_hisax_sct_quadro.patch
isdn-rename-some-debugging-macros-to-not-resemble-config.patch
isdn-rename-debug-option-config_serial_nopause_io.patch
isdn-remove-defunct-test-emulator.patch
isdn-rename-special-macro-config_hisax_hfc4s8s_pcimem.patch
correct-apparent-typo-config_aty_ct-in-aty-video.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
