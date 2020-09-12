Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33FAEC433E2
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:56:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F334421D79
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599940584;
	bh=HJblLBjsB/rx4jUtgR/2O8soAgAcGOCkmorQQUjYUdY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=QTjEMfuwccmv29JYeP9xKlDXrMzRNXadP6ribPV6YigaUhVhRWVaOj+61GtW7fV8y
	 PbL/zwQ5gOpE14TS/IUdKRs4zTuYkCHZnzIJ/AurblJY9WOApD3bUTZaY00CdY1rMf
	 TFfEyfQixUnWL6WPi5eaWOhrzxWs3ZaGh6BdEzi0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725875AbgILT4X (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 15:56:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgILT4W (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 15:56:22 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B4A121531;
        Sat, 12 Sep 2020 19:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599940581;
        bh=HJblLBjsB/rx4jUtgR/2O8soAgAcGOCkmorQQUjYUdY=;
        h=Date:From:To:Subject:From;
        b=iVVEfdtCecZv8DO6oaqYU9kSjbowSlTHIZNbxXa9Fs9inuFL6vIJ8LX7WkfHIvzPm
         3z2T144Ho+dE/ir/tdWpEUPKMURiRQzDu3NIho7K8qLtH1HO5I/SdmFTBPX5dD7jHJ
         73trV7BdiaevfZ28dssnkq4R905tO7CFqTCoOEs8=
Date:   Sat, 12 Sep 2020 12:56:20 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, trong@android.com,
        gregkh@linuxfoundation.org, corbet@lwn.net, swboyd@chromium.org
Subject:  +
 idr-document-calling-context-for-ida-apis-mustnt-use-locks.patch added to -mm
 tree
Message-ID: <20200912195620.R14zu%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/idr.c: document calling context for IDA APIs mustn't use locks
has been added to the -mm tree.  Its filename is
     idr-document-calling-context-for-ida-apis-mustnt-use-locks.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/idr-document-calling-context-for-ida-apis-mustnt-use-locks.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/idr-document-calling-context-for-ida-apis-mustnt-use-locks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Boyd <swboyd@chromium.org>
Subject: lib/idr.c: document calling context for IDA APIs mustn't use locks

The documentation for these functions indicates that callers don't need to
hold a lock while calling them, but that documentation is only in one
place under "IDA Usage".  Let's state the same information on each IDA
function so that it's clear what the calling context requires. 
Furthermore, let's document ida_simple_get() with the same information so
that callers know how this API works.

Link: https://lkml.kernel.org/r/20200910055246.2297797-1-swboyd@chromium.org
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tri Vo <trong@android.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |    9 ++++++---
 lib/idr.c           |    9 ++++++---
 2 files changed, 12 insertions(+), 6 deletions(-)

--- a/include/linux/idr.h~idr-document-calling-context-for-ida-apis-mustnt-use-locks
+++ a/include/linux/idr.h
@@ -263,7 +263,8 @@ void ida_destroy(struct ida *ida);
  *
  * Allocate an ID between 0 and %INT_MAX, inclusive.
  *
- * Context: Any context.
+ * Context: Any context. It is safe to call this function without
+ * locking in your code.
  * Return: The allocated ID, or %-ENOMEM if memory could not be allocated,
  * or %-ENOSPC if there are no free IDs.
  */
@@ -280,7 +281,8 @@ static inline int ida_alloc(struct ida *
  *
  * Allocate an ID between @min and %INT_MAX, inclusive.
  *
- * Context: Any context.
+ * Context: Any context. It is safe to call this function without
+ * locking in your code.
  * Return: The allocated ID, or %-ENOMEM if memory could not be allocated,
  * or %-ENOSPC if there are no free IDs.
  */
@@ -297,7 +299,8 @@ static inline int ida_alloc_min(struct i
  *
  * Allocate an ID between 0 and @max, inclusive.
  *
- * Context: Any context.
+ * Context: Any context. It is safe to call this function without
+ * locking in your code.
  * Return: The allocated ID, or %-ENOMEM if memory could not be allocated,
  * or %-ENOSPC if there are no free IDs.
  */
--- a/lib/idr.c~idr-document-calling-context-for-ida-apis-mustnt-use-locks
+++ a/lib/idr.c
@@ -372,7 +372,8 @@ EXPORT_SYMBOL(idr_replace);
  * Allocate an ID between @min and @max, inclusive.  The allocated ID will
  * not exceed %INT_MAX, even if @max is larger.
  *
- * Context: Any context.
+ * Context: Any context. It is safe to call this function without
+ * locking in your code.
  * Return: The allocated ID, or %-ENOMEM if memory could not be allocated,
  * or %-ENOSPC if there are no free IDs.
  */
@@ -479,7 +480,8 @@ EXPORT_SYMBOL(ida_alloc_range);
  * @ida: IDA handle.
  * @id: Previously allocated ID.
  *
- * Context: Any context.
+ * Context: Any context. It is safe to call this function without
+ * locking in your code.
  */
 void ida_free(struct ida *ida, unsigned int id)
 {
@@ -531,7 +533,8 @@ EXPORT_SYMBOL(ida_free);
  * or freed.  If the IDA is already empty, there is no need to call this
  * function.
  *
- * Context: Any context.
+ * Context: Any context. It is safe to call this function without
+ * locking in your code.
  */
 void ida_destroy(struct ida *ida)
 {
_

Patches currently in -mm which might be from swboyd@chromium.org are

idr-document-calling-context-for-ida-apis-mustnt-use-locks.patch
idr-document-that-ida_simple_getremove-are-deprecated.patch

