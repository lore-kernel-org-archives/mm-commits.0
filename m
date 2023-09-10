Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55EB6EE7FF4
	for <mm-commits@archiver.kernel.org>; Sun, 10 Sep 2023 20:48:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbjIJUsO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Sep 2023 16:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234295AbjIJUsM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 10 Sep 2023 16:48:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F831A5
        for <mm-commits@vger.kernel.org>; Sun, 10 Sep 2023 13:48:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B125FC433C9;
        Sun, 10 Sep 2023 20:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694378887;
        bh=+p+G0L17A3wrrdv6TuHuzzK52OmKVzWiub9gUWzqb1E=;
        h=Date:To:From:Subject:From;
        b=1/HXCv+zSa9uLuOWlx7hOcIRNo/ZSxCWji9RuYJbLfzuXpWeWKLFZBwyTGxj/rGs3
         Hvt4bakpbU5c3p3ke5Qp15FSjajWEkg8ZlATTWDOV5k/t6oqqM67Z+KaZ7XbCP2eVZ
         Owc1acx/efWKhACBJphzDutJg2yEzwXB1BahZ0I4=
Date:   Sun, 10 Sep 2023 13:48:07 -0700
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-fix-a-comment-about-damon_set_attrs-call-timings.patch added to mm-unstable branch
Message-Id: <20230910204807.B125FC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: fix a comment about damon_set_attrs() call timings
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-fix-a-comment-about-damon_set_attrs-call-timings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-fix-a-comment-about-damon_set_attrs-call-timings.patch

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
Subject: mm/damon/core: fix a comment about damon_set_attrs() call timings
Date: Thu, 7 Sep 2023 02:29:26 +0000

The comment on damon_set_attrs() says it should not be called while the
kdamond is running, but now some DAMON modules like sysfs interface and
DAMON_RECLAIM call it from after_aggregation() and/or
after_wmarks_check() callbacks for online tuning.  Update the comment.

Link: https://lkml.kernel.org/r/20230907022929.91361-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-fix-a-comment-about-damon_set_attrs-call-timings
+++ a/mm/damon/core.c
@@ -541,7 +541,11 @@ static void damon_update_monitoring_resu
  * @ctx:		monitoring context
  * @attrs:		monitoring attributes
  *
- * This function should not be called while the kdamond is running.
+ * This function should be called while the kdamond is not running, or an
+ * access check results aggregation is not ongoing (e.g., from
+ * &struct damon_callback->after_aggregation or
+ * &struct damon_callback->after_wmarks_check callbacks).
+ *
  * Every time interval is in micro-seconds.
  *
  * Return: 0 on success, negative error code otherwise.
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

