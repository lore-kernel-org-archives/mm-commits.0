From: akpm@linux-foundation.org
Subject: + uml-fix-build-for-config_printk.patch added to -mm tree
Date: Wed, 31 Oct 2007 13:36:40 -0700
Message-ID: <200710312036.l9VKae8q026978@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48209 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754759AbXJaUhO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Oct 2007 16:37:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: fix build for !CONFIG_PRINTK
has been added to the -mm tree.  Its filename is
     uml-fix-build-for-config_printk.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-kvm.patch
arch-um-drivers-ubd_kernc-a-warning-fix.patch
uml-fix-spurious-irq-testing.patch
uml-remove-last-include-of-libc-asm-pageh.patch
uml-fix-build-for-config_tcp.patch
uml-fix-build-for-config_printk.patch
uml-implement-get_wchan.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
