Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFBD6C433E3
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9229C2078B
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266272;
	bh=PB4H2qrXt7IfzzuAsEJ5Zmfa3L73cpogTDnGUH55PcA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Y4iwIE9keOIDOviwXE3plxEo6WN5BSXNm4NQmy8LyGoUuUxIjW2ohEofd5cFXxB8h
	 Mh+tjB3q2R7mwlP0X6XLAov1U/iuC7nPReWdd+I8CchALHVreMIoMm4PvnGXKt62+A
	 MKs4iqhd18MzyZE6lS0GhG11xC3zHLcUmCn4VDl0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgHLVEc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:04:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:57070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbgHLVEc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:04:32 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E2B520838;
        Wed, 12 Aug 2020 21:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266271;
        bh=PB4H2qrXt7IfzzuAsEJ5Zmfa3L73cpogTDnGUH55PcA=;
        h=Date:From:To:Subject:From;
        b=f42GKTwDUucrb2zoOnzsNK/BXZKFXCO2NMxg0lj8lv7FJ/MvQPbpHb3wtlYJZSM4k
         y6Q0kIU6tDYgPFC/5JK+Bsv1H9Ff3zgr3uiXSvsiHihrpFgl7BsRhrJjyFAqPUA433
         deAREA+ZBnma8aFd5PGCaxwm7leT59/qt54ijAT0=
Date:   Wed, 12 Aug 2020 14:04:31 -0700
From:   akpm@linux-foundation.org
To:     cambda@linux.alibaba.com, joe@perches.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 checkpatch-remove-missing-switch-case-break-test.patch removed from -mm
 tree
Message-ID: <20200812210431.smIV6xV-M%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: remove missing switch/case break test
has been removed from the -mm tree.  Its filename was
     checkpatch-remove-missing-switch-case-break-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from joe@perches.com are

checkpatch-test-git_dir-changes.patch

