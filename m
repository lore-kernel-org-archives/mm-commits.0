Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94765C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 19:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234444AbiD0TYq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Apr 2022 15:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234417AbiD0TYW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2022 15:24:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E7DDAFD1
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 12:19:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CBCF8CE26AE
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 19:19:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1027CC385A9;
        Wed, 27 Apr 2022 19:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651087146;
        bh=fkAu0GAmacmLG6oKp+COM4sY80+6MjPZkZj8b90whaQ=;
        h=Date:To:From:Subject:From;
        b=06IxAFUOykkbFNbz8VbR/rsY+7F1+LUyXB9Dbq6bo0hZw0S3dxgvriK6jSMNt8o6H
         0IaSI6RmDDDJUykgHzAMu+2vVMFoBJWAu0AsxAhe6ag8FpweXCKmeiM8z4tN7YB7fs
         4XqffWdYE21+76MYh8P9L4Q622dWul+TSwP5EW/Y=
Date:   Wed, 27 Apr 2022 12:19:05 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-support-fixed-virtual-address-ranges-monitoring.patch added to -mm tree
Message-Id: <20220427191906.1027CC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: support fixed virtual address ranges monitoring
has been added to the -mm tree.  Its filename is
     mm-damon-sysfs-support-fixed-virtual-address-ranges-monitoring.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-sysfs-support-fixed-virtual-address-ranges-monitoring.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-sysfs-support-fixed-virtual-address-ranges-monitoring.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: support fixed virtual address ranges monitoring

This commit makes DAMON sysfs interface to support the fixed virtual
address ranges monitoring.  After this commit, writing 'fvaddr' to the
'operations' DAMON sysfs file makes DAMON uses the monitoring operations
set for fixed virtual address ranges, so that users can monitor accesses
to only interested virtual address ranges.

Link: https://lkml.kernel.org/r/20220426231750.48822-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-support-fixed-virtual-address-ranges-monitoring
+++ a/mm/damon/sysfs.c
@@ -1694,7 +1694,7 @@ static struct kobj_type damon_sysfs_attr
 /* This should match with enum damon_ops_id */
 static const char * const damon_sysfs_ops_strs[] = {
 	"vaddr",
-	"unsupported",	/* fvaddr is not supported by sysfs yet */
+	"fvaddr",
 	"paddr",
 };
 
@@ -1844,9 +1844,6 @@ static ssize_t operations_store(struct k
 
 	for (id = 0; id < NR_DAMON_OPS; id++) {
 		if (sysfs_streq(buf, damon_sysfs_ops_strs[id])) {
-			/* fvaddr is not supported by sysfs yet */
-			if (id == DAMON_OPS_FVADDR)
-				return -EINVAL;
 			context->ops_id = id;
 			return count;
 		}
@@ -2136,7 +2133,8 @@ static int damon_sysfs_set_targets(struc
 			damon_sysfs_destroy_targets(ctx);
 			return -ENOMEM;
 		}
-		if (ctx->ops.id == DAMON_OPS_VADDR) {
+		if (ctx->ops.id == DAMON_OPS_VADDR ||
+				ctx->ops.id == DAMON_OPS_FVADDR) {
 			t->pid = find_get_pid(sys_target->pid);
 			if (!t->pid) {
 				damon_sysfs_destroy_targets(ctx);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-test-add-a-kunit-test-case-for-ops-registration.patch
mm-damon-core-add-a-function-for-damon_operations-registration-checks.patch
mm-damon-sysfs-add-a-file-for-listing-available-monitoring-ops.patch
selftets-damon-sysfs-test-existence-and-permission-of-avail_operations.patch
docs-abiadmin-guide-damon-document-avail_operations-sysfs-file.patch
mm-damon-vaddr-register-a-damon_operations-for-fixed-virtual-address-ranges-monitoring.patch
mm-damon-sysfs-support-fixed-virtual-address-ranges-monitoring.patch
docs-abiadmin-guide-damon-update-for-fixed-virtual-address-ranges-monitoring.patch

