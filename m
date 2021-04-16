Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 786E8C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 18:25:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 389F360FD9
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 18:25:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235747AbhDPSZg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Apr 2021 14:25:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235735AbhDPSZf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Apr 2021 14:25:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5EC1610FB;
        Fri, 16 Apr 2021 18:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618597510;
        bh=D/4GYF8oJvSEwOIfLF8rjPH2VirEETih0A2eTYI8jKs=;
        h=Date:From:To:Subject:From;
        b=cX6pRHmf7X8+pUUZQuCZF4IVcp/xjte9eDl2Sn4zTZfQ8ks8z0CUJUI/6p3z8Bb4C
         g01Mbm04CUZQP4ax0tE2iPMEKlPPwimn9iBBDDfVMMQ8UTDE+zlmmZdRvu0upCplQ8
         iN2qHn15QcZuzMLKQa5uYttmD3ZemABw3yMHEiMw=
Date:   Fri, 16 Apr 2021 11:25:08 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, joe@perches.com,
        christophe.jaillet@wanadoo.fr
Subject:  + checkpatch-improve-alloc_array_args-test.patch added to
 -mm tree
Message-ID: <20210416182508.wK6CF%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve ALLOC_ARRAY_ARGS test
has been added to the -mm tree.  Its filename is
     checkpatch-improve-alloc_array_args-test.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-alloc_array_args-test.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-alloc_array_args-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -6911,7 +6911,7 @@ sub process {
 		}
 
 # check for alloc argument mismatch
-		if ($line =~ /\b(kcalloc|kmalloc_array)\s*\(\s*sizeof\b/) {
+		if ($line =~ /\b((?:devm_)?(?:kcalloc|kmalloc_array))\s*\(\s*sizeof\b/) {
 			WARN("ALLOC_ARRAY_ARGS",
 			     "$1 uses number as first arg, sizeof is generally wrong\n" . $herecurr);
 		}
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

checkpatch-improve-alloc_array_args-test.patch

