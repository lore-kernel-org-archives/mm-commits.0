From: akpm@linux-foundation.org
Subject: +
 gcov-compile-specific-gcov-implementation-based-on-gcc-version.patch added
 to -mm tree
Date: Wed, 18 Sep 2013 14:24:21 -0700
Message-ID: <523a1a05.h5khU4E+jIfFq7BG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46610 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891Ab3IRVYW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Sep 2013 17:24:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rusty@rustcorp.com.au, peter.oberparleiter@de.ibm.com, keescook@chromium.org, jstancek@redhat.com, arnd@arndb.de, agospoda@redhat.com, fhrbata@redhat.com

Subject: + gcov-compile-specific-gcov-implementation-based-on-gcc-version.patch added to -mm tree
To: fhrbata@redhat.com,agospoda@redhat.com,arnd@arndb.de,jstancek@redhat.com,keescook@chromium.org,peter.oberparleiter@de.ibm.com,rusty@rustcorp.com.au
From: akpm@linux-foundation.org
Date: Wed, 18 Sep 2013 14:24:21 -0700


The patch titled
     Subject: gcov: compile specific gcov implementation based on gcc version
has been added to the -mm tree.  Its filename is
     gcov-compile-specific-gcov-implementation-based-on-gcc-version.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/gcov-compile-specific-gcov-implementation-based-on-gcc-version.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/gcov-compile-specific-gcov-implementation-based-on-gcc-version.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Frantisek Hrbata <fhrbata@redhat.com>
Subject: gcov: compile specific gcov implementation based on gcc version

Compile the correct gcov implementation file for the specific gcc version.

Signed-off-by: Frantisek Hrbata <fhrbata@redhat.com>
Cc: Jan Stancek <jstancek@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Andy Gospodarek <agospoda@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/gcov.txt |    4 ++++
 kernel/gcov/Kconfig    |   30 ++++++++++++++++++++++++++++++
 kernel/gcov/Makefile   |   32 +++++++++++++++++++++++++++++++-
 3 files changed, 65 insertions(+), 1 deletion(-)

diff -puN Documentation/gcov.txt~gcov-compile-specific-gcov-implementation-based-on-gcc-version Documentation/gcov.txt
--- a/Documentation/gcov.txt~gcov-compile-specific-gcov-implementation-based-on-gcc-version
+++ a/Documentation/gcov.txt
@@ -50,6 +50,10 @@ Configure the kernel with:
         CONFIG_DEBUG_FS=y
         CONFIG_GCOV_KERNEL=y
 
+select the gcc's gcov format, default is autodetect based on gcc version:
+
+        CONFIG_GCOV_FORMAT_AUTODETECT=y
+
 and to get coverage data for the entire kernel:
 
         CONFIG_GCOV_PROFILE_ALL=y
diff -puN kernel/gcov/Kconfig~gcov-compile-specific-gcov-implementation-based-on-gcc-version kernel/gcov/Kconfig
--- a/kernel/gcov/Kconfig~gcov-compile-specific-gcov-implementation-based-on-gcc-version
+++ a/kernel/gcov/Kconfig
@@ -46,4 +46,34 @@ config GCOV_PROFILE_ALL
 	larger and run slower. Also be sure to exclude files from profiling
 	which are not linked to the kernel image to prevent linker errors.
 
+choice
+	prompt "Specify GCOV format"
+	depends on GCOV_KERNEL
+	default GCOV_FORMAT_AUTODETECT
+	---help---
+	The gcov format is usually determined by the GCC version, but there are
+	exceptions where format changes are integrated in lower-version GCCs.
+	In such a case use this option to adjust the format used in the kernel
+	accordingly.
+
+	If unsure, choose "Autodetect".
+
+config GCOV_FORMAT_AUTODETECT
+	bool "Autodetect"
+	---help---
+	Select this option to use the format that corresponds to your GCC
+	version.
+
+config GCOV_FORMAT_3_4
+	bool "GCC 3.4 format"
+	---help---
+	Select this option to use the format defined by GCC 3.4.
+
+config GCOV_FORMAT_4_7
+	bool "GCC 4.7 format"
+	---help---
+	Select this option to use the format defined by GCC 4.7.
+
+endchoice
+
 endmenu
diff -puN kernel/gcov/Makefile~gcov-compile-specific-gcov-implementation-based-on-gcc-version kernel/gcov/Makefile
--- a/kernel/gcov/Makefile~gcov-compile-specific-gcov-implementation-based-on-gcc-version
+++ a/kernel/gcov/Makefile
@@ -1,3 +1,33 @@
 ccflags-y := -DSRCTREE='"$(srctree)"' -DOBJTREE='"$(objtree)"'
 
-obj-$(CONFIG_GCOV_KERNEL) := base.o fs.o gcc_3_4.o
+# if-lt
+# Usage VAR := $(call if-lt, $(a), $(b))
+# Returns 1 if (a < b)
+if-lt = $(shell [ $(1) -lt $(2) ] && echo 1)
+
+ifeq ($(CONFIG_GCOV_FORMAT_3_4),y)
+  cc-ver := 0304
+else ifeq ($(CONFIG_GCOV_FORMAT_4_7),y)
+  cc-ver := 0407
+else
+# Use cc-version if available, otherwise set 0
+#
+# scripts/Kbuild.include, which contains cc-version function, is not included
+# during make clean "make -f scripts/Makefile.clean obj=kernel/gcov"
+# Meaning cc-ver is empty causing if-lt test to fail with
+# "/bin/sh: line 0: [: -lt: unary operator expected" error mesage.
+# This has no affect on the clean phase, but the error message could be
+# confusing/annoying. So this dummy workaround sets cc-ver to zero if cc-version
+# is not available. We can probably move if-lt to Kbuild.include, so it's also
+# not defined during clean or to include Kbuild.include in
+# scripts/Makefile.clean. But the following workaround seems least invasive.
+  cc-ver := $(if $(call cc-version),$(call cc-version),0)
+endif
+
+obj-$(CONFIG_GCOV_KERNEL) := base.o fs.o
+
+ifeq ($(call if-lt, $(cc-ver), 0407),1)
+  obj-$(CONFIG_GCOV_KERNEL) += gcc_3_4.o
+else
+  obj-$(CONFIG_GCOV_KERNEL) += gcc_4_7.o
+endif
_

Patches currently in -mm which might be from fhrbata@redhat.com are

gcov-move-gcov-structs-definitions-to-a-gcc-version-specific-file.patch
gcov-add-support-for-gcc-47-gcov-format.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-compile-specific-gcov-implementation-based-on-gcc-version.patch
kernel-add-support-for-init_array-constructors.patch

