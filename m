From: akpm@linux-foundation.org
Subject: - kbuild-soften-modpost-checks-when-doing-cross-builds.patch removed from -mm tree
Date: Tue, 25 Mar 2008 15:29:52 -0700
Message-ID: <200803252229.m2PMTqUQ016842@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753524AbYCYWja (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Mar 2008 18:39:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@uranus.ravnborg.org, gordonfarquharson@gmail.com, mb@bu3sch.de, sam@ravnborg.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     kbuild: soften modpost checks when doing cross builds
has been removed from the -mm tree.  Its filename was
     kbuild-soften-modpost-checks-when-doing-cross-builds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kbuild: soften modpost checks when doing cross builds
From: Sam Ravnborg <sam@uranus.ravnborg.org>

The module alias support in the kernel have a consistency check where it is
checked that the size of a structure in the kernel and on the build host are
the same.  For cross builds this check does not make sense so detect when we
do cross builds and silently skip the check in these situations.  This fixes a
build bug for a wireless driver when cross building for arm.

Acked-by: Michael Buesch <mb@bu3sch.de>
Tested-by: Gordon Farquharson <gordonfarquharson@gmail.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile                 |    2 +-
 scripts/Makefile.modpost |    6 +++++-
 scripts/mod/file2alias.c |    4 ++++
 scripts/mod/modpost.c    |    5 ++++-
 scripts/mod/modpost.h    |    1 +
 5 files changed, 15 insertions(+), 3 deletions(-)

diff -puN Makefile~kbuild-soften-modpost-checks-when-doing-cross-builds Makefile
--- a/Makefile~kbuild-soften-modpost-checks-when-doing-cross-builds
+++ a/Makefile
@@ -189,7 +189,7 @@ SUBARCH := $(shell uname -m | sed -e s/i
 # Alternatively CROSS_COMPILE can be set in the environment.
 # Default value for CROSS_COMPILE is not to prefix executables
 # Note: Some architectures assign CROSS_COMPILE in their arch/*/Makefile
-
+export KBUILD_BUILDHOST := $(SUBARCH)
 ARCH		?= $(SUBARCH)
 CROSS_COMPILE	?=
 
diff -puN scripts/Makefile.modpost~kbuild-soften-modpost-checks-when-doing-cross-builds scripts/Makefile.modpost
--- a/scripts/Makefile.modpost~kbuild-soften-modpost-checks-when-doing-cross-builds
+++ a/scripts/Makefile.modpost
@@ -58,6 +58,9 @@ modules   := $(patsubst %.o,%.ko, $(wild
 # Stop after building .o files if NOFINAL is set. Makes compile tests quicker
 _modpost: $(if $(KBUILD_MODPOST_NOFINAL), $(modules:.ko:.o),$(modules))
 
+ifneq ($(KBUILD_BUILDHOST),$(ARCH))
+        cross_build := 1
+endif
 
 # Step 2), invoke modpost
 #  Includes step 3,4
@@ -70,7 +73,8 @@ modpost = scripts/mod/modpost           
  $(if $(CONFIG_DEBUG_SECTION_MISMATCH),,-S)      \
  $(if $(CONFIG_MARKERS),-K $(kernelmarkersfile)) \
  $(if $(CONFIG_MARKERS),-M $(markersfile))	 \
- $(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w)
+ $(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w) \
+ $(if $(cross_build),-c)
 
 quiet_cmd_modpost = MODPOST $(words $(filter-out vmlinux FORCE, $^)) modules
       cmd_modpost = $(modpost) -s
diff -puN scripts/mod/file2alias.c~kbuild-soften-modpost-checks-when-doing-cross-builds scripts/mod/file2alias.c
--- a/scripts/mod/file2alias.c~kbuild-soften-modpost-checks-when-doing-cross-builds
+++ a/scripts/mod/file2alias.c
@@ -51,11 +51,13 @@ do {                                    
                 sprintf(str + strlen(str), "*");                \
 } while(0)
 
+unsigned int cross_build = 0;
 /**
  * Check that sizeof(device_id type) are consistent with size of section
  * in .o file. If in-consistent then userspace and kernel does not agree
  * on actual size which is a bug.
  * Also verify that the final entry in the table is all zeros.
+ * Ignore both checks if build host differ from target host and size differs.
  **/
 static void device_id_check(const char *modname, const char *device_id,
 			    unsigned long size, unsigned long id_size,
@@ -64,6 +66,8 @@ static void device_id_check(const char *
 	int i;
 
 	if (size % id_size || size < id_size) {
+		if (cross_build != 0)
+			return;
 		fatal("%s: sizeof(struct %s_device_id)=%lu is not a modulo "
 		      "of the size of section __mod_%s_device_table=%lu.\n"
 		      "Fix definition of struct %s_device_id "
diff -puN scripts/mod/modpost.c~kbuild-soften-modpost-checks-when-doing-cross-builds scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~kbuild-soften-modpost-checks-when-doing-cross-builds
+++ a/scripts/mod/modpost.c
@@ -2026,7 +2026,7 @@ int main(int argc, char **argv)
 	int opt;
 	int err;
 
-	while ((opt = getopt(argc, argv, "i:I:msSo:awM:K:")) != -1) {
+	while ((opt = getopt(argc, argv, "i:I:cmsSo:awM:K:")) != -1) {
 		switch (opt) {
 		case 'i':
 			kernel_read = optarg;
@@ -2035,6 +2035,9 @@ int main(int argc, char **argv)
 			module_read = optarg;
 			external_module = 1;
 			break;
+		case 'c':
+			cross_build = 1;
+			break;
 		case 'm':
 			modversions = 1;
 			break;
diff -puN scripts/mod/modpost.h~kbuild-soften-modpost-checks-when-doing-cross-builds scripts/mod/modpost.h
--- a/scripts/mod/modpost.h~kbuild-soften-modpost-checks-when-doing-cross-builds
+++ a/scripts/mod/modpost.h
@@ -135,6 +135,7 @@ struct elf_info {
 };
 
 /* file2alias.c */
+extern unsigned int cross_build;
 void handle_moddevtable(struct module *mod, struct elf_info *info,
 			Elf_Sym *sym, const char *symname);
 void add_moddevtable(struct buffer *buf, struct module *mod);
_

Patches currently in -mm which might be from sam@uranus.ravnborg.org are

origin.patch

