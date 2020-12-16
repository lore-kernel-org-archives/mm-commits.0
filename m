Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E841C2BBCA
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:10:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19820233FE
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgLPRKY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:10:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:60398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726706AbgLPRKY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:10:24 -0500
Date:   Wed, 16 Dec 2020 09:09:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138582;
        bh=TDz96Ur6yv3uGYnLL3iZDFu5mkcXdfnUcaHB2icZFzI=;
        h=From:To:Subject:From;
        b=L4JtX2hWQTZibh1il9KBHWL1f8eRJIqufUapei2PAmLb+SaVfnCjbPm5FliYMoQS7
         SPs0aFPz5meItmT8OOY36QD5PS+mVDom3CwJoiCb7OYebsDBWRSP4/dtoHTo6WgrTz
         f/BzOlyqPLY6FzUQr9ANNr98XUzWwDutZjsoZoW4=
From:   akpm@linux-foundation.org
To:     dwaipayanray1@gmail.com, joe@perches.com, lukas.bulwahn@gmail.com,
        mm-commits@vger.kernel.org, yashsri421@gmail.com
Subject:  [merged]
 checkpatch-add-new-exception-to-repeated-word-check.patch removed from -mm
 tree
Message-ID: <20201216170941.VvmAPqgol%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add new exception to repeated word check
has been removed from the -mm tree.  Its filename was
     checkpatch-add-new-exception-to-repeated-word-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dwaipayan Ray <dwaipayanray1@gmail.com>
Subject: checkpatch: add new exception to repeated word check

Recently, commit 4f6ad8aa1eac ("checkpatch: move repeated word test")
moved the repeated word test to check for more file types. But after
this, if checkpatch.pl is run on MAINTAINERS, it generates several
new warnings of the type:

WARNING: Possible repeated word: 'git'

For example:
WARNING: Possible repeated word: 'git'
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml.git

So, the pattern "git git://..." is a false positive in this case.

There are several other combinations which may produce a wrong
warning message, such as "@size size", ":Begin begin", etc.

Extend repeated word check to compare the characters before and
after the word matches.

If there is a non whitespace character before the first word or a
non whitespace character excluding punctuation characters after
the second word, then the check is skipped and the warning is avoided.

Also add case insensitive word matching to the repeated word check.

Link: https://lore.kernel.org/linux-kernel-mentees/81b6a0bb2c7b9256361573f7a13201ebcd4876f1.camel@perches.com/
Link: https://lkml.kernel.org/r/20201017162732.152351-1-dwaipayanray1@gmail.com
Signed-off-by: Dwaipayan Ray <dwaipayanray1@gmail.com>
Suggested-by: Joe Perches <joe@perches.com>
Suggested-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Cc: Aditya Srivastava <yashsri421@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-add-new-exception-to-repeated-word-check
+++ a/scripts/checkpatch.pl
@@ -3050,19 +3050,30 @@ sub process {
 
 # check for repeated words separated by a single space
 		if ($rawline =~ /^\+/ || $in_commit_log) {
+			pos($rawline) = 1 if (!$in_commit_log);
 			while ($rawline =~ /\b($word_pattern) (?=($word_pattern))/g) {
 
 				my $first = $1;
 				my $second = $2;
-
+				my $start_pos = $-[1];
+				my $end_pos = $+[2];
 				if ($first =~ /(?:struct|union|enum)/) {
 					pos($rawline) += length($first) + length($second) + 1;
 					next;
 				}
 
-				next if ($first ne $second);
+				next if (lc($first) ne lc($second));
 				next if ($first eq 'long');
 
+				# check for character before and after the word matches
+				my $start_char = '';
+				my $end_char = '';
+				$start_char = substr($rawline, $start_pos - 1, 1) if ($start_pos > ($in_commit_log ? 0 : 1));
+				$end_char = substr($rawline, $end_pos, 1) if ($end_pos < length($rawline));
+
+				next if ($start_char =~ /^\S$/);
+				next if (index(" \t.,;?!", $end_char) == -1);
+
 				if (WARN("REPEATED_WORD",
 					 "Possible repeated word: '$first'\n" . $herecurr) &&
 				    $fix) {
_

Patches currently in -mm which might be from dwaipayanray1@gmail.com are


