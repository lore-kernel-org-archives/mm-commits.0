Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F26C2D0E4
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 21:38:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5E8D22403
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 21:38:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dcLApzeA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbgKTViT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Nov 2020 16:38:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:51318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727241AbgKTViT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 20 Nov 2020 16:38:19 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA6E621D40;
        Fri, 20 Nov 2020 21:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1605908297;
        bh=5eCBHOk4JNGzwZ8Zf97laPqCKcy/t6bVMlEz3VSVwvE=;
        h=Date:From:To:Subject:From;
        b=dcLApzeA+5WWL/8jgxkuSbkMIAkBNW9Bf7y5Z0uRj01a9XaZSDK2QOBoMpbT7Vq48
         0ShkgAABtGS1aez5sRw3JWcyJh1EZFqUHAgnoKXrMINuA76hD0dKy1XXqFxlFCTz5n
         7+ke3QPbx7c5h0wMGnnN+uO8AYGNyCmwcLI/Jufo=
Date:   Fri, 20 Nov 2020 13:38:16 -0800
From:   akpm@linux-foundation.org
To:     christophe.leroy@csgroup.eu, jakub@redhat.com,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        rdunlap@infradead.org
Subject:  + ilog2-improve-ilog2-for-constant-arguments.patch added
 to -mm tree
Message-ID: <20201120213816.xu9sdnCom%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ilog2: Improve ilog2 for constant arguments
has been added to the -mm tree.  Its filename is
     ilog2-improve-ilog2-for-constant-arguments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ilog2-improve-ilog2-for-constant-arguments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ilog2-improve-ilog2-for-constant-arguments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jakub Jelinek <jakub@redhat.com>
Subject: ilog2: Improve ilog2 for constant arguments

As discussed in https://gcc.gnu.org/bugzilla/show_bug.cgi?id=97445 the
const_ilog2 macro generates a lot of code which interferes badly with GCC
inlining heuristics, until it can be proven that the ilog2 argument can or
can't be simplified into a constant.

It can be expressed using __builtin_clzll builtin which is supported by
GCC 3.4 and later and when used only in the __builtin_constant_p guarded
code it ought to always fold back to a constant.  Other compilers support
the same builtin for many years too.

Other option would be to change the const_ilog2 macro, though as the
description says it is meant to be used also in C constant expressions,
and while GCC will fold it to constant with constant argument even in
those, perhaps it is better to avoid using extensions in that case.

Link: https://lkml.kernel.org/r/20201120125154.GB3040@hirez.programming.kicks-ass.net
Link: https://lkml.kernel.org/r/20201021132718.GB2176@tucnak
Signed-off-by: Jakub Jelinek <jakub@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/log2.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/log2.h~ilog2-improve-ilog2-for-constant-arguments
+++ a/include/linux/log2.h
@@ -156,7 +156,8 @@ unsigned long __rounddown_pow_of_two(uns
 #define ilog2(n) \
 ( \
 	__builtin_constant_p(n) ?	\
-	const_ilog2(n) :		\
+	((n) < 2 ? 0 :			\
+	 63 - __builtin_clzll (n)) :	\
 	(sizeof(n) <= 4) ?		\
 	__ilog2_u32(n) :		\
 	__ilog2_u64(n)			\
_

Patches currently in -mm which might be from jakub@redhat.com are

ilog2-improve-ilog2-for-constant-arguments.patch

