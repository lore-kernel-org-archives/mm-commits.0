Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55387C54E94
	for <mm-commits@archiver.kernel.org>; Tue, 24 Jan 2023 21:57:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbjAXV5D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 24 Jan 2023 16:57:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjAXV5D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2023 16:57:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB9627D70
        for <mm-commits@vger.kernel.org>; Tue, 24 Jan 2023 13:57:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10593B816D8
        for <mm-commits@vger.kernel.org>; Tue, 24 Jan 2023 21:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0C7C433D2;
        Tue, 24 Jan 2023 21:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674597419;
        bh=hXUcEOBb9Ydd5F0Z3cWpjlpLmampIzTnf9iwcBppFV4=;
        h=Date:To:From:Subject:From;
        b=XHBhdtF1wE+ym+LdXpqriY96Ym2YuQtkf8sDCZbVvyZ4VA9KiM8KlFXsKo1cdhSm6
         Clgdg9UvzuFBrF+MUph9C0kL1WJyXzHIsIXk2PdZx6VB+Gcu/fpqsvlsHihmcFY3zO
         xPGLaMgKqQpUdqJAb6DaGFJkr/3quc94mB0f/9sM=
Date:   Tue, 24 Jan 2023 13:56:59 -0800
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-reset-page-tags-properly-with-sampling-v2.patch added to mm-unstable branch
Message-Id: <20230124215659.9E0C7C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-reset-page-tags-properly-with-sampling-v2
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-reset-page-tags-properly-with-sampling-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-reset-page-tags-properly-with-sampling-v2.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan-reset-page-tags-properly-with-sampling-v2
Date: Tue, 24 Jan 2023 21:40:09 +0100

update comment

Link: https://lkml.kernel.org/r/5dbd866714b4839069e2d8469ac45b60953db290.1674592780.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~kasan-reset-page-tags-properly-with-sampling-v2
+++ a/mm/page_alloc.c
@@ -2521,7 +2521,8 @@ inline void post_alloc_hook(struct page
 		} else {
 			/*
 			 * KASAN decided to exclude this allocation from being
-			 * unpoisoned due to sampling. Skip poisoning as well.
+			 * (un)poisoned due to sampling. Make KASAN skip
+			 * poisoning when the allocation is freed.
 			 */
 			SetPageSkipKASanPoison(page);
 		}
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-reset-page-tags-properly-with-sampling.patch
kasan-reset-page-tags-properly-with-sampling-v2.patch

