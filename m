From: akpm@linux-foundation.org
Subject: - blackfin-arch-define-a-new-cacheline_aligned-attribute-to-put-it-in-l1-data-memory-with-linkscript-update.patch removed from -mm tree
Date: Mon, 30 Apr 2007 12:11:01 -0700
Message-ID: <200704301911.l3UJB149012470@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946659AbXD3TLF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:11:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bryan.wu@analog.com, mm-commits@vger.kernel.org


The patch titled
     blackfin arch: define a new cacheline_aligned attribute to put it in L1 data memory with linkscript update
has been removed from the -mm tree.  Its filename was
     blackfin-arch-define-a-new-cacheline_aligned-attribute-to-put-it-in-l1-data-memory-with-linkscript-update.patch

This patch was dropped because it was folded into blackfin-arch.patch

------------------------------------------------------
Subject: blackfin arch: define a new cacheline_aligned attribute to put it in L1 data memory with linkscript update
From: "Wu, Bryan" <bryan.wu@analog.com>

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/Kconfig              |    8 ++++++++
 arch/blackfin/kernel/vmlinux.lds.S |    8 ++++++++
 include/asm-blackfin/cache.h       |   11 +++++++----
 3 files changed, 23 insertions(+), 4 deletions(-)

diff -puN arch/blackfin/Kconfig~blackfin-arch-define-a-new-cacheline_aligned-attribute-to-put-it-in-l1-data-memory-with-linkscript-update arch/blackfin/Kconfig
--- a/arch/blackfin/Kconfig~blackfin-arch-define-a-new-cacheline_aligned-attribute-to-put-it-in-l1-data-memory-with-linkscript-update
+++ a/arch/blackfin/Kconfig
@@ -514,6 +514,14 @@ config IP_CHECKSUM_L1
 	  If enabled IP Checksum function is linked
 	  into L1 instruction memory.(less latency)
 
+config CACHELINE_ALIGNED_L1
+	bool "Locate cacheline_aligned data to L1 Data Memory"
+	default y
+	depends on !BF531
+	help
+	  If enabled cacheline_anligned data is linked
+	  into L1 data memory.(less latency)
+
 config SYSCALL_TAB_L1
 	bool "Locate Syscall Table L1 Data Memory"
 	default n
diff -puN arch/blackfin/kernel/vmlinux.lds.S~blackfin-arch-define-a-new-cacheline_aligned-attribute-to-put-it-in-l1-data-memory-with-linkscript-update arch/blackfin/kernel/vmlinux.lds.S
--- a/arch/blackfin/kernel/vmlinux.lds.S~blackfin-arch-define-a-new-cacheline_aligned-attribute-to-put-it-in-l1-data-memory-with-linkscript-update
+++ a/arch/blackfin/kernel/vmlinux.lds.S
@@ -174,6 +174,9 @@ SECTIONS
 		 __sbss_l1 = .;
 		*(.l1.bss)
 
+		. = ALIGN(32);
+		*(.data_l1.cacheline_aligned)
+
 		. = ALIGN(4);
 		 __ebss_l1 = .;
 	} > l1_data_a AT > ram
@@ -198,6 +201,11 @@ SECTIONS
 		. = ALIGN(0x2000);
 		*(.data.init_task)
 		*(.data)
+
+		. = ALIGN(32);
+		*(.data.cacheline_aligned)
+
+		. = ALIGN(0x2000);
 		__edata = .;
 	} > ram
 
diff -puN include/asm-blackfin/cache.h~blackfin-arch-define-a-new-cacheline_aligned-attribute-to-put-it-in-l1-data-memory-with-linkscript-update include/asm-blackfin/cache.h
--- a/include/asm-blackfin/cache.h~blackfin-arch-define-a-new-cacheline_aligned-attribute-to-put-it-in-l1-data-memory-with-linkscript-update
+++ a/include/asm-blackfin/cache.h
@@ -10,13 +10,16 @@
  */
 #define L1_CACHE_SHIFT	5
 #define L1_CACHE_BYTES	(1 << L1_CACHE_SHIFT)
+#define SMP_CACHE_BYTES	L1_CACHE_BYTES
 
 /*
- * Don't make __cacheline_aligned and
- * ____cacheline_aligned defined in include/linux/cache.h
+ * Put cacheline_aliged data to L1 data memory
  */
-#define __cacheline_aligned
-#define ____cacheline_aligned
+#ifdef CONFIG_CACHELINE_ALIGNED_L1
+#define __cacheline_aligned				\
+	  __attribute__((__aligned__(L1_CACHE_BYTES),	\
+		__section__(".data_l1.cacheline_aligned")))
+#endif
 
 /*
  * largest L1 which this arch supports
_

Patches currently in -mm which might be from bryan.wu@analog.com are

origin.patch
blackfin-Documentation.patch
blackfin-arch.patch
blackfin-arch-define-a-new-cacheline_aligned-attribute-to-put-it-in-l1-data-memory-with-linkscript-update.patch
blackfin-arch-fix-bug-asserting-gpio-requested-doesnt-make-sense-with-gpio-whole-port-accesses.patch
blackfin-arch-04-and-05-silicon-doesnt-exist-for-bf534-bf536-adn-bf537-so-dont-let-people-select-the-option.patch
blackfin-arch-fix-coding-style-in-ints-priority-sc-c-file.patch
blackfin-arch-fix-bug-refuse-to-boot-if-rootfs-image-is-not-attached-when-mtd_uclinux-is-selected.patch
blackfin-arch-move-revid-function-into-global-headers-as-inline-functions.patch
blackfin-arch-need-linux-ttyh-header-for-console_init-prototype.patch
blackfin-arch-convert-most-blackfin-specific-spi-register-settings-to-common-spi-framework-settings.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
blackfin-on-chip-ethernet-mac-controller-driver.patch
blackfin-on-chip-ethernet-mac-controller-driver-update.patch
blackfin-patch-add-blackfin-support-in-smc91x.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-on-chip-rtc-controller-driver-fix-rtc_update_irq-augument.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver-cleanup-and-coding-style-fixing.patch
blackfin-blackfin-on-chip-spi-controller-driver-fix-reboot-kernel-mounting-spi-flash-print-error-bug.patch
blackfin-spi-controller-driver-update-according-to-david-brownells-review.patch
blackfin-serial-core-driver-uart1-should-depend-on-bf534-bf536-bf537-remove-experimental-marking-from-on-chip-serial-core-driver-and-make-options-less-wordy.patch
move-die-notifier-handling-to-common-code-fix.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
revoke-core-code-generic_file_revoke-stub-for-nommu.patch
vdso-print-fatal-signals-fix-compiling-error-bug-in.patch
