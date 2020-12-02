Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6BB9C6369E
	for <mm-commits@archiver.kernel.org>; Wed,  2 Dec 2020 23:30:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AE5E217A0
	for <mm-commits@archiver.kernel.org>; Wed,  2 Dec 2020 23:30:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbgLBXa0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Dec 2020 18:30:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:43162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727233AbgLBXaZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 2 Dec 2020 18:30:25 -0500
Date:   Wed, 02 Dec 2020 15:29:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606951785;
        bh=kB5pZw6cVvyapa0cRzTz6HUicicCkiCKvtLFn1v73G8=;
        h=From:To:Subject:From;
        b=HKiYXDwaeasaG/AvyMVlzOEJsxPWlXun6eaXIAiUPDuCNiUAhsh7yKpDWsV/5+Lap
         S9SfNqSZFT9y85XaT0jZgfNRTnkKgWPy3mgVSN9o4nJc5WePZvO3KGgb5CzPKAmhu9
         bKhOI1l7Fuhd+KzcNeF37yQximd5y3V8Jy+Q9QV0=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, baolin.wang@linux.alibaba.com,
        mm-commits@vger.kernel.org
Subject:  + mm-vmalloc-remove-unnecessary-return-statement.patch
 added to -mm tree
Message-ID: <20201202232944.nntA22P-Y%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: remove unnecessary return statement
has been added to the -mm tree.  Its filename is
     mm-vmalloc-remove-unnecessary-return-statement.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-remove-unnecessary-return-statement.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-remove-unnecessary-return-statement.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm/vmalloc.c: remove unnecessary return statement

Remove unnecessary return statement for void function.

Link: https://lkml.kernel.org/r/ca23f89259c80c3562700ae6e227b2815a195853.1606891153.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-remove-unnecessary-return-statement
+++ a/mm/vmalloc.c
@@ -2291,7 +2291,6 @@ static void __vunmap(const void *addr, i
 	}
 
 	kfree(area);
-	return;
 }
 
 static inline void __vfree_deferred(const void *addr)
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-vmalloc-remove-unnecessary-return-statement.patch

