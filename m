Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F7B1C4708F
	for <mm-commits@archiver.kernel.org>; Wed,  2 Jun 2021 22:28:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 059FA613D6
	for <mm-commits@archiver.kernel.org>; Wed,  2 Jun 2021 22:28:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbhFBWaD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Jun 2021 18:30:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:43576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhFBWaD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 2 Jun 2021 18:30:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C72B613D6;
        Wed,  2 Jun 2021 22:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622672883;
        bh=EDiCH9iRHfGGGC2P5L6bSEBiDiArHAKsqVwjIhQunI0=;
        h=Date:From:To:Subject:From;
        b=rrfJTlXCD3axaViAm1V2o7hzVfqZ732Qzvc6fmuQKpOsHQ2pLyuNi1HcmEt3MR4+y
         sCb3fIfUhNOarlWdjnwwLDBvhn5jCIrVavUsuTRkvZf07KUdyWqdraDorOcWAM0V+Y
         4CLchlh8t8vkJrQ5usFg+m1l013wJ23Y0U1NBDkM=
Date:   Wed, 02 Jun 2021 15:28:03 -0700
From:   akpm@linux-foundation.org
To:     elder@ieee.org, gregkh@linuxfoundation.org, joe@perches.com,
        manikishanghantasala@gmail.com, mm-commits@vger.kernel.org
Subject:  + checkpatch-improve-the-indented-label-test.patch added
 to -mm tree
Message-ID: <20210602222803.K_-B_yexv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve the indented label test
has been added to the -mm tree.  Its filename is
     checkpatch-improve-the-indented-label-test.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-the-indented-label-test.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-the-indented-label-test.patch

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
Subject: checkpatch: improve the indented label test

checkpatch identifies a label only when a terminating colon
immediately follows an identifier.

Bitfield definitions can appear to be labels so ignore any
spaces between the identifier terminating colon and any digit
that may be used to define a bitfield length.

Miscellanea:

o Improve the initial checkpatch comment
o Use the more typical '&&' instead of 'and'
o Require the initial label character to be a non-digit
  (Can't use $Ident here because $Ident allows ## concatenation)
o Use $sline instead of $line to ignore comments
o Use '$sline !~ /.../' instead of '!($line =~ /.../)'

Link: https://lkml.kernel.org/r/b54d673e7cde7de5de0c9ba4dd57dd0858580ca4.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Manikishan Ghantasala <manikishanghantasala@gmail.com>
Cc: Alex Elder <elder@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-improve-the-indented-label-test
+++ a/scripts/checkpatch.pl
@@ -5361,9 +5361,13 @@ sub process {
 			}
 		}
 
-#goto labels aren't indented, allow a single space however
-		if ($line=~/^.\s+[A-Za-z\d_]+:(?![0-9]+)/ and
-		   !($line=~/^. [A-Za-z\d_]+:/) and !($line=~/^.\s+default:/)) {
+# check that goto labels aren't indented (allow a single space indentation)
+# and ignore bitfield definitions like foo:1
+# Strictly, labels can have whitespace after the identifier and before the :
+# but this is not allowed here as many ?: uses would appear to be labels
+		if ($sline =~ /^.\s+[A-Za-z_][A-Za-z\d_]*:(?!\s*\d+)/ &&
+		    $sline !~ /^. [A-Za-z\d_][A-Za-z\d_]*:/ &&
+		    $sline !~ /^.\s+default:/) {
 			if (WARN("INDENTED_LABEL",
 				 "labels should not be indented\n" . $herecurr) &&
 			    $fix) {
_

Patches currently in -mm which might be from joe@perches.com are

slub-indicate-slab_fix-uses-printf-formats.patch
checkpatch-improve-the-indented-label-test.patch

