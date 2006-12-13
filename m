From: akpm@osdl.org
Subject: - kbuild-fix-rr-is-now-default.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:51:28 -0800
Message-ID: <200612130651.kBD6pSN8030350@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57225 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964962AbWLMGvr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:51:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olecom@flower.upol.cz, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kbuild: fix-rR-is-now-default
has been removed from the -mm tree.  Its filename was
     kbuild-fix-rr-is-now-default.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kbuild: fix-rR-is-now-default
From: Oleg Verych <olecom@flower.upol.cz>

`make -d help | grep Makefile` shows patterns, where make tries to rebuild
included and top makefiles.

While `make -rR is now default' commit should fix this, actually, it was just
a little janitorial.

This fix is aimed to complete cancelling implicit rules.

Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Oleg Verych <olecom@flower.upol.cz>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Makefile |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN Makefile~kbuild-fix-rr-is-now-default Makefile
--- a/Makefile~kbuild-fix-rr-is-now-default
+++ a/Makefile
@@ -10,8 +10,11 @@ NAME=Avast! A bilge rat!
 # Comments in this file are targeted only to the developer, do not
 # expect to learn how to build the kernel reading this file.
 
-# Do not print "Entering directory ..."
-MAKEFLAGS += --no-print-directory
+# Do not:
+# o  use make's built-in rules and variables
+#    (this increases performance and avoid hard-to-debug behavour);
+# o  print "Entering directory ...";
+MAKEFLAGS += -rR --no-print-directory
 
 # We are using a recursive build, so we need to do a little thinking
 # to get the ordering right.
@@ -271,12 +274,8 @@ export quiet Q KBUILD_VERBOSE
 # Look for make include files relative to root of kernel src
 MAKEFLAGS += --include-dir=$(srctree)
 
-# We need some generic definitions
-include  $(srctree)/scripts/Kbuild.include
-
-# Do not use make's built-in rules and variables
-# This increases performance and avoid hard-to-debug behavour
-MAKEFLAGS += -rR
+# We need some generic definitions.
+include $(srctree)/scripts/Kbuild.include
 
 # Make variables (CC, etc...)
 
@@ -1484,6 +1483,8 @@ endif	# skip-makefile
 PHONY += FORCE
 FORCE:
 
+# Cancel implicit rules on top Makefile, `-rR' will apply to sub-makes.
+Makefile: ;
 
 # Declare the contents of the .PHONY variable as phony.  We keep that
 # information in a variable se we can use it in if_changed and friends.
_

Patches currently in -mm which might be from olecom@flower.upol.cz are

origin.patch
deprecate-smbfs-in-favour-of-cifs-docs.patch

