From: akpm@linux-foundation.org
Subject: [merged]
 ubsan-fix-tree-wide-wmaybe-uninitialized-false-positives.patch removed from -mm tree
Date: Wed, 23 Mar 2016 10:42:39 -0700
Message-ID: <56f2d58f.AQ9CDucM5GNOVyQn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59381 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756387AbcCWRmk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:42:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ubsan: fix tree-wide -Wmaybe-uninitialized false positives
has been removed from the -mm tree.  Its filename was
     ubsan-fix-tree-wide-wmaybe-uninitialized-false-positives.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: ubsan: fix tree-wide -Wmaybe-uninitialized false positives

-fsanitize=* options makes GCC less smart than usual and increase number
of 'maybe-uninitialized' false-positives. So this patch does two things:
 * Add -Wno-maybe-uninitialized to CFLAGS_UBSAN which will disable all
   such warnings for instrumented files.
 * Remove CONFIG_UBSAN_SANITIZE_ALL from all[yes|mod]config builds. So
   the all[yes|mod]config build goes without -fsanitize=* and still with
   -Wmaybe-uninitialized.

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.ubsan      |    5 +++++
 scripts/Makefile.ubsan |    4 ++++
 2 files changed, 9 insertions(+)

diff -puN lib/Kconfig.ubsan~ubsan-fix-tree-wide-wmaybe-uninitialized-false-positives lib/Kconfig.ubsan
--- a/lib/Kconfig.ubsan~ubsan-fix-tree-wide-wmaybe-uninitialized-false-positives
+++ a/lib/Kconfig.ubsan
@@ -13,6 +13,11 @@ config UBSAN_SANITIZE_ALL
 	bool "Enable instrumentation for the entire kernel"
 	depends on UBSAN
 	depends on ARCH_HAS_UBSAN_SANITIZE_ALL
+
+	# We build with -Wno-maybe-uninitilzed, but we still want to
+	# use -Wmaybe-uninitilized in allmodconfig builds.
+	# So dependsy bellow used to disable this option in allmodconfig
+	depends on !COMPILE_TEST
 	default y
 	help
 	  This option activates instrumentation for the entire kernel.
diff -puN scripts/Makefile.ubsan~ubsan-fix-tree-wide-wmaybe-uninitialized-false-positives scripts/Makefile.ubsan
--- a/scripts/Makefile.ubsan~ubsan-fix-tree-wide-wmaybe-uninitialized-false-positives
+++ a/scripts/Makefile.ubsan
@@ -14,4 +14,8 @@ ifdef CONFIG_UBSAN
 ifdef CONFIG_UBSAN_ALIGNMENT
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=alignment)
 endif
+
+      # -fsanitize=* options makes GCC less smart than usual and
+      # increase number of 'maybe-uninitialized false-positives
+      CFLAGS_UBSAN += $(call cc-option, -Wno-maybe-uninitialized)
 endif
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are


