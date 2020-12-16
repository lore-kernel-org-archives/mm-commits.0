Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5545C0018C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:10:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 852A6233EB
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:10:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbgLPRKj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:10:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:60540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726918AbgLPRKj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:10:39 -0500
Date:   Wed, 16 Dec 2020 09:09:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138598;
        bh=Sa/mfAV1+SZLrKdpGX/EEezHuOh3Fd/Yj0zGypWFqj0=;
        h=From:To:Subject:From;
        b=CSdpIHrxTgtzo4BGklPs29ivwHXSFD19No6BAl0r+dC3x/8N71uNKUrhmx5yJ/ABp
         Cf3D4tN4yz7Ly3kbLuwxv+pG4CGHHjUxuJYPhB+M+KOjwOuF0Q28o0Hsk30Ywh1jaS
         Q9hwDgUTFHssOHIgr0L91nZRgI690j9fz9huESJ0=
From:   akpm@linux-foundation.org
To:     joe@perches.com, mm-commits@vger.kernel.org, trix@redhat.com
Subject:  [merged]
 checkpatch-add-a-fixer-for-missing-newline-at-eof.patch removed from -mm
 tree
Message-ID: <20201216170958.S5YcOpHof%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add a fixer for missing newline at eof
has been removed from the -mm tree.  Its filename was
     checkpatch-add-a-fixer-for-missing-newline-at-eof.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tom Rix <trix@redhat.com>
Subject: checkpatch: add a fixer for missing newline at eof

Remove the trailing error message from the fixed lines.

Link: https://lkml.kernel.org/r/20201017142546.28988-1-trix@redhat.com
Signed-off-by: Tom Rix <trix@redhat.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-add-a-fixer-for-missing-newline-at-eof
+++ a/scripts/checkpatch.pl
@@ -3418,8 +3418,11 @@ sub process {
 
 # check for adding lines without a newline.
 		if ($line =~ /^\+/ && defined $lines[$linenr] && $lines[$linenr] =~ /^\\ No newline at end of file/) {
-			WARN("MISSING_EOF_NEWLINE",
-			     "adding a line without newline at end of file\n" . $herecurr);
+			if (WARN("MISSING_EOF_NEWLINE",
+			         "adding a line without newline at end of file\n" . $herecurr) &&
+			    $fix) {
+				fix_delete_line($fixlinenr+1, "No newline at end of file");
+			}
 		}
 
 # check we are in a valid source file C or perl if not then ignore this hunk
_

Patches currently in -mm which might be from trix@redhat.com are


