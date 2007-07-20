From: akpm@linux-foundation.org
Subject: + remove-kconfig-setting-config_debug_shirq.patch added to -mm tree
Date: Fri, 20 Jul 2007 14:43:25 -0700
Message-ID: <200707202143.l6KLhQ3c017997@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41159 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937106AbXGTVoH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 17:44:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fernando@oss.ntt.co.jp, alan@lxorguk.ukuu.org.uk, dwmw2@infradead.org, mingo@elte.hu


The patch titled
     Remove Kconfig setting CONFIG_DEBUG_SHIRQ
has been added to the -mm tree.  Its filename is
     remove-kconfig-setting-config_debug_shirq.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove Kconfig setting CONFIG_DEBUG_SHIRQ
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

request_irq() and setup_irq() are not fast paths and free_irq() much less
so.  In fact, by enabling this feature unconditionally we would have
_everyone_ (unknowingly) testing devices drivers, which hopefully will
result in more bug-reports and, in turn, better drivers.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/configs/at91sam9rlek_defconfig     |    1 -
 arch/arm/configs/picotux200_defconfig       |    1 -
 arch/arm/configs/s3c2410_defconfig          |    1 -
 arch/avr32/configs/atngw100_defconfig       |    1 -
 arch/avr32/configs/atstk1002_defconfig      |    1 -
 arch/i386/defconfig                         |    1 -
 arch/ia64/configs/tiger_defconfig           |    1 -
 arch/ia64/configs/zx1_defconfig             |    1 -
 arch/ia64/defconfig                         |    1 -
 arch/mips/configs/bigsur_defconfig          |    1 -
 arch/mips/configs/mipssim_defconfig         |    1 -
 arch/mips/configs/pnx8550-jbs_defconfig     |    1 -
 arch/mips/configs/pnx8550-stb810_defconfig  |    1 -
 arch/mips/configs/yosemite_defconfig        |    1 -
 arch/powerpc/configs/cell_defconfig         |    1 -
 arch/powerpc/configs/celleb_defconfig       |    1 -
 arch/powerpc/configs/chrp32_defconfig       |    1 -
 arch/powerpc/configs/ebony_defconfig        |    1 -
 arch/powerpc/configs/g5_defconfig           |    1 -
 arch/powerpc/configs/holly_defconfig        |    1 -
 arch/powerpc/configs/iseries_defconfig      |    1 -
 arch/powerpc/configs/linkstation_defconfig  |    1 -
 arch/powerpc/configs/lite5200_defconfig     |    1 -
 arch/powerpc/configs/maple_defconfig        |    1 -
 arch/powerpc/configs/mpc8272_ads_defconfig  |    1 -
 arch/powerpc/configs/mpc8313_rdb_defconfig  |    1 -
 arch/powerpc/configs/mpc8540_ads_defconfig  |    1 -
 arch/powerpc/configs/mpc8544_ds_defconfig   |    1 -
 arch/powerpc/configs/mpc8560_ads_defconfig  |    1 -
 arch/powerpc/configs/mpc8568mds_defconfig   |    1 -
 arch/powerpc/configs/mpc85xx_cds_defconfig  |    1 -
 arch/powerpc/configs/mpc8641_hpcn_defconfig |    1 -
 arch/powerpc/configs/pasemi_defconfig       |    1 -
 arch/powerpc/configs/pmac32_defconfig       |    1 -
 arch/powerpc/configs/ppc64_defconfig        |    1 -
 arch/powerpc/configs/ps3_defconfig          |    1 -
 arch/powerpc/configs/pseries_defconfig      |    1 -
 arch/sh/configs/r7780rp_defconfig           |    1 -
 arch/sh/configs/r7785rp_defconfig           |    1 -
 arch/sh/configs/se7712_defconfig            |    1 -
 arch/sh64/configs/cayman_defconfig          |    1 -
 arch/sparc64/defconfig                      |    1 -
 arch/x86_64/defconfig                       |    1 -
 drivers/char/cyclades.c                     |    2 +-
 drivers/net/e1000/e1000_main.c              |    9 +++++----
 kernel/irq/manage.c                         |    6 ------
 lib/Kconfig.debug                           |    9 ---------
 47 files changed, 6 insertions(+), 63 deletions(-)

