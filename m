Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56C44C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:01:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiLAABR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiLAAAl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:00:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7CE87CB1
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:00:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FC0AB81AD6
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:00:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26D3C433C1;
        Thu,  1 Dec 2022 00:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852835;
        bh=Nerd7ce8Ng5Q1/R3Qgz2i1EVUb7LOG/NzXRANJk8zlM=;
        h=Date:To:From:Subject:From;
        b=Y/YFJBuV6xe7PNCPz5GCw+CZy+hMQ1q2q84xEd2bqHgslGB3kKpYZJHXTne8fOOMd
         TPpwM3HB3heK6zjMX44oJZdGHDdt4CvMUJ+n7HbbaWoVhpRn9z/W7F+nenKu2iPU56
         jNHRRbM6XgvNmZO3GfDL4+s/dL42PEnXFl7ROdXI=
Date:   Wed, 30 Nov 2022 16:00:35 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-add-a-callback-for-scheme-target-regions-check.patch removed from -mm tree
Message-Id: <20221201000035.C26D3C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: add a callback for scheme target regions check
has been removed from the -mm tree.  Its filename was
     mm-damon-core-add-a-callback-for-scheme-target-regions-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: add a callback for scheme target regions check
Date: Tue, 1 Nov 2022 22:03:21 +0000

Patch series "efficiently expose damos action tried regions information".

DAMON users can retrieve the monitoring results via 'after_aggregation'
callbacks if the user is using the kernel API, or 'damon_aggregated'
tracepoint if the user is in the user space.  Those are useful if full
monitoring results are necessary.  However, if the user has interest in
only a snapshot of the results for some regions having specific access
pattern, the interfaces could be inefficient.  For example, some users
only want to know which memory regions are not accessed for more than a
specific time at the moment.

Also, some DAMOS users would want to know exactly to what memory regions
the schemes' actions tried to be applied, for a debugging or a tuning.  As
DAMOS has its internal mechanism for quota and regions prioritization, the
users would need to simulate DAMOS' mechanism against the monitoring
results.  That's unnecessarily complex.

This patchset implements DAMON kernel API callbacks and sysfs directory
for efficient exposure of the information for the use cases.  The new
callback will be called for each region when a DAMOS action is gonna tried
to be applied to it.  The sysfs directory will be called 'tried_regions'
and placed under each scheme sysfs directory.  Users can write a special
keyworkd, 'update_schemes_regions', to the 'state' file of a kdamond sysfs
directory.  Then, DAMON sysfs interface will fill the directory with the
information of regions that corresponding scheme action was tried to be
applied for next one aggregation interval.

Patches Sequence
----------------

The first one (patch 1) implements the callback for the kernel space
users.  Following two patches (patches 2 and 3) implements sysfs
directories for the information and its sub directories.  Two patches
(patches 4 and 5) for implementing the special keywords for filling the
data to and cleaning up the directories follow.  Patch 6 adds a selftest
for the new sysfs directory.  Finally, two patches (patches 7 and 8)
document the new feature in the administrator guide and the ABI document.


This patch (of 8):

Getting DAMON monitoring results of only specific access pattern (e.g.,
getting address ranges of memory that not accessed at all for two minutes)
can be useful for efficient monitoring of the system.  The information can
also be helpful for deep level investigation of DAMON-based operation
schemes.

For that, users need to record (in case of the user space users) or
iterate (in case of the kernel space users) full monitoring results and
filter it out for the specific access pattern.  In case of the DAMOS
investigation, users will even need to simulate DAMOS' quota and
prioritization mechanisms.  It's inefficient and complex.

Add a new DAMON callback that will be called before each scheme is applied
to each region.  DAMON kernel API users will be able to do the query-like
monitoring results collection, or DAMOS investigation in an efficient and
simple way using it.

Commits for providing the capability to the user space users will follow.

Link: https://lkml.kernel.org/r/20221101220328.95765-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20221101220328.95765-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    5 +++++
 mm/damon/core.c       |    6 +++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/include/linux/damon.h~mm-damon-core-add-a-callback-for-scheme-target-regions-check
+++ a/include/linux/damon.h
@@ -357,6 +357,7 @@ struct damon_operations {
  * @after_wmarks_check:	Called after each schemes' watermarks check.
  * @after_sampling:	Called after each sampling.
  * @after_aggregation:	Called after each aggregation.
+ * @before_damos_apply:	Called before applying DAMOS action.
  * @before_terminate:	Called before terminating the monitoring.
  * @private:		User private data.
  *
@@ -385,6 +386,10 @@ struct damon_callback {
 	int (*after_wmarks_check)(struct damon_ctx *context);
 	int (*after_sampling)(struct damon_ctx *context);
 	int (*after_aggregation)(struct damon_ctx *context);
+	int (*before_damos_apply)(struct damon_ctx *context,
+			struct damon_target *target,
+			struct damon_region *region,
+			struct damos *scheme);
 	void (*before_terminate)(struct damon_ctx *context);
 };
 
--- a/mm/damon/core.c~mm-damon-core-add-a-callback-for-scheme-target-regions-check
+++ a/mm/damon/core.c
@@ -772,6 +772,7 @@ static void damos_apply_scheme(struct da
 	unsigned long sz = damon_sz_region(r);
 	struct timespec64 begin, end;
 	unsigned long sz_applied = 0;
+	int err = 0;
 
 	if (c->ops.apply_scheme) {
 		if (quota->esz && quota->charged_sz + sz > quota->esz) {
@@ -782,7 +783,10 @@ static void damos_apply_scheme(struct da
 			damon_split_region_at(t, r, sz);
 		}
 		ktime_get_coarse_ts64(&begin);
-		sz_applied = c->ops.apply_scheme(c, t, r, s);
+		if (c->callback.before_damos_apply)
+			err = c->callback.before_damos_apply(c, t, r, s);
+		if (!err)
+			sz_applied = c->ops.apply_scheme(c, t, r, s);
 		ktime_get_coarse_ts64(&end);
 		quota->total_charged_ns += timespec64_to_ns(&end) -
 			timespec64_to_ns(&begin);
_

Patches currently in -mm which might be from sj@kernel.org are


