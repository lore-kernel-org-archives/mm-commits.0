From: akpm@linux-foundation.org
Subject: + kconfig-use-macros-which-are-already-defined-fix.patch added to -mm tree
Date: Thu, 26 Feb 2015 13:24:16 -0800
Message-ID: <54ef8f00.FnKt8XtgASEyQiYY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59041 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbbBZVYR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Feb 2015 16:24:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, michal.simek@xilinx.com, monstr@monstr.eu, mm-commits@vger.kernel.org


The patch titled
     Subject: kconfig-use-macros-which-are-already-defined-fix
has been added to the -mm tree.  Its filename is
     kconfig-use-macros-which-are-already-defined-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kconfig-use-macros-which-are-already-defined-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kconfig-use-macros-which-are-already-defined-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-sysc-fix-uname26-for-40-fix.patch
mm.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch
mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-find__bit-reimplementation-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
kconfig-use-macros-which-are-already-defined-fix.patch
linux-next.patch
linux-next-rejects.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

