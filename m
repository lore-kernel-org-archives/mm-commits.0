From: akpm@linux-foundation.org
Subject: + listh-add-debug-version-of-list_empty.patch added to -mm tree
Date: Tue, 15 Mar 2011 13:45:42 -0700
Message-ID: <201103152045.p2FKjg5d010319@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40639 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758414Ab1COUqG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Mar 2011 16:46:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-phil.2.carmody@nokia.com, andi@firstfloor.org, kirill@shutemov.name, lizf@cn.fujitsu.com, menage@google.com


The patch titled
     list.h: add debug version of list_empty
has been added to the -mm tree.  Its filename is
     listh-add-debug-version-of-list_empty.patch

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
Subject: list.h: add debug version of list_empty
From: Phil Carmody <ext-phil.2.carmody@nokia.com>

Heed the notice in list_del: "Note: list_empty() on entry does not return
true after this, the entry is in an undefined state.", and check for
precisely that condition.

There are currently a few instances in the code of this sequence:

    if(!list_empty(pnode))
        list_del(pnode);

which seems to be useless or dangerous if intended to protect from
repeated del's.  And given that I've seen an oops pointing to a
dereference of poison in such a list_empty, I'm veering towards dangerous.
This patch would make such errors obvious.

Nothing is changed in the non-DEBUG_LIST build.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |    4 ++++
 lib/list_debug.c     |   18 ++++++++++++++++++
 2 files changed, 22 insertions(+)

diff -puN include/linux/list.h~listh-add-debug-version-of-list_empty include/linux/list.h
--- a/include/linux/list.h~listh-add-debug-version-of-list_empty
+++ a/include/linux/list.h
@@ -183,10 +183,14 @@ static inline int list_is_last(const str
  * list_empty - tests whether a list is empty
  * @head: the list to test.
  */
+#ifndef CONFIG_DEBUG_LIST
 static inline int list_empty(const struct list_head *head)
 {
 	return head->next == head;
 }
+#else
+extern int list_empty(const struct list_head *head);
+#endif
 
 /**
  * list_empty_careful - tests whether a list is empty and not being modified
diff -puN lib/list_debug.c~listh-add-debug-version-of-list_empty lib/list_debug.c
--- a/lib/list_debug.c~listh-add-debug-version-of-list_empty
+++ a/lib/list_debug.c
@@ -73,3 +73,21 @@ void list_del(struct list_head *entry)
 	entry->prev = LIST_POISON2;
 }
 EXPORT_SYMBOL(list_del);
+
+/**
+ * list_empty - tests whether a list is empty
+ * @head: the list to test.
+ */
+int list_empty(const struct list_head *head)
+{
+	if ((head->prev == LIST_POISON2) || (head->prev == LIST_POISON1))
+		WARN(1, "list_empty performed on a node "
+		     "at %p removed from a list.\n", head);
+	else
+		WARN((head->prev == head) != (head->next == head),
+		     "list_empty corruption. %p<-%p->%p is half-empty.\n",
+		     head->prev, head, head->next);
+
+	return head->next == head;
+}
+EXPORT_SYMBOL(list_empty);
_

Patches currently in -mm which might be from ext-phil.2.carmody@nokia.com are

cgroups-if-you-list_empty-a-head-then-dont-list_del-it.patch
linux-next.patch
calibrate-extract-fall-back-calculation-into-own-helper.patch
calibrate-home-in-on-correct-lpj-value-more-quickly.patch
calibrate-retry-with-wider-bounds-when-converge-seems-to-fail.patch
calibrate-retry-with-wider-bounds-when-converge-seems-to-fail-fix.patch
listh-add-debug-version-of-list_empty.patch

