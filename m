From: akpm@linux-foundation.org
Subject: [merged] make-help-add-tools-help-target.patch removed
 from -mm tree
Date: Tue, 09 May 2017 11:00:41 -0700
Message-ID: <20170509180041.ljRodwV4M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34236 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753800AbdEISAm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:00:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org


The patch titled
     Subject: make help: add tools help target
has been removed from the -mm tree.  Its filename was
     make-help-add-tools-help-target.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: make help: add tools help target

Add a top-level Makefile help target for Userspace tools.

Also make each help "heading" end with a colon ':'.

Link: http://lkml.kernel.org/r/55c986ff-3966-3e47-2984-7349da2cce51@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN Makefile~make-help-add-tools-help-target Makefile
--- a/Makefile~make-help-add-tools-help-target
+++ a/Makefile
@@ -1374,7 +1374,7 @@ help:
 	@echo  '  headers_install - Install sanitised kernel headers to INSTALL_HDR_PATH'; \
 	 echo  '                    (default: $(INSTALL_HDR_PATH))'; \
 	 echo  ''
-	@echo  'Static analysers'
+	@echo  'Static analysers:'
 	@echo  '  checkstack      - Generate a list of stack hogs'
 	@echo  '  namespacecheck  - Name space analysis on compiled kernel'
 	@echo  '  versioncheck    - Sanity check on version.h usage'
@@ -1384,7 +1384,7 @@ help:
 	@echo  '  headerdep       - Detect inclusion cycles in headers'
 	@$(MAKE) -f $(srctree)/scripts/Makefile.help checker-help
 	@echo  ''
-	@echo  'Kernel selftest'
+	@echo  'Kernel selftest:'
 	@echo  '  kselftest       - Build and run kernel selftest (run as root)'
 	@echo  '                    Build, install, and boot kernel before'
 	@echo  '                    running kselftest on it'
@@ -1392,6 +1392,10 @@ help:
 	@echo  '  kselftest-merge - Merge all the config dependencies of kselftest to existed'
 	@echo  '                    .config.'
 	@echo  ''
+	@echo 'Userspace tools targets:'
+	@echo '  use "make tools/help"'
+	@echo '  or  "cd tools; make help"'
+	@echo  ''
 	@echo  'Kernel packaging:'
 	@$(MAKE) $(build)=$(package-dir) help
 	@echo  ''
_

Patches currently in -mm which might be from rdunlap@infradead.org are

imx7-fix-kconfig-warning-and-build-errors.patch

