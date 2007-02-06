From: akpm@linux-foundation.org
Subject: + kbuild-improve-option-checking-kbuildinclude-cleanup.patch added to -mm tree
Date: Tue, 06 Feb 2007 14:59:46 -0800
Message-ID: <200702062259.l16MxksE031873@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54568 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324AbXBFXAj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 18:00:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olecom@flower.upol.cz, ak@suse.de, dsd@gentoo.org, horst@schirmeier.com, jbeulich@novell.com, randy.dunlap@oracle.com, sam@ravnborg.org, zippel@linux-m68k.org


The patch titled
     kbuild: improve option checking, Kbuild.include cleanup
has been added to the -mm tree.  Its filename is
     kbuild-improve-option-checking-kbuildinclude-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kbuild: improve option checking, Kbuild.include cleanup
From: Oleg Verych <olecom@flower.upol.cz>

GNU binutils, root users, tmpfiles, external modules ro builds must be fixed
to do the right thing now.

-- all checks by shell united in one macro -- checker-shell;
-- one disposable output sym. link to /dev/null per shell,
   thus no racing, `-Z' is removed;
-- modules' build output directory is used, if supplied;
-- every option checking function calls shell wrapper, acquires probe;
-- `echo -e' bashizm substituted (people with sh != bash have distinct
   CC options!);
-- some spelling and sense added to the comments;
-- small shuffle of whitespace.

Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Horst Schirmeier <horst@schirmeier.com>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: Daniel Drake <dsd@gentoo.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Oleg Verych <olecom@flower.upol.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Kbuild.include |   96 +++++++++++++++++++++------------------
 1 files changed, 53 insertions(+), 43 deletions(-)

diff -puN scripts/Kbuild.include~kbuild-improve-option-checking-kbuildinclude-cleanup scripts/Kbuild.include
--- a/scripts/Kbuild.include~kbuild-improve-option-checking-kbuildinclude-cleanup
+++ a/scripts/Kbuild.include
@@ -1,7 +1,7 @@
 ####
 # kbuild: Generic definitions
 
-# Convinient variables
+# Convenient constants
 comma   := ,
 squote  := '
 empty   :=
@@ -56,40 +56,46 @@ endef
 # gcc support functions
 # See documentation in Documentation/kbuild/makefiles.txt
 
-# output directory for tests below
-TMPOUT := $(if $(KBUILD_EXTMOD),$(firstword $(KBUILD_EXTMOD))/)
+# checker-shell
+# Usage: option = $(call checker-shell, $(CC)...-o $$OUT, option-ok, otherwise)
+# Exit code chooses option. $$OUT is safe location for needless output.
+define checker-shell
+  $(shell set -e; \
+    DIR=$(KBUILD_EXTMOD); \
+    cd $${DIR:-$(objtree)}; \
+    OUT=$$PWD/.$$$$.null; \
+    \
+    ln -s /dev/null $$OUT; \
+    if $(1) >/dev/null 2>&1; \
+      then echo "$(2)"; \
+      else echo "$(3)"; \
+    fi; \
+    rm -f $$OUT)
+endef
 
 # as-option
 # Usage: cflags-y += $(call as-option, -Wa$(comma)-isa=foo,)
-
-as-option = $(shell if $(CC) $(CFLAGS) $(1) -Wa,-Z -c -o /dev/null \
-	     -xassembler /dev/null > /dev/null 2>&1; then echo "$(1)"; \
-	     else echo "$(2)"; fi ;)
+as-option = $(call checker-shell, \
+   $(CC) $(CFLAGS) $(1) -c -xassembler /dev/null -o $$OUT, $(1), $(2))
 
 # as-instr
 # Usage: cflags-y += $(call as-instr, instr, option1, option2)
