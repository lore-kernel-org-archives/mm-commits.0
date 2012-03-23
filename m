From: akpm@linux-foundation.org
Subject: [folded] coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix.patch removed from -mm tree
Date: Fri, 23 Mar 2012 14:31:18 -0700
Message-ID: <20120323213119.0D7B2A02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:35223 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab2CWVbW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 17:31:22 -0400
Received: by eaaq10 with SMTP id q10so188447eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 14:31:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, avi@redhat.com, cmetcalf@tilera.com, deller@gmx.de, ink@jurassic.park.msu.ru, jbaron@redhat.com, jejb@parisc-linux.org, mattst88@gmail.com, ralf@linux-mips.org, roland@hack.frob.com, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix
has been removed from the -mm tree.  Its filename was
     coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix.patch

This patch was dropped because it was folded into coredump-add-vm_nodump-madv_nodump-madv_clear_nodump.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix

fix up the architectures which broke

Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Roland McGrath <roland@hack.frob.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/mman.h  |    4 ++++
 arch/mips/include/asm/mman.h   |    4 ++++
 arch/parisc/include/asm/mman.h |    4 ++++
 arch/xtensa/include/asm/mman.h |    4 ++++
 4 files changed, 16 insertions(+)

diff -puN arch/alpha/include/asm/mman.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix arch/alpha/include/asm/mman.h
--- a/arch/alpha/include/asm/mman.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix
+++ a/arch/alpha/include/asm/mman.h
@@ -56,6 +56,10 @@
 #define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
 #define MADV_NOHUGEPAGE	15		/* Not worth backing with hugepages */
 
+#define MADV_DONTDUMP   16		/* Explicity exclude from the core dump,
+					   overrides the coredump filter bits */
+#define MADV_DODUMP	17		/* Clear the MADV_NODUMP flag */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
diff -puN arch/mips/include/asm/mman.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix arch/mips/include/asm/mman.h
--- a/arch/mips/include/asm/mman.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix
+++ a/arch/mips/include/asm/mman.h
@@ -80,6 +80,10 @@
 #define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
 #define MADV_NOHUGEPAGE	15		/* Not worth backing with hugepages */
 
+#define MADV_DONTDUMP   16		/* Explicity exclude from the core dump,
+					   overrides the coredump filter bits */
+#define MADV_DODUMP	17		/* Clear the MADV_NODUMP flag */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
diff -puN arch/parisc/include/asm/mman.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix arch/parisc/include/asm/mman.h
--- a/arch/parisc/include/asm/mman.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix
+++ a/arch/parisc/include/asm/mman.h
@@ -62,6 +62,10 @@
 #define MADV_HUGEPAGE	67		/* Worth backing with hugepages */
 #define MADV_NOHUGEPAGE	68		/* Not worth backing with hugepages */
 
+#define MADV_DONTDUMP   69		/* Explicity exclude from the core dump,
+					   overrides the coredump filter bits */
+#define MADV_DODUMP	70		/* Clear the MADV_NODUMP flag */
+
 /* compatibility flags */
 #define MAP_FILE	0
 #define MAP_VARIABLE	0
diff -puN arch/xtensa/include/asm/mman.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix arch/xtensa/include/asm/mman.h
--- a/arch/xtensa/include/asm/mman.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix
+++ a/arch/xtensa/include/asm/mman.h
@@ -86,6 +86,10 @@
 #define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
 #define MADV_NOHUGEPAGE	15		/* Not worth backing with hugepages */
 
+#define MADV_DONTDUMP   16		/* Explicity exclude from the core dump,
+					   overrides the coredump filter bits */
+#define MADV_DODUMP	17		/* Clear the MADV_NODUMP flag */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any.patch
kernel-watchdogc-convert-to-pr_foo.patch
kernel-watchdogc-add-comment-to-watchdog-exit-path.patch
backlight-use-id-driver_data-to-differentiate-lp855x-chips.patch
backlight-add-driver-for-bachmanns-ot200.patch
leds-lp5521-support-led-pattern-data.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip.patch
leds-lm3530-replace-i2c_client-with-led_classdev.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation.patch
rtc-rtc-driver-for-da9052-53-pmic-v1.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch

