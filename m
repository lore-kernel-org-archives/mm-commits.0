Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA2B8C433ED
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:03:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5A50610FA
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:03:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbhEGBE0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:04:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234033AbhEGBEZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:04:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAA1161041;
        Fri,  7 May 2021 01:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349406;
        bh=ysc8PI4vf08R5L9VYB8ANlK/168HmCXCzG/31Mt9IKU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=RCdOhFnx+hlgMVnLFg0wPhPK2UdxHG8Q+km2go/UAfQTueKGiXutueCGNQl6CJ4Yy
         fP8uJV8j9OAdxYqLrMCMZazeFagq9nCi+2fcJtsGKt+ZcgPGCcFl9rxnZJ6+U/GLV8
         gD/QOyIuuWdGivCnUjpLMDZE7mEQRs+FoGNxpT38=
Date:   Thu, 06 May 2021 18:03:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org, unixbhaskar@gmail.com
Subject:  [patch 26/91] lib/bch.c: fix a typo in the file bch.c
Message-ID: <20210507010325.QeVlkd9iL%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: lib/bch.c: fix a typo in the file bch.c

s/buid/build/

Link: https://lkml.kernel.org/r/20210301123129.18754-1-unixbhaskar@gmail.com
Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/bch.c~lib-fix-a-typo-in-the-file-bchc
+++ a/lib/bch.c
@@ -584,7 +584,7 @@ static int find_affine4_roots(struct bch
 	k = a_log(bch, a);
 	rows[0] = c;
 
-	/* buid linear system to solve X^4+aX^2+bX+c = 0 */
+	/* build linear system to solve X^4+aX^2+bX+c = 0 */
 	for (i = 0; i < m; i++) {
 		rows[i+1] = bch->a_pow_tab[4*i]^
 			(a ? bch->a_pow_tab[mod_s(bch, k)] : 0)^
_
