From: akpm@linux-foundation.org
Subject: [patch 117/126] m32r: defconfig: cleanup from old Kconfig
 options
Date: Fri, 08 Sep 2017 16:17:25 -0700
Message-ID: <20170908231725.flwWe7kB7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53764 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752999AbdIHXR0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:17:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, krzk@kernel.org, mm-commits@vger.kernel.org, sudipm.mukherjee@gmail.com, torvalds@linux-foundation.org

From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: m32r: defconfig: cleanup from old Kconfig options

Remove old, dead Kconfig options (in order appearing in this commit):
 - EXPERIMENTAL is gone since v3.9;
 - IP_NF_QUEUE: commit 3dd6664fac7e ("netfilter: remove unused "config
   IP_NF_QUEUE"");
 - IP_NF_TARGET_ULOG: commit d4da843e6fad ("netfilter: kill remnants of
   ulog targets");
 - VIDEO_OUTPUT_CONTROL: commit f167a64e9d67 ("video / output: Drop
   display output class support");
 - MTD_PARTITIONS: commit 6a8a98b22b10 ("mtd: kill
   CONFIG_MTD_PARTITIONS");
 - MTD_CHAR: commit 660685d9d1b4 ("mtd: merge mtdchar module with
   mtdcore");
 - MTD_CONCAT: commit f53fdebcc3e1 ("mtd: drop MTD_CONCAT from Kconfig
   entirely");

Link: http://lkml.kernel.org/r/1500527065-4575-1-git-send-email-krzk@kernel.org
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Acked-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/configs/m32104ut_defconfig     |    4 ----
 arch/m32r/configs/m32700ut.smp_defconfig |    3 ---
 arch/m32r/configs/m32700ut.up_defconfig  |    3 ---
 arch/m32r/configs/mappi.nommu_defconfig  |    2 --
 arch/m32r/configs/mappi.smp_defconfig    |    4 ----
 arch/m32r/configs/mappi.up_defconfig     |    4 ----
 arch/m32r/configs/mappi2.opsp_defconfig  |    2 --
 arch/m32r/configs/mappi2.vdec2_defconfig |    2 --
 arch/m32r/configs/mappi3.smp_defconfig   |    4 ----
 arch/m32r/configs/oaks32r_defconfig      |    2 --
 arch/m32r/configs/opsput_defconfig       |    2 --
 arch/m32r/configs/usrv_defconfig         |    5 -----
 12 files changed, 37 deletions(-)

diff -puN arch/m32r/configs/m32104ut_defconfig~m32r-defconfig-cleanup-from-old-kconfig-options arch/m32r/configs/m32104ut_defconfig
--- a/arch/m32r/configs/m32104ut_defconfig~m32r-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/m32r/configs/m32104ut_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
@@ -40,7 +39,6 @@ CONFIG_NETFILTER_XT_MATCH_REALM=m
 CONFIG_NETFILTER_XT_MATCH_SCTP=m
 CONFIG_NETFILTER_XT_MATCH_STRING=m
 CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
-CONFIG_IP_NF_QUEUE=m
 CONFIG_IP_NF_IPTABLES=m
 CONFIG_IP_NF_MATCH_ADDRTYPE=m
 CONFIG_IP_NF_MATCH_ECN=m
@@ -48,7 +46,6 @@ CONFIG_IP_NF_MATCH_TTL=m
 CONFIG_IP_NF_FILTER=m
 CONFIG_IP_NF_TARGET_REJECT=m
 CONFIG_IP_NF_TARGET_LOG=m
-CONFIG_IP_NF_TARGET_ULOG=m
 CONFIG_IP_NF_MANGLE=m
 CONFIG_IP_NF_TARGET_ECN=m
 CONFIG_IP_NF_TARGET_TTL=m
@@ -106,7 +103,6 @@ CONFIG_SENSORS_SMSC47M1=m
 CONFIG_SENSORS_W83781D=m
 CONFIG_SENSORS_W83L785TS=m
 CONFIG_SENSORS_W83627HF=m
-CONFIG_VIDEO_OUTPUT_CONTROL=m
 CONFIG_EXT2_FS=y
 CONFIG_EXT2_FS_XATTR=y
 CONFIG_EXT2_FS_POSIX_ACL=y
diff -puN arch/m32r/configs/m32700ut.smp_defconfig~m32r-defconfig-cleanup-from-old-kconfig-options arch/m32r/configs/m32700ut.smp_defconfig
--- a/arch/m32r/configs/m32700ut.smp_defconfig~m32r-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/m32r/configs/m32700ut.smp_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
@@ -30,7 +29,6 @@ CONFIG_IP_PNP=y
 CONFIG_IP_PNP_DHCP=y
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=m
@@ -63,7 +61,6 @@ CONFIG_SERIAL_M32R_SIO_CONSOLE=y
 CONFIG_SERIAL_M32R_PLDSIO=y
 CONFIG_HW_RANDOM=y
 CONFIG_DS1302=y
-CONFIG_VIDEO_OUTPUT_CONTROL=m
 CONFIG_FB=y
 CONFIG_FIRMWARE_EDID=y
 CONFIG_FB_S1D13XXX=y
diff -puN arch/m32r/configs/m32700ut.up_defconfig~m32r-defconfig-cleanup-from-old-kconfig-options arch/m32r/configs/m32700ut.up_defconfig
--- a/arch/m32r/configs/m32700ut.up_defconfig~m32r-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/m32r/configs/m32700ut.up_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
@@ -29,7 +28,6 @@ CONFIG_IP_PNP=y
 CONFIG_IP_PNP_DHCP=y
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=m
@@ -62,7 +60,6 @@ CONFIG_SERIAL_M32R_SIO_CONSOLE=y
 CONFIG_SERIAL_M32R_PLDSIO=y
 CONFIG_HW_RANDOM=y
 CONFIG_DS1302=y
-CONFIG_VIDEO_OUTPUT_CONTROL=m
 CONFIG_FB=y
 CONFIG_FIRMWARE_EDID=y
 CONFIG_FB_S1D13XXX=y
diff -puN arch/m32r/configs/mappi.nommu_defconfig~m32r-defconfig-cleanup-from-old-kconfig-options arch/m32r/configs/mappi.nommu_defconfig
--- a/arch/m32r/configs/mappi.nommu_defconfig~m32r-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/m32r/configs/mappi.nommu_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
 CONFIG_LOG_BUF_SHIFT=14
@@ -39,7 +38,6 @@ CONFIG_NETDEVICES=y
 # CONFIG_VT is not set
 CONFIG_SERIAL_M32R_SIO_CONSOLE=y
 CONFIG_HW_RANDOM=y
-CONFIG_VIDEO_OUTPUT_CONTROL=m
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 CONFIG_NFS_FS=y
diff -puN arch/m32r/configs/mappi.smp_defconfig~m32r-defconfig-cleanup-from-old-kconfig-options arch/m32r/configs/mappi.smp_defconfig
--- a/arch/m32r/configs/mappi.smp_defconfig~m32r-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/m32r/configs/mappi.smp_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
@@ -31,9 +30,7 @@ CONFIG_IP_PNP_DHCP=y
 # CONFIG_IPV6 is not set
 # CONFIG_STANDALONE is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_NBD=m
@@ -50,7 +47,6 @@ CONFIG_NETDEVICES=y
 # CONFIG_VT is not set
 CONFIG_SERIAL_M32R_SIO_CONSOLE=y
 CONFIG_HW_RANDOM=y
-CONFIG_VIDEO_OUTPUT_CONTROL=m
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 CONFIG_ISO9660_FS=y
diff -puN arch/m32r/configs/mappi.up_defconfig~m32r-defconfig-cleanup-from-old-kconfig-options arch/m32r/configs/mappi.up_defconfig
--- a/arch/m32r/configs/mappi.up_defconfig~m32r-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/m32r/configs/mappi.up_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
@@ -29,9 +28,7 @@ CONFIG_IP_PNP_DHCP=y
 # CONFIG_IPV6 is not set
 # CONFIG_STANDALONE is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_NBD=m
@@ -48,7 +45,6 @@ CONFIG_NETDEVICES=y
 # CONFIG_VT is not set
 CONFIG_SERIAL_M32R_SIO_CONSOLE=y
 CONFIG_HW_RANDOM=y
-CONFIG_VIDEO_OUTPUT_CONTROL=m
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 CONFIG_ISO9660_FS=y
diff -puN arch/m32r/configs/mappi2.opsp_defconfig~m32r-defconfig-cleanup-from-old-kconfig-options arch/m32r/configs/mappi2.opsp_defconfig
--- a/arch/m32r/configs/mappi2.opsp_defconfig~m32r-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/m32r/configs/mappi2.opsp_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
@@ -50,7 +49,6 @@ CONFIG_SMC91X=y
 # CONFIG_SERIO_I8042 is not set
 CONFIG_SERIAL_M32R_SIO_CONSOLE=y
 CONFIG_HW_RANDOM=y
-CONFIG_VIDEO_OUTPUT_CONTROL=m
 # CONFIG_VGA_CONSOLE is not set
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
diff -puN arch/m32r/configs/mappi2.vdec2_defconfig~m32r-defconfig-cleanup-from-old-kconfig-options arch/m32r/configs/mappi2.vdec2_defconfig
--- a/arch/m32r/configs/mappi2.vdec2_defconfig~m32r-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/m32r/configs/mappi2.vdec2_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
@@ -49,7 +48,6 @@ CONFIG_SMC91X=y
 # CONFIG_SERIO_I8042 is not set
 CONFIG_SERIAL_M32R_SIO_CONSOLE=y
 CONFIG_HW_RANDOM=y
-CONFIG_VIDEO_OUTPUT_CONTROL=m
 # CONFIG_VGA_CONSOLE is not set
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
diff -puN arch/m32r/configs/mappi3.smp_defconfig~m32r-defconfig-cleanup-from-old-kconfig-options arch/m32r/configs/mappi3.smp_defconfig
--- a/arch/m32r/configs/mappi3.smp_defconfig~m32r-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/m32r/configs/mappi3.smp_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
@@ -29,9 +28,7 @@ CONFIG_IP_PNP=y
 CONFIG_IP_PNP_DHCP=y
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_NBD=m
@@ -50,7 +47,6 @@ CONFIG_SMC91X=y
 # CONFIG_VT is not set
 CONFIG_SERIAL_M32R_SIO_CONSOLE=y
 CONFIG_HW_RANDOM=y
-CONFIG_VIDEO_OUTPUT_CONTROL=m
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 CONFIG_ISO9660_FS=y
diff -puN arch/m32r/configs/oaks32r_defconfig~m32r-defconfig-cleanup-from-old-kconfig-options arch/m32r/configs/oaks32r_defconfig
--- a/arch/m32r/configs/oaks32r_defconfig~m32r-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/m32r/configs/oaks32r_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
@@ -37,7 +36,6 @@ CONFIG_NETDEVICES=y
 # CONFIG_VT is not set
 CONFIG_SERIAL_M32R_SIO_CONSOLE=y
 CONFIG_HW_RANDOM=y
-CONFIG_VIDEO_OUTPUT_CONTROL=m
 CONFIG_EXT2_FS=y
 CONFIG_NFS_FS=y
 CONFIG_NFS_V3=y
diff -puN arch/m32r/configs/opsput_defconfig~m32r-defconfig-cleanup-from-old-kconfig-options arch/m32r/configs/opsput_defconfig
--- a/arch/m32r/configs/opsput_defconfig~m32r-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/m32r/configs/opsput_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
@@ -46,7 +45,6 @@ CONFIG_SERIAL_M32R_SIO_CONSOLE=y
 CONFIG_SERIAL_M32R_PLDSIO=y
 CONFIG_HW_RANDOM=y
 CONFIG_DS1302=y
-CONFIG_VIDEO_OUTPUT_CONTROL=m
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 CONFIG_ISO9660_FS=m
diff -puN arch/m32r/configs/usrv_defconfig~m32r-defconfig-cleanup-from-old-kconfig-options arch/m32r/configs/usrv_defconfig
--- a/arch/m32r/configs/usrv_defconfig~m32r-defconfig-cleanup-from-old-kconfig-options
+++ a/arch/m32r/configs/usrv_defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
@@ -34,9 +33,6 @@ CONFIG_INET_ESP=y
 CONFIG_INET_IPCOMP=y
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_ADV_OPTIONS=y
@@ -62,7 +58,6 @@ CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
 # CONFIG_SERIAL_M32R_SIO is not set
 # CONFIG_HWMON is not set
-CONFIG_VIDEO_OUTPUT_CONTROL=m
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 # CONFIG_EXT3_FS_XATTR is not set
_
