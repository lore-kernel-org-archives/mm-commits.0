Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E3F8E936E1
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:23:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244946AbjJDUXP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244635AbjJDUWn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:43 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D8CFF
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:22:40 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8390AC433C8;
        Wed,  4 Oct 2023 20:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450959;
        bh=OsVccFFoQ0RRyZNk39Yhn8VGnvdQtJ066h2ocQqrCOE=;
        h=Date:To:From:Subject:From;
        b=ABxnPyYqgj8weB3lZTIBx92VMiWUvAe0uHzHBL32GQitokh5o57pyrtFXC1pFHNOs
         wjx2v8MSp7DJS4CG0Tk1ukRy0j120gtOj6q09BFtlsbTSiOlC8rSHArFZGq8Kr12r8
         9XbxBur005U3U1jDBfJRLp9ICV0U4H8ZS3W7QCH0=
Date:   Wed, 04 Oct 2023 13:22:37 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, rostedt@goodmis.org,
        corbet@lwn.net, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-document-damos-apply-intervals.patch removed from -mm tree
Message-Id: <20231004202239.8390AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/mm/damon/design: document DAMOS apply intervals
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-document-damos-apply-intervals.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: document DAMOS apply intervals
Date: Sat, 16 Sep 2023 02:09:41 +0000

Update DAMON design doc to explain about DAMOS apply intervals.

Link: https://lkml.kernel.org/r/20230916020945.47296-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-damos-apply-intervals
+++ a/Documentation/mm/damon/design.rst
@@ -259,7 +259,8 @@ works, DAMON provides a feature called D
 Schemes (DAMOS).  It lets users specify their desired schemes at a high
 level.  For such specifications, DAMON starts monitoring, finds regions having
 the access pattern of interest, and applies the user-desired operation actions
-to the regions as soon as found.
+to the regions, for every user-specified time interval called
+``apply_interval``.
 
 
 .. _damon_design_damos_action:
_

Patches currently in -mm which might be from sj@kernel.org are


