Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D9DDC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:35:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E5C72076C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196121;
	bh=yReHrm+CRBK2jWGzrPLqUD6EvgFN+eTqa9bi83J09VA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=upClzLmWeDiE6V1IlSOP/Yp4FteuzrPWFIf+ZIAv2QNxw4jHkQQGY61rJu9Yqwj3n
	 XvjvdC7QlsZJedfgmJYbsLKWiflFhXzfwTW0TK2BZ6WLoDzujl+RYD+9uFjQcL8P/t
	 qnHUShAFQzEx1jBqTIWm55PxxcEZHwQ2+h0+D5as=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbgHLBfU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:35:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:36232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726430AbgHLBfU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:35:20 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D32F206B2;
        Wed, 12 Aug 2020 01:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196119;
        bh=yReHrm+CRBK2jWGzrPLqUD6EvgFN+eTqa9bi83J09VA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=VMe5P09hDF3MajZ9WvX/W2XKZCu/8ea/+r6LKwOQho2WD5X9Isw2Qq9/AnTdobqfp
         y/TwfOg2ETt5sgCmhg1AUOPJ4wnIXvMCVJS+i6KmyaQJwjuRt/ICvCyBX/S1vzQV/t
         JfPhGMhOuQI8Y1tEOFbyTp5V0GR6fSjPFzEoLRAw=
Date:   Tue, 11 Aug 2020 18:35:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cambda@linux.alibaba.com,
        joe@perches.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 096/165] checkpatch: remove missing switch/case
 break test
Message-ID: <20200812013519.aAWxaJ-nE%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joe Perches <joe@perches.com>
Subject: checkpatch: remove missing switch/case break test

This test doesn't work well and newer compilers are much better
at emitting this warning.

Link: http://lkml.kernel.org/r/7e25090c79f6a69d502ab8219863300790192fe2.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Cambda Zhu <cambda@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   25 -------------------------
 1 file changed, 25 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-remove-missing-switch-case-break-test
+++ a/scripts/checkpatch.pl
@@ -6543,31 +6543,6 @@ sub process {
 			}
 		}
 
-# check for case / default statements not preceded by break/fallthrough/switch
-		if ($line =~ /^.\s*(?:case\s+(?:$Ident|$Constant)\s*|default):/) {
-			my $has_break = 0;
-			my $has_statement = 0;
-			my $count = 0;
-			my $prevline = $linenr;
-			while ($prevline > 1 && ($file || $count < 3) && !$has_break) {
-				$prevline--;
-				my $rline = $rawlines[$prevline - 1];
-				my $fline = $lines[$prevline - 1];
-				last if ($fline =~ /^\@\@/);
-				next if ($fline =~ /^\-/);
-				next if ($fline =~ /^.(?:\s*(?:case\s+(?:$Ident|$Constant)[\s$;]*|default):[\s$;]*)*$/);
-				$has_break = 1 if ($rline =~ /fall[\s_-]*(through|thru)/i);
-				next if ($fline =~ /^.[\s$;]*$/);
-				$has_statement = 1;
-				$count++;
-				$has_break = 1 if ($fline =~ /\bswitch\b|\b(?:break\s*;[\s$;]*$|exit\s*\(\b|return\b|goto\b|continue\b)/);
-			}
-			if (!$has_break && $has_statement) {
-				WARN("MISSING_BREAK",
-				     "Possible switch case/default not preceded by break or fallthrough comment\n" . $herecurr);
-			}
-		}
-
 # check for /* fallthrough */ like comment, prefer fallthrough;
 		my @fallthroughs = (
 			'fallthrough',
_
