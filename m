Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83722C47088
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 19:11:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65E62613B5
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 19:11:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233522AbhEZTND (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 May 2021 15:13:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:43884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233713AbhEZTM5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 26 May 2021 15:12:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7D02610A8;
        Wed, 26 May 2021 19:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622056286;
        bh=PislYHQZ5R28OeI0+wJjDb1dQdrMcTEbjPvuAL0GnSg=;
        h=Date:From:To:Subject:From;
        b=kdJj8JQbL/rs90IEAmA5xn3x538kDswLrn6uOL6WKjo7IP/tRtclNf8J+C9HN0fJ8
         87LmnSFASDTd6P4scVbu+7xnvLSBxuuQVJ+z1EOL/OlFkBvPT7LjZ/8drsctrbVnWr
         wMqHcZmG7NQNMzfDcMEDZnfBqEiFH5opTMly54H8=
Date:   Wed, 26 May 2021 12:11:25 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, colin.king@canonical.com, jgg@nvidia.com,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com
Subject:  + mm-selftests-for-exclusive-device-memory-fix.patch
 added to -mm tree
Message-ID: <20210526191125.prW2JmZLN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: selftests: fix potential integer overflow on shift of a int
has been added to the -mm tree.  Its filename is
     mm-selftests-for-exclusive-device-memory-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-selftests-for-exclusive-device-memory-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-selftests-for-exclusive-device-memory-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: mm: selftests: fix potential integer overflow on shift of a int

The left shift of the int mapped is evaluated using 32 bit arithmetic and
then assigned to an unsigned long.  In the case where mapped is 0x80000
when PAGE_SHIFT is 12 will lead to the upper bits being sign extended in
the unsigned long.  Larger values can lead to an int overflow.  Avoid this
by making mapped an unsigned long.

Addresses-Coverity: ("Uninitentional integer overflow")
Link: https://lkml.kernel.org/r/20210526170530.3766167-1-colin.king@canonical.com
Fixes: 8b2a105c3794 ("mm: selftests for exclusive device memory")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/test_hmm.c~mm-selftests-for-exclusive-device-memory-fix
+++ a/lib/test_hmm.c
@@ -733,7 +733,8 @@ static int dmirror_exclusive(struct dmir
 
 	mmap_read_lock(mm);
 	for (addr = start; addr < end; addr = next) {
-		int i, mapped;
+		unsigned long mapped;
+		int i;
 
 		if (end < addr + (ARRAY_SIZE(pages) << PAGE_SHIFT))
 			next = end;
_

Patches currently in -mm which might be from colin.king@canonical.com are

scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch
ocfs2-remove-redundant-assignment-to-pointer-queue.patch
mm-selftests-for-exclusive-device-memory-fix.patch

