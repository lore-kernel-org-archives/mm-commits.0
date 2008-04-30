From: akpm@linux-foundation.org
Subject: - lists-add-const-qualifier-to-first-arg-of-list_splice-operations.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:40:52 -0700
Message-ID: <200804300540.m3U5eqUL029006@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756163AbYD3Fl1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:41:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, mm-commits@vger.kernel.org


The patch titled
     lists: add "const" qualifier to first arg of list_splice() operations
has been removed from the -mm tree.  Its filename was
     lists-add-const-qualifier-to-first-arg-of-list_splice-operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lists: add "const" qualifier to first arg of list_splice() operations
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Since neither the list_splice() nor __list_splice() routines modify their
first argument, might as well declare them "const".

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/list.h~lists-add-const-qualifier-to-first-arg-of-list_splice-operations include/linux/list.h
--- a/include/linux/list.h~lists-add-const-qualifier-to-first-arg-of-list_splice-operations
+++ a/include/linux/list.h
@@ -328,7 +328,7 @@ static inline int list_is_singular(const
 	return !list_empty(head) && (head->next == head->prev);
 }
 
-static inline void __list_splice(struct list_head *list,
+static inline void __list_splice(const struct list_head *list,
 				 struct list_head *head)
 {
 	struct list_head *first = list->next;
@@ -347,7 +347,8 @@ static inline void __list_splice(struct 
  * @list: the new list to add.
  * @head: the place to add it in the first list.
  */
-static inline void list_splice(struct list_head *list, struct list_head *head)
+static inline void list_splice(const struct list_head *list,
+				struct list_head *head)
 {
 	if (!list_empty(list))
 		__list_splice(list, head);
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
git-dvb.patch
git-mtd.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
remove-ifdef-__kernel__-checks-from-unexported-headers.patch
remove-__kernel__-tests-of-unexported-headers-under-asm-generic.patch
drop-the-exporting-of-empty-linux-byteorder-generich.patch

