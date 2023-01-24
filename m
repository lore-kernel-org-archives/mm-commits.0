Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B3ABC54E94
	for <mm-commits@archiver.kernel.org>; Tue, 24 Jan 2023 23:31:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjAXXbQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 24 Jan 2023 18:31:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjAXXbP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2023 18:31:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D649C3BD84
        for <mm-commits@vger.kernel.org>; Tue, 24 Jan 2023 15:31:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73608613EA
        for <mm-commits@vger.kernel.org>; Tue, 24 Jan 2023 23:31:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED7BC433D2;
        Tue, 24 Jan 2023 23:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674603073;
        bh=IrSoICb3GzLouC8VDW9cTnf01rSrhhRRsIVY/lFRWYQ=;
        h=Date:To:From:Subject:From;
        b=CSPOTNaCJdtWb6jBmuspnBSVOzjjz/HxmlogNf+8ikfaedwznkgp6YAiLN6hIDIku
         i63k8BivD2ZcLtdT7bMg5J6INlPz3F9qRxW2e5q2pqBFppDY9bo9Jrgk2OrXTTirMQ
         0RvRQqDr+RqR0Oukxaj6bNcGvtVcmSehO9YsI8Dw=
Date:   Tue, 24 Jan 2023 15:31:13 -0800
To:     mm-commits@vger.kernel.org, heinzm@redhat.com, joe@perches.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-improve-embedded_filename-test.patch added to mm-nonmm-unstable branch
Message-Id: <20230124233113.CED7BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve EMBEDDED_FILENAME test
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-improve-embedded_filename-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-improve-embedded_filename-test.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve EMBEDDED_FILENAME test
Date: Tue, 24 Jan 2023 15:16:55 -0800

Privately, Heinz Mauelshagen showed that the embedded filename test is not
specific enough.

> WARNING: It's generally not useful to have the filename in the file
> #113: FILE: errors.c:113:
> +            block < registered_errors.blocks + registered_errors.count;

Extend the test to use the appropriate word boundary tests.

Link: https://lkml.kernel.org/r/36069dac5d07509dab1c7f1238f8cbb08db80ac6.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-improve-embedded_filename-test
+++ a/scripts/checkpatch.pl
@@ -3751,7 +3751,7 @@ sub process {
 		}
 
 # check for embedded filenames
-		if ($rawline =~ /^\+.*\Q$realfile\E/) {
+		if ($rawline =~ /^\+.*\b\Q$realfile\E\b/) {
 			WARN("EMBEDDED_FILENAME",
 			     "It's generally not useful to have the filename in the file\n" . $herecurr);
 		}
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-improve-embedded_filename-test.patch

