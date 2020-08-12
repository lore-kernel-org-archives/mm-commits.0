Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10177C433E5
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D911D208A9
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196038;
	bh=CuNM5WHO9tIvAJ5E3sbipPLkb7gpdWoOwKyigF1kI50=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=UCHGMfhQ4d5w9p1pG25B8dsmpLbLwlzbEtBxb92rOLel12WI7szB9IRI2xU3SqGxQ
	 2l2ApNcu/Yn8s5vI7vVjrFGV5Yi+dSgCBUTfsMCk4GNIApgEUUhAN6SuDIGMiFqHoU
	 uMctopSzz0H9Kf11ExMNCLwe3nJ4HqQ40AReK2+U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbgHLBd6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:33:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726492AbgHLBd6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:33:58 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B90E32080C;
        Wed, 12 Aug 2020 01:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196038;
        bh=CuNM5WHO9tIvAJ5E3sbipPLkb7gpdWoOwKyigF1kI50=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=s6d68jaAinnq4gYs0YcpcFeU0L5VMHGm4te/j/48J3C+5rkbuE3aXdIEzfolIFxMH
         b0Ym6ETiq2/QNZlI5R2bXxPnVnRfTY+as5i+AwCdQ6gptaa9cyUmDOWFGzsSZvfFgE
         TFLG8FqowK4Ckt5B0G8VCzpwmiayv32S65O9ymuE=
Date:   Tue, 11 Aug 2020 18:33:57 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, natechancellor@gmail.com,
        rdunlap@infradead.org, torvalds@linux-foundation.org
Subject:  [patch 070/165] include/linux/compiler-clang.h: drop
 duplicated word in a comment
Message-ID: <20200812013357.xcVCdExb5%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: include/linux/compiler-clang.h: drop duplicated word in a comment

Drop the doubled word "the" in a comment.

Link: http://lkml.kernel.org/r/6a18c301-3505-742f-4dd7-0f38d0e537b9@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-clang.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/compiler-clang.h~clang-linux-compiler-clangh-drop-duplicated-word-in-a-comment
+++ a/include/linux/compiler-clang.h
@@ -40,7 +40,7 @@
 #endif
 
 /*
- * Not all versions of clang implement the the type-generic versions
+ * Not all versions of clang implement the type-generic versions
  * of the builtin overflow checkers. Fortunately, clang implements
  * __has_builtin allowing us to avoid awkward version
  * checks. Unfortunately, we don't know which version of gcc clang
_
