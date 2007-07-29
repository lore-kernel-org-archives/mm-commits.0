From: akpm@linux-foundation.org
Subject: + fix-kgdb-kernel-doc.patch added to -mm tree
Date: Sun, 29 Jul 2007 00:44:16 -0700
Message-ID: <200707290744.l6T7iG6D014300@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55883 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760651AbXG2Hox (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 03:44:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     fix kgdb kernel-doc
has been added to the -mm tree.  Its filename is
     fix-kgdb-kernel-doc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix kgdb kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

No kernel-doc comments in this file, although kgdb.tmpl implies that it needs
some:

Warning(linux-2.6.23-rc1-mm1//kernel/kgdb.c): no structured comments found

Add kernel-doc notation in kgdb.h for:
Warning(linux-2.6.23-rc1-mm1//include/linux/kgdb.h:225): No description found for parameter 'remove_all_hw_break'
Warning(linux-2.6.23-rc1-mm1//include/linux/kgdb.h:225): No description found for parameter 'correct_hw_break'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/kgdb.tmpl |    4 +++-
 include/linux/kgdb.h            |    4 ++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN Documentation/DocBook/kgdb.tmpl~fix-kgdb-kernel-doc Documentation/DocBook/kgdb.tmpl
--- a/Documentation/DocBook/kgdb.tmpl~fix-kgdb-kernel-doc
+++ a/Documentation/DocBook/kgdb.tmpl
@@ -235,7 +235,9 @@
       and are optionally implemented.  Some functions (with _hw_ in the name)
       end up being required on arches which use hardware breakpoints.
       </para>
-!Ikernel/kgdb.c
+<!--
+X!Ikernel/kgdb.c
+-->
   </chapter>
   <chapter id="DriverSpecificFunctions">
     <title>Driver-Specific Functions</title>
diff -puN include/linux/kgdb.h~fix-kgdb-kernel-doc include/linux/kgdb.h
--- a/include/linux/kgdb.h~fix-kgdb-kernel-doc
+++ a/include/linux/kgdb.h
@@ -207,6 +207,10 @@ extern int kgdb_arch_remove_breakpoint(u
  * breakpoint.
  * @remove_hw_breakpoint: Allow an architecture to specify how to remove a
  * hardware breakpoint.
+ * @remove_all_hw_break: Allow an architecture to specify how to remove all
+ * hardware breakpoints.
+ * @correct_hw_break: Allow an architecture to specify how to correct the
+ * hardware debug registers.
  *
  * The @shadowth flag is an option to shadow information not retrievable by
  * gdb otherwise.  This is deprecated in favor of a binutils which supports
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
update-dontdiff-file.patch
kernel-doc-fixes-for-pci-and-drivers-base.patch
x86-64-calgary-fix-section-mismatch-warnings-in-tce.patch
various-doc-kernel-parameters-fixes.patch
pnp-fix-kernel-doc-warnings.patch
sched-fix-kernel-doc-warnings.patch
git-acpi.patch
git-mtd.patch
git-net.patch
aha152x-in-debug-mode.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-kgdb-kernel-doc.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
i2ch-kernel-doc-additions.patch
irqh-fix-kernel-doc.patch
docbook-bad-file-references.patch
kthread-silence-bogus-section-mismatch-warning.patch
profile-likely-unlikely-macros.patch
fix-filemapc-kernel-doc.patch
fix-auditscc-kernel-doc.patch
