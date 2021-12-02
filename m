Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A7C6C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Dec 2021 04:30:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355425AbhLBEdl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Dec 2021 23:33:41 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:39644 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355407AbhLBEdl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Dec 2021 23:33:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D131CCE2079
        for <mm-commits@vger.kernel.org>; Thu,  2 Dec 2021 04:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99D8C00446;
        Thu,  2 Dec 2021 04:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638419415;
        bh=KafVUpUDdq2iFUfa+/Z727hk6f7An7o2hFGyUN6VxT0=;
        h=Date:From:To:Subject:From;
        b=dkred5KmVTasKSE2C8BEkE9rc2FsVo3bNBuliQfWWmP4g7URLWU6bZWHbkxFJiscd
         QiSu1ga9O0U5qq/kp87CM8r04/9hXIc97f9PcEAI53WXynlmsnl4FlqNTn909O8VeM
         K3rtYtbu6Rz53p/ouFXuaB5pb1hMxM0Km8rHihvI=
Date:   Wed, 01 Dec 2021 20:30:15 -0800
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, heikki.krogerus@linux.intel.com,
        mm-commits@vger.kernel.org
Subject:  +
 list-introduce-list_is_head-helper-and-re-use-it-in-listh.patch added to
 -mm tree
Message-ID: <20211202043015.lk53BDNj-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: list: introduce list_is_head() helper and re-use it in list.h
has been added to the -mm tree.  Its filename is
     list-introduce-list_is_head-helper-and-re-use-it-in-listh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/list-introduce-list_is_head-helper-and-re-use-it-in-listh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/list-introduce-list_is_head-helper-and-re-use-it-in-listh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

list-introduce-list_is_head-helper-and-re-use-it-in-listh.patch

