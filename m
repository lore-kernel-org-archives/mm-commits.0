Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A149FC433DB
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 00:27:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6780A22E00
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 00:27:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbhAGA12 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Jan 2021 19:27:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:55936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726297AbhAGA11 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 6 Jan 2021 19:27:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6EC322D75;
        Thu,  7 Jan 2021 00:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609979206;
        bh=9uGqNtOkhRQc6LLSUto/9uzL4mYznvLnCQJr0X9AiKo=;
        h=Date:From:To:Subject:From;
        b=z2lFTdffpgDS06X/l87hisLT0dq9K530zGNdj7esfplOGGpr7J3DGmwCQt2BIr5JG
         DukCFb6i6Mqcp3sgjTFUslGqrVD7xZgv1sQPgm1ENT4/EkPrD1ZcDG6zLIgJl2pDZU
         RLsj4odAWJUff50xON4siC6OZmCyvI+okgu3/cWk=
Date:   Wed, 06 Jan 2021 16:26:46 -0800
From:   akpm@linux-foundation.org
To:     dwaipayanray1@gmail.com, joe@perches.com,
        mm-commits@vger.kernel.org
Subject:  + checkpatch-trivial-style-fixes.patch added to -mm tree
Message-ID: <20210107002646.zSkrKl_T9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: trivial style fixes
has been added to the -mm tree.  Its filename is
     checkpatch-trivial-style-fixes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-trivial-style-fixes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-trivial-style-fixes.patch

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
Subject: checkpatch: trivial style fixes

Indentations should use tabs wherever possible.
Replace spaces by tabs for indents.

Link: https://lkml.kernel.org/r/20210105103044.40282-1-dwaipayanray1@gmail.com
Signed-off-by: Dwaipayan Ray <dwaipayanray1@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-trivial-style-fixes
+++ a/scripts/checkpatch.pl
@@ -2974,7 +2974,7 @@ sub process {
 				}
 				if (!defined $lines[$linenr]) {
 					WARN("BAD_SIGN_OFF",
-                                             "Co-developed-by: must be immediately followed by Signed-off-by:\n" . "$here\n" . $rawline);
+					     "Co-developed-by: must be immediately followed by Signed-off-by:\n" . "$here\n" . $rawline);
 				} elsif ($rawlines[$linenr] !~ /^\s*signed-off-by:\s*(.*)/i) {
 					WARN("BAD_SIGN_OFF",
 					     "Co-developed-by: must be immediately followed by Signed-off-by:\n" . "$here\n" . $rawline . "\n" .$rawlines[$linenr]);
@@ -2997,8 +2997,8 @@ sub process {
 			if (ERROR("GERRIT_CHANGE_ID",
 			          "Remove Gerrit Change-Id's before submitting upstream\n" . $herecurr) &&
 			    $fix) {
-                                fix_delete_line($fixlinenr, $rawline);
-                        }
+				fix_delete_line($fixlinenr, $rawline);
+			}
 		}
 
 # Check if the commit log is in a possible stack dump
@@ -3240,10 +3240,10 @@ sub process {
 				next if ($start_char =~ /^\S$/);
 				next if (index(" \t.,;?!", $end_char) == -1);
 
-                                # avoid repeating hex occurrences like 'ff ff fe 09 ...'
-                                if ($first =~ /\b[0-9a-f]{2,}\b/i) {
-                                        next if (!exists($allow_repeated_words{lc($first)}));
-                                }
+				# avoid repeating hex occurrences like 'ff ff fe 09 ...'
+				if ($first =~ /\b[0-9a-f]{2,}\b/i) {
+					next if (!exists($allow_repeated_words{lc($first)}));
+				}
 
 				if (WARN("REPEATED_WORD",
 					 "Possible repeated word: '$first'\n" . $herecurr) &&
@@ -4432,7 +4432,7 @@ sub process {
 			WARN("STATIC_CONST_CHAR_ARRAY",
 			     "char * array declaration might be better as static const\n" .
 				$herecurr);
-               }
+		}
 
 # check for sizeof(foo)/sizeof(foo[0]) that could be ARRAY_SIZE(foo)
 		if ($line =~ m@\bsizeof\s*\(\s*($Lval)\s*\)@) {
@@ -5285,7 +5285,7 @@ sub process {
 		    $lines[$linenr - 3] !~ /^[ +]\s*$Ident\s*:/) {
 			WARN("RETURN_VOID",
 			     "void function return statements are not generally useful\n" . $hereprev);
-               }
+		}
 
 # if statements using unnecessary parentheses - ie: if ((foo == bar))
 		if ($perl_version_ok &&
_

Patches currently in -mm which might be from dwaipayanray1@gmail.com are

checkpatch-trivial-style-fixes.patch

