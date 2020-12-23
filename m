Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8135FC433E6
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 20:38:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4431122510
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 20:38:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbgLWUiI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Dec 2020 15:38:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:41178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726279AbgLWUiI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Dec 2020 15:38:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1AF22246B;
        Wed, 23 Dec 2020 20:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608755847;
        bh=jOQt2hN7nmv0ABNV1G0SSEBz0PRvNzE4e/V1UfFM1xM=;
        h=Date:From:To:Subject:From;
        b=doS6iu3JZNTuwHxBMbfLjxoui5p29Ud1LaG78qcONpPQcPTiPXjMTgC197lnsnySC
         lWQE7u2/kDu661jteME1gZFsEGpOlpzZLy30LJCYH784rORf2tFTYcOAc8hI8bo8Gd
         9CGvQQ4HULHbCbAH190wjfCexurv1d/U6srLP0Aw=
Date:   Wed, 23 Dec 2020 12:37:27 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        joe@perches.com
Subject:  + checkpatch-prefer-strscpy-to-strlcpy.patch added to -mm
 tree
Message-ID: <20201223203727.4oUVP%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: prefer strscpy to strlcpy
has been added to the -mm tree.  Its filename is
     checkpatch-prefer-strscpy-to-strlcpy.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-prefer-strscpy-to-strlcpy.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-prefer-strscpy-to-strlcpy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

checkpatch-prefer-strscpy-to-strlcpy.patch

