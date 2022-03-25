Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5EC5C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354024AbiCYBN7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357195AbiCYBNu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:13:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85709BD2E4
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:12:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29B6EB8270A
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4DE5C340EC;
        Fri, 25 Mar 2022 01:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170728;
        bh=YYOPx6tAYUSAh1j+lyoATmZ6aGpKrZHhFdYqlfAIIdc=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=CPuZt1rZj3MVeFoMddb9AqWIp6W0Wdimbz9KXYjuNXxEvZ+49b1vu/d3WgSaaZyJX
         WXDvs7anlIHKgy96mv6/ddlEDEWvhIYsRc3CkfVy1SD1peEaQxr++hrcvcQcOtGlVE
         EPV/U/ASKiEq6Hjn6Hr+KJJhUYMIGRFNY7Q/vhk8=
Date:   Thu, 24 Mar 2022 18:12:08 -0700
To:     linmiaohe@huawei.com, elver@google.com, andreyknvl@gmail.com,
        pcc@google.com, akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 071/114] kasan: update function name in comments
Message-Id: <20220325011208.D4DE5C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peter Collingbourne <pcc@google.com>
Subject: kasan: update function name in comments

The function kasan_global_oob was renamed to kasan_global_oob_right, but
the comments referring to it were not updated.  Do so.

Link: https://linux-review.googlesource.com/id/I20faa90126937bbee77d9d44709556c3dd4b40be
Link: https://lkml.kernel.org/r/20220219012433.890941-1-pcc@google.com
Signed-off-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/test_kasan.c~kasan-update-function-name-in-comments
+++ a/lib/test_kasan.c
@@ -786,7 +786,7 @@ static void ksize_uaf(struct kunit *test
 static void kasan_stack_oob(struct kunit *test)
 {
 	char stack_array[10];
-	/* See comment in kasan_global_oob. */
+	/* See comment in kasan_global_oob_right. */
 	char *volatile array = stack_array;
 	char *p = &array[ARRAY_SIZE(stack_array) + OOB_TAG_OFF];
 
@@ -799,7 +799,7 @@ static void kasan_alloca_oob_left(struct
 {
 	volatile int i = 10;
 	char alloca_array[i];
-	/* See comment in kasan_global_oob. */
+	/* See comment in kasan_global_oob_right. */
 	char *volatile array = alloca_array;
 	char *p = array - 1;
 
@@ -814,7 +814,7 @@ static void kasan_alloca_oob_right(struc
 {
 	volatile int i = 10;
 	char alloca_array[i];
-	/* See comment in kasan_global_oob. */
+	/* See comment in kasan_global_oob_right. */
 	char *volatile array = alloca_array;
 	char *p = array + i;
 
_
