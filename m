Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18FDCC433E0
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 19:51:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C947723104
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 19:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728771AbhASTvO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jan 2021 14:51:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:51292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731579AbhASTvK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Jan 2021 14:51:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BC3F2310B;
        Tue, 19 Jan 2021 19:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611085830;
        bh=IV+sRxtoHtsO2UaewohWumcPVF8/T/xC3GKus1t9NZs=;
        h=Date:From:To:Subject:From;
        b=uBjhy17qCBMIN7nnR3TcVfWj3lTtuOTbyslstJJ4EOwQvT/rxpKN3763QShWKSh6o
         zA8piQlx603KhTZFyAAlfh/94NePhJU7/TOTB7k3EC/qvKUopqajGVynSuAf3aFoNg
         kPnx+py+38QDL/qgmhpeTBYff/b8mTKixD4I/K0Y=
Date:   Tue, 19 Jan 2021 11:50:28 -0800
From:   akpm@linux-foundation.org
To:     dgilbert@interlog.com, joe@perches.com, mm-commits@vger.kernel.org
Subject:  +
 checkpatch-improve-typecast_int_constant-test-message.patch added to -mm
 tree
Message-ID: <20210119195028.jLnXw1Tvg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve TYPECAST_INT_CONSTANT test message
has been added to the -mm tree.  Its filename is
     checkpatch-improve-typecast_int_constant-test-message.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-typecast_int_constant-test-message.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-typecast_int_constant-test-message.patch

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
Subject: checkpatch: improve TYPECAST_INT_CONSTANT test message

Improve the TYPECAST_INT_CONSTANT test by showing the suggested conversion
for various type of uses like (unsigned int)1 to 1U.

Link: https://lkml.kernel.org/r/ecefe8dcb93fe7028311b69dd297ba52224233d4.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-improve-typecast_int_constant-test-message
+++ a/scripts/checkpatch.pl
@@ -6527,18 +6527,18 @@ sub process {
 		if ($line =~ /(\(\s*$C90_int_types\s*\)\s*)($Constant)\b/) {
 			my $cast = $1;
 			my $const = $2;
+			my $suffix = "";
+			my $newconst = $const;
+			$newconst =~ s/${Int_type}$//;
+			$suffix .= 'U' if ($cast =~ /\bunsigned\b/);
+			if ($cast =~ /\blong\s+long\b/) {
+			    $suffix .= 'LL';
+			} elsif ($cast =~ /\blong\b/) {
+			    $suffix .= 'L';
+			}
 			if (WARN("TYPECAST_INT_CONSTANT",
-				 "Unnecessary typecast of c90 int constant\n" . $herecurr) &&
+				 "Unnecessary typecast of c90 int constant - '$cast$const' could be '$const$suffix'\n" . $herecurr) &&
 			    $fix) {
-				my $suffix = "";
-				my $newconst = $const;
-				$newconst =~ s/${Int_type}$//;
-				$suffix .= 'U' if ($cast =~ /\bunsigned\b/);
-				if ($cast =~ /\blong\s+long\b/) {
-					$suffix .= 'LL';
-				} elsif ($cast =~ /\blong\b/) {
-					$suffix .= 'L';
-				}
 				$fixed[$fixlinenr] =~ s/\Q$cast\E$const\b/$newconst$suffix/;
 			}
 		}
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-improve-blank-line-after-declaration-test.patch
checkpatch-prefer-ftrace-over-function-entry-exit-printks.patch
checkpatch-improve-typecast_int_constant-test-message.patch

