From: akpm@linux-foundation.org
Subject: - mkmakefile-include-arch-on-o=-builds.patch removed from -mm tree
Date: Sun, 30 Sep 2007 23:52:46 -0700
Message-ID: <200710010652.l916qkBL003801@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33497 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751341AbXJAGxH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2007 02:53:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 7eggert@gmx.de, sam@ravnborg.org, tony@bakeyournoodle.com, mm-commits@vger.kernel.org


The patch titled
     mkmakefile: include ARCH on O= builds
has been removed from the -mm tree.  Its filename was
     mkmakefile-include-arch-on-o=-builds.patch

This patch was dropped because of rejects against Sam's tree

------------------------------------------------------
Subject: mkmakefile: include ARCH on O= builds
From: Bodo Eggert <7eggert@gmx.de>

If you build using O=builddir ARCH=bar, you'll currently need to supply
ARCH= on builds from the builddir, too.  With this patch, the generated
Makefile will do that instead.

make ARCH= will still override the Makefile default, allowing existing
scripts to work correctly.

Signed-off-by: Bodo Eggert <7eggert@gmx.de>
Cc: Tony Breeds <tony@bakeyournoodle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile           |    2 +-
 scripts/mkmakefile |    6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN Makefile~mkmakefile-include-arch-on-o=-builds Makefile
--- a/Makefile~mkmakefile-include-arch-on-o=-builds
+++ a/Makefile
@@ -360,7 +360,7 @@ PHONY += outputmakefile
 outputmakefile:
 ifneq ($(KBUILD_SRC),)
 	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/mkmakefile \
-	    $(srctree) $(objtree) $(VERSION) $(PATCHLEVEL)
+	    $(srctree) $(objtree) $(VERSION) $(PATCHLEVEL) $(ARCH)
 endif
 
 # To make sure we do not include .config for any of the *config targets
diff -puN scripts/mkmakefile~mkmakefile-include-arch-on-o=-builds scripts/mkmakefile
--- a/scripts/mkmakefile~mkmakefile-include-arch-on-o=-builds
+++ a/scripts/mkmakefile
@@ -8,6 +8,7 @@
 # $2 - Output directory
 # $3 - version
 # $4 - patchlevel
+# $5 - arch
 
 
 test ! -r $2/Makefile -o -O $2/Makefile || exit 0
@@ -21,16 +22,17 @@ PATCHLEVEL = $4
 
 KERNELSRC    := $1
 KERNELOUTPUT := $2
+ARCH         := $5
 
 MAKEFLAGS += --no-print-directory
 
 .PHONY: all \$(MAKECMDGOALS)
 
 all:
-	\$(MAKE) -C \$(KERNELSRC) O=\$(KERNELOUTPUT)
+	\$(MAKE) -C \$(KERNELSRC) O=\$(KERNELOUTPUT) ARCH=\$(ARCH)
 
 Makefile:;
 
 \$(filter-out all Makefile,\$(MAKECMDGOALS)) %/:
-	\$(MAKE) -C \$(KERNELSRC) O=\$(KERNELOUTPUT) \$@
+	\$(MAKE) -C \$(KERNELSRC) O=\$(KERNELOUTPUT) ARCH=\$(ARCH) \$@
 EOF
_

Patches currently in -mm which might be from 7eggert@gmx.de are

mkmakefile-include-arch-on-o=-builds.patch
limit-minixfs-printks-on-corrupted-dir-i_size.patch
