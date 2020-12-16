Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 948C2C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:10:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C91D23433
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:10:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgLPRK2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:10:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:60006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727045AbgLPRK2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:10:28 -0500
Date:   Wed, 16 Dec 2020 09:10:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138612;
        bh=ZU8Ass8oay39mL7irUBahk62Uqd32MxF8isEpDgjeuI=;
        h=From:To:Subject:From;
        b=V3NZ5KS1R6jK3u/H/TQwjNyL44hvlxkLZUdJ3ZEwtnlMrVPy2bfqkUdUrZqZzseC8
         brYUNAK18NnES7yvYhmZksEFZgpC0Z90uhRIm7W6aKyvFiF9NAXidyapvDQHaMc2mk
         P5s5gz0bdQ7ud+l9kgevoFGvNedSrZ9DirgNkB9w=
From:   akpm@linux-foundation.org
To:     joe@perches.com, lukas.bulwahn@gmail.com,
        mm-commits@vger.kernel.org, yashsri421@gmail.com
Subject:  [merged]
 checkpatch-avoid-commit_log_long_line-warning-for-signature-tags.patch
 removed from -mm tree
Message-ID: <20201216171012.e3F8qoMUA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: avoid COMMIT_LOG_LONG_LINE warning for signature tags
has been removed from the -mm tree.  Its filename was
     checkpatch-avoid-commit_log_long_line-warning-for-signature-tags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Aditya Srivastava <yashsri421@gmail.com>
Subject: checkpatch: avoid COMMIT_LOG_LONG_LINE warning for signature tags

Currently checkpatch warns us for long lines in commits even for signature
tag lines.

Generally these lines exceed the 75-character limit because of:
1) long names and long email address
2) some comments on scoped review and acknowledgement, i.e., for a
dedicated pointer on what was reported by the identity in 'Reported-by'
3) some additional comments on CC: stable@vger.org tags

Exclude signature tag lines from this class of warning.

There were 1896 COMMIT_LOG_LONG_LINE warnings in v5.6..v5.8 before this
patch application and 1879 afterwards.

A quick manual check found all the dropped warnings related to signature
tags.

Link: https://lkml.kernel.org/r/20201116083754.10629-1-yashsri421@gmail.com
Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-avoid-commit_log_long_line-warning-for-signature-tags
+++ a/scripts/checkpatch.pl
@@ -2952,8 +2952,8 @@ sub process {
 					# file delta changes
 		      $line =~ /^\s*(?:[\w\.\-]+\/)++[\w\.\-]+:/ ||
 					# filename then :
-		      $line =~ /^\s*(?:Fixes:|Link:)/i ||
-					# A Fixes: or Link: line
+		      $line =~ /^\s*(?:Fixes:|Link:|$signature_tags)/i ||
+					# A Fixes: or Link: line or signature tag line
 		      $commit_log_possible_stack_dump)) {
 			WARN("COMMIT_LOG_LONG_LINE",
 			     "Possible unwrapped commit description (prefer a maximum 75 chars per line)\n" . $herecurr);
_

Patches currently in -mm which might be from yashsri421@gmail.com are


