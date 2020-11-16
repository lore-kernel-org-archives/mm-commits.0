Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 870FDC4742C
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 19:52:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24A5B20829
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 19:52:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="g5tu2uIh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgKPTwF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 14:52:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:46150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726575AbgKPTwF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Nov 2020 14:52:05 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8745207BC;
        Mon, 16 Nov 2020 19:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605556325;
        bh=NqCzLRV+RmUONIyh0hr6W7qBtajx4eOKF6VnbwonxHQ=;
        h=Date:From:To:Subject:From;
        b=g5tu2uIhEmn+s6eLwpW+VnXGoqyMgZAd7GyophdD/XtmA7KgjuYNC9zEbVZZPxf3O
         /CPykp/w6TNFOdvBKBsmV6eTufzxnJE9hxQcPUtgdBZ1DROFShUsokOk0z5jRDZSxu
         La15nnWjIQESO85r9Q37xzAiWS86vu3NIqkLO5y4=
Date:   Mon, 16 Nov 2020 11:52:04 -0800
From:   akpm@linux-foundation.org
To:     joe@perches.com, lukas.bulwahn@gmail.com,
        mm-commits@vger.kernel.org, yashsri421@gmail.com
Subject:  +
 checkpatch-avoid-commit_log_long_line-warning-for-signature-tags.patch
 added to -mm tree
Message-ID: <20201116195204.qnYUEMWYd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: avoid COMMIT_LOG_LONG_LINE warning for signature tags
has been added to the -mm tree.  Its filename is
     checkpatch-avoid-commit_log_long_line-warning-for-signature-tags.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-avoid-commit_log_long_line-warning-for-signature-tags.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-avoid-commit_log_long_line-warning-for-signature-tags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

checkpatch-fix-false-positives-in-repeated_word-warning.patch
checkpatch-add-fix-option-for-gerrit_change_id.patch
checkpatch-avoid-commit_log_long_line-warning-for-signature-tags.patch

