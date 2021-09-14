Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D218EC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 14 Sep 2021 03:10:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4F1D6113B
	for <mm-commits@archiver.kernel.org>; Tue, 14 Sep 2021 03:10:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238376AbhINDMG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Sep 2021 23:12:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238205AbhINDMG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Sep 2021 23:12:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1C2360E90;
        Tue, 14 Sep 2021 03:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631589049;
        bh=mipQ/6llGMVSrffVqEDteT2+M6Jtd8tKJ+gPsoyAh24=;
        h=Date:From:To:Subject:From;
        b=uBV3YVfjZMteuK1HloMrVsLBhHYXP9nhYDIZAQyyWZNXO5S2gbyzUj3usLu/+02Wd
         V4XC4aqYYQZRteb75k5wE7y/F25fC7V3f58P/+DErQMFowlowL5vCqdB5DNHtpElo7
         8UHPb8u5+oZOfT7F8KiXvsJdLaaKP41Rineqol3c=
Date:   Mon, 13 Sep 2021 20:10:49 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, eb@emlix.com, mm-commits@vger.kernel.org
Subject:  + mm-use-__pfn_to_section-instead-of-open-coding-it.patch
 added to -mm tree
Message-ID: <20210914031049.Tic87Y1s8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use __pfn_to_section() instead of open coding it
has been added to the -mm tree.  Its filename is
     mm-use-__pfn_to_section-instead-of-open-coding-it.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-use-__pfn_to_section-instead-of-open-coding-it.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-use-__pfn_to_section-instead-of-open-coding-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rolf Eike Beer <eb@emlix.com>
Subject: mm: use __pfn_to_section() instead of open coding it

It is defined in the same file just a few lines above.

Link: https://lkml.kernel.org/r/4598487.Rc0NezkW7i@mobilepool36.emlix.com
Signed-off-by: Rolf Eike Beer <eb@emlix.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mmzone.h~mm-use-__pfn_to_section-instead-of-open-coding-it
+++ a/include/linux/mmzone.h
@@ -1481,7 +1481,7 @@ static inline int pfn_valid(unsigned lon
 
 	if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
 		return 0;
-	ms = __nr_to_section(pfn_to_section_nr(pfn));
+	ms = __pfn_to_section(pfn);
 	if (!valid_section(ms))
 		return 0;
 	/*
@@ -1496,7 +1496,7 @@ static inline int pfn_in_present_section
 {
 	if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
 		return 0;
-	return present_section(__nr_to_section(pfn_to_section_nr(pfn)));
+	return present_section(__pfn_to_section(pfn));
 }
 
 static inline unsigned long next_present_section_nr(unsigned long section_nr)
_

Patches currently in -mm which might be from eb@emlix.com are

mm-use-__pfn_to_section-instead-of-open-coding-it.patch

