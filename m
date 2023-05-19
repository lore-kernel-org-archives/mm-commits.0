Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA8E0C77B75
	for <mm-commits@archiver.kernel.org>; Fri, 19 May 2023 20:53:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjESUxp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 May 2023 16:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbjESUxp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 May 2023 16:53:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F7418F
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 13:53:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F00C65941
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 20:53:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946E3C433D2;
        Fri, 19 May 2023 20:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684529622;
        bh=Nm5gJ4IIPHTWhkDnmR3PBRhPNzVBtzzLygvt7hFisAQ=;
        h=Date:To:From:Subject:From;
        b=zZ99y02Esow4Xt4EHDelAQFE34AIFoITxz6FrRPzDqUWPjc6SMmgR7//h2EmMPG/6
         fHsLpdzMm7pOGEF8oCyuAtewkDzr5Q7qxq5MrMgH8ZTMAst+YwZmIAtY1go+8MaHxB
         GohLsSskIDZ6bJ8PyEF8DKNUB2MBCSZPTtXgmFjE=
Date:   Fri, 19 May 2023 13:53:42 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fix-mult_frac-multiple-argument-evaluation-bug.patch added to mm-nonmm-unstable branch
Message-Id: <20230519205342.946E3C433D2@smtp.kernel.org>
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
Date: Fri, 19 May 2023 23:24:54 +0300

mult_frac() evaluates _all_ arguments multiple times in the body.

Clarify comment while I'm at it.

Link: https://lkml.kernel.org/r/f522ad25-f899-4526-abc4-da35868b6a8b@p183
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
+	typeof(x) q = x_ / d_;	\
+	typeof(x) r = x_ % d_;	\
+	q * n_ + r * n_ / d_;	\
+})
 
 #define sector_div(a, b) do_div(a, b)
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

add-intptr_t.patch
fix-mult_frac-multiple-argument-evaluation-bug.patch

