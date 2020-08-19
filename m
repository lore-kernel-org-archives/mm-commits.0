Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF159C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 01:42:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD41920855
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 01:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597801363;
	bh=PGGuID//p+sptN+dfXmDy0NkJG+MeBAUhi6d5dKeJQs=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=RgTcWa+0wtluhmeg9P81VYMe6X2w0+UDX+NfBJnzvVHCgf8dLXSSPThkvmL6mKEJU
	 s3Fs00E+D9NvJv/tLcYzEzFkV81xAmrTN2LE3xkL5YqfgYXDVFk28+Mw+lG1Y7npYC
	 ucEwAslxNUL2tmkDW8JyIekgXkvkWMzZIprlu1aE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727808AbgHSBmn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 21:42:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:59864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726367AbgHSBmm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 21:42:42 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 982A92083B;
        Wed, 19 Aug 2020 01:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597801361;
        bh=PGGuID//p+sptN+dfXmDy0NkJG+MeBAUhi6d5dKeJQs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=DlWdJ2z3ZssfiB3ptur7ypDYf0bU++69burYfC4HMF0H6Zz+59kj6I4CdyXDbEJfg
         ePDMFNE/ksoFd3fu5NAm97dvLcZ+6pglkbaIqkztErkx452VCJHUY27J+4JEEjOx+8
         SpPA4nvggobPMydRdKCg1sxPrfrJvcWD+hvmFd6Q=
Date:   Tue, 18 Aug 2020 18:42:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     joe@perches.com, mm-commits@vger.kernel.org
Subject:  + checkpatch-move-repeated-word-test.patch added to -mm
 tree
Message-ID: <20200819014241.jC2U-SEgZ%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: move repeated word test
has been added to the -mm tree.  Its filename is
     checkpatch-move-repeated-word-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-move-repeated-word-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-move-repeated-word-test.patch

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
Subject: checkpatch: move repeated word test

Currently this test only works on .[ch] files.

Move the test to check more file types and the commit log.

Link: http://lkml.kernel.org/r/180b3b5677771c902b2e2f7a2b7090ede65fe004.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   72 ++++++++++++++++++++--------------------
 1 file changed, 36 insertions(+), 36 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-move-repeated-word-test
+++ a/scripts/checkpatch.pl
@@ -2993,6 +2993,42 @@ sub process {
 			}
 		}
 
+# check for repeated words separated by a single space
+		if ($rawline =~ /^\+/ || $in_commit_log) {
+			while ($rawline =~ /\b($word_pattern) (?=($word_pattern))/g) {
+
+				my $first = $1;
+				my $second = $2;
+
+				if ($first =~ /(?:struct|union|enum)/) {
+					pos($rawline) += length($first) + length($second) + 1;
+					next;
+				}
+
+				next if ($first ne $second);
+				next if ($first eq 'long');
+
+				if (WARN("REPEATED_WORD",
+					 "Possible repeated word: '$first'\n" . $herecurr) &&
+				    $fix) {
+					$fixed[$fixlinenr] =~ s/\b$first $second\b/$first/;
+				}
+			}
+
+			# if it's a repeated word on consecutive lines in a comment block
+			if ($prevline =~ /$;+\s*$/ &&
+			    $prevrawline =~ /($word_pattern)\s*$/) {
+				my $last_word = $1;
+				if ($rawline =~ /^\+\s*\*\s*$last_word /) {
+					if (WARN("REPEATED_WORD",
+						 "Possible repeated word: '$last_word'\n" . $hereprev) &&
+					    $fix) {
+						$fixed[$fixlinenr] =~ s/(\+\s*\*\s*)$last_word /$1/;
+					}
+				}
+			}
+		}
+
 # ignore non-hunk lines and lines being removed
 		next if (!$hunk_line || $line =~ /^-/);
 
@@ -3316,42 +3352,6 @@ sub process {
 			}
 		}
 
-# check for repeated words separated by a single space
-		if ($rawline =~ /^\+/) {
-			while ($rawline =~ /\b($word_pattern) (?=($word_pattern))/g) {
-
-				my $first = $1;
-				my $second = $2;
-
-				if ($first =~ /(?:struct|union|enum)/) {
-					pos($rawline) += length($first) + length($second) + 1;
-					next;
-				}
-
-				next if ($first ne $second);
-				next if ($first eq 'long');
-
-				if (WARN("REPEATED_WORD",
-					 "Possible repeated word: '$first'\n" . $herecurr) &&
-				    $fix) {
-					$fixed[$fixlinenr] =~ s/\b$first $second\b/$first/;
-				}
-			}
-
-			# if it's a repeated word on consecutive lines in a comment block
-			if ($prevline =~ /$;+\s*$/ &&
-			    $prevrawline =~ /($word_pattern)\s*$/) {
-				my $last_word = $1;
-				if ($rawline =~ /^\+\s*\*\s*$last_word /) {
-					if (WARN("REPEATED_WORD",
-						 "Possible repeated word: '$last_word'\n" . $hereprev) &&
-					    $fix) {
-						$fixed[$fixlinenr] =~ s/(\+\s*\*\s*)$last_word /$1/;
-					}
-				}
-			}
-		}
-
 # check for space before tabs.
 		if ($rawline =~ /^\+/ && $rawline =~ / \t/) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-test-git_dir-changes.patch
checkpatch-move-repeated-word-test.patch

