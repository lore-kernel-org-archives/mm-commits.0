From: akpm@osdl.org
Subject: + kbuild-improving-option-checking-fix.patch added to -mm tree
Date: Wed, 24 Jan 2007 23:35:59 -0800
Message-ID: <200701250735.l0P7ZxrQ009310@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52163 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965678AbXAYHgG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 02:36:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olecom@flower.upol.cz, sam@ravnborg.org, zippel@linux-m68k.org


The patch titled
     spell 4 kbuild: improving option checking
has been added to the -mm tree.  Its filename is
     kbuild-improving-option-checking-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spell 4 kbuild: improving option checking
From: Oleg Verych <olecom@flower.upol.cz>

Signed-off-by: Oleg Verych <olecom@flower.upol.cz>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 scripts/Kbuild.include |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN scripts/Kbuild.include~kbuild-improving-option-checking-fix scripts/Kbuild.include
--- a/scripts/Kbuild.include~kbuild-improving-option-checking-fix
+++ a/scripts/Kbuild.include
@@ -1,7 +1,7 @@
 ####
 # kbuild: Generic definitions
 
-# Convinient constants
+# Convenient constants
 comma   := ,
 squote  := '
 empty   :=
@@ -170,7 +170,7 @@ make-cmd = $(subst \#,\\\#,$(subst $$,$$
 # PHONY targets skipped in both cases.
 any-prereq = $(filter-out $(PHONY),$?) $(filter-out $(PHONY) $(wildcard $^),$^)
 
-# Execute command if command has changed or prerequisitei(s) are updated
+# Execute command if command has changed or prerequisite(s) are updated
 #
 if_changed = $(if $(strip $(any-prereq) $(arg-check)),                       \
 	@set -e;                                                             \
@@ -187,7 +187,7 @@ if_changed_dep = $(if $(strip $(any-prer
 	mv -f $(dot-target).tmp $(dot-target).cmd)
 
 # Usage: $(call if_changed_rule,foo)
-# will check if $(cmd_foo) changed, or any of the prequisites changed,
+# will check if $(cmd_foo) changed, or any of the prerequisites changed,
 # and if so will execute $(rule_foo)
 if_changed_rule = $(if $(strip $(any-prereq) $(arg-check) ),                 \
 	@set -e;                                                             \
@@ -232,3 +232,5 @@ why =                                   
 
 echo-why = $(call escsq, $(strip $(why)))
 endif
+
+ LocalWords:  prequisites
_

Patches currently in -mm which might be from olecom@flower.upol.cz are

kbuild-improving-option-checking.patch
kbuild-improving-option-checking-fix.patch
deprecate-smbfs-in-favour-of-cifs-docs.patch
