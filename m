Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7308AC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377927AbiATVa2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:30:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39694 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377925AbiATVa0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:30:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F4A86188A
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98308C340E0;
        Thu, 20 Jan 2022 21:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714224;
        bh=bP/OtNjOEWvMcw6x1zfwF8AmgjPIx2a+1thISv9qHnQ=;
        h=Date:From:To:Subject:From;
        b=DglOH7DGDaPwU0LFZGZKzRmgDZPFC/8TaYnKVLhQ4iRXQfIdqIvWyY4Yn4sUEJyQk
         Z/Fm2i7HufD1sKi9TKOBo2ju+ryA1ufoEynO5LWM1MybCgsz+xacB5lWgi2N4jzYx8
         pkoVQX60E4cXZJjFs54TNiLitG3LXuHkeTqKZLDI=
Date:   Thu, 20 Jan 2022 13:30:24 -0800
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, heikki.krogerus@linux.intel.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 list-introduce-list_is_head-helper-and-re-use-it-in-listh.patch removed
 from -mm tree
Message-ID: <20220120213024.0lWO0XJZ7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: list: introduce list_is_head() helper and re-use it in list.h
has been removed from the -mm tree.  Its filename was
     list-introduce-list_is_head-helper-and-re-use-it-in-listh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: list: introduce list_is_head() helper and re-use it in list.h

Introduce list_is_head() in the similar (*) way as it's done for
list_entry_is_head().  Make use of it in the list.h.

*) it's done as inliner and not a macro to be aligned with other
   list_is_*() APIs; while at it, make all three to have the same
   style.

Link: https://lkml.kernel.org/r/20211201141824.81400-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |   36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

--- a/include/linux/list.h~list-introduce-list_is_head-helper-and-re-use-it-in-listh
+++ a/include/linux/list.h
@@ -258,8 +258,7 @@ static inline void list_bulk_move_tail(s
  * @list: the entry to test
  * @head: the head of the list
  */
-static inline int list_is_first(const struct list_head *list,
-					const struct list_head *head)
+static inline int list_is_first(const struct list_head *list, const struct list_head *head)
 {
 	return list->prev == head;
 }
@@ -269,13 +268,22 @@ static inline int list_is_first(const st
  * @list: the entry to test
  * @head: the head of the list
  */
-static inline int list_is_last(const struct list_head *list,
-				const struct list_head *head)
+static inline int list_is_last(const struct list_head *list, const struct list_head *head)
 {
 	return list->next == head;
 }
 
 /**
+ * list_is_head - tests whether @list is the list @head
+ * @list: the entry to test
+ * @head: the head of the list
+ */
+static inline int list_is_head(const struct list_head *list, const struct list_head *head)
+{
+	return list == head;
+}
+
+/**
  * list_empty - tests whether a list is empty
  * @head: the list to test.
  */
@@ -318,7 +326,7 @@ static inline void list_del_init_careful
 static inline int list_empty_careful(const struct list_head *head)
 {
 	struct list_head *next = smp_load_acquire(&head->next);
-	return (next == head) && (next == head->prev);
+	return list_is_head(next, head) && (next == head->prev);
 }
 
 /**
@@ -393,10 +401,9 @@ static inline void list_cut_position(str
 {
 	if (list_empty(head))
 		return;
-	if (list_is_singular(head) &&
-		(head->next != entry && head != entry))
+	if (list_is_singular(head) && !list_is_head(entry, head) && (entry != head->next))
 		return;
-	if (entry == head)
+	if (list_is_head(entry, head))
 		INIT_LIST_HEAD(list);
 	else
 		__list_cut_position(list, head, entry);
@@ -570,7 +577,7 @@ static inline void list_splice_tail_init
  * @head:	the head for your list.
  */
 #define list_for_each(pos, head) \
-	for (pos = (head)->next; pos != (head); pos = pos->next)
+	for (pos = (head)->next; !list_is_head(pos, (head)); pos = pos->next)
 
 /**
  * list_for_each_continue - continue iteration over a list
@@ -580,7 +587,7 @@ static inline void list_splice_tail_init
  * Continue to iterate over a list, continuing after the current position.
  */
 #define list_for_each_continue(pos, head) \
-	for (pos = pos->next; pos != (head); pos = pos->next)
+	for (pos = pos->next; !list_is_head(pos, (head)); pos = pos->next)
 
 /**
  * list_for_each_prev	-	iterate over a list backwards
@@ -588,7 +595,7 @@ static inline void list_splice_tail_init
  * @head:	the head for your list.
  */
 #define list_for_each_prev(pos, head) \
-	for (pos = (head)->prev; pos != (head); pos = pos->prev)
+	for (pos = (head)->prev; !list_is_head(pos, (head)); pos = pos->prev)
 
 /**
  * list_for_each_safe - iterate over a list safe against removal of list entry
@@ -597,8 +604,9 @@ static inline void list_splice_tail_init
  * @head:	the head for your list.
  */
 #define list_for_each_safe(pos, n, head) \
-	for (pos = (head)->next, n = pos->next; pos != (head); \
-		pos = n, n = pos->next)
+	for (pos = (head)->next, n = pos->next; \
+	     !list_is_head(pos, (head)); \
+	     pos = n, n = pos->next)
 
 /**
  * list_for_each_prev_safe - iterate over a list backwards safe against removal of list entry
@@ -608,7 +616,7 @@ static inline void list_splice_tail_init
  */
 #define list_for_each_prev_safe(pos, n, head) \
 	for (pos = (head)->prev, n = pos->prev; \
-	     pos != (head); \
+	     !list_is_head(pos, (head)); \
 	     pos = n, n = pos->prev)
 
 /**
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


