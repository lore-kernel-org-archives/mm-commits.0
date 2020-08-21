Return-Path: <SRS0=KdEm=B7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AE03C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 21:33:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2037920724
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 21:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598045630;
	bh=6L3R3cULCdp0Bwd/B8GOLbdirV0b3zuYyOQLtBF4sfE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=J3cKWvsJfPdYxih7//vZllqwa3GC3Ts+F05jHwiFdUGIfCzkg3ew5nDwl1Ns8ONzQ
	 cTyuOWM+tyfenWjPvgR9+1rTQcIpm7NQzjyJn4T1gZ4VYlPn4o1l0zcdOjWAAnRMy2
	 j2P4xN8jMskCjx+M7iozAOPJkKhhcYdlBhWy7iAo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgHUVdt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Aug 2020 17:33:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbgHUVds (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 21 Aug 2020 17:33:48 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0B3A20724;
        Fri, 21 Aug 2020 21:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598045628;
        bh=6L3R3cULCdp0Bwd/B8GOLbdirV0b3zuYyOQLtBF4sfE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=T/5lQp0lMk481MUKcRBuWE/Dsxvu0iH9u4I82vHanJfnS4f4SHYMymi4kJbnhiGZh
         k7epRZNtx9pgHTdobAYgwrs+qQ7RLKP4Aw2aSJ7e9l67e5aO33z4+IsXACnyAM83XD
         mGyOyfMcwkcS+T9ihu0XGkfSeVymzZQSQOPVn5B0=
Date:   Fri, 21 Aug 2020 14:33:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     joe@perches.com, lukas.bulwahn@gmail.com,
        mm-commits@vger.kernel.org, mrinalmni@gmail.com
Subject:  + checkpatch-fix-the-usage-of-capture-group.patch added
 to -mm tree
Message-ID: <20200821213347.NBA7weFIM%akpm@linux-foundation.org>
In-Reply-To: <20200820174132.67fd4a7a9359048f807a533b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix the usage of capture group ( ... )
has been added to the -mm tree.  Its filename is
     checkpatch-fix-the-usage-of-capture-group.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-fix-the-usage-of-capture-group.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-fix-the-usage-of-capture-group.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

checkpatch-fix-the-usage-of-capture-group.patch

