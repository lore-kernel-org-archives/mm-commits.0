Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC72AC48BDF
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 22:47:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AF866128C
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 22:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhFOWtd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Jun 2021 18:49:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229898AbhFOWtb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Jun 2021 18:49:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7C7C61246;
        Tue, 15 Jun 2021 22:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623797245;
        bh=2kvyHCNcJjKDHEJVuFhl39gxkBPkzGpIZm/O4Jp2m0U=;
        h=Date:From:To:Subject:From;
        b=OLK0wJx49o5HkF2PNQeqTlwhUretTF8l7Bm1ioPpXrnbjCI2h3GnpsrPwmC/3flGO
         ZZVqjwjTjoWo8sPl83o1JLlMiai8r4yhUa5LUe9aGfqTqykO00bB7IM3Q4URPZIyhO
         B2N8/LG3WcKCYA3b+uyzo0jR0A0ybwMF93QZEwgE=
Date:   Tue, 15 Jun 2021 15:47:25 -0700
From:   akpm@linux-foundation.org
To:     andy.shevchenko@gmail.com, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  +
 kernelh-split-out-kstrtox-and-simple_strtox-to-a-separate-header-fix.patch
 added to -mm tree
Message-ID: <20210615224725.cQ3_-k6vm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kstrtox: fix documentation references
has been added to the -mm tree.  Its filename is
     kernelh-split-out-kstrtox-and-simple_strtox-to-a-separate-header-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernelh-split-out-kstrtox-and-simple_strtox-to-a-separate-header-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernelh-split-out-kstrtox-and-simple_strtox-to-a-separate-header-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: kstrtox: fix documentation references

After moving declarations of kstrto*() to a separate header, update the doc.

Link: https://lkml.kernel.org/r/20210615220003.377901-1-andy.shevchenko@gmail.com
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/kernel-api.rst |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/Documentation/core-api/kernel-api.rst~kernelh-split-out-kstrtox-and-simple_strtox-to-a-separate-header-fix
+++ a/Documentation/core-api/kernel-api.rst
@@ -24,11 +24,8 @@ String Conversions
 .. kernel-doc:: lib/vsprintf.c
    :export:
 
-.. kernel-doc:: include/linux/kernel.h
-   :functions: kstrtol
-
-.. kernel-doc:: include/linux/kernel.h
-   :functions: kstrtoul
+.. kernel-doc:: include/linux/kstrtox.h
+   :functions: kstrtol kstrtoul
 
 .. kernel-doc:: lib/kstrtox.c
    :export:
_

Patches currently in -mm which might be from andy.shevchenko@gmail.com are

kernelh-split-out-kstrtox-and-simple_strtox-to-a-separate-header-fix.patch

