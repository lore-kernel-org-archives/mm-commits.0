Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C8C1C43381
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5779564F21
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhB0Cdh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:33:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:51478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230087AbhB0Cc6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:32:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72D6B64F53;
        Sat, 27 Feb 2021 02:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393142;
        bh=OMaR4k9IxDTkT7zDbf7lAnu1SSlaGLK8nK9ia8eUwBE=;
        h=Date:From:To:Subject:From;
        b=GfKeER1SFB6DvFZKnzv9VhbyUY8KD+mkgh0n0JT1jLP98w042A6SGv/9Ced6QimPL
         AAHoaGwT85i1wkhC3k4utMSo4D5dwsNsq0iXsvmgKSckpJ75plOlfzkVMkU0kQ2ZCR
         Mt0AIBk+OkiVeAKAKSBUUud/4iYCMvFmzmSg5KTY=
Date:   Fri, 26 Feb 2021 18:32:22 -0800
From:   akpm@linux-foundation.org
To:     dgilbert@interlog.com, joe@perches.com, mm-commits@vger.kernel.org
Subject:  [merged]
 checkpatch-improve-typecast_int_constant-test-message.patch removed from
 -mm tree
Message-ID: <20210227023222.hGo2XmgK5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve TYPECAST_INT_CONSTANT test message
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-typecast_int_constant-test-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -6518,18 +6518,18 @@ sub process {
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


