Return-Path: <SRS0=qjDH=DG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C65D0C4727C
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 20:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FFE12076A
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 20:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601410432;
	bh=hulAM+pz4M2FaVYVZVDjYSU34QC0ipKhZDNShTcERlo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=YUyZe5LYgpqBfypDcJbEUbvcaifhbbY4gB9HmAcOvHPPZz3g1imFs2jNJy/ORi5t5
	 V9BO7J9n/RYybVspcvd9WdhfpbzAdzl4YUZD/YafXmm86i88wltsFddvOfsllfHaSS
	 cMQwec3+FHWpW7UxNSaZSR6WLCvA3/KlyesbcIGw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbgI2UNw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Sep 2020 16:13:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgI2UNv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 29 Sep 2020 16:13:51 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA23D2076A;
        Tue, 29 Sep 2020 20:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601410429;
        bh=hulAM+pz4M2FaVYVZVDjYSU34QC0ipKhZDNShTcERlo=;
        h=Date:From:To:Subject:From;
        b=SXdxGs/40lGYGiymo116BJIgWBWewF45oonsxkF31jesLLUK+XEsKAP3vpZAX6toX
         q8TfhNV2v3CLCtyVCPvVaYPAqUWDWpw3SeFypoTEJmdzs6DMRryIMQphTC3POoftfs
         PdXck55VnIlxKXypDCpPLfUlt0B7RnNWh3Umy2xA=
Date:   Tue, 29 Sep 2020 13:13:48 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, cezary.rojewski@intel.com,
        mm-commits@vger.kernel.org
Subject:  +
 list-add-a-macro-to-test-if-entry-is-pointing-to-the-head.patch added to
 -mm tree
Message-ID: <20200929201348.QghR1pWrt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/list.h: add a macro to test if entry is pointing to the head
has been added to the -mm tree.  Its filename is
     list-add-a-macro-to-test-if-entry-is-pointing-to-the-head.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/list-add-a-macro-to-test-if-entry-is-pointing-to-the-head.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/list-add-a-macro-to-test-if-entry-is-pointing-to-the-head.patch

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

mm-dmapoolc-replace-open-coded-list_for_each_entry_safe.patch
mm-dmapoolc-replace-hard-coded-function-name-with-__func__.patch
kernelh-split-out-min-max-et-al-helpers.patch
list-add-a-macro-to-test-if-entry-is-pointing-to-the-head.patch

