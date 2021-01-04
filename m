Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAE4BC433E0
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 18:57:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBF8A21D1B
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 18:57:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbhADS5E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Jan 2021 13:57:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:49978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbhADS5E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 4 Jan 2021 13:57:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31CE522241;
        Mon,  4 Jan 2021 18:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609786583;
        bh=djLpm0BvuU/3vfdDzBoPcaDqTAI8wfHnRBFEtUfTDuU=;
        h=Date:From:To:Subject:From;
        b=QIPk95YOswplLKj93M+CEb7x8xGrE3rx5pEOfOUmmnDnrGc+Pj+cgqnhel6sv1gMZ
         f9RBRvECPj3zNie1Myu/vbmn4rYbAzVvvPBTqT+/s/kuca59wgKj3LMi0bUCI9yG3f
         iGZYmeEzXCI9UbUgU+YVtV1YKGRCUJt5cjP8gW/Y=
Date:   Mon, 04 Jan 2021 10:56:22 -0800
From:   akpm@linux-foundation.org
To:     broonie@kernel.org, matti.vaittinen@fi.rohmeurope.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  [merged]
 lib-linear_ranges-fix-repeated-words-one-typo.patch removed from -mm tree
Message-ID: <20210104185622.2wDgVNRUM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/linear_ranges: fix repeated words & one typo
has been removed from the -mm tree.  Its filename was
     lib-linear_ranges-fix-repeated-words-one-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib/linear_ranges: fix repeated words & one typo

Change "which which" to "for which" in 3 places.
Change "ranges" to possessive "range's" in 1 place.

Link: https://lkml.kernel.org/r/20201221040610.12809-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Cc: Mark Brown <broonie@kernel.org>
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

fs-delete-repeated-words-in-comments.patch
mm-zswap-clean-up-confusing-comment.patch

