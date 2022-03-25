Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD781C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:43:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233999AbiCYWof (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233970AbiCYWoQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:44:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C01520C18A
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:42:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A38DBB82A1E
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:42:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533D7C340ED;
        Fri, 25 Mar 2022 22:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248159;
        bh=m9rMpsnPhjBhurewlMsSGdopFxpPsO5mbJDBn5xVOCg=;
        h=Date:To:From:Subject:From;
        b=UMDhnRhgxD/mwr3AhZFmE4xXQEDh2Sf2SkjIjDhxjSPILW0iZZtHhVakfagutE3SC
         3N/7yEhOW3mKMcobduQDkSJV5VcuXhS79s5FWzO0swc9p28Upt7/AWE3sz6/Oig/t6
         1VBBdoXdUcCX0BTc323YGXdritZGKo+5PIO9qJ68=
Date:   Fri, 25 Mar 2022 15:42:38 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com, elver@google.com,
        andreyknvl@gmail.com, pcc@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-update-function-name-in-comments.patch removed from -mm tree
Message-Id: <20220325224239.533D7C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: update function name in comments
has been removed from the -mm tree.  Its filename was
     kasan-update-function-name-in-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from pcc@google.com are


