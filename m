From: akpm@linux-foundation.org
Subject: [merged]
 kasan-show-gcc-version-requirements-in-kconfig-and-documentation.patch
 removed from -mm tree
Date: Wed, 06 May 2015 11:58:16 -0700
Message-ID: <554a6448.FmWcMc/wg+xgyGqU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51852 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbbEFS6Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 May 2015 14:58:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, a.ryabinin@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: show gcc version requirements in Kconfig and Documentation
has been removed from the -mm tree.  Its filename was
     kasan-show-gcc-version-requirements-in-kconfig-and-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: kasan: show gcc version requirements in Kconfig and Documentation

The documentation shows a need for gcc > 4.9.2, but it's really >=.  The
Kconfig entries don't show require versions so add them.  Correct a
latter/later typo too.  Also mention that gcc 5 required to catch out of
bounds accesses to global and stack variables.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kasan.txt |    8 +++++---
 lib/Kconfig.kasan       |    8 ++++++--
 2 files changed, 11 insertions(+), 5 deletions(-)

diff -puN Documentation/kasan.txt~kasan-show-gcc-version-requirements-in-kconfig-and-documentation Documentation/kasan.txt
--- a/Documentation/kasan.txt~kasan-show-gcc-version-requirements-in-kconfig-and-documentation
+++ a/Documentation/kasan.txt
@@ -9,7 +9,9 @@ a fast and comprehensive solution for fi
 bugs.
 
 KASan uses compile-time instrumentation for checking every memory access,
-therefore you will need a certain version of GCC > 4.9.2
+therefore you will need a gcc version of 4.9.2 or later. KASan could detect out
+of bounds accesses to stack or global variables, but only if gcc 5.0 or later was
+used to built the kernel.
 
 Currently KASan is supported only for x86_64 architecture and requires that the
 kernel be built with the SLUB allocator.
@@ -23,8 +25,8 @@ To enable KASAN configure kernel with:
 
 and choose between CONFIG_KASAN_OUTLINE and CONFIG_KASAN_INLINE. Outline/inline
 is compiler instrumentation types. The former produces smaller binary the
-latter is 1.1 - 2 times faster. Inline instrumentation requires GCC 5.0 or
-latter.
+latter is 1.1 - 2 times faster. Inline instrumentation requires a gcc version
+of 5.0 or later.
 
 Currently KASAN works only with the SLUB memory allocator.
 For better bug detection and nicer report, enable CONFIG_STACKTRACE and put
diff -puN lib/Kconfig.kasan~kasan-show-gcc-version-requirements-in-kconfig-and-documentation lib/Kconfig.kasan
--- a/lib/Kconfig.kasan~kasan-show-gcc-version-requirements-in-kconfig-and-documentation
+++ a/lib/Kconfig.kasan
@@ -10,8 +10,11 @@ config KASAN
 	help
 	  Enables kernel address sanitizer - runtime memory debugger,
 	  designed to find out-of-bounds accesses and use-after-free bugs.
-	  This is strictly debugging feature. It consumes about 1/8
-	  of available memory and brings about ~x3 performance slowdown.
+	  This is strictly a debugging feature and it requires a gcc version
+	  of 4.9.2 or later. Detection of out of bounds accesses to stack or
+	  global variables requires gcc 5.0 or later.
+	  This feature consumes about 1/8 of available memory and brings about
+	  ~x3 performance slowdown.
 	  For better error detection enable CONFIG_STACKTRACE,
 	  and add slub_debug=U to boot cmdline.
 
@@ -40,6 +43,7 @@ config KASAN_INLINE
 	  memory accesses. This is faster than outline (in some workloads
 	  it gives about x2 boost over outline instrumentation), but
 	  make kernel's .text size much bigger.
+	  This requires a gcc version of 5.0 or later.
 
 endchoice
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-reduce-object-size-of-mlog-uses.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
compiler-gcch-neatening.patch
compiler-gcc-integrate-the-various-compiler-gcch-files.patch
get_maintainerpl-add-get_maintainerignore-file-capability.patch
maintainers-update-sound-soc-intel-patterns.patch
maintainers-remove-section-broadcom-bcm33xx-mips-architecture.patch
maintainers-update-brcm-dts-pattern.patch
maintainers-update-brcm-gpio-filename-pattern.patch
maintainers-remove-unused-nbdh-pattern.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch

