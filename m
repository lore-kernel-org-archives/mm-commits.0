Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B7A1C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E857964EE2
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhBZBXS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:23:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:52296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230083AbhBZBWi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:22:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5FC464F42;
        Fri, 26 Feb 2021 01:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302515;
        bh=NNg7VSGccGaPEWu+1xW048UQ643iDq2tfK23+P9ikVA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WZsF8wuU5HY93Pplc3Y+IBotV8WCyRYz0+Cfsv3rNzHG3goda4BVe9sGRYHIoW5Jh
         B8OqplA8SEuoSDKqY1l9EF+6FVtw+AgDY8/2G/D/ySSeg9dUTS/GLZElk4G+1Y5o6j
         SvEu16zFW2JwFEyRq2dRunf3bI26fMP34/Eyg2ak=
Date:   Thu, 25 Feb 2021 17:21:54 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dgilbert@interlog.com, joe@perches.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 103/118] checkpatch: improve TYPECAST_INT_CONSTANT
 test message
Message-ID: <20210226012154.kJ5ZmuRtE%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
