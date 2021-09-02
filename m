Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 255B6C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:57:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A39860E8B
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:57:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347938AbhIBV6x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:58:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243139AbhIBV6w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:58:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDAAF6056B;
        Thu,  2 Sep 2021 21:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619874;
        bh=W5UlXSXOIa4cHd1UZpUTIGQO5HZZUOKbYIsO69xw2R4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HuKqzstWiIPamkcSWK1GkzSJ03PE96MEk30BM6aBAjm8bqVU6NTb1sOxNF54h5swD
         zK+Cap/ghcuKqfSk9WVN5+t2h8mnIa8PVa9xJe7ciyfdZaQOFROxDDVD1WU8tbLf8K
         xg4ZyrP8NApYmQDqJ+j1Hqm6RALgCNCfqg8Fdj28=
Date:   Thu, 02 Sep 2021 14:57:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        aryabinin@virtuozzo.com, dvyukov@google.com, elver@google.com,
        glider@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 149/212] kasan: test: avoid corrupting memory in
 kasan_rcu_uaf
Message-ID: <20210902215753.m2qklrGfI%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
