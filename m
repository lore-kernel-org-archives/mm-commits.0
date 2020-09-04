Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD182C2BB84
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 23:35:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC35B20C09
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 23:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599262553;
	bh=6WT/eIjHIIiMrlzdI/sZtAds5GrfVF+meLSclJlcCyk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=JMcb9VWQoYXuInhroYj2pvpqpqrIOP39TAcE9IaQ7k7iVoiesKbJOBa2WLjrUaFlo
	 a+ZIn9h96FIaA0VzhrRNuVYOPb3Rxrhq+v1sftdj3b5GjDbDuOQNtVBrS2HqrFwjCO
	 /o1dxXqseDFg+G9AxNRu/6Rksrxhqtv6ryNjUHsE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbgIDXfx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 19:35:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:38868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgIDXfx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 19:35:53 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58E80208C7;
        Fri,  4 Sep 2020 23:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599262552;
        bh=6WT/eIjHIIiMrlzdI/sZtAds5GrfVF+meLSclJlcCyk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=NXdkWHIV/r+nGvtWJ5kG09Tp7QrwfBezrOztZLvGe+8apdj68uXoi4xZbCXvdgEZA
         FQARw7MuyZUFDqnSva3ym8cfOHVyRMC0Qi7UWrg5eNsg3nFCdbZKOZK5GsloHwgmO0
         oyQv8aLVJXsXb7CpOCtE/c7GCntFOSafVjqzXgmQ=
Date:   Fri, 04 Sep 2020 16:35:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com, linux-mm@kvack.org,
        lukas.bulwahn@gmail.com, mm-commits@vger.kernel.org,
        mrinalmni@gmail.com, torvalds@linux-foundation.org
Subject:  [patch 10/19] checkpatch: fix the usage of capture group
 ( ... )
Message-ID: <20200904233552.kLq6B7QPc%akpm@linux-foundation.org>
In-Reply-To: <20200904163454.4db0e6ce0c4584d2653678a3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
