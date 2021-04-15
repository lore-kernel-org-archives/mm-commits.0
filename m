Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C52C433ED
	for <mm-commits@archiver.kernel.org>; Thu, 15 Apr 2021 20:35:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99C5F61153
	for <mm-commits@archiver.kernel.org>; Thu, 15 Apr 2021 20:35:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235150AbhDOUf4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Apr 2021 16:35:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234978AbhDOUfz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Apr 2021 16:35:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8B3261131;
        Thu, 15 Apr 2021 20:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618518931;
        bh=/QeDI0e4FdRUlV4SbEWY5ZDqGyvVlHLon/UneZgj8+Y=;
        h=Date:From:To:Subject:From;
        b=ox+xBhYMRZurlZItuMNnXTeAFGGQOT5HcP4YqLbDLnOOuttdTk7ff5ajyJ1+PMnPz
         BW4325ZzAsG+Hn5xlyEo6GC3axIxv1080oJTbpY0KJOsyWX2cn8lwfHvAtwKCe6sWP
         G9P4LahRlmphLZLR+x9TxYRseAtuGu80TAAzF58Q=
Date:   Thu, 15 Apr 2021 13:35:29 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, steven.price@arm.com,
        christophe.leroy@csgroup.eu
Subject:  + mm-ptdump-fix-build-failure.patch added to -mm tree
Message-ID: <20210415203529.ACtEF%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: ptdump: fix build failure
has been added to the -mm tree.  Its filename is
     mm-ptdump-fix-build-failure.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-ptdump-fix-build-failure.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-ptdump-fix-build-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

mm-ptdump-fix-build-failure.patch

