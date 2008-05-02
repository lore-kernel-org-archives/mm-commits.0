From: akpm@linux-foundation.org
Subject: - dmi-clean-up-dmi-helper-declarations.patch removed from -mm tree
Date: Fri, 02 May 2008 12:42:58 -0700
Message-ID: <200805021942.m42JgwHc011244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932271AbYEBTnk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:43:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, Matt_Domsch@dell.com, mm-commits@vger.kernel.org


The patch titled
     dmi: clean-up dmi helper declarations
has been removed from the -mm tree.  Its filename was
     dmi-clean-up-dmi-helper-declarations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dmi: clean-up dmi helper declarations
From: Jean Delvare <khali@linux-fr.org>

The declaration of dmi helper functions is a bit messy and inconsistent at the
moment:

* On ia64 they are declared in <asm/io.h>.
* On x86-64 they are declared in <asm/dmi.h>.
* On i386 they are declared both in <asm/io.h> and <asm/dmi.h>.

Fix the header files so that the dmi helper functions are consistently
defined in <asm/dmi.h>.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-ia64/dmi.h  |    5 +++++
 include/asm-ia64/io.h   |    5 -----
 include/asm-x86/dmi.h   |    1 +
 include/asm-x86/io_32.h |    5 -----
 4 files changed, 6 insertions(+), 10 deletions(-)

diff -puN include/asm-ia64/dmi.h~dmi-clean-up-dmi-helper-declarations include/asm-ia64/dmi.h
--- a/include/asm-ia64/dmi.h~dmi-clean-up-dmi-helper-declarations
+++ a/include/asm-ia64/dmi.h
@@ -3,4 +3,9 @@
 
 #include <asm/io.h>
 
+/* Use normal IO mappings for DMI */
+#define dmi_ioremap ioremap
+#define dmi_iounmap(x,l) iounmap(x)
+#define dmi_alloc(l) kmalloc(l, GFP_ATOMIC)
+
 #endif
diff -puN include/asm-ia64/io.h~dmi-clean-up-dmi-helper-declarations include/asm-ia64/io.h
--- a/include/asm-ia64/io.h~dmi-clean-up-dmi-helper-declarations
+++ a/include/asm-ia64/io.h
@@ -423,11 +423,6 @@ extern void __iomem * ioremap(unsigned l
 extern void __iomem * ioremap_nocache (unsigned long offset, unsigned long size);
 extern void iounmap (volatile void __iomem *addr);
 
-/* Use normal IO mappings for DMI */
-#define dmi_ioremap ioremap
-#define dmi_iounmap(x,l) iounmap(x)
-#define dmi_alloc(l) kmalloc(l, GFP_ATOMIC)
-
 /*
  * String version of IO memory access ops:
  */
diff -puN include/asm-x86/dmi.h~dmi-clean-up-dmi-helper-declarations include/asm-x86/dmi.h
--- a/include/asm-x86/dmi.h~dmi-clean-up-dmi-helper-declarations
+++ a/include/asm-x86/dmi.h
@@ -27,6 +27,7 @@ static inline void *dmi_alloc(unsigned l
 
 #endif
 
+/* Use early IO mappings for DMI because it's initialized early */
 #define dmi_ioremap early_ioremap
 #define dmi_iounmap early_iounmap
 
diff -puN include/asm-x86/io_32.h~dmi-clean-up-dmi-helper-declarations include/asm-x86/io_32.h
--- a/include/asm-x86/io_32.h~dmi-clean-up-dmi-helper-declarations
+++ a/include/asm-x86/io_32.h
@@ -133,11 +133,6 @@ extern void *early_ioremap(unsigned long
 extern void early_iounmap(void *addr, unsigned long size);
 extern void __iomem *fix_ioremap(unsigned idx, unsigned long phys);
 
-/* Use early IO mappings for DMI because it's initialized early */
-#define dmi_ioremap early_ioremap
-#define dmi_iounmap early_iounmap
-#define dmi_alloc alloc_bootmem
