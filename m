Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 631C9C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 21 May 2022 16:15:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245302AbiEUQPw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 21 May 2022 12:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237279AbiEUQPw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 21 May 2022 12:15:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899F825D9
        for <mm-commits@vger.kernel.org>; Sat, 21 May 2022 09:15:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25A3760E16
        for <mm-commits@vger.kernel.org>; Sat, 21 May 2022 16:15:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C94EC385A5;
        Sat, 21 May 2022 16:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653149749;
        bh=CakRylsC2/R/z4ZFvQONM1ajL/MPbGDwH7A9TFVYcsc=;
        h=Date:To:From:Subject:From;
        b=r8VI2U+nhliCv2JHXOg8P7zwkvktunGPgSw8luEtMOMol+69Yf+0b4YICWRS/t1eO
         B82jeIJ7br+gJU3Y7k3nY3riebQF3lNmGlI2IDfV6M9TKFXIKOombYsO3S/R1v9OkY
         3CPoaBNy3WTwREPG4l87yTdswXH5v14tqFAqWyfg=
Date:   Sat, 21 May 2022 09:15:48 -0700
To:     mm-commits@vger.kernel.org, glider@google.com, elver@google.com,
        dvyukov@google.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kfence-use-page_aligned-helper.patch added to mm-unstable branch
Message-Id: <20220521161549.4C94EC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kfence: Use PAGE_ALIGNED helper
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kfence-use-page_aligned-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kfence-use-page_aligned-helper.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: kfence: Use PAGE_ALIGNED helper
Date: Fri, 20 May 2022 10:18:33 +0800

Use PAGE_ALIGNED macro instead of IS_ALIGNED and passing PAGE_SIZE.

Link: https://lkml.kernel.org/r/20220520021833.121405-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/kfence_test.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/kfence/kfence_test.c~mm-kfence-use-page_aligned-helper
+++ a/mm/kfence/kfence_test.c
@@ -296,10 +296,9 @@ static void *test_alloc(struct kunit *te
 
 			if (policy == ALLOCATE_ANY)
 				return alloc;
-			if (policy == ALLOCATE_LEFT && IS_ALIGNED((unsigned long)alloc, PAGE_SIZE))
+			if (policy == ALLOCATE_LEFT && PAGE_ALIGNED(alloc))
 				return alloc;
-			if (policy == ALLOCATE_RIGHT &&
-			    !IS_ALIGNED((unsigned long)alloc, PAGE_SIZE))
+			if (policy == ALLOCATE_RIGHT && !PAGE_ALIGNED(alloc))
 				return alloc;
 		} else if (policy == ALLOCATE_NONE)
 			return alloc;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-kfence-use-page_aligned-helper.patch

