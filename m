From: akpm@linux-foundation.org
Subject: + llist-introduce-llist_entry_safe.patch added to -mm tree
Date: Mon, 26 Sep 2016 16:37:06 -0700
Message-ID: <57e9b122./mFIr2FqRnD1VIsK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47312 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932504AbcIZXhH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2016 19:37:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glider@google.com, dvyukov@google.com, edumazet@google.com, kcc@google.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: llist: introduce llist_entry_safe()
has been added to the -mm tree.  Its filename is
     llist-introduce-llist_entry_safe.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/llist-introduce-llist_entry_safe.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/llist-introduce-llist_entry_safe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: llist: introduce llist_entry_safe()

Currently llist_for_each_entry() and llist_for_each_entry_safe() iterate
until &pos->member != NULL.  But when building the kernel with Clang, the
compiler assumes &pos->member cannot be NULL if the member's offset is
greater than 0.  Therefore the loop condition is always true, and the
loops become infinite.

To work around this, introduce llist_entry_safe(), which returns NULL for
NULL pointers, and additionally check that pos is not NULL in the list
iterators before dereferencing it.

Link: http://lkml.kernel.org/r/1474636978-41435-3-git-send-email-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Kostya Serebryany <kcc@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/llist.h |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff -puN include/linux/llist.h~llist-introduce-llist_entry_safe include/linux/llist.h
--- a/include/linux/llist.h~llist-introduce-llist_entry_safe
+++ a/include/linux/llist.h
@@ -88,6 +88,16 @@ static inline void init_llist_head(struc
 	container_of(ptr, type, member)
 
 /**
+ * llist_entry_safe - get the struct of this entry without overflowing
+ * @ptr:	the &struct llist_node pointer.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the llist_node within the struct.
+ */
+#define llist_entry_safe(ptr, type, member)		\
+	container_of_safe(ptr, type, member)
+
+
+/**
  * llist_for_each - iterate over some deleted entries of a lock-less list
  * @pos:	the &struct llist_node to use as a loop cursor
  * @node:	the first entry of deleted list entries
@@ -120,9 +130,10 @@ static inline void init_llist_head(struc
  * reverse the order by yourself before traversing.
  */
 #define llist_for_each_entry(pos, node, member)				\
-	for ((pos) = llist_entry((node), typeof(*(pos)), member);	\
-	     &(pos)->member != NULL;					\
-	     (pos) = llist_entry((pos)->member.next, typeof(*(pos)), member))
+	for ((pos) = llist_entry_safe((node), typeof(*(pos)), member);	\
+	     pos != NULL && &(pos)->member != NULL;			\
+	     (pos) = llist_entry_safe((pos)->member.next, \
+					typeof(*(pos)), member))
 
 /**
  * llist_for_each_entry_safe - iterate over some deleted entries of lock-less list of given type
@@ -141,10 +152,11 @@ static inline void init_llist_head(struc
  * you want to traverse from the oldest to the newest, you must
  * reverse the order by yourself before traversing.
  */
-#define llist_for_each_entry_safe(pos, n, node, member)			       \
-	for (pos = llist_entry((node), typeof(*pos), member);		       \
-	     &pos->member != NULL &&					       \
-	        (n = llist_entry(pos->member.next, typeof(*n), member), true); \
+#define llist_for_each_entry_safe(pos, n, node, member)			     \
+	for (pos = llist_entry_safe((node), typeof(*pos), member);	     \
+	     pos != NULL && &pos->member != NULL &&			     \
+		(n = llist_entry_safe(pos->member.next, typeof(*n), member), \
+		 true); \
 	     pos = n)
 
 /**
_

Patches currently in -mm which might be from glider@google.com are

include-linux-provide-a-safe-version-of-container_of.patch
llist-introduce-llist_entry_safe.patch
kcov-do-not-instrument-lib-stackdepotc.patch

