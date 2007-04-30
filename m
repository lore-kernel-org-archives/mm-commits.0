From: akpm@linux-foundation.org
Subject: - blackfin-arch-add-scm_timestampns-and-siocgstampns-to.patch removed from -mm tree
Date: Mon, 30 Apr 2007 12:10:46 -0700
Message-ID: <200704301910.l3UJAk5V012454@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946676AbXD3TKt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:10:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bryan.wu@analog.com, mm-commits@vger.kernel.org


The patch titled
     blackfin arch: add SCM_TIMESTAMPNS and SIOCGSTAMPNS to socket header file with code style cleaning up
has been removed from the -mm tree.  Its filename was
     blackfin-arch-add-scm_timestampns-and-siocgstampns-to.patch

This patch was dropped because it was folded into blackfin-arch.patch

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

origin.patch
blackfin-Documentation.patch
blackfin-arch.patch
blackfin-arch-add-scm_timestampns-and-siocgstampns-to.patch
blackfin-arch-add-missing-blackfin-support-in-lib.patch
blackfin-arch-fix-bug-data-cannot-be-put-into-l1-data.patch
blackfin-arch-source-kernel-preemption-option.patch
blackfin-arch-workaround-bf561-anomaly-05000266.patch
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
