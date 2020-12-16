Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F813C0018C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D4712332A
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgLPEo4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:44:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:49140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgLPEo4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:44:56 -0500
Date:   Tue, 15 Dec 2020 20:44:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093881;
        bh=K/bZBVp903bWP++jQnq7F61aAHPXl38hOH5H3SUsxUM=;
        h=From:To:Subject:In-Reply-To:From;
        b=TRAXQbV46Z7HAHPTpD/gxR5unrS1hx9oCUJfEYVzHSuImLf0lkRDdY8hwXD01Jml0
         5gDP2LtmZ5mmmzsqoGeapRy/JQkn7Qcd/BXVgXG/pJ2YMhptJauTSqcRbWnTYld5Yn
         f/PAXIAPG9bnjjlQRe2x0Qhhz6ukxin/bDOn4ZP8=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        trix@redhat.com
Subject:  [patch 43/95] checkpatch: add a fixer for missing newline
 at eof
Message-ID: <20201216044440.n0lgSiFqI%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Tom Rix <trix@redhat.com>
Subject: checkpatch: add a fixer for missing newline at eof

Remove the trailing error message from the fixed lines.

Link: https://lkml.kernel.org/r/20201017142546.28988-1-trix@redhat.com
Signed-off-by: Tom Rix <trix@redhat.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-add-a-fixer-for-missing-newline-at-eof
+++ a/scripts/checkpatch.pl
@@ -3418,8 +3418,11 @@ sub process {
 
 # check for adding lines without a newline.
 		if ($line =~ /^\+/ && defined $lines[$linenr] && $lines[$linenr] =~ /^\\ No newline at end of file/) {
-			WARN("MISSING_EOF_NEWLINE",
-			     "adding a line without newline at end of file\n" . $herecurr);
+			if (WARN("MISSING_EOF_NEWLINE",
+			         "adding a line without newline at end of file\n" . $herecurr) &&
+			    $fix) {
+				fix_delete_line($fixlinenr+1, "No newline at end of file");
+			}
 		}
 
 # check we are in a valid source file C or perl if not then ignore this hunk
_
