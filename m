Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48B23C7EE2F
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:46:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjFJAqw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbjFJAp5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:45:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506313AB1
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:45:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D9AB651C5
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:45:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70507C433EF;
        Sat, 10 Jun 2023 00:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357955;
        bh=5WIgBLIZx752CJSjLd0EH1k33knUwAGr50bhvF0TLxc=;
        h=Date:To:From:Subject:From;
        b=TJfstsYtbZCmfcb+Xq/y2bUGyt8dEssy1d2OVduRJYB92hFTsWsMyaHy76NyLz2mK
         ZkSjrV+GBNCsUONKhjkKaCf3oiPut9SlX0qzWpO/9llGbcaAM9+4oGZLMgJQXBzne1
         MtplWMN06rT68VGBHNtfRnduJS28aBfJllNNfI+Y=
Date:   Fri, 09 Jun 2023 17:45:54 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fix-mult_frac-multiple-argument-evaluation-bug.patch removed from -mm tree
Message-Id: <20230610004555.70507C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: include/linux/math.h: fix mult_frac() multiple argument evaluation bug
has been removed from the -mm tree.  Its filename was
     fix-mult_frac-multiple-argument-evaluation-bug.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


