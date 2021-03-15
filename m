Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D14DC433E0
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 22:58:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42B7460240
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 22:58:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbhCOW6K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Mar 2021 18:58:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231975AbhCOW56 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Mar 2021 18:57:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B907B64F51;
        Mon, 15 Mar 2021 22:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615849078;
        bh=lX/NDj1oMWSldyqU6Wqfbv5FK1K+R4WsWJQbbGE7VUA=;
        h=Date:From:To:Subject:From;
        b=z+jnEqbNetdr70yYVbXDYoN3zrDhFR1O/YVZovvHIpqbA/z1ehKBYRHAdnGcIFrPd
         WPwS1LXP+RsxuQ++qI5Qnw/CS/muzr9wVK1K99TGvZUbjaTCJojRcH3GKrVuYwQlwl
         7M8DB68ad2vv02Pdsrp24hAv/Lg+/B/z3LAZsHKE=
Date:   Mon, 15 Mar 2021 15:57:57 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, dvyukov@google.com, elver@google.com,
        glider@google.com, jannh@google.com, mm-commits@vger.kernel.org
Subject:  + kfence-zero-guard-page-after-out-of-bounds-access.patch
 added to -mm tree
Message-ID: <20210315225757.XQwT8GQBu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: zero guard page after out-of-bounds access
has been added to the -mm tree.  Its filename is
     kfence-zero-guard-page-after-out-of-bounds-access.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfence-zero-guard-page-after-out-of-bounds-access.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfence-zero-guard-page-after-out-of-bounds-access.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kfence: zero guard page after out-of-bounds access

After an out-of-bounds accesses, zero the guard page before re-protecting
in kfence_guarded_free().  On one hand this helps make the failure mode of
subsequent out-of-bounds accesses more deterministic, but could also
prevent certain information leaks.

Link: https://lkml.kernel.org/r/20210312121653.348518-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Acked-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/kfence/core.c~kfence-zero-guard-page-after-out-of-bounds-access
+++ a/mm/kfence/core.c
@@ -371,6 +371,7 @@ static void kfence_guarded_free(void *ad
 
 	/* Restore page protection if there was an OOB access. */
 	if (meta->unprotected_page) {
+		memzero_explicit((void *)ALIGN_DOWN(meta->unprotected_page, PAGE_SIZE), PAGE_SIZE);
 		kfence_protect(meta->unprotected_page);
 		meta->unprotected_page = 0;
 	}
_

Patches currently in -mm which might be from elver@google.com are

kfence-zero-guard-page-after-out-of-bounds-access.patch