diff -puN arch/arm/configs/at91sam9rlek_defconfig~remove-kconfig-setting-config_debug_shirq arch/arm/configs/at91sam9rlek_defconfig
--- a/arch/arm/configs/at91sam9rlek_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/arm/configs/at91sam9rlek_defconfig
@@ -906,7 +906,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
diff -puN arch/arm/configs/picotux200_defconfig~remove-kconfig-setting-config_debug_shirq arch/arm/configs/picotux200_defconfig
--- a/arch/arm/configs/picotux200_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/arm/configs/picotux200_defconfig
@@ -1292,7 +1292,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
diff -puN arch/arm/configs/s3c2410_defconfig~remove-kconfig-setting-config_debug_shirq arch/arm/configs/s3c2410_defconfig
--- a/arch/arm/configs/s3c2410_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/arm/configs/s3c2410_defconfig
@@ -1367,7 +1367,6 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
diff -puN arch/avr32/configs/atngw100_defconfig~remove-kconfig-setting-config_debug_shirq arch/avr32/configs/atngw100_defconfig
--- a/arch/avr32/configs/atngw100_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/avr32/configs/atngw100_defconfig
@@ -939,7 +939,6 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -puN arch/avr32/configs/atstk1002_defconfig~remove-kconfig-setting-config_debug_shirq arch/avr32/configs/atstk1002_defconfig
--- a/arch/avr32/configs/atstk1002_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/avr32/configs/atstk1002_defconfig
@@ -756,7 +756,6 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -puN arch/i386/defconfig~remove-kconfig-setting-config_debug_shirq arch/i386/defconfig
--- a/arch/i386/defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/i386/defconfig
@@ -1423,7 +1423,6 @@ CONFIG_UNUSED_SYMBOLS=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -puN arch/ia64/configs/tiger_defconfig~remove-kconfig-setting-config_debug_shirq arch/ia64/configs/tiger_defconfig
--- a/arch/ia64/configs/tiger_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/ia64/configs/tiger_defconfig
@@ -1318,7 +1318,6 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_LOG_BUF_SHIFT=20
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
diff -puN arch/ia64/configs/zx1_defconfig~remove-kconfig-setting-config_debug_shirq arch/ia64/configs/zx1_defconfig
--- a/arch/ia64/configs/zx1_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/ia64/configs/zx1_defconfig
@@ -1533,7 +1533,6 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_LOG_BUF_SHIFT=17
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
diff -puN arch/ia64/defconfig~remove-kconfig-setting-config_debug_shirq arch/ia64/defconfig
--- a/arch/ia64/defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/ia64/defconfig
@@ -1482,7 +1482,6 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_LOG_BUF_SHIFT=20
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
diff -puN arch/mips/configs/bigsur_defconfig~remove-kconfig-setting-config_debug_shirq arch/mips/configs/bigsur_defconfig
--- a/arch/mips/configs/bigsur_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/mips/configs/bigsur_defconfig
@@ -999,7 +999,6 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
diff -puN arch/mips/configs/mipssim_defconfig~remove-kconfig-setting-config_debug_shirq arch/mips/configs/mipssim_defconfig
--- a/arch/mips/configs/mipssim_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/mips/configs/mipssim_defconfig
@@ -838,7 +838,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_UNUSED_SYMBOLS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_DETECT_SOFTLOCKUP is not set
 # CONFIG_SCHEDSTATS is not set
