Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08752C4332F
	for <mm-commits@archiver.kernel.org>; Tue,  1 Nov 2022 22:58:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiKAW6b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Nov 2022 18:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiKAW6a (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2022 18:58:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77152C2
        for <mm-commits@vger.kernel.org>; Tue,  1 Nov 2022 15:58:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DF0361773
        for <mm-commits@vger.kernel.org>; Tue,  1 Nov 2022 22:58:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B40F4C433C1;
        Tue,  1 Nov 2022 22:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667343507;
        bh=b8Vzt6iOW/JzYTLBaIeckIpjmYlMPuOIpFjjl0rFf/8=;
        h=Date:To:From:Subject:From;
        b=gupt01P37mknKd+q8T7eAi5FUFcq4/YBk+1JkeS1gmx+PzbqU44Q4phbQIZbkd6TF
         G2P53Pjk3IRdi3Logho9DWtVycqc8+1AWY46oPFceC58sGNBUxQBAmuMeUe7F09e3N
         cQ5LXrmeMceVSquGaEeY2owbchMO6tCT4a+GaI3E=
Date:   Tue, 01 Nov 2022 15:58:27 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-add-a-callback-for-scheme-target-regions-check.patch added to mm-unstable branch
Message-Id: <20221101225827.B40F4C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: add a callback for scheme target regions check
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-add-a-callback-for-scheme-target-regions-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-add-a-callback-for-scheme-target-regions-check.patch

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

mm-damon-core-split-out-damos-charged-region-skip-logic-into-a-new-function.patch
mm-damon-core-split-damos-application-logic-into-a-new-function.patch
mm-damon-core-split-out-scheme-stat-update-logic-into-a-new-function.patch
mm-damon-core-split-out-scheme-quota-adjustment-logic-into-a-new-function.patch
mm-damon-sysfs-use-damon_addr_range-for-regions-start-and-end-values.patch
mm-damon-sysfs-remove-parameters-of-damon_sysfs_region_alloc.patch
mm-damon-sysfs-move-sysfs_lock-to-common-module.patch
mm-damon-sysfs-move-unsigned-long-range-directory-to-common-module.patch
mm-damon-sysfs-split-out-kdamond-independent-schemes-stats-update-logic-into-a-new-function.patch
mm-damon-sysfs-split-out-schemes-directory-implementation-to-separate-file.patch
mm-damon-modules-deduplicate-init-steps-for-damon-context-setup.patch
mm-damon-reclaimlru_sort-remove-unnecessarily-included-headers.patch
mm-damon-reclaim-enable-and-disable-synchronously.patch
selftests-damon-add-tests-for-damon_reclaims-enabled-parameter.patch
mm-damon-lru_sort-enable-and-disable-synchronously.patch
selftests-damon-add-tests-for-damon_lru_sorts-enabled-parameter.patch
docs-admin-guide-mm-damon-usage-describe-the-rules-of-sysfs-region-directories.patch
docs-admin-guide-mm-damon-usage-fix-wrong-usage-example-of-init_regions-file.patch
mm-damon-core-add-a-callback-for-scheme-target-regions-check.patch
mm-damon-sysfs-schemes-implement-schemes-tried_regions-directory.patch
mm-damon-sysfs-schemes-implement-scheme-region-directory.patch
mm-damon-sysfs-implement-damos-tried-regions-update-command.patch
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command.patch
tools-selftets-damon-sysfs-test-tried_regions-directory-existence.patch
docs-admin-guide-mm-damon-usage-document-schemes-s-tried_regions-sysfs-directory.patch
docs-abi-damon-document-schemes-s-tried_regions-sysfs-directory.patch

