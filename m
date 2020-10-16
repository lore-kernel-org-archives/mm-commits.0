Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E03EAC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 915AC2145D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881599;
	bh=6llyuXUenEhdKqdhWBRhaagE+3j2DoukBqyZRKG5sYw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=WJeUjjUKnKsC9/iYkNwY1UHq3VWu84o6BQNzwxoJS0pIxieg9rFpcd/XvX+e/WD1s
	 uDJo6AZNJJjWSC/RBg6go16AqRLna3Qtj0Oxkgw1j+B5wmo9+K9rbAFpdOjFS9EzYa
	 WgXgD9Uvs2WCPgRkVxAcngfTyzyrWlWwgLyYaIvE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409122AbgJPUxT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:53:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:41492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409095AbgJPUxT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:53:19 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B75A1205CB;
        Fri, 16 Oct 2020 20:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881598;
        bh=6llyuXUenEhdKqdhWBRhaagE+3j2DoukBqyZRKG5sYw=;
        h=Date:From:To:Subject:From;
        b=PMKt+P2iPbZ9Rjh2Gi1aQdi1PGR5773YsuTJ1dgD5FcNfO71U9e+tqAzRp0TvVLnD
         V4Rj0QMjNgdEcXBnNL3xEbb3Y+rXfypMhmsY/Aud+mPOclkuL1vstibOLtILZDA2Un
         k2bJGiGXERvloVDMuMkc//ZCad5WMG+nTUpySZ2Q=
Date:   Fri, 16 Oct 2020 13:53:17 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, gregkh@linuxfoundation.org,
        mm-commits@vger.kernel.org, swboyd@chromium.org, trong@android.com,
        willy@infradead.org
Subject:  [merged]
 idr-document-calling-context-for-ida-apis-mustnt-use-locks.patch removed
 from -mm tree
Message-ID: <20201016205317.2_X6mZ3Os%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/idr.c: document calling context for IDA APIs mustn't use locks
has been removed from the -mm tree.  Its filename was
     idr-document-calling-context-for-ida-apis-mustnt-use-locks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


