From: akpm@linux-foundation.org
Subject: - uml-fix-prototypes.patch removed from -mm tree
Date: Mon, 07 May 2007 17:07:46 -0700
Message-ID: <200705080007.l4807kwV009317@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967423AbXEHAIS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:08:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: blaisorblade@yahoo.it, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix prototypes
has been removed from the -mm tree.  Its filename was
     uml-fix-prototypes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: fix prototypes
From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

Declare strlcpy and strlcat more correctly.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/user.h |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN arch/um/include/user.h~uml-fix-prototypes arch/um/include/user.h
--- a/arch/um/include/user.h~uml-fix-prototypes
+++ a/arch/um/include/user.h
@@ -14,6 +14,11 @@
  */
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 
+/*
+ * This will provide the size_t definition in both kernel and userspace builds
+ */
+#include <linux/types.h>
+
 extern void panic(const char *fmt, ...)
 	__attribute__ ((format (printf, 1, 2)));
 extern int printk(const char *fmt, ...)
@@ -21,8 +26,7 @@ extern int printk(const char *fmt, ...)
 extern void schedule(void);
 extern int in_aton(char *str);
 extern int open_gdb_chan(void);
-/* These use size_t, however unsigned long is correct on both i386 and x86_64. */
-extern unsigned long strlcpy(char *, const char *, unsigned long);
-extern unsigned long strlcat(char *, const char *, unsigned long);
+extern size_t strlcpy(char *, const char *, size_t);
+extern size_t strlcat(char *, const char *, size_t);
 
 #endif
_

Patches currently in -mm which might be from blaisorblade@yahoo.it are

origin.patch
uml-make-hostfs_setattr-support-operations-on-unlinked-open-files.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
