Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C3D5C77B73
	for <mm-commits@archiver.kernel.org>; Mon, 22 May 2023 21:15:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbjEVVPS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 May 2023 17:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233161AbjEVVPR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 May 2023 17:15:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDFBC1
        for <mm-commits@vger.kernel.org>; Mon, 22 May 2023 14:15:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85B3662A3D
        for <mm-commits@vger.kernel.org>; Mon, 22 May 2023 21:15:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0037C4339C;
        Mon, 22 May 2023 21:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684790115;
        bh=UbYSDn4eqd22hhIYBPJ9Wx+bHxLcoZCLr0jJBnuGg+0=;
        h=Date:To:From:Subject:From;
        b=chVHBTr4o13vgj3qFyDyHY8FWx0fAgcir9uC4shKc8BJqQnrkdCTa0pm3hqU67rqA
         EY31EKwY5TN7jwgqrVnwKxJiQSaSGWwTcBsoyV41/BtmSwe85N1htG72hw8LVrjCDc
         3px/TN3JhHnWb0law31OkmrsaqPOjkzfkE0CMHyQ=
Date:   Mon, 22 May 2023 14:15:14 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fix-mult_frac-multiple-argument-evaluation-bug.patch added to mm-nonmm-unstable branch
Message-Id: <20230522211514.E0037C4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/math.h: fix mult_frac() multiple argument evaluation bug
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fix-mult_frac-multiple-argument-evaluation-bug.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fix-mult_frac-multiple-argument-evaluation-bug.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: include/linux/math.h: fix mult_frac() multiple argument evaluation bug
Date: Sat, 20 May 2023 21:25:19 +0300

mult_frac() evaluates _all_ arguments multiple times in the body.

Clarify comment while I'm at it.

Link: https://lkml.kernel.org/r/f9f9fdbb-ec8e-4f5e-a998-2a58627a1a43@p183
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/math.h |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/include/linux/math.h~fix-mult_frac-multiple-argument-evaluation-bug
+++ a/include/linux/math.h
@@ -118,17 +118,17 @@ __STRUCT_FRACT(s32)
 __STRUCT_FRACT(u32)
 #undef __STRUCT_FRACT
 
-/*
- * Multiplies an integer by a fraction, while avoiding unnecessary
- * overflow or loss of precision.
- */
-#define mult_frac(x, numer, denom)(			\
-{							\
-	typeof(x) quot = (x) / (denom);			\
-	typeof(x) rem  = (x) % (denom);			\
-	(quot * (numer)) + ((rem * (numer)) / (denom));	\
-}							\
-)
+/* Calculate "x * n / d" without unnecessary overflow or loss of precision. */
+#define mult_frac(x, n, d)	\
+({				\
+	typeof(x) x_ = (x);	\
+	typeof(n) n_ = (n);	\
+	typeof(d) d_ = (d);	\
+				\
+	typeof(x_) q = x_ / d_;	\
+	typeof(x_) r = x_ % d_;	\
+	q * n_ + r * n_ / d_;	\
+})
 
 #define sector_div(a, b) do_div(a, b)
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

add-intptr_t.patch
fix-mult_frac-multiple-argument-evaluation-bug.patch

