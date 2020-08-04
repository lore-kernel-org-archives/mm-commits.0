Return-Path: <SRS0=09mD=BO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12B5FC433E0
	for <mm-commits@archiver.kernel.org>; Tue,  4 Aug 2020 03:22:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 135DB206DA
	for <mm-commits@archiver.kernel.org>; Tue,  4 Aug 2020 03:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596511362;
	bh=n7EN4GenrvVmxFOQxJE01ChZbr3GZ2sBJ7Ejw8Nc/ro=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=aUKwGezi0ZWZcXko9SO48x8/DwoFJ0cudlyTXSDNQR45gQiikXxe0jGQn2UykkDax
	 Vt8v+lTxMNnlZlddlaHN09jOVltUrMeXJTlU7C6ZC6Hbztf0pLyb5rjKTdsOjcJUiA
	 vu2nAHLBSaT2suseiZr+9bFvwUu2eqYYdEaWn5Os=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729641AbgHDDWl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Aug 2020 23:22:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729637AbgHDDWl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Aug 2020 23:22:41 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B21782068F;
        Tue,  4 Aug 2020 03:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596511360;
        bh=n7EN4GenrvVmxFOQxJE01ChZbr3GZ2sBJ7Ejw8Nc/ro=;
        h=Date:From:To:Subject:From;
        b=m6CVgB0VBsXCPca8nn9TSTnReZGxuGKdtfZtPRBqWFF/KST74drkstBEaedh/18GV
         fd7STOaqH6e8RbKQzgNdk8K8aTMoqpIWeiwhxFucr5gkysq+PZGCa4mFFy3FZb6Y3P
         L35Tm9mbS8M/mFn083YrrDcoe+a4Vd6cYeu8f0lM=
Date:   Mon, 03 Aug 2020 20:22:40 -0700
From:   akpm@linux-foundation.org
To:     cambda@linux.alibaba.com, joe@perches.com,
        mm-commits@vger.kernel.org
Subject:  + checkpatch-remove-missing-switch-case-break-test.patch
 added to -mm tree
Message-ID: <20200804032240.kruazyS7u%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: remove missing switch/case break test
has been added to the -mm tree.  Its filename is
     checkpatch-remove-missing-switch-case-break-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-remove-missing-switch-case-break-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-remove-missing-switch-case-break-test.patch

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
@@ -6551,31 +6551,6 @@ sub process {
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
const_structscheckpatch-add-regulator_ops.patch
checkpatch-add-test-for-possible-misuse-of-is_enabled-without-config_.patch
checkpatch-add-fix-option-for-assign_in_if.patch
checkpatch-add-test-for-repeated-words.patch
checkpatch-remove-missing-switch-case-break-test.patch
nilfs2-convert-__nilfs_msg-to-integrate-the-level-and-format.patch
nilfs2-use-a-more-common-logging-style.patch

