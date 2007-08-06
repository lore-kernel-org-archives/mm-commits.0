From: akpm@linux-foundation.org
Subject: - fix-kgdb-kernel-doc.patch removed from -mm tree
Date: Mon, 06 Aug 2007 00:53:46 -0700
Message-ID: <200708060753.l767rkf9016364@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44275 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758879AbXHFHzv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 03:55:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     fix kgdb kernel-doc
has been removed from the -mm tree.  Its filename was
     fix-kgdb-kernel-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

fix-auditscc-kernel-doc.patch
git-mtd.patch
aha152x-in-debug-mode.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
profile-likely-unlikely-macros.patch
