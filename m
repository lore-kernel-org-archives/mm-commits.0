Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FBA1C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 01:02:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC1DB22287
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 01:02:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgLWBCl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Dec 2020 20:02:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:54802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725902AbgLWBCl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Dec 2020 20:02:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9376722287;
        Wed, 23 Dec 2020 01:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608685320;
        bh=jFuh35c7eU/dSrUh9twGeTUuZqDZ5XpSac6dhCiHQd4=;
        h=Date:From:To:Subject:From;
        b=JbaUGn5IAxTNBEqHGxf8oM/gkaRlTPfchk9OdUkb8QkGdnLFB6kQOEkgJwAQIP075
         AUGHp0ZZ2e39/UAsB+muEiTgQTKYvQp9QfpUM53gfbBmCPUaZiMJVnVnRcXoX7Q6VG
         BUx2A49nOy+QWzyiUQbVDztdpBIc6KGXJsYzFfQA=
Date:   Tue, 22 Dec 2020 17:02:00 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, matti.vaittinen@fi.rohmeurope.com,
        broonie@kernel.org, rdunlap@infradead.org
Subject:  + lib-linear_ranges-fix-repeated-words-one-typo.patch added
 to -mm tree
Message-ID: <20201223010200.tq1gx%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/linear_ranges: fix repeated words & one typo
has been added to the -mm tree.  Its filename is
     lib-linear_ranges-fix-repeated-words-one-typo.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-linear_ranges-fix-repeated-words-one-typo.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-linear_ranges-fix-repeated-words-one-typo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib/linear_ranges: fix repeated words & one typo

Change "which which" to "for which" in 3 places.
Change "ranges" to possessive "range's" in 1 place.

Link: https://lkml.kernel.org/r/20201221040610.12809-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/linear_ranges.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/lib/linear_ranges.c~lib-linear_ranges-fix-repeated-words-one-typo
+++ a/lib/linear_ranges.c
@@ -128,7 +128,7 @@ EXPORT_SYMBOL_GPL(linear_range_get_value
  * @selector:	address where found selector value is updated
  * @found:	flag to indicate that given value was in the range
  *
- * Return selector which which range value is closest match for given
+ * Return selector for which range value is closest match for given
  * input value. Value is matching if it is equal or smaller than given
  * value. If given value is in the range, then @found is set true.
  *
@@ -168,11 +168,11 @@ EXPORT_SYMBOL_GPL(linear_range_get_selec
  * @selector:	address where found selector value is updated
  * @found:	flag to indicate that given value was in the range
  *
- * Scan array of ranges for selector which which range value matches given
+ * Scan array of ranges for selector for which range value matches given
  * input value. Value is matching if it is equal or smaller than given
  * value. If given value is found to be in a range scanning is stopped and
  * @found is set true. If a range with values smaller than given value is found
- * but the range max is being smaller than given value, then the ranges
+ * but the range max is being smaller than given value, then the range's
  * biggest selector is updated to @selector but scanning ranges is continued
  * and @found is set to false.
  *
@@ -209,7 +209,7 @@ EXPORT_SYMBOL_GPL(linear_range_get_selec
  * @selector:	address where found selector value is updated
  * @found:	flag to indicate that given value was in the range
  *
- * Return selector which which range value is closest match for given
+ * Return selector for which range value is closest match for given
  * input value. Value is matching if it is equal or higher than given
  * value. If given value is in the range, then @found is set true.
  *
_

Patches currently in -mm which might be from rdunlap@infradead.org are

zlib-move-export_symbol-and-module_license-out-of-dfltcc_symsc.patch
mm-zswap-clean-up-confusing-comment.patch
lib-linear_ranges-fix-repeated-words-one-typo.patch

