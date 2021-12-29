Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D573C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 29 Dec 2021 23:21:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbhL2XVo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Dec 2021 18:21:44 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59210 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232759AbhL2XVo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Dec 2021 18:21:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C42D661597
        for <mm-commits@vger.kernel.org>; Wed, 29 Dec 2021 23:21:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC24C36AE9;
        Wed, 29 Dec 2021 23:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640820103;
        bh=LUd1XHsrlNVTc0TL8wB8vr1LliM9OBF/OmPlu3GIjB4=;
        h=Date:From:To:Subject:From;
        b=ObzgRZMliDdL731U7wjE73T4jUziiZrVDm4CogFbO3e/EPyq9LhVDGGOYaxyfyZez
         Ht12sIZPTqu1lOqBpsypYaD6gWErm99yu3+3YRjrwQDFzSXk5psM+wZuuWfx6WpOI7
         /v3diplRz4XokArfHwovi3IHhr5xete6MSHSBgnI=
Date:   Wed, 29 Dec 2021 15:21:43 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org
Subject:  + mm-damon-dbgfs-remove-a-unnecessary-variable.patch added
 to -mm tree
Message-ID: <20211229232143.wyaGe%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/dbgfs: remove an unnecessary variable
has been added to the -mm tree.  Its filename is
     mm-damon-dbgfs-remove-a-unnecessary-variable.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-dbgfs-remove-a-unnecessary-variable.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-dbgfs-remove-a-unnecessary-variable.patch

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
Subject: mm/damon/dbgfs: remove an unnecessary variable

Patch series "mm/damon: Hide unnecessary information disclosures".

DAMON is exposing some unnecessary information including kernel pointer
in kernel log and tracepoint.  This patchset hides such information.
The first patch is only for a trivial cleanup, though.


This patch (of 4):

This commit removes a unnecessarily used variable in
dbgfs_target_ids_write().

Link: https://lkml.kernel.org/r/20211229131016.23641-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20211229131016.23641-2-sj@kernel.org
Fixes: 4bc05954d007 ("mm/damon: implement a debugfs-based user space interface")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-remove-a-unnecessary-variable
+++ a/mm/damon/dbgfs.c
@@ -363,7 +363,7 @@ static ssize_t dbgfs_target_ids_write(st
 {
 	struct damon_ctx *ctx = file->private_data;
 	bool id_is_pid = true;
-	char *kbuf, *nrs;
+	char *kbuf;
 	unsigned long *targets;
 	ssize_t nr_targets;
 	ssize_t ret;
@@ -373,14 +373,13 @@ static ssize_t dbgfs_target_ids_write(st
 	if (IS_ERR(kbuf))
 		return PTR_ERR(kbuf);
 
-	nrs = kbuf;
 	if (!strncmp(kbuf, "paddr\n", count)) {
 		id_is_pid = false;
 		/* target id is meaningless here, but we set it just for fun */
 		scnprintf(kbuf, count, "42    ");
 	}
 
-	targets = str_to_target_ids(nrs, count, &nr_targets);
+	targets = str_to_target_ids(kbuf, count, &nr_targets);
 	if (!targets) {
 		ret = -ENOMEM;
 		goto out;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-remove-some-no-need-func-definitions-in-damonh-file-fix.patch
mm-damon-convert-macro-functions-to-static-inline-functions.patch
docs-admin-guide-mm-damon-usage-update-for-scheme-quotas-and-watermarks.patch
docs-admin-guide-mm-damon-usage-remove-redundant-information.patch
docs-admin-guide-mm-damon-usage-mention-tracepoint-at-the-beginning.patch
docs-admin-guide-mm-damon-usage-update-for-kdamond_pid-and-mkrm_contexts.patch
mm-damon-remove-a-mistakenly-added-comment-for-a-future-feature.patch
mm-damon-schemes-account-scheme-actions-that-successfully-applied.patch
mm-damon-schemes-account-how-many-times-quota-limit-has-exceeded.patch
mm-damon-reclaim-provide-reclamation-statistics.patch
docs-admin-guide-mm-damon-reclaim-document-statistics-parameters.patch
mm-damon-dbgfs-support-all-damos-stats.patch
docs-admin-guide-mm-damon-usage-update-for-schemes-statistics.patch
mm-damon-dbgfs-remove-a-unnecessary-variable.patch
mm-damon-vaddr-use-pr_debug-for-damon_va_three_regions-failure-logging.patch
mm-damon-vaddr-hide-kernel-pointer-from-damon_va_three_regions-failure-log.patch
mm-damon-hide-kernel-pointer-from-tracepoint-event.patch

