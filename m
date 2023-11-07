Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E34AC4167D
	for <mm-commits@archiver.kernel.org>; Tue,  7 Nov 2023 15:41:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343981AbjKGPlD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Nov 2023 10:41:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343989AbjKGPlC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Nov 2023 10:41:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951A694;
        Tue,  7 Nov 2023 07:41:00 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3452DC433CA;
        Tue,  7 Nov 2023 15:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699371660;
        bh=jo9XUAwv29Q7hFnUax/u2I/TNWJEGHFxnWoS7rm2dtM=;
        h=Date:To:From:Subject:From;
        b=tVem3/qyrwBKPzBef/sS//Iyzw6r9h+csNBIq/lem4TliSNc/tqA1qFhAmMXW+vDV
         f/ekPvPiWX0uI7pYcSUhAdEbm2CFPcYRyAvg5LpbqE59+YJNvSKjQUi/i/PQLaNvDn
         oO6mKqfrDmAYOV+T4QwwfSB4NgT96ORrLkqrRe3c=
Date:   Tue, 07 Nov 2023 07:40:59 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-handle-tried-regions-sysfs-directory-allocation-failure.patch added to mm-hotfixes-unstable branch
Message-Id: <20231107154100.3452DC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs-schemes: handle tried regions sysfs directory allocation failure
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-handle-tried-regions-sysfs-directory-allocation-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-handle-tried-regions-sysfs-directory-allocation-failure.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm/damon/sysfs-schemes: handle tried regions sysfs directory allocation failure
Date: Mon, 6 Nov 2023 23:34:07 +0000

DAMOS tried regions sysfs directory allocation function
(damon_sysfs_scheme_regions_alloc()) is not handling the memory allocation
failure.  In the case, the code will dereference NULL pointer.  Handle the
failure to avoid such invalid access.

Link: https://lkml.kernel.org/r/20231106233408.51159-3-sj@kernel.org
Fixes: 9277d0367ba1 ("mm/damon/sysfs-schemes: implement scheme region directory")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.2+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-handle-tried-regions-sysfs-directory-allocation-failure
+++ a/mm/damon/sysfs-schemes.c
@@ -162,6 +162,9 @@ damon_sysfs_scheme_regions_alloc(void)
 	struct damon_sysfs_scheme_regions *regions = kmalloc(sizeof(*regions),
 			GFP_KERNEL);
 
+	if (!regions)
+		return NULL;
+
 	regions->kobj = (struct kobject){};
 	INIT_LIST_HEAD(&regions->regions_list);
 	regions->nr_regions = 0;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-check-error-from-damon_sysfs_update_target.patch
mm-damon-sysfs-schemes-handle-tried-regions-sysfs-directory-allocation-failure.patch
mm-damon-sysfs-schemes-handle-tried-region-directory-allocation-failure.patch

