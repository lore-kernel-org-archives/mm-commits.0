Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4310AC4320E
	for <mm-commits@archiver.kernel.org>; Thu, 12 Aug 2021 20:56:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BD8160ED5
	for <mm-commits@archiver.kernel.org>; Thu, 12 Aug 2021 20:56:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234153AbhHLU4c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Aug 2021 16:56:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:49028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232611AbhHLU4c (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Aug 2021 16:56:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E44760F35;
        Thu, 12 Aug 2021 20:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628801766;
        bh=gcut+rd8EZqtoWmIRIIbn4DdmqBCe4pxBXgcZKBvHHM=;
        h=Date:From:To:Subject:From;
        b=YJzuM6e41GCcxjxDMdku5MHGzninS4l0wJM4/Tcd1qK6SZ7tcEvVwgoKpkwWa8HiQ
         x5QxMQPN7uXYgf7XuguWGfXgZhaKvXKjXuGJdzEynieYdwHVUMSrUP8/pFqWAlooyT
         icG/hpqttB9RLjxDMEBWb2Jk3kxrITSo7foZQfN4=
Date:   Thu, 12 Aug 2021 13:56:06 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, glider@google.com, elver@google.com,
        dvyukov@google.com, aryabinin@virtuozzo.com, andreyknvl@gmail.com
Subject:  + kasan-test-avoid-corrupting-memory-in-kasan_rcu_uaf.patch
 added to -mm tree
Message-ID: <20210812205606._Xvgr%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: test: avoid corrupting memory in kasan_rcu_uaf
has been added to the -mm tree.  Its filename is
     kasan-test-avoid-corrupting-memory-in-kasan_rcu_uaf.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-test-avoid-corrupting-memory-in-kasan_rcu_uaf.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-test-avoid-corrupting-memory-in-kasan_rcu_uaf.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@gmail.com>
Subject: kasan: test: avoid corrupting memory in kasan_rcu_uaf

kasan_rcu_uaf() writes to freed memory via kasan_rcu_reclaim(), which is
only safe with the GENERIC mode (as it uses quarantine).  For other modes,
this test corrupts kernel memory, which might result in a crash.

Turn the write into a read.

Link: https://lkml.kernel.org/r/b6f2c3bf712d2457c783fa59498225b66a634f62.1628779805.git.andreyknvl@gmail.com
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan_module.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_kasan_module.c~kasan-test-avoid-corrupting-memory-in-kasan_rcu_uaf
+++ a/lib/test_kasan_module.c
@@ -71,7 +71,7 @@ static noinline void __init kasan_rcu_re
 						struct kasan_rcu_info, rcu);
 
 	kfree(fp);
-	fp->i = 1;
+	((volatile struct kasan_rcu_info *)fp)->i;
 }
 
 static noinline void __init kasan_rcu_uaf(void)
_

Patches currently in -mm which might be from andreyknvl@gmail.com are

kasan-test-rework-kmalloc_oob_right.patch
kasan-test-avoid-writing-invalid-memory.patch
kasan-test-avoid-corrupting-memory-via-memset.patch
kasan-test-disable-kmalloc_memmove_invalid_size-for-hw_tags.patch
kasan-test-only-do-kmalloc_uaf_memset-for-generic-mode.patch
kasan-test-clean-up-ksize_uaf.patch
kasan-test-avoid-corrupting-memory-in-copy_user_test.patch
kasan-test-avoid-corrupting-memory-in-kasan_rcu_uaf.patch

