Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45334C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:23:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25ACB61CAA
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbhGFTZl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:25:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:58848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229999AbhGFTZk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:25:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90C7C61CA9;
        Tue,  6 Jul 2021 19:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599380;
        bh=PMp/KIMdf/7/w7cGMOlOvnfhKiPdIyHjr7ZWwZX6WTA=;
        h=Date:From:To:Subject:From;
        b=yzRz7CHnnnAYfgJxMj+XlkGVKbclxg+pK/OPmu28o9uMjlfkdJzYwFZyssugc/AEb
         HdqX0JEGDxcYv4tPt5LrzxBQb6vkWLNktklwkYdxRbxfWDNk9CNg1CyIHNtRGVElPh
         nTNSXpWkiixLdTTdKQTiKFM2agssIUrGtzQ0fjKc=
Date:   Tue, 06 Jul 2021 12:23:00 -0700
From:   akpm@linux-foundation.org
To:     joe@perches.com, linux@roeck-us.net, mm-commits@vger.kernel.org,
        ribalda@chromium.org
Subject:  [merged]
 =?US-ASCII?Q?checkpatch-do-not-complain-about-positive-return-values-s?=
 =?US-ASCII?Q?tarting-with-epoll.patch?= removed from -mm tree
Message-ID: <20210706192300.LDCwGUJ-3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: do not complain about positive return values starting with EPOLL
has been removed from the -mm tree.  Its filename was
     checkpatch-do-not-complain-about-positive-return-values-starting-with-epoll.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


