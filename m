From: akpm@linux-foundation.org
Subject: - uml-fix-build-for-config_printk.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:11:04 -0800
Message-ID: <200711152111.lAFLB4Sp015729@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59388 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761748AbXKOVRJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix build for !CONFIG_PRINTK
has been removed from the -mm tree.  Its filename was
     uml-fix-build-for-config_printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: fix build for !CONFIG_PRINTK
From: Jeff Dike <jdike@addtoit.com>

Handle the case of CONFIG_PRINTK being disabled.  This requires a do-nothing
stub to be present in arch/um/include/user.h so that we don't get references
to printk from libc code.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/user.h |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN arch/um/include/user.h~uml-fix-build-for-config_printk arch/um/include/user.h
--- a/arch/um/include/user.h~uml-fix-build-for-config_printk
+++ a/arch/um/include/user.h
@@ -1,11 +1,13 @@
 /* 
- * Copyright (C) 2000 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
 #ifndef __USER_H__
 #define __USER_H__
 
+#include "uml-config.h"
+
 /*
  * The usual definition - copied here because the kernel provides its own,
  * fancier, type-safe, definition.  Using that one would require
@@ -23,8 +25,17 @@
 
 extern void panic(const char *fmt, ...)
 	__attribute__ ((format (printf, 1, 2)));
+
+#ifdef UML_CONFIG_PRINTK
 extern int printk(const char *fmt, ...)
 	__attribute__ ((format (printf, 1, 2)));
+#else
+static inline int printk(const char *fmt, ...)
+{
+	return 0;
+}
+#endif
+
 extern void schedule(void);
 extern int in_aton(char *str);
 extern int open_gdb_chan(void);
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
uml-delete-some-unused-headers.patch
uml-allow-lflags-on-command-line.patch
uml-tidy-kern_utilh.patch
uml-tidy-pgtableh.patch
uml-reconst-a-parameter.patch
arch-um-remove-duplicate-includes.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
