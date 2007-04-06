From: akpm@linux-foundation.org
Subject: + blackfin-arch-add-scm_timestampns-and-siocgstampns-to.patch added to -mm tree
Date: Fri, 06 Apr 2007 14:24:49 -0700
Message-ID: <200704062124.l36LOnxT019343@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34724 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933090AbXDFVYv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 17:24:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com


The patch titled
     blackfin arch: add SCM_TIMESTAMPNS and SIOCGSTAMPNS to socket header file with code style cleaning up
has been added to the -mm tree.  Its filename is
     blackfin-arch-add-scm_timestampns-and-siocgstampns-to.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: blackfin arch: add SCM_TIMESTAMPNS and SIOCGSTAMPNS to socket header file with code style cleaning up
From: "Wu, Bryan" <bryan.wu@analog.com>

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-blackfin/socket.h  |   11 ++++++-----
 include/asm-blackfin/sockios.h |    3 ++-
 2 files changed, 8 insertions(+), 6 deletions(-)

diff -puN include/asm-blackfin/socket.h~blackfin-arch-add-scm_timestampns-and-siocgstampns-to include/asm-blackfin/socket.h
--- a/include/asm-blackfin/socket.h~blackfin-arch-add-scm_timestampns-and-siocgstampns-to
+++ a/include/asm-blackfin/socket.h
@@ -38,15 +38,16 @@
 #define SO_BINDTODEVICE	25
 
 /* Socket filtering */
-#define SO_ATTACH_FILTER        26
-#define SO_DETACH_FILTER        27
+#define SO_ATTACH_FILTER	26
+#define SO_DETACH_FILTER	27
 
-#define SO_PEERNAME             28
+#define SO_PEERNAME		28
 #define SO_TIMESTAMP		29
 #define SCM_TIMESTAMP		SO_TIMESTAMP
 
 #define SO_ACCEPTCONN		30
-#define SO_PEERSEC             31
+#define SO_PEERSEC		31
 #define SO_PASSSEC		34
-
+#define SO_TIMESTAMPNS		35
+#define SCM_TIMESTAMPNS		SO_TIMESTAMPNS
 #endif				/* _ASM_SOCKET_H */
diff -puN include/asm-blackfin/sockios.h~blackfin-arch-add-scm_timestampns-and-siocgstampns-to include/asm-blackfin/sockios.h
--- a/include/asm-blackfin/sockios.h~blackfin-arch-add-scm_timestampns-and-siocgstampns-to
+++ a/include/asm-blackfin/sockios.h
@@ -7,6 +7,7 @@
 #define FIOGETOWN	0x8903
 #define SIOCGPGRP	0x8904
 #define SIOCATMARK	0x8905
-#define SIOCGSTAMP	0x8906	/* Get stamp */
+#define SIOCGSTAMP	0x8906	/* Get stamp (timeval) */
+#define SIOCGSTAMPNS	0x8907	/* Get stamp (timespec) */
 
 #endif				/* __ARCH_BFIN_SOCKIOS__ */
_

Patches currently in -mm which might be from bryan.wu@analog.com are

usb-gadget-rndis-fix-struct-rndis_packet_msg_type.patch
blackfin-Documentation.patch
blackfin-arch.patch
blackfin-arch-balance-parenthesis-in-macros.patch
blackfin-arch-2.6.21-rc4-mm1-update.patch
blackfin-arch-fix-struct-dmasg-packing-bug.patch
blackfin-arch-cleanup-cache-header-file.patch
blackfin-arch-fix-reboot-kernel-mounting-spi-flash-print-error-bug.patch
blackfin-arch-fix-compiling-error-in-flat-c-file.patch
blackfin-arch-power-management-replace-firmware-disk-mode.patch
blackfin-arch-add-kdebug-header-file.patch
blackfin-arch-fix-bug-bf561-rev-id-are-8-bit.patch
blackfin-arch-fix-bug-prevent-warning-in-case-bf531-is-target.patch
blackfin-arch-fix-stamp537-isp1716-irq-setting-bug.patch
blackfin-arch-fix-bug-interrupt-setup-problem-request_irq.patch
blackfin-arch-pnav-and-bluetechnix-cm-bf537-use-the-mac.patch
blackfin-arch-always-include-linux-kallsysms-header-file.patch
blackfin-arch-sync-with-uclibc-no-functional-changes.patch
blackfin-arch-using-asm-generic-pgtable-header-file-by.patch
blackfin-arch-add-missing-__clear_user-function-to.patch
blackfin-arch-use-boot_command_line-instead-of.patch
blackfin-arch-fix-some-coding-style-in-include.patch
blackfin-arch-add-scm_timestampns-and-siocgstampns-to.patch
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
move-die-notifier-handling-to-common-code-fix.patch
blackfin-blackfin-utrace-patch.patch
utrace-nommu-fixup-support-utrace.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
revoke-core-code-generic_file_revoke-stub-for-nommu.patch
vdso-print-fatal-signals-fix-compiling-error-bug-in.patch
