Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62593C4743C
	for <mm-commits@archiver.kernel.org>; Wed, 23 Jun 2021 04:42:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A5AF6138C
	for <mm-commits@archiver.kernel.org>; Wed, 23 Jun 2021 04:42:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhFWEof (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Jun 2021 00:44:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:42676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229544AbhFWEoe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Jun 2021 00:44:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B510F61185;
        Wed, 23 Jun 2021 04:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624423337;
        bh=9WMVCF+xjV/y0lxnca0oe8BFaAa2G7nl+V6UTZnBEzE=;
        h=Date:From:To:Subject:From;
        b=LUaNvyv5x4oEnd129hlvHPBjNlXbNMfbKY9T3fXRWybXISR42y9W7dwb4JV91mhd1
         ucAIUB2afcpVbbbN8s3uW1KcrRXMYwBYz4OssJRduWp9tt/ny65O3FecU/+4ea3PXr
         PSopJCjcGawzelPL6NxKBQ94Mx7TfXaS229A7sNw=
Date:   Tue, 22 Jun 2021 21:42:17 -0700
From:   akpm@linux-foundation.org
To:     joe@perches.com, linux@roeck-us.net, mm-commits@vger.kernel.org,
        ribalda@chromium.org
Subject:  +
 =?US-ASCII?Q?checkpatch-do-not-complain-about-positive-return-values-s?=
 =?US-ASCII?Q?tarting-with-epoll.patch?= added to -mm tree
Message-ID: <20210623044217.KMX1tDBQg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: do not complain about positive return values starting with EPOLL
has been added to the -mm tree.  Its filename is
     checkpatch-do-not-complain-about-positive-return-values-starting-with-epoll.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-do-not-complain-about-positive-return-values-starting-with-epoll.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-do-not-complain-about-positive-return-values-starting-with-epoll.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from linux@roeck-us.net are

checkpatch-scripts-spdxcheckpy-now-requires-python3.patch
checkpatch-do-not-complain-about-positive-return-values-starting-with-epoll.patch

