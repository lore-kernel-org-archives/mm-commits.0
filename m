From: akpm@linux-foundation.org
Subject: + force-erroneous-inclusions-of-compiler-h-files-to-be-errors.patch added to -mm tree
Date: Wed, 18 Jul 2007 16:10:03 -0700
Message-ID: <200707182310.l6INA3Zo001464@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41392 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757625AbXGRXKL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 19:10:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com


The patch titled
     Force erroneous inclusions of compiler-*.h files to be errors
has been added to the -mm tree.  Its filename is
     force-erroneous-inclusions-of-compiler-h-files-to-be-errors.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Force erroneous inclusions of compiler-*.h files to be errors
From: "Robert P. J. Day" <rpjday@mindspring.com>

Replace worthless comments with actual preprocessor errors when including
the wrong versions of the compiler.h files.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h   |    4 +++-
 include/linux/compiler-gcc3.h  |    4 +++-
 include/linux/compiler-gcc4.h  |    4 +++-
 include/linux/compiler-intel.h |    4 +++-
 4 files changed, 12 insertions(+), 4 deletions(-)

diff -puN include/linux/compiler-gcc.h~force-erroneous-inclusions-of-compiler-h-files-to-be-errors include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~force-erroneous-inclusions-of-compiler-h-files-to-be-errors
+++ a/include/linux/compiler-gcc.h
@@ -1,4 +1,6 @@
-/* Never include this file directly.  Include <linux/compiler.h> instead.  */
+#ifndef _LINUX_COMPILER_H
+#error "Please don't include <linux/compiler-gcc.h> directly, include <linux/compiler.h> instead."
+#endif
 
 /*
  * Common definitions for all gcc versions go here.
diff -puN include/linux/compiler-gcc3.h~force-erroneous-inclusions-of-compiler-h-files-to-be-errors include/linux/compiler-gcc3.h
--- a/include/linux/compiler-gcc3.h~force-erroneous-inclusions-of-compiler-h-files-to-be-errors
+++ a/include/linux/compiler-gcc3.h
@@ -1,4 +1,6 @@
-/* Never include this file directly.  Include <linux/compiler.h> instead.  */
+#ifndef _LINUX_COMPILER_H
+#error "Please don't include <linux/compiler-gcc3.h> directly, include <linux/compiler.h> instead."
+#endif
 
 /* These definitions are for GCC v3.x.  */
 #include <linux/compiler-gcc.h>
diff -puN include/linux/compiler-gcc4.h~force-erroneous-inclusions-of-compiler-h-files-to-be-errors include/linux/compiler-gcc4.h
--- a/include/linux/compiler-gcc4.h~force-erroneous-inclusions-of-compiler-h-files-to-be-errors
+++ a/include/linux/compiler-gcc4.h
@@ -1,4 +1,6 @@
-/* Never include this file directly.  Include <linux/compiler.h> instead.  */
+#ifndef _LINUX_COMPILER_H
+#error "Please don't include <linux/compiler-gcc4.h> directly, include <linux/compiler.h> instead."
+#endif
 
 /* These definitions are for GCC v4.x.  */
 #include <linux/compiler-gcc.h>
diff -puN include/linux/compiler-intel.h~force-erroneous-inclusions-of-compiler-h-files-to-be-errors include/linux/compiler-intel.h
--- a/include/linux/compiler-intel.h~force-erroneous-inclusions-of-compiler-h-files-to-be-errors
+++ a/include/linux/compiler-intel.h
@@ -1,4 +1,6 @@
-/* Never include this file directly.  Include <linux/compiler.h> instead.  */
+#ifndef _LINUX_COMPILER_H
+#error "Please don't include <linux/compiler-intel.h> directly, include <linux/compiler.h> instead."
+#endif
 
 #ifdef __ECC
 
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-alsa.patch
git-dvb.patch
git-kbuild.patch
git-kvm.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
remove-dead-references-to-module_parm-macro.patch
i386-uaccessh-replace-hard-coded-constant-with-appropriate-macro-from-kernelh.patch
i386-ioapic-remove-old-irq-balancing-debug-cruft.patch
i386-deactivate-the-test-for-the-dead-config_debug_page_type.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors.patch
