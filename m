From: akpm@linux-foundation.org
Subject: [patch 013/114] make help: add tools help target
Date: Mon, 08 May 2017 15:55:08 -0700
Message-ID: <20170508225508.lU3ZO39Mv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45808 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751354AbdEHWzJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:55:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, rdunlap@infradead.org, torvalds@linux-foundation.org

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
