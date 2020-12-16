Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DB35C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C714023432
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:10:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgLPRKI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:10:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:59902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727022AbgLPRKI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:10:08 -0500
Date:   Wed, 16 Dec 2020 09:09:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138592;
        bh=I7bBOrL53IiBKCHcrVz0XR1OFZSx6XDZqHF8Xg5EdEM=;
        h=From:To:Subject:From;
        b=1dC58kNNzewkccmFUbzxNasJlNvEdaWXL+Q94cDrNd7Jk+fb1KMNBv5a4TfJ2W98a
         VzIVtfn5YpyFteQ9DqbSHRghs+CLNBt4KAC1cTXjhIxIWKnYXyPBBjVevK1+Z1rqc9
         94V3R9H42Vy1weL9c6ORKDpPIVxpsKvTckmdNw98=
From:   akpm@linux-foundation.org
To:     joe@perches.com, julia.lawall@inria.fr, mm-commits@vger.kernel.org,
        trix@redhat.com
Subject:  [merged]
 checkpatch-allow-fix-removal-of-unnecessary-break-statements.patch removed
 from -mm tree
Message-ID: <20201216170952.5T8RLEdXg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: allow --fix removal of unnecessary break statements
has been removed from the -mm tree.  Its filename was
     checkpatch-allow-fix-removal-of-unnecessary-break-statements.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: allow --fix removal of unnecessary break statements

switch/case use of break after a return, goto or break is unnecessary.

There is an existing warning for the return and goto uses, so add
break and a --fix option too.

Link: https://lkml.kernel.org/r/d9ea654104d55f590fb97d252d64a66b23c1a096.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Julia Lawall <julia.lawall@inria.fr>
Cc: Tom Rix <trix@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-allow-fix-removal-of-unnecessary-break-statements
+++ a/scripts/checkpatch.pl
@@ -3699,12 +3699,16 @@ sub process {
 		}
 
 # check indentation of a line with a break;
-# if the previous line is a goto or return and is indented the same # of tabs
+# if the previous line is a goto, return or break
+# and is indented the same # of tabs
 		if ($sline =~ /^\+([\t]+)break\s*;\s*$/) {
 			my $tabs = $1;
-			if ($prevline =~ /^\+$tabs(?:goto|return)\b/) {
-				WARN("UNNECESSARY_BREAK",
-				     "break is not useful after a goto or return\n" . $hereprev);
+			if ($prevline =~ /^\+$tabs(goto|return|break)\b/) {
+				if (WARN("UNNECESSARY_BREAK",
+					 "break is not useful after a $1\n" . $hereprev) &&
+				    $fix) {
+					fix_delete_line($fixlinenr, $rawline);
+				}
 			}
 		}
 
_

Patches currently in -mm which might be from joe@perches.com are


