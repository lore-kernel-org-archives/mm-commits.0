From: akpm@linux-foundation.org
Subject: - list-debugging-use-warn_on-instead-of-bug.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:55:28 -0700
Message-ID: <200807252255.m6PMtSwv002980@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754448AbYGYXHQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:07:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, arjan@infradead.org, matthew@wil.cx, mm-commits@vger.kernel.org


The patch titled
     list debugging: use WARN() instead of BUG()
has been removed from the -mm tree.  Its filename was
     list-debugging-use-warn_on-instead-of-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: list debugging: use WARN() instead of BUG()
From: Dave Jones <davej@redhat.com>

Arjan noted that the list_head debugging is BUG'ing when it detects
corruption.  By causing the box to panic immediately, we're possibly
losing some bug reports.  Changing this to a WARN() should mean we at the
least start seeing reports collected at kerneloops.org

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list_debug.c |   36 ++++++++++++++----------------------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff -puN lib/list_debug.c~list-debugging-use-warn_on-instead-of-bug lib/list_debug.c
--- a/lib/list_debug.c~list-debugging-use-warn_on-instead-of-bug
+++ a/lib/list_debug.c
@@ -20,18 +20,14 @@ void __list_add(struct list_head *new,
 			      struct list_head *prev,
 			      struct list_head *next)
 {
-	if (unlikely(next->prev != prev)) {
-		printk(KERN_ERR "list_add corruption. next->prev should be "
-			"prev (%p), but was %p. (next=%p).\n",
-			prev, next->prev, next);
-		BUG();
-	}
-	if (unlikely(prev->next != next)) {
-		printk(KERN_ERR "list_add corruption. prev->next should be "
-			"next (%p), but was %p. (prev=%p).\n",
-			next, prev->next, prev);
-		BUG();
-	}
+	WARN(next->prev != prev,
+		"list_add corruption. next->prev should be "
+		"prev (%p), but was %p. (next=%p).\n",
+		prev, next->prev, next);
+	WARN(prev->next != next,
+		"list_add corruption. prev->next should be "
+		"next (%p), but was %p. (prev=%p).\n",
+		next, prev->next, prev);
 	next->prev = new;
 	new->next = next;
 	new->prev = prev;
@@ -47,16 +43,12 @@ EXPORT_SYMBOL(__list_add);
  */
 void list_del(struct list_head *entry)
 {
-	if (unlikely(entry->prev->next != entry)) {
-		printk(KERN_ERR "list_del corruption. prev->next should be %p, "
-				"but was %p\n", entry, entry->prev->next);
-		BUG();
-	}
-	if (unlikely(entry->next->prev != entry)) {
-		printk(KERN_ERR "list_del corruption. next->prev should be %p, "
-				"but was %p\n", entry, entry->next->prev);
-		BUG();
-	}
+	WARN(entry->prev->next != entry,
+		"list_del corruption. prev->next should be %p, "
+		"but was %p\n", entry, entry->prev->next);
+	WARN(entry->next->prev != entry,
+		"list_del corruption. next->prev should be %p, "
+		"but was %p\n", entry, entry->next->prev);
 	__list_del(entry->prev, entry->next);
 	entry->next = LIST_POISON1;
 	entry->prev = LIST_POISON2;
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
x86-remove-init_mm-export-as-planned-for-2626.patch

