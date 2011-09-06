From: akpm@linux-foundation.org
Subject: + llist-make-all-llist-functions-inline.patch added to -mm tree
Date: Tue, 06 Sep 2011 14:37:07 -0700
Message-ID: <201109062137.p86Lb8g2002592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751154Ab1IFVhZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2011 17:37:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ying.huang@intel.com, andi@firstfloor.org, mathieu.desnoyers@efficios.com, peterz@infradead.org


The patch titled
     llist: make all llist functions inline
has been added to the -mm tree.  Its filename is
     llist-make-all-llist-functions-inline.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: llist: make all llist functions inline
From: Huang Ying <ying.huang@intel.com>

Because llist may be used in performance critical code path, make all
llist functions inline to avoid function calling overhead.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/apei/Kconfig |    1 
 include/linux/llist.h     |  122 ++++++++++++++++++++++++++++++++--
 lib/Kconfig               |    3 
 lib/Makefile              |    2 
 lib/llist.c               |  129 ------------------------------------
 5 files changed, 116 insertions(+), 141 deletions(-)

diff -puN drivers/acpi/apei/Kconfig~llist-make-all-llist-functions-inline drivers/acpi/apei/Kconfig
--- a/drivers/acpi/apei/Kconfig~llist-make-all-llist-functions-inline
+++ a/drivers/acpi/apei/Kconfig
@@ -14,7 +14,6 @@ config ACPI_APEI_GHES
 	depends on ACPI_APEI && X86
 	select ACPI_HED
 	select IRQ_WORK
-	select LLIST
 	select GENERIC_ALLOCATOR
 	help
 	  Generic Hardware Error Source provides a way to report
diff -puN include/linux/llist.h~llist-make-all-llist-functions-inline include/linux/llist.h
--- a/include/linux/llist.h~llist-make-all-llist-functions-inline
+++ a/include/linux/llist.h
@@ -37,8 +37,28 @@
  * architectures that don't have NMI-safe cmpxchg implementation, the
  * list can NOT be used in NMI handler.  So code uses the list in NMI
  * handler should depend on CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG.
+ *
+ * Copyright 2010,2011 Intel Corp.
+ *   Author: Huang Ying <ying.huang@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation;
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#include <linux/kernel.h>
+#include <asm/system.h>
+#include <asm/processor.h>
+
 struct llist_head {
 	struct llist_node *first;
 };
