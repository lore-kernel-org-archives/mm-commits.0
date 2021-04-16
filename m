Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B041AC433ED
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 22:46:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 955FA613C7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 22:46:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234965AbhDPWqu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Apr 2021 18:46:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234797AbhDPWqr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Apr 2021 18:46:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2117C613C5;
        Fri, 16 Apr 2021 22:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618613181;
        bh=MkCvSbtAeLbKTeGB85UdZQMtFmOwEku9Mq87qmjNORo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2Ksq4w23sD3jOQ6M8HvOAnbdVo7LiR5AQ1qnw8D8CNGXsLdepyuK6ypg0XvvuU+in
         n4Sn+lqFLgm8DhcA2QJmWdbjc354gec7mx/C8x1dsX0+q2KDcxtja+b2iO1kwvhoXW
         cDWPywCfFjy/S4WVXZmVnLT2N9Bdmzx1Jai+M/cs=
Date:   Fri, 16 Apr 2021 15:46:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, christophe.leroy@csgroup.eu,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        steven.price@arm.com, torvalds@linux-foundation.org
Subject:  [patch 10/12] mm: ptdump: fix build failure
Message-ID: <20210416224620.vDDxhwPBO%akpm@linux-foundation.org>
In-Reply-To: <20210416154523.3f9794326e8e1db549873cf8@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: mm: ptdump: fix build failure

	  CC      mm/ptdump.o
	In file included from <command-line>:
	mm/ptdump.c: In function 'ptdump_pte_entry':
	././include/linux/compiler_types.h:320:38: error: call to '__compiletime_assert_207' declared with attribute error: Unsupported access size for {READ,WRITE}_ONCE().
	  320 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
	      |                                      ^
	././include/linux/compiler_types.h:301:4: note: in definition of macro '__compiletime_assert'
	  301 |    prefix ## suffix();    \
	      |    ^~~~~~
	././include/linux/compiler_types.h:320:2: note: in expansion of macro '_compiletime_assert'
	  320 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
	      |  ^~~~~~~~~~~~~~~~~~~
	./include/asm-generic/rwonce.h:36:2: note: in expansion of macro 'compiletime_assert'
	   36 |  compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long), \
	      |  ^~~~~~~~~~~~~~~~~~
	./include/asm-generic/rwonce.h:49:2: note: in expansion of macro 'compiletime_assert_rwonce_type'
	   49 |  compiletime_assert_rwonce_type(x);    \
	      |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	mm/ptdump.c:114:14: note: in expansion of macro 'READ_ONCE'
	  114 |  pte_t val = READ_ONCE(*pte);
	      |              ^~~~~~~~~
	make[2]: *** [mm/ptdump.o] Error 1

READ_ONCE() cannot be used for reading PTEs.  Use ptep_get() instead.  See
commit 481e980a7c19 ("mm: Allow arches to provide ptep_get()") and commit
c0e1c8c22beb ("powerpc/8xx: Provide ptep_get() with 16k pages") for
details.

Link: https://lkml.kernel.org/r/912b349e2bcaa88939904815ca0af945740c6bd4.1618478922.git.christophe.leroy@csgroup.eu
Fixes: 30d621f6723b ("mm: add generic ptdump")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Steven Price <steven.price@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ptdump.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/ptdump.c~mm-ptdump-fix-build-failure
+++ a/mm/ptdump.c
@@ -111,7 +111,7 @@ static int ptdump_pte_entry(pte_t *pte,
 			    unsigned long next, struct mm_walk *walk)
 {
 	struct ptdump_state *st = walk->private;
-	pte_t val = READ_ONCE(*pte);
+	pte_t val = ptep_get(pte);
 
 	if (st->effective_prot)
 		st->effective_prot(st, 4, pte_val(val));
_
