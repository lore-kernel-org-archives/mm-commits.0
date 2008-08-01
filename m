From: akpm@linux-foundation.org
Subject: - gcov-create-links-to-gcda-files-in-build-directory.patch removed from -mm tree
Date: Fri, 01 Aug 2008 10:08:19 -0700
Message-ID: <200808011708.m71H8Jm8025244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530AbYHARKO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Aug 2008 13:10:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peter.oberparleiter@de.ibm.com, rusty@rustcorp.com.au, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     gcov: create links to .gcda files in build directory
has been removed from the -mm tree.  Its filename was
     gcov-create-links-to-gcda-files-in-build-directory.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gcov: create links to .gcda files in build directory
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

Modify kbuild to create symbolic links in the build directory which refer
to the .gcda files in sysfs.

Required by the gcov profiling infrastructure: the gcov tool requires all
data files (x.gcda, x.gcno) to be found in the same directory.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile               |    8 +++++---
 scripts/Makefile.build |    9 ++++++++-
 2 files changed, 13 insertions(+), 4 deletions(-)

diff -puN Makefile~gcov-create-links-to-gcda-files-in-build-directory Makefile
--- a/Makefile~gcov-create-links-to-gcda-files-in-build-directory
+++ a/Makefile
@@ -322,7 +322,7 @@ LDFLAGS_MODULE  =
 CFLAGS_KERNEL	=
 AFLAGS_KERNEL	=
 CFLAGS_GCOV	= -fprofile-arcs -ftest-coverage
-
+GCOV_DATA_DIR	= /sys/kernel/debug/gcov
 
 # Use LINUXINCLUDE when you must reference the include/ directory.
 # Needed to be compatible with the O= option
@@ -345,7 +345,7 @@ KERNELVERSION = $(VERSION).$(PATCHLEVEL)
 export VERSION PATCHLEVEL SUBLEVEL KERNELRELEASE KERNELVERSION
 export ARCH SRCARCH CONFIG_SHELL HOSTCC HOSTCFLAGS CROSS_COMPILE AS LD CC
 export CPP AR NM STRIP OBJCOPY OBJDUMP MAKE AWK GENKSYMS PERL UTS_MACHINE
-export HOSTCXX HOSTCXXFLAGS LDFLAGS_MODULE CHECK CHECKFLAGS
+export HOSTCXX HOSTCXXFLAGS LDFLAGS_MODULE CHECK CHECKFLAGS GCOV_DATA_DIR
 
 export KBUILD_CPPFLAGS NOSTDINC_FLAGS LINUXINCLUDE OBJCOPYFLAGS LDFLAGS
 export KBUILD_CFLAGS CFLAGS_KERNEL CFLAGS_MODULE CFLAGS_GCOV
@@ -1179,6 +1179,7 @@ clean: archclean $(clean-dirs)
 		-o -name '*.symtypes' -o -name 'modules.order'	\
 		-o -name 'Module.markers' \
 		-o -name '*.gcno' \
+		-o -name '*.gcda' \
 		-o -name '.tmp_*.o.*' \) \
 		-type f -print | xargs rm -f
 
@@ -1382,7 +1383,8 @@ clean: $(clean-dirs)
 	@find $(KBUILD_EXTMOD) $(RCS_FIND_IGNORE) \
 		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
 		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
-		-o -name '*.gcno' \) -type f -print | xargs rm -f
+		-o -name '*.gcno' -o -name '*.gcda' \) \
+		\( -type f -o -type l \) -print | xargs rm -f
 
 help:
 	@echo  '  Building external modules.'
diff -puN scripts/Makefile.build~gcov-create-links-to-gcda-files-in-build-directory scripts/Makefile.build
--- a/scripts/Makefile.build~gcov-create-links-to-gcda-files-in-build-directory
+++ a/scripts/Makefile.build
@@ -198,6 +198,12 @@ cmd_modversions =							\
 	fi;
 endif
 
+ifdef CONFIG_GCOV_PROFILE
+# Create a link to the gcov data file in /sys
+cmd_gcov = ln -s -f $(GCOV_DATA_DIR)$(if \
+	$(filter-out /%,$(@D)),$(objtree)/$(@D),$(@D))/$(@F:.o=.gcda) $(@D)
+endif
+
 define rule_cc_o_c
 	$(call echo-cmd,checksrc) $(cmd_checksrc)			  \
 	$(call echo-cmd,cc_o_c) $(cmd_cc_o_c);				  \
@@ -205,7 +211,8 @@ define rule_cc_o_c
 	scripts/basic/fixdep $(depfile) $@ '$(call make-cmd,cc_o_c)' >    \
 	                                              $(dot-target).tmp;  \
 	rm -f $(depfile);						  \
-	mv -f $(dot-target).tmp $(dot-target).cmd
+	mv -f $(dot-target).tmp $(dot-target).cmd;			  \
+	$(cmd_gcov)
 endef
 
 # Built-in and composite module parts
_

Patches currently in -mm which might be from peter.oberparleiter@de.ibm.com are

kernel-call-constructors.patch
kernel-call-constructors-uml-fix-1.patch
kernel-call-constructors-uml-fix-2.patch
kernel-introduce-gcc_version_lower-macro.patch
seq_file-add-function-to-write-binary-data.patch
gcov-add-gcov-profiling-infrastructure.patch
gcov-add-gcov-profiling-infrastructure-revert-link-changes.patch
gcov-create-links-to-gcda-files-in-build-directory.patch
gcov-architecture-specific-compile-flag-adjustments.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-fix.patch
gcov-architecture-specific-compile-flag-adjustments-x86_64-fix.patch

