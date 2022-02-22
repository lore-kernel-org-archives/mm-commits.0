Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09536C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 04:22:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiBVEWZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 23:22:25 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:51656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiBVEWY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 23:22:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25B489310
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 20:15:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B7FC615B7
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 04:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B9B1C340E8;
        Tue, 22 Feb 2022 04:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645503301;
        bh=ceOZax/3EoSO7z9VVa1CXWAjvsalZctmwZ9eSY7XAuI=;
        h=Date:To:From:Subject:From;
        b=rAU3tP9hXIOSI9yGM6oQxKt6Ov9R2VwJE8mr1O32gZK3+AhDS/3WKHBgvUxrUVNf+
         gbznqT8DJm8HIDQRBN2OoTuBwPItaVHgJdiM85KjCkG1Qrnb6R1y4quAIL066tu9XL
         WMQpHYUk+NProfoirSVcSh0ju+/EL620A0ueDocI=
Date:   Mon, 21 Feb 2022 20:15:01 -0800
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com, elver@google.com,
        pcc@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-update-function-name-in-comments.patch added to -mm tree
Message-Id: <20220222041501.9B9B1C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: update function name in comments
has been added to the -mm tree.  Its filename is
     kasan-update-function-name-in-comments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-update-function-name-in-comments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-update-function-name-in-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Collingbourne <pcc@google.com>
Subject: kasan: update function name in comments

The function kasan_global_oob was renamed to kasan_global_oob_right, but
the comments referring to it were not updated.  Do so.

Link: https://linux-review.googlesource.com/id/I20faa90126937bbee77d9d44709556c3dd4b40be
Link: https://lkml.kernel.org/r/20220219012433.890941-1-pcc@google.com
Signed-off-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Marco Elver <elver@google.com>
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

Patches currently in -mm which might be from pcc@google.com are

kasan-update-function-name-in-comments.patch
mm-mmzonec-use-try_cmpxchg-in-page_cpupid_xchg_last.patch

