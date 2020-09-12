Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABB08C10DAA
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 16:24:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74F87221E3
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 16:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599927847;
	bh=3mXsINsAZyrbwhjNssPcQE1bLOcEEUX+/yqQysz22sA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=HSDyRsoy/Jsea0pALxhT5Jymkot0lMB+N9RDZd119jabwLD0F5VWD2T4g1Mr/rTrc
	 mfk1ifoJ4ESXcG30LW8EeEJ/UmodvEyyWpkMtZlTYnD/d63HnAnbQ1gQBAPmH2AHwT
	 YDUrET38cqOX7DpokY4Wk3CZKUpiug8qsc2jLolA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbgILQYF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 12:24:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbgILQXz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 12:23:55 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BDF82087C;
        Sat, 12 Sep 2020 16:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599927834;
        bh=3mXsINsAZyrbwhjNssPcQE1bLOcEEUX+/yqQysz22sA=;
        h=Date:From:To:Subject:From;
        b=vdw1l6BlyEVPUhoqUP4h/JDoIu68AliB2lQf+ZaBstvPqt0pKFmuQgAYCurZamFxC
         eo4EhjjYqsF8vn7/XIsf5uktVp9U5Df+l87V/QLKxbEC+Oa+sQ8GVK/sonb5/jV7ba
         dQHkT6ZRbVqiO+W834hBx0b1pPX1z/q4NRPYyY5o=
Date:   Sat, 12 Sep 2020 09:23:54 -0700
From:   akpm@linux-foundation.org
To:     joe@perches.com, lukas.bulwahn@gmail.com,
        mm-commits@vger.kernel.org, mrinalmni@gmail.com
Subject:  [merged] checkpatch-fix-the-usage-of-capture-group.patch
 removed from -mm tree
Message-ID: <20200912162354.Z-B04casn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix the usage of capture group ( ... )
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-the-usage-of-capture-group.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mrinal Pandey <mrinalmni@gmail.com>
Subject: checkpatch: fix the usage of capture group ( ... )

The usage of "capture group (...)" in the immediate condition after `&&`
results in `$1` being uninitialized.  This issues a warning "Use of
uninitialized value $1 in regexp compilation at ./scripts/checkpatch.pl
line 2638".

I noticed this bug while running checkpatch on the set of commits from
v5.7 to v5.8-rc1 of the kernel on the commits with a diff content in their
commit message.

This bug was introduced in the script by commit e518e9a59ec3 ("checkpatch:
emit an error when there's a diff in a changelog").  It has been in the
script since then.

The author intended to store the match made by capture group in variable
`$1`.  This should have contained the name of the file as `[\w/]+`
matched.  However, this couldn't be accomplished due to usage of capture
group and `$1` in the same regular expression.

Fix this by placing the capture group in the condition before `&&`.  Thus,
`$1` can be initialized to the text that capture group matches thereby
setting it to the desired and required value.

Link: https://lkml.kernel.org/r/20200714032352.f476hanaj2dlmiot@mrinalpandey
Fixes: e518e9a59ec3 ("checkpatch: emit an error when there's a diff in a changelog")
Signed-off-by: Mrinal Pandey <mrinalmni@gmail.com>
Reviewed-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Tested-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-fix-the-usage-of-capture-group
+++ a/scripts/checkpatch.pl
@@ -2639,8 +2639,8 @@ sub process {
 
 # Check if the commit log has what seems like a diff which can confuse patch
 		if ($in_commit_log && !$commit_log_has_diff &&
-		    (($line =~ m@^\s+diff\b.*a/[\w/]+@ &&
-		      $line =~ m@^\s+diff\b.*a/([\w/]+)\s+b/$1\b@) ||
+		    (($line =~ m@^\s+diff\b.*a/([\w/]+)@ &&
+		      $line =~ m@^\s+diff\b.*a/[\w/]+\s+b/$1\b@) ||
 		     $line =~ m@^\s*(?:\-\-\-\s+a/|\+\+\+\s+b/)@ ||
 		     $line =~ m/^\s*\@\@ \-\d+,\d+ \+\d+,\d+ \@\@/)) {
 			ERROR("DIFF_IN_COMMIT_MSG",
_

Patches currently in -mm which might be from mrinalmni@gmail.com are


