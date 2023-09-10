Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD48BEE7FF4
	for <mm-commits@archiver.kernel.org>; Sun, 10 Sep 2023 20:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjIJUsT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Sep 2023 16:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjIJUsR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 10 Sep 2023 16:48:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68F4188
        for <mm-commits@vger.kernel.org>; Sun, 10 Sep 2023 13:48:11 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0C0C433C7;
        Sun, 10 Sep 2023 20:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694378891;
        bh=iuAxh52uJNGouu9xJKehWnjWKk4HeLDQc0YXrkJO0ZM=;
        h=Date:To:From:Subject:From;
        b=eZHHNUFWeFa2OEgtWfXkfY+AWm7YBxN1IC1SNttckmIoKPjl8oOzN0TlvG24JlIP4
         2LnHTpLxvAWpaJGE7ZpVTBKMetl6P6gI9scJHdwiT4TLFxX/QL2lwxDwjh0jalQJKB
         Qj/3XeRtwZ/e/hpkmofLK5PS04/kh6l1O9amYVws=
Date:   Sun, 10 Sep 2023 13:48:10 -0700
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-remove-duplicated-comment-for-watermarks-based-deactivation.patch added to mm-unstable branch
Message-Id: <20230910204811.5D0C0C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: remove duplicated comment for watermarks-based deactivation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-remove-duplicated-comment-for-watermarks-based-deactivation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-remove-duplicated-comment-for-watermarks-based-deactivation.patch

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
Subject: mm/damon/core: remove duplicated comment for watermarks-based deactivation
Date: Thu, 7 Sep 2023 02:29:28 +0000

The comment for explaining about watermarks-based monitoring part
deactivation is duplicated in two paragraphs.  Remove one.

Link: https://lkml.kernel.org/r/20230907022929.91361-11-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    3 ---
 1 file changed, 3 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-remove-duplicated-comment-for-watermarks-based-deactivation
+++ a/include/linux/damon.h
@@ -317,9 +317,6 @@ struct damos_access_pattern {
  * monitoring context are inactive, DAMON stops monitoring either, and just
  * repeatedly checks the watermarks.
  *
- * If all schemes that registered to a &struct damon_ctx are inactive, DAMON
- * stops monitoring and just repeatedly checks the watermarks.
- *
  * Before applying the &action to a memory region, &struct damon_operations
  * implementation could check pages of the region and skip &action to respect
  * &filters
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

