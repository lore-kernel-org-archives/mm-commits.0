From: akpm@linux-foundation.org
Subject: + call-export_report-from-the-makefile.patch added to -mm tree
Date: Mon, 27 Aug 2007 14:29:02 -0700
Message-ID: <200708272129.l7RLT2oF029089@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60799 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765614AbXH0V3n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 17:29:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, sam@ravnborg.org


The patch titled
     call export_report from the Makefile
has been added to the -mm tree.  Its filename is
     call-export_report-from-the-makefile.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: call export_report from the Makefile
From: Adrian Bunk <bunk@kernel.org>

The main feature is that export_report now automatically works
for O= builds.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN Makefile~call-export_report-from-the-makefile Makefile
--- a/Makefile~call-export_report-from-the-makefile
+++ a/Makefile
@@ -1157,6 +1157,7 @@ help:
 	@echo  'Static analysers'
 	@echo  '  checkstack      - Generate a list of stack hogs'
 	@echo  '  namespacecheck  - Name space analysis on compiled kernel'
+	@echo  '  export_report   - List the usages of all exported symbols'
 	@if [ -r $(srctree)/include/asm-$(ARCH)/Kbuild ]; then \
 	 echo  '  headers_check   - Sanity check on exported headers'; \
 	 fi
@@ -1416,6 +1417,9 @@ versioncheck:
 namespacecheck:
 	$(PERL) $(srctree)/scripts/namespace.pl
 
+export_report:
+	$(PERL) $(srctree)/scripts/export_report.pl
+
 endif #ifeq ($(config-targets),1)
 endif #ifeq ($(mixed-targets),1)
 
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-acpi.patch
git-dvb.patch
pass-g-to-assembler-under-config_debug_info-fix.patch
fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
fix-ide-ide-remove-ide-dma-check.patch
drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch
git-nfsd.patch
file-capabilities-clear-fcaps-on-inode-change-fix.patch
security-cleanups.patch
make-kernel-power-maincsuspend_enter-static.patch
uml-fix-inlines.patch
kconfig-syntax-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
make-fs-libfscsimple_commit_write-static.patch
allow-disabling-dnotify-without-embedded.patch
fix-export_reportpl.patch
export_reportpl-fix-perl-coding-errors.patch
call-export_report-from-the-makefile.patch
remove-fs-ext2-balloccreserve_blocks.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
