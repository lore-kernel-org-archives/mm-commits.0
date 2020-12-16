Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A46AC0018C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:45:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 634C223124
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbgLPEpl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:45:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:50972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbgLPEpk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:45:40 -0500
Date:   Tue, 15 Dec 2020 20:44:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093900;
        bh=lskZnbeLCdBi/XM5wjTt+F9CnUp6n+3jmz8JFoHgJ5A=;
        h=From:To:Subject:In-Reply-To:From;
        b=oYqdar3EqMB6mhpfJsV+ArBswL97ieMMvjh8cObQvPsOd8mB4dPiaFI932UaYXssT
         2oRT5WMu9fk4GAw1seo4n+LuMnbfisNsOPIssN6u7qH9S7hPlUpU/FzDPlLjzvpDWt
         ajdx446t3YovbjAejAsBmWkDzDx7aG35q4icSX1o=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com, linux-mm@kvack.org,
        lukas.bulwahn@gmail.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, yashsri421@gmail.com
Subject:  [patch 49/95] checkpatch: avoid COMMIT_LOG_LONG_LINE
 warning for signature tags
Message-ID: <20201216044459.Cr3oYo_Y2%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
