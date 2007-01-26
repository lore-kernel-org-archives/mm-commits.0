From: akpm@osdl.org
Subject: - kbuild-improving-option-checking.patch removed from -mm tree
Date: Thu, 25 Jan 2007 20:25:41 -0800
Message-ID: <200701260425.l0Q4PfIU007299@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44746 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030738AbXAZEZw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 23:25:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olecom@flower.upol.cz, sam@ravnborg.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     kbuild: improving option checking
has been removed from the -mm tree.  Its filename was
     kbuild-improving-option-checking.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: kbuild: improving option checking
From: Oleg Verych <olecom@flower.upol.cz>

GNU binutils, root users, tmpfiles, external modules ro builds must be
fixed to do the right thing now.

In "safe" environment new /dev/null replacement may be used as simply as
`echo > null', `gcc -o null'.  In aggressive starting with $(null) is
recommended.

Feature: file $(objtree)/null isn't in any "clear" target (yet).

Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Oleg Verych <olecom@flower.upol.cz>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 scripts/Kbuild.include |   71 ++++++++++++++++++++++++---------------
 1 file changed, 45 insertions(+), 26 deletions(-)

diff -puN scripts/Kbuild.include~kbuild-improving-option-checking scripts/Kbuild.include
--- a/scripts/Kbuild.include~kbuild-improving-option-checking
+++ a/scripts/Kbuild.include
@@ -1,12 +1,15 @@
 ####
 # kbuild: Generic definitions
 
-# Convinient variables
+# Convenient constants
 comma   := ,
 squote  := '
 empty   :=
 space   := $(empty) $(empty)
 
+# Immortal black-hole for mortals and roots
+null = $(shell test -L null || (rm -f null; ln -s /dev/null null); echo null)
+
 ###
 # Name of target with a '.' as filename prefix. foo/bar.o => foo/.bar.o
 dot-target = $(dir $@).$(notdir $@)
@@ -56,35 +59,45 @@ endef
 # gcc support functions
 # See documentation in Documentation/kbuild/makefiles.txt
 
-# output directory for tests below
-TMPOUT := $(if $(KBUILD_EXTMOD),$(firstword $(KBUILD_EXTMOD))/)
-
 # as-option
 # Usage: cflags-y += $(call as-option, -Wa$(comma)-isa=foo,)
-
-as-option = $(shell if $(CC) $(CFLAGS) $(1) -Wa,-Z -c -o /dev/null \
-	     -xassembler /dev/null > /dev/null 2>&1; then echo "$(1)"; \
-	     else echo "$(2)"; fi ;)
+define as-option
+  $(shell
+    if $(CC) $(CFLAGS) $(1) -c -o $(null) -xassembler null >null 2>&1; \
+      then echo $(1); \
+      else echo $(2); \
+    fi)
+endef
 
 # as-instr
 # Usage: cflags-y += $(call as-instr, instr, option1, option2)
-
-as-instr = $(shell if echo -e "$(1)" | \
-		      $(CC) $(AFLAGS) -c -xassembler - \
-			    -o $(TMPOUT)astest$$$$.out > /dev/null 2>&1; \
-		   then rm $(TMPOUT)astest$$$$.out; echo "$(2)"; \
-		   else echo "$(3)"; fi)
+define as-instr
+  $(shell \
+    if printf "$(1)" | $(AS) >$(null) 2>&1 -W -o null; \
+      then echo "$(2)"; \
+      else echo "$(3)"; \
+    fi)
+endef
 
 # cc-option
 # Usage: cflags-y += $(call cc-option, -march=winchip-c6, -march=i586)