-
-as-instr = $(shell if echo -e "$(1)" | \
-		      $(CC) $(AFLAGS) -c -xassembler - \
-			    -o $(TMPOUT)astest$$$$.out > /dev/null 2>&1; \
-		   then rm $(TMPOUT)astest$$$$.out; echo "$(2)"; \
-		   else echo "$(3)"; fi)
+as-instr = $(call checker-shell, \
+   printf "$(1)" | $(CC) $(AFLAGS) -c -xassembler -o $$OUT -, $(2), $(3))
 
 # cc-option
 # Usage: cflags-y += $(call cc-option, -march=winchip-c6, -march=i586)
-
-cc-option = $(shell if $(CC) $(CFLAGS) $(1) -S -o /dev/null -xc /dev/null \
-             > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
+cc-option = $(call checker-shell, \
+   $(CC) $(CFLAGS) $(if $(3),$(3),$(1)) -S -xc /dev/null -o $$OUT, $(1), $(2))
 
 # cc-option-yn
 # Usage: flag := $(call cc-option-yn, -march=winchip-c6)
-cc-option-yn = $(shell if $(CC) $(CFLAGS) $(1) -S -o /dev/null -xc /dev/null \
-                > /dev/null 2>&1; then echo "y"; else echo "n"; fi;)
+cc-option-yn = $(call cc-option, "y", "n", $(1))
 
 # cc-option-align
 # Prefix align with either -falign or -malign
 cc-option-align = $(subst -functions=0,,\
-	$(call cc-option,-falign-functions=0,-malign-functions=0))
+   $(call cc-option,-falign-functions=0,-malign-functions=0))
 
 # cc-version
 # Usage gcc-ver := $(call cc-version, $(CC))
