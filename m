Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F524C43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0387B216C4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881634;
	bh=gjlXQXJ34Kj+bqkf5xWI0GzRKkPbJkxQDOeO4M3rReI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Mk/M7hlIXwxIJdyzLnI8T2sAfDc58FFhfTRJvrJl/4JzOOCH9trnrD9EZScNr9sUJ
	 ol5Vv5WPEUZ5dcUPR9QC7lCq9MV3wK7gmi4I0swCsHczYk74XFIztKrUKzOa2d9vfj
	 8SKTPohu9xngUHiTfio9yVVQs7TkoHa4S8jbd9Kk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409212AbgJPUxx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:53:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409209AbgJPUxs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:53:48 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E0BF21775;
        Fri, 16 Oct 2020 20:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881627;
        bh=gjlXQXJ34Kj+bqkf5xWI0GzRKkPbJkxQDOeO4M3rReI=;
        h=Date:From:To:Subject:From;
        b=lBeG3ifN4GGJWcRkNXBz+jkUDoAOcqkBrxs3dFNcsKUpWmQFxscm2nnbYqCi6l9Ba
         4I+bedPc8ufaWvrEK4LjotXdQN4TGqnpLkRSldVsfM0+A1PQF+c0D4JYB0fKvPYa3J
         RoktclGu1lP49vohQ4dVJwonzrklE3KBUsjOnmys=
Date:   Fri, 16 Oct 2020 13:53:47 -0700
From:   akpm@linux-foundation.org
To:     joe@perches.com, mm-commits@vger.kernel.org
Subject:  [merged] checkpatch-move-repeated-word-test.patch removed
 from -mm tree
Message-ID: <20201016205347.q1PFQS8sg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: move repeated word test
has been removed from the -mm tree.  Its filename was
     checkpatch-move-repeated-word-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2991,6 +2991,42 @@ sub process {
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
 
@@ -3314,42 +3350,6 @@ sub process {
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

