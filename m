Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C70EC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3A18216C4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881612;
	bh=FuGELoE0d0PZdGwZAtd7i7OUeW3Yu5r7vkpjuMqeFZs=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=TccDbXSQ2N54QWK1XGAjbZ6LQZwHQmyS0WlDKM67cJFZ8hKSqJV2e6bDdFTEvWAIy
	 U1ICKw+Uxt9rlkkAKgwfpoXKrkfGXpy3ILTxtiW2KWqtgI07vzHLcOWpu+cH+AlpRY
	 Fl2T/508fWMXrIVCCcmLCMB3/3c0aASm2sio3078=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409131AbgJPUxc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:53:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409125AbgJPUxa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:53:30 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B65CC2076C;
        Fri, 16 Oct 2020 20:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881610;
        bh=FuGELoE0d0PZdGwZAtd7i7OUeW3Yu5r7vkpjuMqeFZs=;
        h=Date:From:To:Subject:From;
        b=0TyKRh7Di5K5WX3aD6CjAG+cvDoeqc05nE4kMtZUqfBQxvekRr6iijV1gIJAJEP5+
         9oTvg5b+RAFALgHhw/eqx2hcKVTGOk8hmDXOguDxI+2aa+3TRaiFcjocHoFnnMRRsY
         0UK6a1MK2SRP5mvIh9SOgPOD3ffzXQ/DR/ieWZ5c=
Date:   Fri, 16 Oct 2020 13:53:29 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, cezary.rojewski@intel.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 list-add-a-macro-to-test-if-entry-is-pointing-to-the-head.patch removed
 from -mm tree
Message-ID: <20201016205329.Odg4AhH0b%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/list.h: add a macro to test if entry is pointing to the head
has been removed from the -mm tree.  Its filename was
     list-add-a-macro-to-test-if-entry-is-pointing-to-the-head.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: include/linux/list.h: add a macro to test if entry is pointing to the head

Add a macro to test if entry is pointing to the head of the list which is
useful in cases like:

  list_for_each_entry(pos, &head, member) {
    if (cond)
      break;
  }
  if (list_entry_is_head(pos, &head, member))
    return -ERRNO;

that allows to avoid additional variable to be added to track if loop has
not been stopped in the middle.

While here, convert list_for_each_entry*() family of macros to use a new one.

Link: https://lkml.kernel.org/r/20200929134342.51489-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

--- a/include/linux/list.h~list-add-a-macro-to-test-if-entry-is-pointing-to-the-head
+++ a/include/linux/list.h
@@ -610,6 +610,15 @@ static inline void list_splice_tail_init
 	     pos = n, n = pos->prev)
 
 /**
+ * list_entry_is_head - test if the entry points to the head of the list
+ * @pos:	the type * to cursor
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ */
+#define list_entry_is_head(pos, head, member)				\
+	(&pos->member == (head))
+
+/**
  * list_for_each_entry	-	iterate over list of given type
  * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
@@ -617,7 +626,7 @@ static inline void list_splice_tail_init
  */
 #define list_for_each_entry(pos, head, member)				\
 	for (pos = list_first_entry(head, typeof(*pos), member);	\
-	     &pos->member != (head);					\
+	     !list_entry_is_head(pos, head, member);			\
 	     pos = list_next_entry(pos, member))
 
 /**
@@ -628,7 +637,7 @@ static inline void list_splice_tail_init
  */
 #define list_for_each_entry_reverse(pos, head, member)			\
 	for (pos = list_last_entry(head, typeof(*pos), member);		\
-	     &pos->member != (head); 					\
+	     !list_entry_is_head(pos, head, member); 			\
 	     pos = list_prev_entry(pos, member))
 
 /**
@@ -653,7 +662,7 @@ static inline void list_splice_tail_init
  */
 #define list_for_each_entry_continue(pos, head, member) 		\
 	for (pos = list_next_entry(pos, member);			\
-	     &pos->member != (head);					\
+	     !list_entry_is_head(pos, head, member);			\
 	     pos = list_next_entry(pos, member))
 
 /**
@@ -667,7 +676,7 @@ static inline void list_splice_tail_init
  */
 #define list_for_each_entry_continue_reverse(pos, head, member)		\
 	for (pos = list_prev_entry(pos, member);			\
-	     &pos->member != (head);					\
+	     !list_entry_is_head(pos, head, member);			\
 	     pos = list_prev_entry(pos, member))
 
 /**
@@ -679,7 +688,7 @@ static inline void list_splice_tail_init
  * Iterate over list of given type, continuing from current position.
  */
 #define list_for_each_entry_from(pos, head, member) 			\
-	for (; &pos->member != (head);					\
+	for (; !list_entry_is_head(pos, head, member);			\
 	     pos = list_next_entry(pos, member))
 
 /**
@@ -692,7 +701,7 @@ static inline void list_splice_tail_init
  * Iterate backwards over list of given type, continuing from current position.
  */
 #define list_for_each_entry_from_reverse(pos, head, member)		\
-	for (; &pos->member != (head);					\
+	for (; !list_entry_is_head(pos, head, member);			\
 	     pos = list_prev_entry(pos, member))
 
 /**
@@ -705,7 +714,7 @@ static inline void list_splice_tail_init
 #define list_for_each_entry_safe(pos, n, head, member)			\
 	for (pos = list_first_entry(head, typeof(*pos), member),	\
 		n = list_next_entry(pos, member);			\
-	     &pos->member != (head); 					\
+	     !list_entry_is_head(pos, head, member); 			\
 	     pos = n, n = list_next_entry(n, member))
 
 /**
@@ -721,7 +730,7 @@ static inline void list_splice_tail_init
 #define list_for_each_entry_safe_continue(pos, n, head, member) 		\
 	for (pos = list_next_entry(pos, member), 				\
 		n = list_next_entry(pos, member);				\
-	     &pos->member != (head);						\
+	     !list_entry_is_head(pos, head, member);				\
 	     pos = n, n = list_next_entry(n, member))
 
 /**
@@ -736,7 +745,7 @@ static inline void list_splice_tail_init
  */
 #define list_for_each_entry_safe_from(pos, n, head, member) 			\
 	for (n = list_next_entry(pos, member);					\
-	     &pos->member != (head);						\
+	     !list_entry_is_head(pos, head, member);				\
 	     pos = n, n = list_next_entry(n, member))
 
 /**
@@ -752,7 +761,7 @@ static inline void list_splice_tail_init
 #define list_for_each_entry_safe_reverse(pos, n, head, member)		\
 	for (pos = list_last_entry(head, typeof(*pos), member),		\
 		n = list_prev_entry(pos, member);			\
-	     &pos->member != (head); 					\
+	     !list_entry_is_head(pos, head, member); 			\
 	     pos = n, n = list_prev_entry(n, member))
 
 /**
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


