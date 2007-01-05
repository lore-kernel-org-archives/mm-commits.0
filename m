From: akpm@osdl.org
Subject: + uml-locking-comments-in-iomem-driver.patch added to -mm tree
Date: Fri, 05 Jan 2007 12:13:31 -0800
Message-ID: <200701052013.l05KDVch031090@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57173 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbXAEUNe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 15:13:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: locking comments in iomem driver
has been added to the -mm tree.  Its filename is
     uml-locking-comments-in-iomem-driver.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: locking comments in iomem driver
From: Jeff Dike <jdike@addtoit.com>

Comment some lack of locking in the iomem driver.

Also, a couple of variables are in the wrong place, so they are moved.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
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

x86_64-i386-kernel-mode-faults-pollute-current-thead.patch
uml-console-locking-fixes.patch
uml-return-hotplug-errors-to-host.patch
uml-console-whitespace-and-comment-tidying.patch
uml-lock-the-irqs_to_free-list.patch
uml-add-locking-to-network-transport-registration.patch
uml-network-driver-whitespace-and-style-fixes.patch
uml-watchdog-driver-locking.patch
uml-watchdog-driver-formatting.patch
uml-audio-driver-locking.patch
uml-audio-driver-formatting.patch
uml-mconsole-locking.patch
uml-make-two-variables-static.patch
uml-port-driver-formatting.patch
uml-kill-a-compilation-warning.patch
uml-network-driver-locking-and-code-cleanup.patch
uml-use-list_head-where-possible.patch
uml-locking-commentary-in-the-random-driver.patch
uml-mostly-const-a-structure.patch
uml-chan_userh-formatting-fices.patch
uml-console-locking-commentary-and-code-cleanup.patch
uml-fix-previous-console-locking.patch
uml-locking-comments-in-iomem-driver.patch
uml-memc-and-physmemc-formatting-fixes.patch
uml-fix-prototypes.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
