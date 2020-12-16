Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DE41C2BBCD
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:09:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28EF8233FB
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:09:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgLPRJw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:09:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:59928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727025AbgLPRJw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:09:52 -0500
Date:   Wed, 16 Dec 2020 09:09:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138555;
        bh=Z3i4emETtnU+2RHoiKjs6f9fpAeRbkroqUopBeIOmws=;
        h=From:To:Subject:From;
        b=mg3tQay0TsqYLpVJcEjYqE/g5aUG5AHJPwRaUzqi70fop4NkjOAdWlH2n9Cuhka2c
         Jq+BET1V0c0I+8YQjNOmkkkmBSd1arQ5Gnb+5ViX6giktHE9HziEWXdg6x5KTk+/ES
         fQrQneruXOasbTlRhm9Tspb3qhcDmk9Ul8Ey1VX0=
From:   akpm@linux-foundation.org
To:     christophe.leroy@csgroup.eu, jakub@redhat.com,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        rdunlap@infradead.org
Subject:  [merged] ilog2-improve-ilog2-for-constant-arguments.patch
 removed from -mm tree
Message-ID: <20201216170915.sgQCyDhKo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ilog2: improve ilog2 for constant arguments
has been removed from the -mm tree.  Its filename was
     ilog2-improve-ilog2-for-constant-arguments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jakub Jelinek <jakub@redhat.com>
Subject: ilog2: improve ilog2 for constant arguments

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

[akpm@linux-foundation.org: coding style fixes]
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
+	 63 - __builtin_clzll(n)) :	\
 	(sizeof(n) <= 4) ?		\
 	__ilog2_u32(n) :		\
 	__ilog2_u64(n)			\
_

Patches currently in -mm which might be from jakub@redhat.com are


