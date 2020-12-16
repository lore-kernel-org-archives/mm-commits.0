Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BA45C0018C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:10:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61BCF233FB
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgLPRKa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:10:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:60282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727032AbgLPRKa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:10:30 -0500
Date:   Wed, 16 Dec 2020 09:10:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138614;
        bh=QssbLzCmcheXrjyLM+F8mpS6F22M8IddyI2yA5rzcZc=;
        h=From:To:Subject:From;
        b=oD2Uka9w6+TEz2rsoTMwlacUh2Ncjsbuo09CSwiZXLN7s0CnerWlCwmcieSGBusCz
         +JWb+y6osIgJHZKc4Fb4IJCVRLQxXvPNyynQdNpIxXJD3wl3R5aXvJlg66kuKZpnhN
         1m7H4dJmfUTN9Bplgru68ixURyznR3WbBlWEzt1M=
From:   akpm@linux-foundation.org
To:     dwaipayanray1@gmail.com, joe@perches.com,
        mm-commits@vger.kernel.org
Subject:  [merged] checkpatch-fix-unescaped-left-brace.patch
 removed from -mm tree
Message-ID: <20201216171014.vfUEoYZ_U%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix unescaped left brace
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-unescaped-left-brace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dwaipayan Ray <dwaipayanray1@gmail.com>
Subject: checkpatch: fix unescaped left brace

There is an unescaped left brace in a regex in OPEN_BRACE check.  This
throws a runtime error when checkpatch is run with --fix flag and the
OPEN_BRACE check is executed.

Fix it by escaping the left brace.

Link: https://lkml.kernel.org/r/20201115202928.81955-1-dwaipayanray1@gmail.com
Fixes: 8d1824780f2f ("checkpatch: add --fix option for a couple OPEN_BRACE misuses")
Signed-off-by: Dwaipayan Ray <dwaipayanray1@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-fix-unescaped-left-brace
+++ a/scripts/checkpatch.pl
@@ -4505,7 +4505,7 @@ sub process {
 			    $fix) {
 				fix_delete_line($fixlinenr, $rawline);
 				my $fixed_line = $rawline;
-				$fixed_line =~ /(^..*$Type\s*$Ident\(.*\)\s*){(.*)$/;
+				$fixed_line =~ /(^..*$Type\s*$Ident\(.*\)\s*)\{(.*)$/;
 				my $line1 = $1;
 				my $line2 = $2;
 				fix_insert_line($fixlinenr, ltrim($line1));
_

Patches currently in -mm which might be from dwaipayanray1@gmail.com are


