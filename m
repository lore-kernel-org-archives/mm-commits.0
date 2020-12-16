Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4501C2BBCA
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:46:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98ADA2333E
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:46:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725960AbgLPEqD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:46:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:51340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgLPEqC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:46:02 -0500
Date:   Tue, 15 Dec 2020 20:45:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093922;
        bh=E28KMpjtlEEkUhibzvEum5NQ2noQ33V4xBsx/lRCnNM=;
        h=From:To:Subject:In-Reply-To:From;
        b=pTIP0BkTDCUimrmP9M26uSfUrxm4Kw06NshqARJ/oLSFwWkkbvMNvUqJ6xSVpDGrv
         KiAxhBXKAEc52JyMDvzHQvTJZVcK16KdUQp3sUSdEXka2Ya3DIzIzUdYX/sIBjKiXc
         r7H2XdEEAJueSoLre0qEh0dvbTnpuj0kvkq8gYIs=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dwaipayanray1@gmail.com,
        joe@perches.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, yepeilin.cs@gmail.com
Subject:  [patch 56/95] checkpatch: fix TYPO_SPELLING check for
 words with apostrophe
Message-ID: <20201216044521.yfiPsRHif%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Dwaipayan Ray <dwaipayanray1@gmail.com>
Subject: checkpatch: fix TYPO_SPELLING check for words with apostrophe

checkpatch reports a false TYPO_SPELLING warning for some words containing
an apostrophe when run with --codespell option.

A false positive is "doesn't".  Occurrence of the word causes checkpatch
to emit the following warning:

"WARNING: 'doesn'' may be misspelled - perhaps 'doesn't'?"

Modify the regex pattern to be more in line with the codespell default
word matching regex.  This fixes the word capture and avoids the false
warning.

In addition, highlight the misspelled word location by adding a caret
below the word.

[akpm@linux-foundation.org: make matched misspelling more obvious, per Joe]
  Link: https://lkml.kernel.org/r/09c24ef1aa2f1c4fe909d76f5426f08780b9d81c.camel@perches.com
Link: https://lkml.kernel.org/r/20201201190729.169733-1-dwaipayanray1@gmail.com
Signed-off-by: Dwaipayan Ray <dwaipayanray1@gmail.com>
Suggested-by: Joe Perches <joe@perches.com>
Reported-by: Peilin Ye <yepeilin.cs@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-fix-typo_spelling-check-for-words-with-apostrophe
+++ a/scripts/checkpatch.pl
@@ -3182,15 +3182,18 @@ sub process {
 # Check for various typo / spelling mistakes
 		if (defined($misspellings) &&
 		    ($in_commit_log || $line =~ /^(?:\+|Subject:)/i)) {
-			while ($rawline =~ /(?:^|[^a-z@])($misspellings)(?:\b|$|[^a-z@])/gi) {
+			while ($rawline =~ /(?:^|[^\w\-'`])($misspellings)(?:[^\w\-'`]|$)/gi) {
 				my $typo = $1;
+				my $blank = copy_spacing($rawline);
+				my $ptr = substr($blank, 0, $-[1]) . "^" x length($typo);
+				my $hereptr = "$hereline$ptr\n";
 				my $typo_fix = $spelling_fix{lc($typo)};
 				$typo_fix = ucfirst($typo_fix) if ($typo =~ /^[A-Z]/);
 				$typo_fix = uc($typo_fix) if ($typo =~ /^[A-Z]+$/);
 				my $msg_level = \&WARN;
 				$msg_level = \&CHK if ($file);
 				if (&{$msg_level}("TYPO_SPELLING",
-						  "'$typo' may be misspelled - perhaps '$typo_fix'?\n" . $herecurr) &&
+						  "'$typo' may be misspelled - perhaps '$typo_fix'?\n" . $hereptr) &&
 				    $fix) {
 					$fixed[$fixlinenr] =~ s/(^|[^A-Za-z@])($typo)($|[^A-Za-z@])/$1$typo_fix$3/;
 				}
_