@@ -97,35 +103,42 @@ cc-version = $(shell $(CONFIG_SHELL) $(s
 
 # cc-ifversion
 # Usage:  EXTRA_CFLAGS += $(call cc-ifversion, -lt, 0402, -O1)
-cc-ifversion = $(shell if [ $(call cc-version, $(CC)) $(1) $(2) ]; then \
-                       echo $(3); fi;)
+cc-ifversion = $(shell [ $(call cc-version, $(CC)) $(1) $(2) ] && echo $(3))
 
 # ld-option
 # Usage: ldflags += $(call ld-option, -Wl$(comma)--hash-style=both)
-ld-option = $(shell if $(CC) $(1) -nostdlib -xc /dev/null \
-			     -o $(TMPOUT)ldtest$$$$.out > /dev/null 2>&1; \
-             then rm $(TMPOUT)ldtest$$$$.out; echo "$(1)"; \
-             else echo "$(2)"; fi)
+ld-option = $(call checker-shell, \
+   $(CC) $(1) -nostdlib -xc /dev/null -o $$OUT, $(1), $(2))
+
+######
 
-###
 # Shorthand for $(Q)$(MAKE) -f scripts/Makefile.build obj=
 # Usage:
 # $(Q)$(MAKE) $(build)=dir
 build := -f $(if $(KBUILD_SRC),$(srctree)/)scripts/Makefile.build obj
 
-# Prefix -I with $(srctree) if it is not an absolute path
-addtree = $(if $(filter-out -I/%,$(1)),$(patsubst -I%,-I$(srctree)/%,$(1))) $(1)
+# Prefix -I with $(srctree) if it is not an absolute path,
+# add original to the end
+addtree = $(if \
+	$(filter-out -I/%, $(1)), $(patsubst -I%,-I$(srctree)/%,$(1))) $(1)
+
 # Find all -I options and call addtree
-flags = $(foreach o,$($(1)),$(if $(filter -I%,$(o)),$(call addtree,$(o)),$(o)))
+flags = $(foreach o,$($(1)), \
+	$(if $(filter -I%,$(o)), $(call addtree, $(o)), $(o)))
 
-# If quiet is set, only print short version of command
+# echo command.
+# Short version is used, if $(quiet) equals `quiet_', otherwise full one.
+echo-cmd = $(if $($(quiet)cmd_$(1)), \
+	echo '  $(call escsq,$($(quiet)cmd_$(1)))$(echo-why)';)
+
+# printing commands
 cmd = @$(echo-cmd) $(cmd_$(1))
 
-# Add $(obj)/ for paths that is not absolute
-objectify = $(foreach o,$(1),$(if $(filter /%,$(o)),$(o),$(obj)/$(o)))
+# Add $(obj)/ for paths that are not absolute
+objectify = $(foreach o,$(1), $(if $(filter /%,$(o)), $(o), $(obj)/$(o)))
 
 ###
-# if_changed      - execute command if any prerequisite is newer than 
+# if_changed      - execute command if any prerequisite is newer than
 #                   target, or command line has changed
 # if_changed_dep  - as if_changed, but uses fixdep to reveal dependencies
 #                   including used config symbols
@@ -133,16 +146,12 @@ objectify = $(foreach o,$(1),$(if $(filt
 # See Documentation/kbuild/makefiles.txt for more info
 
 ifneq ($(KBUILD_NOCMDDEP),1)
-# Check if both arguments has same arguments. Result in empty string if equal
+# Check if both arguments has same arguments. Result is empty string, if equal.
 # User may override this check using make KBUILD_NOCMDDEP=1
 arg-check = $(strip $(filter-out $(cmd_$(1)), $(cmd_$@)) \
                     $(filter-out $(cmd_$@),   $(cmd_$(1))) )
 endif
 
-# echo command. Short version is $(quiet) equals quiet, otherwise full command
-echo-cmd = $(if $($(quiet)cmd_$(1)), \
-	echo '  $(call escsq,$($(quiet)cmd_$(1)))$(echo-why)';)
-
 # >'< substitution is for echo to work,
 # >$< substitution to preserve $ when reloading .cmd file
 # note: when using inline perl scripts [perl -e '...$$t=1;...']
@@ -153,15 +162,15 @@ make-cmd = $(subst \#,\\\#,$(subst $$,$$
 # PHONY targets skipped in both cases.
 any-prereq = $(filter-out $(PHONY),$?) $(filter-out $(PHONY) $(wildcard $^),$^)
 
-# Execute command if command has changed or prerequisitei(s) are updated
+# Execute command if command has changed or prerequisite(s) are updated.
 #
 if_changed = $(if $(strip $(any-prereq) $(arg-check)),                       \
 	@set -e;                                                             \
 	$(echo-cmd) $(cmd_$(1));                                             \
 	echo 'cmd_$@ := $(make-cmd)' > $(dot-target).cmd)
 
-# execute the command and also postprocess generated .d dependencies
-# file
+# Execute the command and also postprocess generated .d dependencies file.
+#
 if_changed_dep = $(if $(strip $(any-prereq) $(arg-check) ),                  \
 	@set -e;                                                             \
 	$(echo-cmd) $(cmd_$(1));                                             \
@@ -169,9 +178,10 @@ if_changed_dep = $(if $(strip $(any-prer
 	rm -f $(depfile);                                                    \
 	mv -f $(dot-target).tmp $(dot-target).cmd)
 
+# Will check if $(cmd_foo) changed, or any of the prerequisites changed,
+# and if so will execute $(rule_foo).
 # Usage: $(call if_changed_rule,foo)
-# will check if $(cmd_foo) changed, or any of the prequisites changed,
-# and if so will execute $(rule_foo)
+#
 if_changed_rule = $(if $(strip $(any-prereq) $(arg-check) ),                 \
 	@set -e;                                                             \
 	$(rule_$(1)))
_

Patches currently in -mm which might be from olecom@flower.upol.cz are

scripts-replace-gawk-head-bc-with-shell-update.patch
kbuild-improve-option-checking-kbuildinclude-cleanup.patch
kbuild-correctly-skip-tilded-backups-in-localversion-files.patch
deprecate-smbfs-in-favour-of-cifs-docs.patch
