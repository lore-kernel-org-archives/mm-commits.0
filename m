Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0923DC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:11:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A495820878
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817893;
	bh=fnww0eDY2nc5QuOeEIdQygEjQLxesP7fYQ2kuhvFRmc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=gV08wgSdsmMthxE2/yJvn6KnvW/WzaL62G5fKohaMFPuGBySv9rS68iRoaQ5J603U
	 dgXu0Q1Q3mlDuql0bnWd45C7CCvf3tG9wr//L5xsZX1Pxb1JhIiY+dUtJhvKHb5D7W
	 mykrfsO/EaOESnV+KSwXWxaNtYG/JiUy3Hx/goqk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388465AbgJPDLd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:11:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387864AbgJPDLd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:11:33 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3021320878;
        Fri, 16 Oct 2020 03:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817892;
        bh=fnww0eDY2nc5QuOeEIdQygEjQLxesP7fYQ2kuhvFRmc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=siCnyE0/sGEC5On8mHZFmtnwFRoaA6rzC7Hg5hXsXhePqBeQ82QQA2hrY/RXhfkSq
         u27vqAt4N6/IWTT5ssdxxlKbeDsNCkpVAIY9B6RWmFLvlcK3A33L11gUelk1IYdcVe
         UVeUK9o9MeQFjeUW0iYhTJqLPlG3fsENZw+yvFd4=
Date:   Thu, 15 Oct 2020 20:11:31 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        cezary.rojewski@intel.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 116/156] include/linux/list.h: add a macro to test
 if entry is pointing to the head
Message-ID: <20201016031131.wuiVfC3Xo%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
