Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07DF5C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:48:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFBAF208C7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816493;
	bh=vd9iw5yMH+xYduXNN1/Olu/sWY4FzPloiEXCcQcv3zY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=L03/5xrKzOaxgxiKdhQjzkHUUReDHELq/EDmWRbFzg7JlLUqM89g0cbJlHrOOnomG
	 oqhbSsNoPxi3pjOI9EQeVTpqQ6JQJ1Flehca6oIO0CaJw6iHudvwL2JDTKK+el77wU
	 E+N72IZEgPBKgtAXdkuToxnu+vuJCEgUYtQSSMqc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404360AbgJPCsN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:48:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:35792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404351AbgJPCsN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:48:13 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51C0D2074D;
        Fri, 16 Oct 2020 02:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816490;
        bh=vd9iw5yMH+xYduXNN1/Olu/sWY4FzPloiEXCcQcv3zY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0NAix3oQ710HZjSva4gaWlsAAt7CZWBZrhuiOqUkGVmVuM6OGig5D5NhJup3OGfGZ
         3cYOX70rJ4DH49RwZ8wzCY7iRzOUcx61rnl51i0ECil+toxgshbTnM5Thk84QdhnZy
         FRmtpmhoAzCYyhHCSUchkJcFGD3c/nbuaYx/0VrI=
Date:   Thu, 15 Oct 2020 19:48:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net,
        gregkh@linuxfoundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, swboyd@chromium.org,
        torvalds@linux-foundation.org, trong@android.com,
        willy@infradead.org
Subject:  [patch 112/156] lib/idr.c: document calling context for
 IDA APIs mustn't use locks
Message-ID: <20201016024809.FkcEF0WY5%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
