Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ECA3C71153
	for <mm-commits@archiver.kernel.org>; Sun, 10 Sep 2023 20:48:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjIJUsP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Sep 2023 16:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjIJUsO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 10 Sep 2023 16:48:14 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F071A6
        for <mm-commits@vger.kernel.org>; Sun, 10 Sep 2023 13:48:10 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B604C433C7;
        Sun, 10 Sep 2023 20:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694378889;
        bh=DqO0llLcXOvF2TGjOV6ij2eRgiK46z4Ioq+48hhtY5w=;
        h=Date:To:From:Subject:From;
        b=ueU33O3V23qlvwelCAhzko1d01mqykox8D2jEZE8zf6j/5c78BkOjr1jpRUocRsE4
         iRuZRryuEjuh5tMqYZcNvU6yK047sg/KzPxk5VDqBai0KlVGzsWGcAf+sqWuVPRSI7
         KjdOV+T6EkrQck+JuyALGUqUT6hvS3tQTI0QeIMg=
Date:   Sun, 10 Sep 2023 13:48:09 -0700
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-add-more-comments-for-nr_accesses.patch added to mm-unstable branch
Message-Id: <20230910204809.9B604C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: add more comments for nr_accesses
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-add-more-comments-for-nr_accesses.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-add-more-comments-for-nr_accesses.patch

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
Subject: mm/damon/core: add more comments for nr_accesses
Date: Thu, 7 Sep 2023 02:29:27 +0000

The comment on struct damon_region about nr_accesses field looks not
sufficient.  Many people actually used to ask what nr_accesses mean.
There is more detailed explanation of the mechanism on the comment for
struct damon_attrs, but it is also ambiguous, as it doesn't specify the
name of the counter for aggregating the access check results.  Make
those more detailed.

Link: https://lkml.kernel.org/r/20230907022929.91361-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-add-more-comments-for-nr_accesses
+++ a/include/linux/damon.h
@@ -43,6 +43,10 @@ struct damon_addr_range {
  * @list:		List head for siblings.
  * @age:		Age of this region.
  *
+ * @nr_accesses is reset to zero for every &damon_attrs->aggr_interval and be
+ * increased for every &damon_attrs->sample_interval if an access to the region
+ * during the last sampling interval is found.
+ *
  * @age is initially zero, increased for each aggregation interval, and reset
  * to zero again if the access frequency is significantly changed.  If two
  * regions are merged into a new region, both @nr_accesses and @age of the new
@@ -472,13 +476,14 @@ struct damon_callback {
  *				regions.
  *
  * For each @sample_interval, DAMON checks whether each region is accessed or
- * not.  It aggregates and keeps the access information (number of accesses to
- * each region) for @aggr_interval time.  DAMON also checks whether the target
- * memory regions need update (e.g., by ``mmap()`` calls from the application,
- * in case of virtual memory monitoring) and applies the changes for each
- * @ops_update_interval.  All time intervals are in micro-seconds.
- * Please refer to &struct damon_operations and &struct damon_callback for more
- * detail.
+ * not during the last @sample_interval.  If such access is found, DAMON
+ * aggregates the information by increasing &damon_region->nr_accesses for
+ * @aggr_interval time.  For each @aggr_interval, the count is reset.  DAMON
+ * also checks whether the target memory regions need update (e.g., by
+ * ``mmap()`` calls from the application, in case of virtual memory monitoring)
+ * and applies the changes for each @ops_update_interval.  All time intervals
+ * are in micro-seconds.  Please refer to &struct damon_operations and &struct
+ * damon_callback for more detail.
  */
 struct damon_attrs {
 	unsigned long sample_interval;
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

