From: akpm@osdl.org
Subject: - make-help-in-build-tree-doesnt-show-headers_-targets.patch removed from -mm tree
Date: Tue, 30 Jan 2007 13:47:03 -0800
Message-ID: <200701302147.l0ULl3k6030152@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51926 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbXA3VrN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 16:47:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, olecom@flower.upol.cz, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     `make help' in build tree doesn't show headers_* targets
has been removed from the -mm tree.  Its filename was
     make-help-in-build-tree-doesnt-show-headers_-targets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: `make help' in build tree doesn't show headers_* targets
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

`make help' in the build tree doesn't show the help texts about the
`headers_install' and `headers_check' targets because it looks for
include/asm-$(ARCH)/Kbuild in the wrong place.
Add the missing `$(srctree)' prefixes to fix this.
Also move the printing of the default install path for the headers inside the
`if/fi', where it belongs.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Acked-by: Oleg Verych <olecom@flower.upol.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN Makefile~make-help-in-build-tree-doesnt-show-headers_-targets Makefile
--- a/Makefile~make-help-in-build-tree-doesnt-show-headers_-targets
+++ a/Makefile
@@ -1116,15 +1116,15 @@ help:
 	@echo  '  cscope	  - Generate cscope index'
 	@echo  '  kernelrelease	  - Output the release version string'
 	@echo  '  kernelversion	  - Output the version stored in Makefile'
-	@if [ -r include/asm-$(ARCH)/Kbuild ]; then \
+	@if [ -r $(srctree)/include/asm-$(ARCH)/Kbuild ]; then \
 	 echo  '  headers_install - Install sanitised kernel headers to INSTALL_HDR_PATH'; \
+	 echo  '                    (default: $(INSTALL_HDR_PATH))'; \
 	 fi
-	@echo  '                    (default: $(INSTALL_HDR_PATH))'
 	@echo  ''
 	@echo  'Static analysers'
 	@echo  '  checkstack      - Generate a list of stack hogs'
 	@echo  '  namespacecheck  - Name space analysis on compiled kernel'
-	@if [ -r include/asm-$(ARCH)/Kbuild ]; then \
+	@if [ -r $(srctree)/include/asm-$(ARCH)/Kbuild ]; then \
 	 echo  '  headers_check   - Sanity check on exported headers'; \
 	 fi
 	@echo  ''
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