diff -puN arch/mips/configs/pnx8550-jbs_defconfig~remove-kconfig-setting-config_debug_shirq arch/mips/configs/pnx8550-jbs_defconfig
--- a/arch/mips/configs/pnx8550-jbs_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/mips/configs/pnx8550-jbs_defconfig
@@ -1201,7 +1201,6 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
diff -puN arch/mips/configs/pnx8550-stb810_defconfig~remove-kconfig-setting-config_debug_shirq arch/mips/configs/pnx8550-stb810_defconfig
--- a/arch/mips/configs/pnx8550-stb810_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/mips/configs/pnx8550-stb810_defconfig
@@ -1191,7 +1191,6 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_FS is not set
 CONFIG_HEADERS_CHECK=y
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
diff -puN arch/mips/configs/yosemite_defconfig~remove-kconfig-setting-config_debug_shirq arch/mips/configs/yosemite_defconfig
--- a/arch/mips/configs/yosemite_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/mips/configs/yosemite_defconfig
@@ -810,7 +810,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
diff -puN arch/powerpc/configs/cell_defconfig~remove-kconfig-setting-config_debug_shirq arch/powerpc/configs/cell_defconfig
--- a/arch/powerpc/configs/cell_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/powerpc/configs/cell_defconfig
@@ -1468,7 +1468,6 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 # CONFIG_DETECT_SOFTLOCKUP is not set
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -puN arch/powerpc/configs/celleb_defconfig~remove-kconfig-setting-config_debug_shirq arch/powerpc/configs/celleb_defconfig
--- a/arch/powerpc/configs/celleb_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/powerpc/configs/celleb_defconfig
@@ -1295,7 +1295,6 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -puN arch/powerpc/configs/chrp32_defconfig~remove-kconfig-setting-config_debug_shirq arch/powerpc/configs/chrp32_defconfig
--- a/arch/powerpc/configs/chrp32_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/powerpc/configs/chrp32_defconfig
@@ -1454,7 +1454,6 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -puN arch/powerpc/configs/ebony_defconfig~remove-kconfig-setting-config_debug_shirq arch/powerpc/configs/ebony_defconfig
--- a/arch/powerpc/configs/ebony_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/powerpc/configs/ebony_defconfig
@@ -772,7 +772,6 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -puN arch/powerpc/configs/g5_defconfig~remove-kconfig-setting-config_debug_shirq arch/powerpc/configs/g5_defconfig
--- a/arch/powerpc/configs/g5_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/powerpc/configs/g5_defconfig
@@ -1645,7 +1645,6 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -puN arch/powerpc/configs/holly_defconfig~remove-kconfig-setting-config_debug_shirq arch/powerpc/configs/holly_defconfig
--- a/arch/powerpc/configs/holly_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/powerpc/configs/holly_defconfig
@@ -987,7 +987,6 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -puN arch/powerpc/configs/iseries_defconfig~remove-kconfig-setting-config_debug_shirq arch/powerpc/configs/iseries_defconfig
--- a/arch/powerpc/configs/iseries_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/powerpc/configs/iseries_defconfig
@@ -1147,7 +1147,6 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -puN arch/powerpc/configs/linkstation_defconfig~remove-kconfig-setting-config_debug_shirq arch/powerpc/configs/linkstation_defconfig
--- a/arch/powerpc/configs/linkstation_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/powerpc/configs/linkstation_defconfig
@@ -1530,7 +1530,6 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -puN arch/powerpc/configs/lite5200_defconfig~remove-kconfig-setting-config_debug_shirq arch/powerpc/configs/lite5200_defconfig
--- a/arch/powerpc/configs/lite5200_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/powerpc/configs/lite5200_defconfig
@@ -893,7 +893,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -puN arch/powerpc/configs/maple_defconfig~remove-kconfig-setting-config_debug_shirq arch/powerpc/configs/maple_defconfig
--- a/arch/powerpc/configs/maple_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/powerpc/configs/maple_defconfig
@@ -1169,7 +1169,6 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -puN arch/powerpc/configs/mpc8272_ads_defconfig~remove-kconfig-setting-config_debug_shirq arch/powerpc/configs/mpc8272_ads_defconfig
--- a/arch/powerpc/configs/mpc8272_ads_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/powerpc/configs/mpc8272_ads_defconfig
@@ -844,7 +844,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -puN arch/powerpc/configs/mpc8313_rdb_defconfig~remove-kconfig-setting-config_debug_shirq arch/powerpc/configs/mpc8313_rdb_defconfig
--- a/arch/powerpc/configs/mpc8313_rdb_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/powerpc/configs/mpc8313_rdb_defconfig
@@ -1336,7 +1336,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -puN arch/powerpc/configs/mpc8540_ads_defconfig~remove-kconfig-setting-config_debug_shirq arch/powerpc/configs/mpc8540_ads_defconfig
--- a/arch/powerpc/configs/mpc8540_ads_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/powerpc/configs/mpc8540_ads_defconfig
@@ -772,7 +772,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -puN arch/powerpc/configs/mpc8544_ds_defconfig~remove-kconfig-setting-config_debug_shirq arch/powerpc/configs/mpc8544_ds_defconfig
--- a/arch/powerpc/configs/mpc8544_ds_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/powerpc/configs/mpc8544_ds_defconfig
@@ -963,7 +963,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -puN arch/powerpc/configs/mpc8560_ads_defconfig~remove-kconfig-setting-config_debug_shirq arch/powerpc/configs/mpc8560_ads_defconfig
--- a/arch/powerpc/configs/mpc8560_ads_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/powerpc/configs/mpc8560_ads_defconfig
@@ -852,7 +852,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -puN arch/powerpc/configs/mpc8568mds_defconfig~remove-kconfig-setting-config_debug_shirq arch/powerpc/configs/mpc8568mds_defconfig
--- a/arch/powerpc/configs/mpc8568mds_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/powerpc/configs/mpc8568mds_defconfig
@@ -890,7 +890,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -puN arch/powerpc/configs/mpc85xx_cds_defconfig~remove-kconfig-setting-config_debug_shirq arch/powerpc/configs/mpc85xx_cds_defconfig
--- a/arch/powerpc/configs/mpc85xx_cds_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/powerpc/configs/mpc85xx_cds_defconfig
@@ -905,7 +905,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -puN arch/powerpc/configs/mpc8641_hpcn_defconfig~remove-kconfig-setting-config_debug_shirq arch/powerpc/configs/mpc8641_hpcn_defconfig
--- a/arch/powerpc/configs/mpc8641_hpcn_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/powerpc/configs/mpc8641_hpcn_defconfig
@@ -962,7 +962,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -puN arch/powerpc/configs/pasemi_defconfig~remove-kconfig-setting-config_debug_shirq arch/powerpc/configs/pasemi_defconfig
--- a/arch/powerpc/configs/pasemi_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/powerpc/configs/pasemi_defconfig
@@ -1646,7 +1646,6 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -puN arch/powerpc/configs/pmac32_defconfig~remove-kconfig-setting-config_debug_shirq arch/powerpc/configs/pmac32_defconfig
--- a/arch/powerpc/configs/pmac32_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/powerpc/configs/pmac32_defconfig
@@ -1885,7 +1885,6 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -puN arch/powerpc/configs/ppc64_defconfig~remove-kconfig-setting-config_debug_shirq arch/powerpc/configs/ppc64_defconfig
--- a/arch/powerpc/configs/ppc64_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/powerpc/configs/ppc64_defconfig
@@ -1801,7 +1801,6 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -puN arch/powerpc/configs/ps3_defconfig~remove-kconfig-setting-config_debug_shirq arch/powerpc/configs/ps3_defconfig
--- a/arch/powerpc/configs/ps3_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/powerpc/configs/ps3_defconfig
@@ -1118,7 +1118,6 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -puN arch/powerpc/configs/pseries_defconfig~remove-kconfig-setting-config_debug_shirq arch/powerpc/configs/pseries_defconfig
--- a/arch/powerpc/configs/pseries_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/powerpc/configs/pseries_defconfig
@@ -1580,7 +1580,6 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -puN arch/sh/configs/r7780rp_defconfig~remove-kconfig-setting-config_debug_shirq arch/sh/configs/r7780rp_defconfig
--- a/arch/sh/configs/r7780rp_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/sh/configs/r7780rp_defconfig
@@ -1235,7 +1235,6 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
diff -puN arch/sh/configs/r7785rp_defconfig~remove-kconfig-setting-config_debug_shirq arch/sh/configs/r7785rp_defconfig
--- a/arch/sh/configs/r7785rp_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/sh/configs/r7785rp_defconfig
@@ -1139,7 +1139,6 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 # CONFIG_DETECT_SOFTLOCKUP is not set
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -puN arch/sh/configs/se7712_defconfig~remove-kconfig-setting-config_debug_shirq arch/sh/configs/se7712_defconfig
--- a/arch/sh/configs/se7712_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/sh/configs/se7712_defconfig
@@ -993,7 +993,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_DETECT_SOFTLOCKUP is not set
 # CONFIG_SCHEDSTATS is not set
