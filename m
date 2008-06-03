From: akpm@linux-foundation.org
Subject: - kernel-introduce-gcc_version_lower-macro.patch removed from -mm tree
Date: Tue, 03 Jun 2008 15:51:05 -0700
Message-ID: <200806032251.m53Mp5kk023980@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33163 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753341AbYFCWv7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 18:51:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peter.oberparleiter@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     kernel: introduce GCC_VERSION_LOWER macro
has been removed from the -mm tree.  Its filename was
     kernel-introduce-gcc_version_lower-macro.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel: introduce GCC_VERSION_LOWER macro
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

GCC_VERSION_LOWER() can be used to check for gcc versions below a certain
level.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/linux/compiler-gcc.h~kernel-introduce-gcc_version_lower-macro include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~kernel-introduce-gcc_version_lower-macro
+++ a/include/linux/compiler-gcc.h
@@ -6,6 +6,9 @@
  * Common definitions for all gcc versions go here.
  */
 
+#define GCC_VERSION_LOWER(major, minor) ((__GNUC__ < major) || \
+					 (__GNUC__ == major) && \
+					 (__GNUC_MINOR__ < minor))
 
 /* Optimization barrier */
 /* The "volatile" is due to gcc bugs */
_

Patches currently in -mm which might be from peter.oberparleiter@de.ibm.com are

origin.patch
linux-next.patch
kernel-introduce-gcc_version_lower-macro.patch
kbuild-delay-object-file-renaming-during-module-versioning.patch
seq_file-add-function-to-write-binary-data.patch
gcov-add-gcov-profiling-infrastructure.patch
kbuild-make-source-and-include-paths-absolute.patch
gcov-architecture-specific-compile-flag-adjustments.patch
gcov-architecture-specific-compile-flag-adjustments-fix.patch

