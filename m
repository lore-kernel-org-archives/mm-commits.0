From: akpm@linux-foundation.org
Subject: + llist-lib-add-lock-less-null-terminated-single-list.patch added to -mm tree
Date: Wed, 19 Jan 2011 14:02:48 -0800
Message-ID: <201101192202.p0JM2mes005824@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754046Ab1ASWFX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Jan 2011 17:05:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ying.huang@intel.com, ak@linux.intel.com, andy.grover@oracle.com, benh@kernel.crashing.org, chris@zankel.net, cmetcalf@tilera.com, davem@davemloft.net, dhowells@redhat.com, geert@linux-m68k.org, hans-christian.egtvedt@atmel.com, kyle@mcmartin.ca, lethal@linux-sh.org, linux@arm.linux.org.uk, liqin.chen@sunplusct.com, mingo@redhat.com, monstr@monstr.eu, ralf@linux-mips.org, rth@twiddle.net, schwidefsky@de.ibm.com, starvik@axis.com, takata@linux-m32r.org, tony.luck@intel.com, vapier@gentoo.org, ysato@users.sourceforge.jp


The patch titled
     llist: lib, Add lock-less NULL terminated single list
has been added to the -mm tree.  Its filename is
     llist-lib-add-lock-less-null-terminated-single-list.patch

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
Subject: llist: lib, Add lock-less NULL terminated single list
From: Huang Ying <ying.huang@intel.com>

Cmpxchg is used to implement adding new entry to the list, deleting all
entries from the list, deleting first entry of the list and some other
operations.

Because this is a single list, so the tail can not be accessed in O(1).

If there are multiple producers and multiple consumers, llist_add can be
used in producers and llist_del_all can be used in consumers.  They can
work simultaneously without lock.  But llist_del_first can not be used
here.  Because llist_del_first depends on list->first->next does not
changed if list->first is not changed during its operation, but
llist_del_first, llist_add, llist_add sequence in another consumer may
violate that.

If there are multiple producers and one consumer, llist_add can be used in
producers and llist_del_all or llist_del_first can be used in the
consumer.

The list entries deleted via llist_del_all can be traversed with
traversing function such as llist_for_each etc.  But the list entries can
not be traversed safely before deleted from the list without proper
synchronization with the list consumers.

The basic atomic operation of this list is cmpxchg on long.  On
architectures that don't have NMI-safe cmpxchg implementation, the list
can NOT be used in NMI handler.  So code uses the list in NMI handler
should depend on CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mikael Starvik <starvik@axis.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Andy Grover <andy.grover@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/llist.h |   99 +++++++++++++++++++++++++++++++++
 lib/Kconfig           |    3 +
 lib/Makefile          |    2 
 lib/llist.c           |  119 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 223 insertions(+)

diff -puN /dev/null include/linux/llist.h
--- /dev/null
+++ a/include/linux/llist.h
@@ -0,0 +1,99 @@
+#ifndef LLIST_H
+#define LLIST_H
+/*
+ * Lock-less NULL terminated single linked list
+ *
+ * If there are multiple producers and multiple consumers, llist_add
+ * can be used in producers and llist_del_all can be used in
+ * consumers.  They can work simultaneously without lock.  But
+ * llist_del_first can not be used here.  Because llist_del_first
+ * depends on list->first->next does not changed if list->first is not
+ * changed during its operation, but llist_del_first, llist_add,
+ * llist_add sequence in another consumer may violate that.
+ *
+ * If there are multiple producers and one consumer, llist_add can be
+ * used in producers and llist_del_all or llist_del_first can be used
+ * in the consumer.
+ *
+ * The list entries deleted via llist_del_all can be traversed with
+ * traversing function such as llist_for_each etc.  But the list
+ * entries can not be traversed safely before deleted from the list
+ * without proper synchronization with the list consumers.
+ *
+ * The basic atomic operation of this list is cmpxchg on long.  On
+ * architectures that don't have NMI-safe cmpxchg implementation, the
+ * list can NOT be used in NMI handler.  So code uses the list in NMI
+ * handler should depend on CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG.
+ */
+
+struct llist_head {
+	struct llist_node *first;
+};
+
+struct llist_node {
+	struct llist_node *next;
+};
+
+#define LLIST_HEAD_INIT(name)	{ NULL }
+#define LLIST_HEAD(name)	struct llist_head name = LLIST_HEAD_INIT(name)
+
+/**
+ * init_llist_head - initialize lock-less list head
+ * @head:	the head for your lock-less list
+ */
+static inline void init_llist_head(struct llist_head *list)
+{
+	list->first = NULL;
+}
+
+/**
+ * llist_entry - get the struct of this entry
+ * @ptr:	the &struct llist_node pointer.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the llist_node within the struct.
+ */
+#define llist_entry(ptr, type, member)		\
+	container_of(ptr, type, member)
+
+/**
+ * llist_for_each - iterate over some entries of a lock-less list
+ * @pos:	the &struct llist_node to use as a loop cursor
+ * @node:	the first entry of deleted list entries
+ *
+ * In general, some entries of the lock-less list can be traversed
+ * safely only after being deleted from list, so start with an entry
+ * instead of list head.
+ */
+#define llist_for_each(pos, node)			\
+	for (pos = (node); pos; pos = pos->next)
+
+/**
+ * llist_for_each_entry - iterate over some entries of lock-less list of given type
+ * @pos:	the type * to use as a loop cursor.
+ * @node:	the fist entry of deleted list entries.
+ * @member:	the name of the llist_node with the struct.
+ *
+ * In general, some entries of the lock-less list can be traversed
+ * safely only after being removed from list, so start with an entry
+ * instead of list head.
+ */
+#define llist_for_each_entry(pos, node, member)				\
+	for (pos = llist_entry((node), typeof(*pos), member);		\
+	     &pos->member != NULL;					\
+	     pos = llist_entry(pos->member.next, typeof(*pos), member))
+
+/**
+ * llist_empty - tests whether a lock-less list is empty
+ * @head:	the list to test
+ */
+static inline int llist_empty(const struct llist_head *head)
+{
+	return head->first == NULL;
+}
+
+void llist_add(struct llist_node *new, struct llist_head *head);
+void llist_add_batch(struct llist_node *new_first, struct llist_node *new_last,
+		     struct llist_head *head);
+struct llist_node *llist_del_first(struct llist_head *head);
+struct llist_node *llist_del_all(struct llist_head *head);
+#endif /* LLIST_H */
diff -puN lib/Kconfig~llist-lib-add-lock-less-null-terminated-single-list lib/Kconfig
--- a/lib/Kconfig~llist-lib-add-lock-less-null-terminated-single-list
+++ a/lib/Kconfig
@@ -240,4 +240,7 @@ config IOQ
 
 	 If unsure, say N
 
