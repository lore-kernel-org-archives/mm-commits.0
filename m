From: akpm@linux-foundation.org
Subject: - uml-locking-comments-in-iomem-driver.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:48:57 -0800
Message-ID: <200702112248.l1BMmvKJ015681@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59793 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932686AbXBKWs7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:48:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: locking comments in iomem driver
has been removed from the -mm tree.  Its filename was
     uml-locking-comments-in-iomem-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: locking comments in iomem driver
From: Jeff Dike <jdike@addtoit.com>

Comment some lack of locking in the iomem driver.

Also, a couple of variables are in the wrong place, so they are moved.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/mem.c     |   10 ----------
 arch/um/kernel/physmem.c |   17 +++++++++++++++++
 2 files changed, 17 insertions(+), 10 deletions(-)

diff -puN arch/um/kernel/mem.c~uml-locking-comments-in-iomem-driver arch/um/kernel/mem.c
--- a/arch/um/kernel/mem.c~uml-locking-comments-in-iomem-driver
+++ a/arch/um/kernel/mem.c
@@ -367,16 +367,6 @@ struct page *pte_alloc_one(struct mm_str
 	return pte;
 }
 
-struct iomem_region *iomem_regions = NULL;
-int iomem_size = 0;
-
-extern int parse_iomem(char *str, int *add) __init;
-
-__uml_setup("iomem=", parse_iomem,
-"iomem=<name>,<file>\n"
-"    Configure <file> as an IO memory region named <name>.\n\n"
-);
-
 /*
  * Overrides for Emacs so that we follow Linus's tabbing style.
  * Emacs will notice this stuff at the end of the file and automatically
diff -puN arch/um/kernel/physmem.c~uml-locking-comments-in-iomem-driver arch/um/kernel/physmem.c
--- a/arch/um/kernel/physmem.c~uml-locking-comments-in-iomem-driver
+++ a/arch/um/kernel/physmem.c
@@ -398,6 +398,23 @@ __uml_setup("mem=", uml_mem_setup,
 "	Example: mem=64M\n\n"
 );
 
+extern int __init parse_iomem(char *str, int *add);
+
+__uml_setup("iomem=", parse_iomem,
+"iomem=<name>,<file>\n"
+"    Configure <file> as an IO memory region named <name>.\n\n"
+);
+
+/*
+ * This list is constructed in parse_iomem and addresses filled in in
+ * setup_iomem, both of which run during early boot.  Afterwards, it's
+ * unchanged.
+ */
+struct iomem_region *iomem_regions = NULL;
+
+/* Initialized in parse_iomem */
+int iomem_size = 0;
+
 unsigned long find_iomem(char *driver, unsigned long *len_out)
 {
 	struct iomem_region *region = iomem_regions;
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-prototypes.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
