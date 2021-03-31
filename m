Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3F67C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 04:29:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AD8E61581
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 04:29:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhCaE2u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Mar 2021 00:28:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229852AbhCaE23 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 31 Mar 2021 00:28:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD5F16023F;
        Wed, 31 Mar 2021 04:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617164909;
        bh=WHLk3sCtAikqHljshFS0AwTEgo/qAEjcpGUrMzPvX1A=;
        h=Date:From:To:Subject:From;
        b=Tgs6dkXCppSvF9Qh2xgbJfAqVpoz7YpXZ3HpVE6ny0dpEqnL4aqUCjYTWkut1zEYr
         6cEIPRHGGUthvoi5f79Ync6dypJf0Cb0X8kZjA9uy/LYrLFdIJSmdZaQRaZe9vWzY0
         1zwXej+ectyDAFY9j7OAL6DHatI9mfOVB8gVrXY8=
Date:   Tue, 30 Mar 2021 21:28:28 -0700
From:   akpm@linux-foundation.org
To:     joe@perches.com, mm-commits@vger.kernel.org
Subject:  +
 checkpatch-warn-when-missing-newline-in-return-sysfs_emit-formats.patch
 added to -mm tree
Message-ID: <20210331042828.IuXgOoaK_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: warn when missing newline in return sysfs_emit() formats
has been added to the -mm tree.  Its filename is
     checkpatch-warn-when-missing-newline-in-return-sysfs_emit-formats.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-warn-when-missing-newline-in-return-sysfs_emit-formats.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-warn-when-missing-newline-in-return-sysfs_emit-formats.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: warn when missing newline in return sysfs_emit() formats

return sysfs_emit() uses should include a newline.

Suggest adding a newline when one is missing.
Add one using --fix too.

Link: https://lkml.kernel.org/r/aa1819fa5faf786573df298e5e2e7d357ba7d4ad.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-warn-when-missing-newline-in-return-sysfs_emit-formats
+++ a/scripts/checkpatch.pl
@@ -7103,6 +7103,17 @@ sub process {
 			     "Using $1 should generally have parentheses around the comparison\n" . $herecurr);
 		}
 
+# return sysfs_emit(foo, fmt, ...) fmt without newline
+		if ($line =~ /\breturn\s+sysfs_emit\s*\(\s*$FuncArg\s*,\s*($String)/ &&
+		    substr($rawline, $-[6], $+[6] - $-[6]) !~ /\\n"$/) {
+			my $offset = $+[6] - 1;
+			if (WARN("SYSFS_EMIT",
+				 "return sysfs_emit(...) formats should include a terminating newline\n" . $herecurr) &&
+			    $fix) {
+				substr($fixed[$fixlinenr], $offset, 0) = '\\n';
+			}
+		}
+
 # nested likely/unlikely calls
 		if ($line =~ /\b(?:(?:un)?likely)\s*\(\s*!?\s*(IS_ERR(?:_OR_NULL|_VALUE)?|WARN)/) {
 			WARN("LIKELY_MISUSE",
_

Patches currently in -mm which might be from joe@perches.com are

mm-reduce-mem_dump_obj-object-size.patch
checkpatch-warn-when-missing-newline-in-return-sysfs_emit-formats.patch

