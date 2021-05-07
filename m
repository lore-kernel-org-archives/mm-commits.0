Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33529C43460
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:03:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1865D610FA
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:03:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbhEGBE3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:04:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234033AbhEGBE2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:04:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC867610F7;
        Fri,  7 May 2021 01:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349409;
        bh=OyWP+aBbkn96Ye/nLjA0q+DgaVFYPny8AzNjNdrIreg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=IgaVEPvpaFXZYcytRA0hRQpeNg8s+JsP+N8/9KuX1uTWMa+77Jj21ol+BWLG2dRW9
         fo4588iQyVjw2ivBXweggoxufT3O9ixSTUPKyQQYORE6FSIeDe26d7SLcuvrEV2Eot
         Z+12gT0CMX8JjK0h5GoOT4J4z298q07l+KcijgBo=
Date:   Thu, 06 May 2021 18:03:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        wangqing@vivo.com
Subject:  [patch 27/91] lib: fix inconsistent indenting in
 process_bit1()
Message-ID: <20210507010328.8OkrFFfb2%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Wang Qing <wangqing@vivo.com>
Subject: lib: fix inconsistent indenting in process_bit1()

Smatch gives the warning:
	lib/decompress_unlzma.c:395 process_bit1() warn: inconsistent indenting

Link: https://lkml.kernel.org/r/1614567775-4478-1-git-send-email-wangqing@vivo.com
Signed-off-by: Wang Qing <wangqing@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_unlzma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/decompress_unlzma.c~lib-fix-inconsistent-indenting-in-process_bit1
+++ a/lib/decompress_unlzma.c
@@ -391,7 +391,7 @@ static inline int INIT process_bit0(stru
 static inline int INIT process_bit1(struct writer *wr, struct rc *rc,
 					    struct cstate *cst, uint16_t *p,
 					    int pos_state, uint16_t *prob) {
-  int offset;
+	int offset;
 	uint16_t *prob_len;
 	int num_bits;
 	int len;
_
