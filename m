Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88EA1E7C4F4
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:18:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243994AbjJDUSb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244022AbjJDUS3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:18:29 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C012C6
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:18:20 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E8CC433C8;
        Wed,  4 Oct 2023 20:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450700;
        bh=MLR6R5PbbORwjpfIgZIqaWP7S7Hd08gg2M5yEA0pQuo=;
        h=Date:To:From:Subject:From;
        b=RfV+Fw4Fa6LTJOVcRCEQqhnSuSsQqiLJn+NjwdTydMr+uspX7h/thsAa9PQ9HcXE7
         nVCEFTlLTKBMb9HDZkU6b4Wyp4W/GFZSzSa6n+3jNw6rEKSNMwurxVcUyr97rBow+p
         xoWiQutAbLHK/6vT/ZAUyyr4js4kuI0/DiPZVfnw=
Date:   Wed, 04 Oct 2023 13:18:18 -0700
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-explicitly-introduce-nr_accesses.patch removed from -mm tree
Message-Id: <20231004201819.B8E8CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/mm/damon/design: explicitly introduce ``nr_accesses``
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-explicitly-introduce-nr_accesses.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


