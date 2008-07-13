From: akpm@linux-foundation.org
Subject: + mm-make-config_migration-available-w-o-config_numa.patch added to -mm tree
Date: Sat, 12 Jul 2008 22:28:43 -0700
Message-ID: <200807130528.m6D5ShTA005921@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750841AbYGMF3V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jul 2008 01:29:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerald.schaefer@de.ibm.com, cl@linux-foundation.org, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com


The patch titled
     mm: make CONFIG_MIGRATION available w/o CONFIG_NUMA
has been added to the -mm tree.  Its filename is
     mm-make-config_migration-available-w-o-config_numa.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: make CONFIG_MIGRATION available w/o CONFIG_NUMA
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

We'd like to support CONFIG_MEMORY_HOTREMOVE on s390, which depends on
CONFIG_MIGRATION.  So far, CONFIG_MIGRATION is only available with NUMA
support.

This patch makes CONFIG_MIGRATION selectable for architectures that define
ARCH_ENABLE_MEMORY_HOTREMOVE.  When MIGRATION is enabled w/o NUMA, the
kernel won't compile because migrate_vmas() does not know about
vm_ops->migrate() and vma_migratable() does not know about policy_zone. 
To fix this, those two functions can be restricted to '#ifdef CONFIG_NUMA'
because they are not being used w/o NUMA.  vma_migratable() is moved over
from migrate.h to mempolicy.h.

Acked-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |   19 +++++++++++++++++++
 include/linux/migrate.h   |   21 ---------------------
 mm/Kconfig                |    2 +-
 mm/migrate.c              |    2 +-
 4 files changed, 21 insertions(+), 23 deletions(-)

diff -puN include/linux/mempolicy.h~mm-make-config_migration-available-w-o-config_numa include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mm-make-config_migration-available-w-o-config_numa
+++ a/include/linux/mempolicy.h
@@ -2,6 +2,7 @@
 #define _LINUX_MEMPOLICY_H 1
 
 #include <linux/errno.h>
+#include <linux/pagemap.h>
 
 /*
  * NUMA memory policies for Linux.
@@ -220,6 +221,24 @@ extern int mpol_parse_str(char *str, str
 extern int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol,
 			int no_context);
 #endif
+
+/* Check if a vma is migratable */
+static inline int vma_migratable(struct vm_area_struct *vma)
+{
+	if (vma->vm_flags & (VM_IO|VM_HUGETLB|VM_PFNMAP|VM_RESERVED))
+		return 0;
+	/*
+	 * Migration allocates pages in the highest zone. If we cannot
+	 * do so then migration (at least from node to node) is not
+	 * possible.
+	 */
+	if (vma->vm_file &&
+		gfp_zone(mapping_gfp_mask(vma->vm_file->f_mapping))
+								< policy_zone)
+			return 0;
+	return 1;
+}
+
 #else
 
 struct mempolicy {};
diff -puN include/linux/migrate.h~mm-make-config_migration-available-w-o-config_numa include/linux/migrate.h
--- a/include/linux/migrate.h~mm-make-config_migration-available-w-o-config_numa
+++ a/include/linux/migrate.h
@@ -3,28 +3,10 @@
 
 #include <linux/mm.h>
 #include <linux/mempolicy.h>
-#include <linux/pagemap.h>
 
 typedef struct page *new_page_t(struct page *, unsigned long private, int **);
 
 #ifdef CONFIG_MIGRATION
-/* Check if a vma is migratable */
-static inline int vma_migratable(struct vm_area_struct *vma)
-{
-	if (vma->vm_flags & (VM_IO|VM_HUGETLB|VM_PFNMAP|VM_RESERVED))
-		return 0;
-	/*
-	 * Migration allocates pages in the highest zone. If we cannot
-	 * do so then migration (at least from node to node) is not
-	 * possible.
-	 */
-	if (vma->vm_file &&
-		gfp_zone(mapping_gfp_mask(vma->vm_file->f_mapping))
-								< policy_zone)
-			return 0;
-	return 1;
-}
-
 extern int isolate_lru_page(struct page *p, struct list_head *pagelist);
 extern int putback_lru_pages(struct list_head *l);
 extern int migrate_page(struct address_space *,
@@ -39,9 +21,6 @@ extern int migrate_vmas(struct mm_struct
 		const nodemask_t *from, const nodemask_t *to,
 		unsigned long flags);
 #else
-static inline int vma_migratable(struct vm_area_struct *vma)
-					{ return 0; }
-
 static inline int isolate_lru_page(struct page *p, struct list_head *list)
 					{ return -ENOSYS; }
 static inline int putback_lru_pages(struct list_head *l) { return 0; }
diff -puN mm/Kconfig~mm-make-config_migration-available-w-o-config_numa mm/Kconfig
--- a/mm/Kconfig~mm-make-config_migration-available-w-o-config_numa
+++ a/mm/Kconfig
@@ -174,7 +174,7 @@ config SPLIT_PTLOCK_CPUS
 config MIGRATION
 	bool "Page migration"
 	def_bool y
-	depends on NUMA
+	depends on NUMA || ARCH_ENABLE_MEMORY_HOTREMOVE
 	help
 	  Allows the migration of the physical location of pages of processes
 	  while the virtual addresses are not changed. This is useful for
diff -puN mm/migrate.c~mm-make-config_migration-available-w-o-config_numa mm/migrate.c
--- a/mm/migrate.c~mm-make-config_migration-available-w-o-config_numa
+++ a/mm/migrate.c
@@ -1071,7 +1071,6 @@ out2:
 	mmput(mm);
 	return err;
 }
-#endif
 
 /*
  * Call migration functions in the vma_ops that may prepare
@@ -1093,3 +1092,4 @@ int migrate_vmas(struct mm_struct *mm, c
  	}
  	return err;
 }
+#endif
_

Patches currently in -mm which might be from gerald.schaefer@de.ibm.com are

linux-next.patch
mm-make-config_migration-available-w-o-config_numa.patch

