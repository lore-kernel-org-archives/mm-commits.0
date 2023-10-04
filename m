Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C1CDE7C4F1
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:18:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244055AbjJDUSi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243954AbjJDUSd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:18:33 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16615D9
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:18:30 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF52C433C8;
        Wed,  4 Oct 2023 20:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450709;
        bh=sIpSdkwRCXaX3lD0/fQCCORb/KraRL+nJdSjowffs48=;
        h=Date:To:From:Subject:From;
        b=jMFdUiE8PkpWbd3K3Z8pFs3WjhYsuNpYwBec79ezc0JNKF0WA+BJ4VSSo321pjyJ5
         vAjjd2F0Wy85GzMQiMkUBx0nii6m62gU0zTvw3DC6FhqAHUY2oG052WjRPvb1wWphU
         l7xIEj8FX//v5wL3hTrZSJVQRSGmsnHgszDirhDw=
Date:   Wed, 04 Oct 2023 13:18:28 -0700
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-add-more-comments-for-nr_accesses.patch removed from -mm tree
Message-Id: <20231004201829.7BF52C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: add more comments for nr_accesses
has been removed from the -mm tree.  Its filename was
     mm-damon-core-add-more-comments-for-nr_accesses.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


