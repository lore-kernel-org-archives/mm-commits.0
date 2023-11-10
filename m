Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69638C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 10 Nov 2023 19:09:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235875AbjKJTJE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Nov 2023 14:09:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235902AbjKJTIw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Nov 2023 14:08:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2FE12C92A;
        Fri, 10 Nov 2023 10:31:59 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53724C433AD;
        Fri, 10 Nov 2023 18:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699641119;
        bh=MvmzewS5VJRc98gsbGkCIaIKE2HsqDNSyOsXEIVZFwA=;
        h=Date:To:From:Subject:From;
        b=zIS1+NWWfsjeeW4wJqDvIFizSMlHuB0JPnqrmqHsHh0oYX+//JCz06dvK4GRfvPKg
         v+aIUv+VXA45Vb4ZiXmVo3qOt8k7r+odUoloyaFT5EwbrVjr6oCVzkFmwY4YFeYBiV
         mn0MtlK3jY8umi0Dj6DPmwNCmDYVryOTXLSmjLWA=
Date:   Fri, 10 Nov 2023 10:31:58 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, sj@kernel.org,
        hyeongtak.ji@sk.com, hyeongtak.ji@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-corec-avoid-unintentional-filtering-out-of-schemes.patch added to mm-hotfixes-unstable branch
Message-Id: <20231110183159.53724C433AD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core.c: avoid unintentional filtering out of schemes
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-corec-avoid-unintentional-filtering-out-of-schemes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-corec-avoid-unintentional-filtering-out-of-schemes.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Hyeongtak Ji <hyeongtak.ji@gmail.com>
Subject: mm/damon/core.c: avoid unintentional filtering out of schemes
Date: Fri, 10 Nov 2023 14:37:09 +0900

The function '__damos_filter_out()' causes DAMON to always filter out
schemes whose filter type is anon or memcg if its matching value is set
to false.

This commit addresses the issue by ensuring that '__damos_filter_out()'
no longer applies to filters whose type is 'anon' or 'memcg'.

Link: https://lkml.kernel.org/r/1699594629-3816-1-git-send-email-hyeongtak.ji@gmail.com
Fixes: ab9bda001b681 ("mm/damon/core: introduce address range type damos filter")
Signed-off-by: Hyeongtak Ji <hyeongtak.ji@sk.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-corec-avoid-unintentional-filtering-out-of-schemes
+++ a/mm/damon/core.c
@@ -924,7 +924,7 @@ static bool __damos_filter_out(struct da
 		matched = true;
 		break;
 	default:
-		break;
+		return false;
 	}
 
 	return matched == filter->matching;
_

Patches currently in -mm which might be from hyeongtak.ji@gmail.com are

mm-damon-corec-avoid-unintentional-filtering-out-of-schemes.patch

