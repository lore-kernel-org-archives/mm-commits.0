Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51688C43381
	for <mm-commits@archiver.kernel.org>; Thu, 31 Dec 2020 18:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AD85223DB
	for <mm-commits@archiver.kernel.org>; Thu, 31 Dec 2020 18:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgLaSXa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Dec 2020 13:23:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:33670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726352AbgLaSXa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 31 Dec 2020 13:23:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C22DE223E8;
        Thu, 31 Dec 2020 18:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609438969;
        bh=VWXUNMClDCtDgZDnV58iTP2pc+1Xm/VjuO/RNyoM3PU=;
        h=Date:From:To:Subject:From;
        b=2NSJ82hnUF8vwnQ5Jo708VkEEw6WtXiByOPCGjEoHBFJtAJRjwNNiMNrAsAg39VXr
         7V5V6KpRoan5jAzpC2vzcwUt8HvOG9MZCTElbR9Hc7aZBmQvIv+AhVDIPxlQWiA5n/
         aOkORhizHwObR3VV1RMtbdFp4WZPiqT4GGiL5ngc=
Date:   Thu, 31 Dec 2020 10:22:49 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, joe@perches.com,
        mm-commits@vger.kernel.org
Subject:  [merged] checkpatch-prefer-strscpy-to-strlcpy.patch
 removed from -mm tree
Message-ID: <20201231182249.dhYerQjGX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: prefer strscpy to strlcpy
has been removed from the -mm tree.  Its filename was
     checkpatch-prefer-strscpy-to-strlcpy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: prefer strscpy to strlcpy

Prefer strscpy over the deprecated strlcpy function.

Link: https://lkml.kernel.org/r/19fe91084890e2c16fe56f960de6c570a93fa99b.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Requested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-prefer-strscpy-to-strlcpy
+++ a/scripts/checkpatch.pl
@@ -6646,6 +6646,12 @@ sub process {
 #			}
 #		}
 
+# strlcpy uses that should likely be strscpy
+		if ($line =~ /\bstrlcpy\s*\(/) {
+			WARN("STRLCPY",
+			     "Prefer strscpy over strlcpy - see: https://lore.kernel.org/r/CAHk-=wgfRnXz0W3D37d01q3JFkr_i_uTL=V6A6G1oUZcprmknw\@mail.gmail.com/\n" . $herecurr);
+		}
+
 # typecasts on min/max could be min_t/max_t
 		if ($perl_version_ok &&
 		    defined $stat &&
_

Patches currently in -mm which might be from joe@perches.com are


