Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 180EDC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:11:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B400920878
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817915;
	bh=3wE2CDC0O1/ASdsskUy8Z7U7a7HTMhobj2cm8VB2ZqI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=aih4ec2IjxUK05zJeG1XmMvhhdUpz8V2djzftlFR/UdxL+0w0ZkbtRw1/gjS6EW10
	 BhUgWqxHPxOL+Q1Spa3m85NL9roJ5HgwJBY/ox9/rRwK1FZwmiDDjQn1qHzHmSj4pp
	 rUJFe8kUCU8rolCG5Lb8xQa2zI9X3cOW6T+P61K4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389066AbgJPDLz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:11:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:48238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387864AbgJPDLz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:11:55 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C9F520878;
        Fri, 16 Oct 2020 03:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817913;
        bh=3wE2CDC0O1/ASdsskUy8Z7U7a7HTMhobj2cm8VB2ZqI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=MCQ9FwTEcmWZEDdNEYOE/pMefH83bQRAlpegJUMG9cstWc9nPoQIzwGPrqWLeES2/
         KNtZQXDCZGUekCE9dPCZ7r7+SZ/jON1tNn14PM1GK2TBGoYufp6tyylTBOcmPSs139
         NhTrZ17WKodFpTu0VWeuY6TkM86OUwnAUZQQg2/k=
Date:   Thu, 15 Oct 2020 20:11:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 122/156] checkpatch: move repeated word test
Message-ID: <20201016031152.U0Z88bznt%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
