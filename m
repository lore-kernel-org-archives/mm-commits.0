From: akpm@linux-foundation.org
Subject: - kbuild-make-source-and-include-paths-absolute.patch removed from -mm tree
Date: Tue, 03 Jun 2008 15:51:16 -0700
Message-ID: <200806032251.m53MpGK7024001@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753429AbYFCWwF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 18:52:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peter.oberparleiter@de.ibm.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kbuild: make source and include paths absolute
has been removed from the -mm tree.  Its filename was
     kbuild-make-source-and-include-paths-absolute.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kbuild: make source and include paths absolute
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

Change all source and include paths to absolute form when
CONFIG_GCOV_PROFILE is enabled.

Example:

  gcc -Idir1 -c a.c -o a.o

will become

  gcc -I/path/to/dir1 -c /path/to/a.c -o a.o

Required by the gcov profiling infrastructure: when compiling with option
-fprofile-arcs, gcc stores file names inside object files.  Relative paths
prevent the gcov tool from finding corresponding source files.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Kbuild.include |    7 +++++++
 scripts/Makefile.build |    3 ++-
 scripts/Makefile.lib   |    8 +++++++-
 3 files changed, 16 insertions(+), 2 deletions(-)

diff -puN scripts/Kbuild.include~kbuild-make-source-and-include-paths-absolute scripts/Kbuild.include
--- a/scripts/Kbuild.include~kbuild-make-source-and-include-paths-absolute
+++ a/scripts/Kbuild.include
@@ -149,6 +149,13 @@ addtree = $(if $(filter-out -I/%,$(1)),$
 # Find all -I options and call addtree
 flags = $(foreach o,$($(1)),$(if $(filter -I%,$(o)),$(call addtree,$(o)),$(o)))
 
+# Prefix $(1) with $(2)/ if $(1) does not start with /
+addpath = $(if $(filter-out /%,$(1)),$(2)/$(1),$(1))
+
+# Find all -I options and call addpath
+flags_addpath = $(foreach o,$($(1)),\
+		$(if $(filter -I%,$(o)),-I$(call addpath,$(o:-I%=%),$(2)),$(o)))
+
 # echo command.
 # Short version is used, if $(quiet) equals `quiet_', otherwise full one.
 echo-cmd = $(if $($(quiet)cmd_$(1)),\
diff -puN scripts/Makefile.build~kbuild-make-source-and-include-paths-absolute scripts/Makefile.build
--- a/scripts/Makefile.build~kbuild-make-source-and-include-paths-absolute
+++ a/scripts/Makefile.build
@@ -165,7 +165,8 @@ $(obj)/%.symtypes : $(src)/%.c FORCE
 # (See cmd_cc_o_c + relevant part of rule_cc_o_c)
 
 quiet_cmd_cc_o_c = CC $(quiet_modtag)  $@
-cmd_cc_o_c = $(CC) $(c_flags) -c -o $@ $<
+cmd_cc_o_c = $(CC) $(c_flags) -c -o $@ \
+		$(if $(CONFIG_GCOV_PROFILE),$(call addpath,$<,$(objtree)),$<)
 
 ifdef CONFIG_MODVERSIONS
 # When module versioning is enabled the following steps are executed
diff -puN scripts/Makefile.lib~kbuild-make-source-and-include-paths-absolute scripts/Makefile.lib
--- a/scripts/Makefile.lib~kbuild-make-source-and-include-paths-absolute
+++ a/scripts/Makefile.lib
@@ -126,10 +126,16 @@ __a_flags	=                          $(c
 __cpp_flags     =                          $(call flags,_cpp_flags)
 endif
 
-c_flags        = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(KBUILD_CPPFLAGS) \
+___c_flags        = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(KBUILD_CPPFLAGS) \
 		 $(__c_flags) $(modkern_cflags) \
 		 -D"KBUILD_STR(s)=\#s" $(basename_flags) $(modname_flags)
 
+ifeq ($(CONFIG_GCOV_PROFILE),)
+c_flags = $(___c_flags)
+else
+c_flags = $(call flags_addpath,___c_flags,$(objtree))
+endif
+
 a_flags        = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(KBUILD_CPPFLAGS) \
 		 $(__a_flags) $(modkern_aflags)
 
_

Patches currently in -mm which might be from peter.oberparleiter@de.ibm.com are

origin.patch
linux-next.patch
kbuild-make-source-and-include-paths-absolute.patch
gcov-architecture-specific-compile-flag-adjustments.patch
gcov-architecture-specific-compile-flag-adjustments-fix.patch

