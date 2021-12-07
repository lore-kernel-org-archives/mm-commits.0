Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E242DC433EF
	for <mm-commits@archiver.kernel.org>; Tue,  7 Dec 2021 00:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344698AbhLGBCm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Dec 2021 20:02:42 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:48498 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378901AbhLGBCm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Dec 2021 20:02:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AE765CE194C
        for <mm-commits@vger.kernel.org>; Tue,  7 Dec 2021 00:59:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD19AC004DD;
        Tue,  7 Dec 2021 00:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638838749;
        bh=Orqc7fX7odAeCGTtjkgykRWecM5GeVQiOhviS1GGBho=;
        h=Date:From:To:Subject:From;
        b=b3yllqu12j3rf5hkrXQMIF3nRQ9DPRg0ieL0b8Q8cILaXzzKstYmAa3hMIebGwRny
         ivBtKugm0+75uxMFNCkhaqUVvdayeC7Ol4UpnnQFOYNq537sf8wzjBpyxiUf8Hn+m/
         WaEXTi8WbtF2xNlHWqiV/XOatbhp/MzFFWL+fjLg=
Date:   Mon, 06 Dec 2021 16:59:09 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        sj@kernel.org, xhao@linux.alibaba.com
Subject:  +
 mm-damon-modify-damon_rand-macro-to-static-inline-function.patch added to
 -mm tree
Message-ID: <20211207005909.rD8J3Zq_X%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: modify damon_rand() macro to static inline function
has been added to the -mm tree.  Its filename is
     mm-damon-modify-damon_rand-macro-to-static-inline-function.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-modify-damon_rand-macro-to-static-inline-function.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-modify-damon_rand-macro-to-static-inline-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xin Hao <xhao@linux.alibaba.com>
Subject: mm/damon: modify damon_rand() macro to static inline function

damon_rand() cannot be implemented as a macro.

Example:
	damon_rand(a++, b);

The value of 'a' will be incremented twice, This is obviously
unreasonable, So there fix it.

Link: https://lkml.kernel.org/r/110ffcd4e420c86c42b41ce2bc9f0fe6a4f32cd3.1638795127.git.xhao@linux.alibaba.com
Fixes: b9a6ac4e4ede ("mm/damon: adaptively adjust regions")
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/damon.h~mm-damon-modify-damon_rand-macro-to-static-inline-function
+++ a/include/linux/damon.h
@@ -19,7 +19,10 @@
 #define DAMOS_MAX_SCORE		(99)
 
 /* Get a random number in [l, r) */
-#define damon_rand(l, r) (l + prandom_u32_max(r - l))
+static inline unsigned long damon_rand(unsigned long l, unsigned long r)
+{
+	return l + prandom_u32_max(r - l);
+}
 
 /**
  * struct damon_addr_range - Represents an address region of [@start, @end).
_

Patches currently in -mm which might be from xhao@linux.alibaba.com are

mm-damon-unified-access_check-function-naming-rules.patch
mm-damon-add-age-of-region-tracepoint-support.patch
mm-damon-core-using-function-abs-instead-of-diff_of.patch
mm-damon-remove-some-no-need-func-definitions-in-damonh-file.patch
mm-damon-schemes-add-the-validity-judgment-of-thresholds.patch
mm-damon-move-damon_rand-definition-into-damonh.patch
mm-damon-modify-damon_rand-macro-to-static-inline-function.patch

