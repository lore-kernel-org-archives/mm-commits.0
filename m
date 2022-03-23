Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93EC4C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 23:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345415AbiCWXIa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 19:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244356AbiCWXI2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 19:08:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B13F9027C
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 16:06:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D032B8214F
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 23:06:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F42C340E9;
        Wed, 23 Mar 2022 23:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648076815;
        bh=tzco+04R/k/6LLPtlVJx76qnkinJpRQAv0h0wro7Wc4=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=GA/NPJEm512dQpQFbVGlKR/bTmGr0/v5/svPBdxaK6Y2+wvBZB2FDpul6emMqjGtu
         KrXGZMPFPAdqMv76NrtKieUwejMnYO6z7Iwdekn1/+bHgjw163310YBhwa2zzh3Kgf
         P+0fqNd2BYld1bUtMcv70yBxyHhyz0YApm0MH+JQ=
Date:   Wed, 23 Mar 2022 16:06:54 -0700
To:     ryabinin.a.a@gmail.com, lixuefeng@loongson.cn, elver@google.com,
        corbet@lwn.net, bhe@redhat.com, yangtiezhu@loongson.cn,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 32/41] ubsan: no need to unset panic_on_warn in ubsan_epilogue()
Message-Id: <20220323230655.24F42C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: ubsan: no need to unset panic_on_warn in ubsan_epilogue()

panic_on_warn is unset inside panic(), so no need to unset it before
calling panic() in ubsan_epilogue().

Link: https://lkml.kernel.org/r/1644324666-15947-5-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Xuefeng Li <lixuefeng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ubsan.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/lib/ubsan.c~ubsan-no-need-to-unset-panic_on_warn-in-ubsan_epilogue
+++ a/lib/ubsan.c
@@ -154,16 +154,8 @@ static void ubsan_epilogue(void)
 
 	current->in_ubsan--;
 
-	if (panic_on_warn) {
-		/*
-		 * This thread may hit another WARN() in the panic path.
-		 * Resetting this prevents additional WARN() from panicking the
-		 * system on this thread.  Other threads are blocked by the
-		 * panic_mutex in panic().
-		 */
-		panic_on_warn = 0;
+	if (panic_on_warn)
 		panic("panic_on_warn set ...\n");
-	}
 }
 
 void __ubsan_handle_divrem_overflow(void *_data, void *lhs, void *rhs)
_
