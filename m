Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1779C388F9
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 22:55:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47E1C2344C
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 22:55:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="FIM1r8HK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbgKPWzZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 17:55:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:53984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgKPWzZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Nov 2020 17:55:25 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCA2D22453;
        Mon, 16 Nov 2020 22:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605567325;
        bh=7JXmpcvd0PQhrAn8QHf9IZ1CHG6nICNvXMxYacC5774=;
        h=Date:From:To:Subject:From;
        b=FIM1r8HKncza3l2rBH2hoH42KjOhIvORra9YeGtDwg+tBnnrzzpYd1I5Cy03oxRKb
         bBvlluGQq5iS6PFu/UGNDr1ISQGBOY9h86WKth7qgsMC3oiYjDxt+d9hDi1ipIHIuA
         aXwEv9OqPtC6ur0lSQ6ta/CVg09BsWfnRf9MI5yA=
Date:   Mon, 16 Nov 2020 14:55:24 -0800
From:   akpm@linux-foundation.org
To:     dwaipayanray1@gmail.com, joe@perches.com,
        mm-commits@vger.kernel.org
Subject:  + checkpatch-fix-unescaped-left-brace.patch added to -mm
 tree
Message-ID: <20201116225524.-rX5gHB_o%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix unescaped left brace
has been added to the -mm tree.  Its filename is
     checkpatch-fix-unescaped-left-brace.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-fix-unescaped-left-brace.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-fix-unescaped-left-brace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

checkpatch-add-new-exception-to-repeated-word-check.patch
checkpatch-extend-attributes-check-to-handle-more-patterns.patch
checkpatch-improve-email-parsing.patch
checkpatch-fix-spelling-errors-and-remove-repeated-word.patch
checkpatch-fix-unescaped-left-brace.patch