+config LLIST
+	bool
+
 endmenu
diff -puN lib/Makefile~llist-lib-add-lock-less-null-terminated-single-list lib/Makefile
--- a/lib/Makefile~llist-lib-add-lock-less-null-terminated-single-list
+++ a/lib/Makefile
@@ -112,6 +112,8 @@ obj-$(CONFIG_ATOMIC64_SELFTEST) += atomi
 
 obj-$(CONFIG_AVERAGE) += average.o
 
+obj-$(CONFIG_LLIST) += llist.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff -puN /dev/null lib/llist.c
--- /dev/null
+++ a/lib/llist.c
@@ -0,0 +1,119 @@
+/*
+ * Lock-less NULL terminated single linked list
+ *
+ * The basic atomic operation of this list is cmpxchg on long.  On
+ * architectures that don't have NMI-safe cmpxchg implementation, the
+ * list can NOT be used in NMI handler.  So code uses the list in NMI
+ * handler should depend on CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG.
+ *
+ * Copyright 2010 Intel Corp.
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
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/llist.h>
+
+#include <asm/system.h>
+
+/**
+ * llist_add - add a new entry
+ * @new:	new entry to be added
+ * @head:	the head for your lock-less list
+ */
+void llist_add(struct llist_node *new, struct llist_head *head)
+{
+	struct llist_node *entry;
+
+#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
+	BUG_ON(in_nmi());
+#endif
+
+	do {
+		entry = head->first;
+		new->next = entry;
+	} while (cmpxchg(&head->first, entry, new) != entry);
+}
+EXPORT_SYMBOL_GPL(llist_add);
+
+/**
+ * llist_add_batch - add several linked entries in batch
+ * @new_first:	first entry in batch to be added
+ * @new_last:	last entry in batch to be added
+ * @head:	the head for your lock-less list
+ */
+void llist_add_batch(struct llist_node *new_first, struct llist_node *new_last,
+		     struct llist_head *head)
+{
+	struct llist_node *entry;
+
+#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
+	BUG_ON(in_nmi());
+#endif
+
+	do {
+		entry = head->first;
+		new_last->next = entry;
+	} while (cmpxchg(&head->first, entry, new_first) != entry);
+}
+EXPORT_SYMBOL_GPL(llist_add_batch);
+
+/**
+ * llist_del_first - delete the first entry of lock-less list
+ * @head:	the head for your lock-less list
+ *
+ * If list is empty, return NULL, otherwise, return the first entry deleted.
+ *
+ * Only one llist_del_first user can be used simultaneously with
+ * multiple llist_add users without lock. Because otherwise
+ * llist_del_first, llist_add, llist_add sequence in another user may
+ * change @head->first->next, but keep @head->first. If multiple
+ * consumers are needed, please use llist_del_all.
+ */
+struct llist_node *llist_del_first(struct llist_head *head)
+{
+	struct llist_node *entry;
+
+#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
+	BUG_ON(in_nmi());
+#endif
+
+	do {
+		entry = head->first;
+		if (entry == NULL)
+			return NULL;
+	} while (cmpxchg(&head->first, entry, entry->next) != entry);
+
+	return entry;
+}
+EXPORT_SYMBOL_GPL(llist_del_first);
+
+/**
+ * llist_del_all - delete all entries from lock-less list
+ * @head:	the head of lock-less list to delete all entries
+ *
+ * If list is empty, return NULL, otherwise, delete all entries and
+ * return the pointer to the first entry.
+ */
+struct llist_node *llist_del_all(struct llist_head *head)
+{
+#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
+	BUG_ON(in_nmi());
+#endif
+
+	return xchg(&head->first, NULL);
+}
+EXPORT_SYMBOL_GPL(llist_del_all);
_

Patches currently in -mm which might be from ying.huang@intel.com are

llist-add-kconfig-option-arch_have_nmi_safe_cmpxchg.patch
llist-lib-add-lock-less-null-terminated-single-list.patch
llist-irq_work-use-llist-in-irq_work.patch
llist-net-rds-replace-xlist-in-net-rds-xlisth-with-llist.patch

