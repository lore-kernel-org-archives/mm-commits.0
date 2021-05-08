Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EEE9C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 827BA61402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhEHWyS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:54:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:41902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229641AbhEHWyR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:54:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8107961424;
        Sat,  8 May 2021 22:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514395;
        bh=P/8dyPPaTyboNtrLzFuekNlA76TGdkUHRvuhkoPvFag=;
        h=Date:From:To:Subject:From;
        b=aENxyjdkMB717NhWjTpUHgyHruW/mid45q2/yWrQbPhn39hGc2tNTXpmaWARQKpoe
         qRgkK3IeSCO38xrUfoxG4h/ilLC4bOgUgLLC8M1ZGUnI/TFLHsGE2e1ndVOCw8ZcVM
         /FdcN9IW5IJPbseXMx1Vc7mucfsa2FqiehEUPnDQ=
Date:   Sat, 08 May 2021 15:53:15 -0700
From:   akpm@linux-foundation.org
To:     christophe.jaillet@wanadoo.fr, joe@perches.com,
        mm-commits@vger.kernel.org
Subject:  [merged] checkpatch-improve-alloc_array_args-test.patch
 removed from -mm tree
Message-ID: <20210508225315.kmBbo5yVK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve ALLOC_ARRAY_ARGS test
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-alloc_array_args-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: checkpatch: improve ALLOC_ARRAY_ARGS test

The devm_ variant of 'kcalloc()' and 'kmalloc_array()' are not tested
Add the corresponding check.

Link: https://lkml.kernel.org/r/205fc4847972fb6779abcc8818f39c14d1b45af1.1618595794.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-improve-alloc_array_args-test
+++ a/scripts/checkpatch.pl
@@ -7006,7 +7006,7 @@ sub process {
 		}
 
 # check for alloc argument mismatch
-		if ($line =~ /\b(kcalloc|kmalloc_array)\s*\(\s*sizeof\b/) {
+		if ($line =~ /\b((?:devm_)?(?:kcalloc|kmalloc_array))\s*\(\s*sizeof\b/) {
 			WARN("ALLOC_ARRAY_ARGS",
 			     "$1 uses number as first arg, sizeof is generally wrong\n" . $herecurr);
 		}
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are