diff -puN arch/sh64/configs/cayman_defconfig~remove-kconfig-setting-config_debug_shirq arch/sh64/configs/cayman_defconfig
--- a/arch/sh64/configs/cayman_defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/sh64/configs/cayman_defconfig
@@ -910,7 +910,6 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 CONFIG_SCHED_DEBUG=y
 CONFIG_SCHEDSTATS=y
diff -puN arch/sparc64/defconfig~remove-kconfig-setting-config_debug_shirq arch/sparc64/defconfig
--- a/arch/sparc64/defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/sparc64/defconfig
@@ -1373,7 +1373,6 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHED_DEBUG is not set
 CONFIG_SCHEDSTATS=y
diff -puN arch/x86_64/defconfig~remove-kconfig-setting-config_debug_shirq arch/x86_64/defconfig
--- a/arch/x86_64/defconfig~remove-kconfig-setting-config_debug_shirq
+++ a/arch/x86_64/defconfig
@@ -1335,7 +1335,6 @@ CONFIG_UNUSED_SYMBOLS=y
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHED_DEBUG is not set
 # CONFIG_SCHEDSTATS is not set
diff -puN drivers/char/cyclades.c~remove-kconfig-setting-config_debug_shirq drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~remove-kconfig-setting-config_debug_shirq
+++ a/drivers/char/cyclades.c
@@ -1447,7 +1447,7 @@ static irqreturn_t cyy_interrupt(int irq
 	card_base_addr = cinfo->base_addr;
 	index = cinfo->bus_index;
 
-	/* card was not initialized yet (e.g. DEBUG_SHIRQ) */
+	/* card was not initialized yet (e.g. shared IRQ) */
 	if (unlikely(card_base_addr == NULL))
 		return IRQ_HANDLED;
 
diff -puN drivers/net/e1000/e1000_main.c~remove-kconfig-setting-config_debug_shirq drivers/net/e1000/e1000_main.c
--- a/drivers/net/e1000/e1000_main.c~remove-kconfig-setting-config_debug_shirq
+++ a/drivers/net/e1000/e1000_main.c
@@ -1423,10 +1423,11 @@ e1000_open(struct net_device *netdev)
 	    e1000_check_mng_mode(&adapter->hw))
 		e1000_get_hw_control(adapter);
 
