From: akpm@linux-foundation.org
Subject: - lists-remove-a-redundant-conditional-definition-of-list_add.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:54:24 -0700
Message-ID: <200807252254.m6PMsOAY002813@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752279AbYGYWyt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:54:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     lists: remove a redundant conditional definition of list_add()
has been removed from the -mm tree.  Its filename was
     lists-remove-a-redundant-conditional-definition-of-list_add.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lists: remove a redundant conditional definition of list_add()
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Remove the conditional surrounding the definition of list_add() from list.h
since, if you define CONFIG_DEBUG_LIST, the definition you will subsequently
pick up from lib/list_debug.c will be absolutely identical, at which point you
can remove that redundant definition from list_debug.c as well.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |    4 ----
 lib/list_debug.c     |   14 --------------
 2 files changed, 18 deletions(-)

diff -puN include/linux/list.h~lists-remove-a-redundant-conditional-definition-of-list_add include/linux/list.h
--- a/include/linux/list.h~lists-remove-a-redundant-conditional-definition-of-list_add
+++ a/include/linux/list.h
@@ -61,14 +61,10 @@ extern void __list_add(struct list_head 
  * Insert a new entry after the specified head.
  * This is good for implementing stacks.
  */
-#ifndef CONFIG_DEBUG_LIST
 static inline void list_add(struct list_head *new, struct list_head *head)
 {
 	__list_add(new, head, head->next);
 }
-#else
-extern void list_add(struct list_head *new, struct list_head *head);
-#endif
 
 
 /**
diff -puN lib/list_debug.c~lists-remove-a-redundant-conditional-definition-of-list_add lib/list_debug.c
--- a/lib/list_debug.c~lists-remove-a-redundant-conditional-definition-of-list_add
+++ a/lib/list_debug.c
@@ -40,20 +40,6 @@ void __list_add(struct list_head *new,
 EXPORT_SYMBOL(__list_add);
 
 /**
- * list_add - add a new entry
- * @new: new entry to be added
- * @head: list head to add it after
- *
- * Insert a new entry after the specified head.
- * This is good for implementing stacks.
- */
-void list_add(struct list_head *new, struct list_head *head)
-{
-	__list_add(new, head, head->next);
-}
-EXPORT_SYMBOL(list_add);
