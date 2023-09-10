Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C851EC71153
	for <mm-commits@archiver.kernel.org>; Sun, 10 Sep 2023 20:48:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbjIJUsD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Sep 2023 16:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjIJUsD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 10 Sep 2023 16:48:03 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC59188
        for <mm-commits@vger.kernel.org>; Sun, 10 Sep 2023 13:47:59 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3CA9C433C8;
        Sun, 10 Sep 2023 20:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694378878;
        bh=Fryb0JP/IWJJYhZw7CGIYAoViz0yvkC980lR0HtgzmY=;
        h=Date:To:From:Subject:From;
        b=s3ztvPTeNaygOECIfE9gC0Hwr6gmutLrj1b7t5u4qVLpqYQILEflU3jHXkURZRMtP
         LV4pBOvWhZDauY2ungClaD5+9i1eztLO5BhJJy/nUMDGo0kVPpB1AY1Sm4xl1QJ66C
         FCvOWvNBVBFD1m4VUZLf4dPKwSpiKNEWLYpGE+h4=
Date:   Sun, 10 Sep 2023 13:47:58 -0700
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-explicitly-introduce-nr_accesses.patch added to mm-unstable branch
Message-Id: <20230910204758.D3CA9C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/mm/damon/design: explicitly introduce ``nr_accesses``
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-explicitly-introduce-nr_accesses.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-explicitly-introduce-nr_accesses.patch

This patch will later appear in the mm-unstable branch at
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
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: explicitly introduce ``nr_accesses``
Date: Thu, 7 Sep 2023 02:29:22 +0000

The design document is explaining about the access tracking mechanism
and the access rate counter (nr_accesses), but not directly mentions the
name.  Add a sentence for making it clear.

Link: https://lkml.kernel.org/r/20230907022929.91361-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-explicitly-introduce-nr_accesses
+++ a/Documentation/mm/damon/design.rst
@@ -163,9 +163,10 @@ assumption (pages in a region have the s
 one page in the region is required to be checked.  Thus, for each ``sampling
 interval``, DAMON randomly picks one page in each region, waits for one
 ``sampling interval``, checks whether the page is accessed meanwhile, and
-increases the access frequency of the region if so.  Therefore, the monitoring
-overhead is controllable by setting the number of regions.  DAMON allows users
-to set the minimum and the maximum number of regions for the trade-off.
+increases the access frequency counter of the region if so.  The counter is
+called ``nr_regions`` of the region.  Therefore, the monitoring overhead is
+controllable by setting the number of regions.  DAMON allows users to set the
+minimum and the maximum number of regions for the trade-off.
 
 This scheme, however, cannot preserve the quality of the output if the
 assumption is not guaranteed.
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-mm-damon-usage-fixup-missed-ref-keyword.patch
docs-admin-guide-mm-damon-usage-place-debugfs-usage-at-the-bottom.patch
docs-admin-guide-mm-damon-usage-move-debugfs-intro-to-the-bottom-of-the-section.patch
docs-mm-damon-design-explicitly-introduce-nr_accesses.patch
docs-admin-guide-mm-damon-usage-explain-the-format-of-damon_aggregate-tracepoint.patch
docs-mm-damon-design-add-a-section-for-kdamond-and-damon-context.patch
docs-admin-guide-mm-damon-usage-link-design-doc-for-details-of-kdamond-and-context.patch
mm-damon-core-fix-a-comment-about-damon_set_attrs-call-timings.patch
mm-damon-core-add-more-comments-for-nr_accesses.patch
mm-damon-core-remove-duplicated-comment-for-watermarks-based-deactivation.patch
mm-damon-core-remove-struct-target-parameter-from-damon_aggregated-tracepoint.patch

