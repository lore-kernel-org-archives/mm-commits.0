Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EB38C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F0746143B
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhEHWyN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:54:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229728AbhEHWyN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:54:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A37E610FA;
        Sat,  8 May 2021 22:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514391;
        bh=VjEI86r9t0LjaStpL5pLeei6aSC2iUMy0p9lcple3hk=;
        h=Date:From:To:Subject:From;
        b=Z1bxJf03JAd+GEjKlp2vk7w3NxGQ1zj/TZivdKuw/EwMP71jKO3S7wd7hB8Krhlg+
         jZFoTzVebr/ZtMcjMSQT/jD2SqiBA6PYJe/ieaRN6Ap64DqJ0+95A5AK/OTV4oMWhV
         y1L4KEdXgg/JKyeV2+aVHj4DpqVW+VoisBwL1kTw=
Date:   Sat, 08 May 2021 15:53:11 -0700
From:   akpm@linux-foundation.org
To:     joe@perches.com, mm-commits@vger.kernel.org
Subject:  [merged]
 checkpatch-warn-when-missing-newline-in-return-sysfs_emit-formats.patch
 removed from -mm tree
Message-ID: <20210508225311.KJ1gFnEqs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: warn when missing newline in return sysfs_emit() formats
has been removed from the -mm tree.  Its filename was
     checkpatch-warn-when-missing-newline-in-return-sysfs_emit-formats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -7198,6 +7198,17 @@ sub process {
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


