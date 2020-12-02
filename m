Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 264D9C6369E
	for <mm-commits@archiver.kernel.org>; Wed,  2 Dec 2020 23:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF492221EB
	for <mm-commits@archiver.kernel.org>; Wed,  2 Dec 2020 23:45:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgLBXpi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Dec 2020 18:45:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:45670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726108AbgLBXpi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 2 Dec 2020 18:45:38 -0500
Date:   Wed, 02 Dec 2020 15:44:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606952691;
        bh=AhNK84sXXpi2EOJXD2PoDmauHvqTa6A33rxQkr1O5is=;
        h=From:To:Subject:From;
        b=GtCY0E8q7cmiK7P5xn5sFhu1BeZySA3FkNepzT/2hmSU5lFP8UyPDXacVB3BwNZtq
         cNOwJvmsOhgg+RoVl4OSSRmPked+ycBMhCIIbbjc2Swvj6EAsoS2ia36bEF2BE4tOo
         pjCqZSA4a9bjsyZRFDCk5z0x/RWh+XuvH5t26JBY=
From:   akpm@linux-foundation.org
To:     dwaipayanray1@gmail.com, joe@perches.com,
        mm-commits@vger.kernel.org, yepeilin.cs@gmail.com
Subject:  +
 checkpatch-fix-typo_spelling-check-for-words-with-apostrophe.patch added to
 -mm tree
Message-ID: <20201202234450.KzsSAsjqe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix TYPO_SPELLING check for words with apostrophe
has been added to the -mm tree.  Its filename is
     checkpatch-fix-typo_spelling-check-for-words-with-apostrophe.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-fix-typo_spelling-check-for-words-with-apostrophe.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-fix-typo_spelling-check-for-words-with-apostrophe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
+				my $ptr = substr($blank, 0, $-[1]) . "^";
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

Patches currently in -mm which might be from dwaipayanray1@gmail.com are

checkpatch-add-new-exception-to-repeated-word-check.patch
checkpatch-extend-attributes-check-to-handle-more-patterns.patch
checkpatch-improve-email-parsing.patch
checkpatch-fix-spelling-errors-and-remove-repeated-word.patch
checkpatch-fix-unescaped-left-brace.patch
checkpatch-add-warning-for-unnecessary-use-of-%h-and-%hh.patch
checkpatch-add-warning-for-lines-starting-with-a-in-commit-log.patch
checkpatch-fix-typo_spelling-check-for-words-with-apostrophe.patch

