Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5CDCC11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFC6B61477
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238567AbhGAB7C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:59:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:48844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238564AbhGAB6z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:58:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B357A61469;
        Thu,  1 Jul 2021 01:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104585;
        bh=bbvVy1qxmudmoewmDYOVkrblofvGNtoijRMesP4b3Ec=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GOVt2u3495kAFpaCla5KplQe17BOWjXc2xt6Qew9/pu7/hlJCqRTjpN7WZ8/7rkv0
         UyTFTAaMLCNjN150u8yOhs+gXn7OFEyyvPUbMmybbP9uYsxALbe59YbW7H/xK9D7qw
         qj5O0i5B7Bbvx7DVnLsirBBLG/DR/XrqB1kz1zF8=
Date:   Wed, 30 Jun 2021 18:56:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com, linux-mm@kvack.org,
        linux@roeck-us.net, mm-commits@vger.kernel.org,
        ribalda@chromium.org, torvalds@linux-foundation.org
Subject:  [patch 175/192] checkpatch: do not complain about
 positive return values starting with EPOLL
Message-ID: <20210701015625.hw3VerOqR%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>
Subject: checkpatch: do not complain about positive return values starting with EPOLL

checkpatch complains about positive return values of poll functions. 
Example:

WARNING: return of an errno should typically be negative (ie: return -EPOLLIN)
+		return EPOLLIN;

Poll functions return positive values.  The defines for the return values
of poll functions all start with EPOLL, resulting in a number of false
positives.  An often used workaround is to assign poll function return
values to variables and returning that variable, but that is a less than
perfect solution.

There is no error definition which starts with EPOLL, so it is safe to
omit the warning for return values starting with EPOLL.

Link: https://lkml.kernel.org/r/20210622004334.638680-1-linux@roeck-us.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Joe Perches <joe@perches.com>
Cc: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-do-not-complain-about-positive-return-values-starting-with-epoll
+++ a/scripts/checkpatch.pl
@@ -5462,7 +5462,7 @@ sub process {
 # Return of what appears to be an errno should normally be negative
 		if ($sline =~ /\breturn(?:\s*\(+\s*|\s+)(E[A-Z]+)(?:\s*\)+\s*|\s*)[;:,]/) {
 			my $name = $1;
-			if ($name ne 'EOF' && $name ne 'ERROR') {
+			if ($name ne 'EOF' && $name ne 'ERROR' && $name !~ /^EPOLL/) {
 				WARN("USE_NEGATIVE_ERRNO",
 				     "return of an errno should typically be negative (ie: return -$1)\n" . $herecurr);
 			}
_