-	/* before we allocate an interrupt, we must be ready to handle it.
-	 * Setting DEBUG_SHIRQ in the kernel makes it fire an interrupt
-	 * as soon as we call pci_request_irq, so we have to setup our
-	 * clean_rx handler before we do so.  */
+	/* Before we allocate an interrupt, we must be ready to handle it.
+	 * Any pending interrupts (coming from a device sharing our IRQ line or
+	 * generated in the context of a previous kernel if this is a kdump
+	 * kernel, for example) will come in as soon as we call pci_request_irq,
+	 * so we have to setup our clean_rx handler before we do so.  */
 	e1000_configure(adapter);
 
 	err = e1000_request_irq(adapter);
diff -puN kernel/irq/manage.c~remove-kconfig-setting-config_debug_shirq kernel/irq/manage.c
--- a/kernel/irq/manage.c~remove-kconfig-setting-config_debug_shirq
+++ a/kernel/irq/manage.c
@@ -374,14 +374,12 @@ int setup_irq(unsigned int irq, struct i
 	return 0;
 
 mismatch:
-#ifdef CONFIG_DEBUG_SHIRQ
 	if (!(new->flags & IRQF_PROBE_SHARED)) {
 		printk(KERN_ERR "IRQ handler type mismatch for IRQ %d\n", irq);
 		if (old_name)
 			printk(KERN_ERR "current handler: %s\n", old_name);
 		dump_stack();
 	}
-#endif
 	spin_unlock_irqrestore(&desc->lock, flags);
 	return -EBUSY;
 }
@@ -454,7 +452,6 @@ void free_irq(unsigned int irq, void *de
 		spin_unlock_irqrestore(&desc->lock, flags);
 		return;
 	}
-#ifdef CONFIG_DEBUG_SHIRQ
 	if (handler) {
 		/*
 		 * It's a shared IRQ -- the driver ought to be prepared for it
@@ -464,7 +461,6 @@ void free_irq(unsigned int irq, void *de
 		 */
 		handler(irq, dev_id);
 	}
-#endif
 }
 EXPORT_SYMBOL(free_irq);
 
@@ -537,7 +533,6 @@ int request_irq(unsigned int irq, irq_ha
 
 	select_smp_affinity(irq);
 
-#ifdef CONFIG_DEBUG_SHIRQ
 	if (irqflags & IRQF_SHARED) {
 		/*
 		 * It's a shared IRQ -- the driver ought to be prepared for it
@@ -554,7 +549,6 @@ int request_irq(unsigned int irq, irq_ha
 		} else
 			handler(irq, dev_id);
 	}
-#endif
 
 	retval = setup_irq(irq, action);
 	if (retval)
diff -puN lib/Kconfig.debug~remove-kconfig-setting-config_debug_shirq lib/Kconfig.debug
--- a/lib/Kconfig.debug~remove-kconfig-setting-config_debug_shirq
+++ a/lib/Kconfig.debug
@@ -77,15 +77,6 @@ config DEBUG_KERNEL
 	  Say Y here if you are developing drivers or trying to debug and
 	  identify kernel problems.
 
-config DEBUG_SHIRQ
-	bool "Debug shared IRQ handlers"
-	depends on DEBUG_KERNEL && GENERIC_HARDIRQS
-	help
-	  Enable this to generate a spurious interrupt as soon as a shared
-	  interrupt handler is registered, and just before one is deregistered.
-	  Drivers ought to be able to handle interrupts coming in at those
-	  points; some don't and need to be caught.
-
 config DETECT_SOFTLOCKUP
 	bool "Detect Soft Lockups"
 	depends on DEBUG_KERNEL && !S390
_

Patches currently in -mm which might be from fernando@oss.ntt.co.jp are

origin.patch
remove-kconfig-setting-config_debug_shirq.patch
debug-handling-of-early-spurious-interrupts.patch