-
-cc-option = $(shell if $(CC) $(CFLAGS) $(1) -S -o /dev/null -xc /dev/null \
-             > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
+define cc-option
+  $(shell \
+    if $(CC) $(CFLAGS) $(1) -S -o $(null) -xc null >null 2>&1; \
+      then echo "$(1)"; \
+      else echo "$(2)"; \
+    fi)
+endef
 
 # cc-option-yn
 # Usage: flag := $(call cc-option-yn, -march=winchip-c6)
-cc-option-yn = $(shell if $(CC) $(CFLAGS) $(1) -S -o /dev/null -xc /dev/null \
-                > /dev/null 2>&1; then echo "y"; else echo "n"; fi;)
+define cc-option-yn
+  $(shell \
+    if $(CC) $(CFLAGS) $(1) -S -o $(null) -xc null >null 2>&1; \
+      then echo "y"; \
+      else echo "n"; \
+    fi)
+endef
 
 # cc-option-align
 # Prefix align with either -falign or -malign
@@ -102,10 +115,13 @@ cc-ifversion = $(shell if [ $(call cc-ve
 
 # ld-option
 # Usage: ldflags += $(call ld-option, -Wl$(comma)--hash-style=both)
-ld-option = $(shell if $(CC) $(1) -nostdlib -xc /dev/null \
-			     -o $(TMPOUT)ldtest$$$$.out > /dev/null 2>&1; \
-             then rm $(TMPOUT)ldtest$$$$.out; echo "$(1)"; \
-             else echo "$(2)"; fi)
+define ld-option
+  $(shell \
+    if $(CC) $(1) -nostdlib -o $(null) -xc null >null 2>&1; \
+      then echo "$(1)"; \
+      else echo "$(2)"; \
+    fi)
+endef
 
 ###
 # Shorthand for $(Q)$(MAKE) -f scripts/Makefile.build obj=
@@ -115,6 +131,7 @@ build := -f $(if $(KBUILD_SRC),$(srctree
 
 # Prefix -I with $(srctree) if it is not an absolute path
 addtree = $(if $(filter-out -I/%,$(1)),$(patsubst -I%,-I$(srctree)/%,$(1))) $(1)
+
 # Find all -I options and call addtree
 flags = $(foreach o,$($(1)),$(if $(filter -I%,$(o)),$(call addtree,$(o)),$(o)))
 
@@ -125,7 +142,7 @@ cmd = @$(echo-cmd) $(cmd_$(1))
 objectify = $(foreach o,$(1),$(if $(filter /%,$(o)),$(o),$(obj)/$(o)))
 
 ###
-# if_changed      - execute command if any prerequisite is newer than 
+# if_changed      - execute command if any prerequisite is newer than
 #                   target, or command line has changed
 # if_changed_dep  - as if_changed, but uses fixdep to reveal dependencies
 #                   including used config symbols
@@ -153,7 +170,7 @@ make-cmd = $(subst \#,\\\#,$(subst $$,$$
 # PHONY targets skipped in both cases.
 any-prereq = $(filter-out $(PHONY),$?) $(filter-out $(PHONY) $(wildcard $^),$^)
 
-# Execute command if command has changed or prerequisitei(s) are updated
+# Execute command if command has changed or prerequisite(s) are updated
 #
 if_changed = $(if $(strip $(any-prereq) $(arg-check)),                       \
 	@set -e;                                                             \
@@ -170,7 +187,7 @@ if_changed_dep = $(if $(strip $(any-prer
 	mv -f $(dot-target).tmp $(dot-target).cmd)
 
 # Usage: $(call if_changed_rule,foo)
-# will check if $(cmd_foo) changed, or any of the prequisites changed,
+# will check if $(cmd_foo) changed, or any of the prerequisites changed,
 # and if so will execute $(rule_foo)
 if_changed_rule = $(if $(strip $(any-prereq) $(arg-check) ),                 \
 	@set -e;                                                             \
@@ -215,3 +232,5 @@ why =                                   
 
 echo-why = $(call escsq, $(strip $(why)))
 endif
+
+ LocalWords:  prequisites
_

Patches currently in -mm which might be from olecom@flower.upol.cz are

kbuild-improving-option-checking.patch
deprecate-smbfs-in-favour-of-cifs-docs.patch