@@ -113,14 +133,104 @@ static inline void init_llist_head(struc
  * test whether the list is empty without deleting something from the
  * list.
  */
-static inline int llist_empty(const struct llist_head *head)
+static inline bool llist_empty(const struct llist_head *head)
 {
 	return ACCESS_ONCE(head->first) == NULL;
 }
 
-void llist_add(struct llist_node *new, struct llist_head *head);
-void llist_add_batch(struct llist_node *new_first, struct llist_node *new_last,
-		     struct llist_head *head);
-struct llist_node *llist_del_first(struct llist_head *head);
-struct llist_node *llist_del_all(struct llist_head *head);
+/**
+ * llist_add - add a new entry
+ * @new:	new entry to be added
+ * @head:	the head for your lock-less list
+ */
+static inline void llist_add(struct llist_node *new, struct llist_head *head)
+{
+	struct llist_node *entry, *old_entry;
+
+#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
+	BUG_ON(in_nmi());
+#endif
+
+	entry = head->first;
+	do {
+		old_entry = entry;
+		new->next = entry;
+		cpu_relax();
+	} while ((entry = cmpxchg(&head->first, old_entry, new)) != old_entry);
+}
+
+/**
+ * llist_add_batch - add several linked entries in batch
+ * @new_first:	first entry in batch to be added
+ * @new_last:	last entry in batch to be added
+ * @head:	the head for your lock-less list
+ */
+static inline void llist_add_batch(struct llist_node *new_first,
+				   struct llist_node *new_last,
+				   struct llist_head *head)
+{
+	struct llist_node *entry, *old_entry;
+
+#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
+	BUG_ON(in_nmi());
+#endif
+
+	entry = head->first;
+	do {
+		old_entry = entry;
+		new_last->next = entry;
+		cpu_relax();
+	} while ((entry = cmpxchg(&head->first, old_entry, new_first)) != old_entry);
+}
+
+/**
+ * llist_del_first - delete the first entry of lock-less list
+ * @head:	the head for your lock-less list
+ *
+ * If list is empty, return NULL, otherwise, return the first entry
+ * deleted, this is the newest added one.
+ *
+ * Only one llist_del_first user can be used simultaneously with
+ * multiple llist_add users without lock.  Because otherwise
+ * llist_del_first, llist_add, llist_add (or llist_del_all, llist_add,
+ * llist_add) sequence in another user may change @head->first->next,
+ * but keep @head->first.  If multiple consumers are needed, please
+ * use llist_del_all or use lock between consumers.
+ */
+static inline struct llist_node *llist_del_first(struct llist_head *head)
+{
+	struct llist_node *entry, *old_entry, *next;
+
+#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
+	BUG_ON(in_nmi());
+#endif
+
+	entry = head->first;
+	do {
+		if (entry == NULL)
+			return NULL;
+		old_entry = entry;
+		next = entry->next;
+		cpu_relax();
+	} while ((entry = cmpxchg(&head->first, old_entry, next)) != old_entry);
+
+	return entry;
+}
+
+/**
+ * llist_del_all - delete all entries from lock-less list
+ * @head:	the head of lock-less list to delete all entries
+ *
+ * If list is empty, return NULL, otherwise, delete all entries and
+ * return the pointer to the first entry.  The order of entries
+ * deleted is from the newest to the oldest added one.
+ */
+static inline struct llist_node *llist_del_all(struct llist_head *head)
+{
+#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
+	BUG_ON(in_nmi());
+#endif
+
+	return xchg(&head->first, NULL);
+}
 #endif /* LLIST_H */
diff -puN lib/Kconfig~llist-make-all-llist-functions-inline lib/Kconfig
--- a/lib/Kconfig~llist-make-all-llist-functions-inline
+++ a/lib/Kconfig
@@ -276,7 +276,4 @@ config CORDIC
 	  so its calculations are in fixed point. Modules can select this
 	  when they require this function. Module will be called cordic.
 
-config LLIST
-	bool
-
 endmenu
diff -puN lib/Makefile~llist-make-all-llist-functions-inline lib/Makefile
--- a/lib/Makefile~llist-make-all-llist-functions-inline
+++ a/lib/Makefile
@@ -115,8 +115,6 @@ obj-$(CONFIG_CPU_RMAP) += cpu_rmap.o
 
 obj-$(CONFIG_CORDIC) += cordic.o
 
-obj-$(CONFIG_LLIST) += llist.o
-
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff -puN lib/llist.c~llist-make-all-llist-functions-inline /dev/null
--- a/lib/llist.c
+++ /dev/null
@@ -1,129 +0,0 @@
-/*
- * Lock-less NULL terminated single linked list
- *
- * The basic atomic operation of this list is cmpxchg on long.  On
- * architectures that don't have NMI-safe cmpxchg implementation, the
- * list can NOT be used in NMI handler.  So code uses the list in NMI
- * handler should depend on CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG.
- *
- * Copyright 2010,2011 Intel Corp.
- *   Author: Huang Ying <ying.huang@intel.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License version
- * 2 as published by the Free Software Foundation;
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/interrupt.h>
-#include <linux/llist.h>
-
-#include <asm/system.h>
-
-/**
- * llist_add - add a new entry
- * @new:	new entry to be added
- * @head:	the head for your lock-less list
- */
-void llist_add(struct llist_node *new, struct llist_head *head)
-{
-	struct llist_node *entry, *old_entry;
-
-#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
-	BUG_ON(in_nmi());
-#endif
-
-	entry = head->first;
-	do {
-		old_entry = entry;
-		new->next = entry;
-		cpu_relax();
-	} while ((entry = cmpxchg(&head->first, old_entry, new)) != old_entry);
-}
-EXPORT_SYMBOL_GPL(llist_add);
-
-/**
- * llist_add_batch - add several linked entries in batch
- * @new_first:	first entry in batch to be added
- * @new_last:	last entry in batch to be added
- * @head:	the head for your lock-less list
- */
-void llist_add_batch(struct llist_node *new_first, struct llist_node *new_last,
-		     struct llist_head *head)
-{
-	struct llist_node *entry, *old_entry;
-
-#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
-	BUG_ON(in_nmi());
-#endif
-
-	entry = head->first;
-	do {
-		old_entry = entry;
-		new_last->next = entry;
-		cpu_relax();
-	} while ((entry = cmpxchg(&head->first, old_entry, new_first)) != old_entry);
-}
-EXPORT_SYMBOL_GPL(llist_add_batch);
-
-/**
- * llist_del_first - delete the first entry of lock-less list
- * @head:	the head for your lock-less list
- *
- * If list is empty, return NULL, otherwise, return the first entry
- * deleted, this is the newest added one.
- *
- * Only one llist_del_first user can be used simultaneously with
- * multiple llist_add users without lock.  Because otherwise
- * llist_del_first, llist_add, llist_add (or llist_del_all, llist_add,
- * llist_add) sequence in another user may change @head->first->next,
- * but keep @head->first.  If multiple consumers are needed, please
- * use llist_del_all or use lock between consumers.
- */
-struct llist_node *llist_del_first(struct llist_head *head)
-{
-	struct llist_node *entry, *old_entry, *next;
-
-#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
-	BUG_ON(in_nmi());
-#endif
-
-	entry = head->first;
-	do {
-		if (entry == NULL)
-			return NULL;
-		old_entry = entry;
-		next = entry->next;
-		cpu_relax();
-	} while ((entry = cmpxchg(&head->first, old_entry, next)) != old_entry);
-
-	return entry;
-}
-EXPORT_SYMBOL_GPL(llist_del_first);
-
-/**
- * llist_del_all - delete all entries from lock-less list
- * @head:	the head of lock-less list to delete all entries
- *
- * If list is empty, return NULL, otherwise, delete all entries and
- * return the pointer to the first entry.  The order of entries
- * deleted is from the newest to the oldest added one.
- */
-struct llist_node *llist_del_all(struct llist_head *head)
-{
-#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
-	BUG_ON(in_nmi());
-#endif
