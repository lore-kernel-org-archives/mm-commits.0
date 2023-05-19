Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C00C77B7A
	for <mm-commits@archiver.kernel.org>; Fri, 19 May 2023 22:36:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbjESWgf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 May 2023 18:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbjESWge (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 May 2023 18:36:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C835E45
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 15:36:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7F1D65AF3
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 22:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28271C433D2;
        Fri, 19 May 2023 22:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684535792;
        bh=9cRl99bAIPHmNLVBSx6NlM0O1FSc+rQqC7Ou6qQHkJk=;
        h=Date:To:From:Subject:From;
        b=uzEkjrNt8KDDrX+mcfLkS5MCwnmE2iVulGcvb7IXGuSqC+d0aDmMMdsWgPkNgo+k/
         8EHTtT6h/3f9ZkNQA01YM3t46gCEsE6LDCIg4MZXQDMqg/U5gbMtoxjf5uKUdNAkBo
         q/6RcpcY0/p1ESBXRWbWbpRyKR5Jx0g1iibXfYyk=
Date:   Fri, 19 May 2023 15:36:31 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] fix-mult_frac-multiple-argument-evaluation-bug.patch removed from -mm tree
Message-Id: <20230519223632.28271C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: include/linux/math.h: fix mult_frac() multiple argument evaluation bug
has been removed from the -mm tree.  Its filename was
     fix-mult_frac-multiple-argument-evaluation-bug.patch

This patch was dropped because an updated version will be merged

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

