From: akpm@linux-foundation.org
Subject: [folded-merged]
 kconfig-use-macros-which-are-already-defined-fix.patch removed from -mm
 tree
Date: Thu, 16 Apr 2015 12:10:17 -0700
Message-ID: <55300919.H+3/2P4l6o1rHWX0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45507 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbbDPTKR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 15:10:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, michal.simek@xilinx.com, monstr@monstr.eu, mm-commits@vger.kernel.org


The patch titled
     Subject: kconfig-use-macros-which-are-already-defined-fix
has been removed from the -mm tree.  Its filename was
     kconfig-use-macros-which-are-already-defined-fix.patch

This patch was dropped because it was folded into kconfig-use-macros-which-are-already-defined.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kconfig-use-macros-which-are-already-defined-fix

move IS_ENABLED definition to after the IS_BUILTIN and IS_MODULE definitions

Cc: Michal Simek <michal.simek@xilinx.com>
Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kconfig.h |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN include/linux/kconfig.h~kconfig-use-macros-which-are-already-defined-fix include/linux/kconfig.h
--- a/include/linux/kconfig.h~kconfig-use-macros-which-are-already-defined-fix
+++ a/include/linux/kconfig.h
@@ -23,14 +23,6 @@
 #define ___config_enabled(__ignored, val, ...) val
 
 /*
- * IS_ENABLED(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'y' or 'm',
- * 0 otherwise.
- *
- */
-#define IS_ENABLED(option) \
-	(IS_BUILTIN(option) || IS_MODULE(option))
-
-/*
  * IS_BUILTIN(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'y', 0
  * otherwise. For boolean options, this is equivalent to
  * IS_ENABLED(CONFIG_FOO).
@@ -43,4 +35,11 @@
  */
 #define IS_MODULE(option) config_enabled(option##_MODULE)
 
+/*
+ * IS_ENABLED(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'y' or 'm',
+ * 0 otherwise.
+ */
+#define IS_ENABLED(option) \
+	(IS_BUILTIN(option) || IS_MODULE(option))
+
 #endif /* __LINUX_KCONFIG_H */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
lib-find__bit-reimplementation.patch
checkpatch-match-more-world-writable-permissions.patch
binfmt_misc-simplify-entry_status.patch
rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc.patch
fs-fat-remove-unnecessary-includes.patch
kernel-forkc-avoid-division-by-zero.patch
doc-sysctl-kerneltxt-document-threads-max.patch
mm-rcu-protected-get_mm_exe_file.patch
affs-kstrdup-memory-handling.patch
kconfig-use-macros-which-are-already-defined.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch
tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch
documentation-spi-spidev_testc-fix-warning.patch

