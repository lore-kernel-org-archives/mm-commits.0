Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8826C4167D
	for <mm-commits@archiver.kernel.org>; Tue,  7 Nov 2023 15:41:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344033AbjKGPlK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Nov 2023 10:41:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343999AbjKGPlE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Nov 2023 10:41:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4831EA2;
        Tue,  7 Nov 2023 07:41:02 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70BCC433C7;
        Tue,  7 Nov 2023 15:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699371661;
        bh=fdUe7B8gsCWDUYAo9zOcyCcSHvRvuIJMrvjXYNl3fwo=;
        h=Date:To:From:Subject:From;
        b=W+INBAgt2N0LdzPAEKPtDm+KDgD6jK+9bPhejxejfuL9lLRHXTFud+psqe8wdeyGx
         o5GrVJfckj/UwLCYB+rbe9gn2jlv1vERYYHQTzFtdxhZgpfptL+bxXfqBFZiOXq/y3
         rPLT5L+sTOrBW8KHB10xbNLPnUEKVGc+xWQMxXaE=
Date:   Tue, 07 Nov 2023 07:41:01 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-handle-tried-region-directory-allocation-failure.patch added to mm-hotfixes-unstable branch
Message-Id: <20231107154101.D70BCC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs-schemes: handle tried region directory allocation failure
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-handle-tried-region-directory-allocation-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-handle-tried-region-directory-allocation-failure.patch

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
Subject: mm/damon/sysfs-schemes: handle tried region directory allocation failure
Date: Mon, 6 Nov 2023 23:34:08 +0000

DAMON sysfs interface's before_damos_apply callback
(damon_sysfs_before_damos_apply()), which creates the DAMOS tried regions
for each DAMOS action applied region, is not handling the allocation
failure for the sysfs directory data.  As a result, NULL pointer
derefeence is possible.  Fix it by handling the case.

Link: https://lkml.kernel.org/r/20231106233408.51159-4-sj@kernel.org
Fixes: f1d13cacabe1 ("mm/damon/sysfs: implement DAMOS tried regions update command")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.2+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-handle-tried-region-directory-allocation-failure
+++ a/mm/damon/sysfs-schemes.c
@@ -1826,6 +1826,8 @@ static int damon_sysfs_before_damos_appl
 		return 0;
 
 	region = damon_sysfs_scheme_region_alloc(r);
+	if (!region)
+		return 0;
 	list_add_tail(&region->list, &sysfs_regions->regions_list);
 	sysfs_regions->nr_regions++;
 	if (kobject_init_and_add(&region->kobj,
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-check-error-from-damon_sysfs_update_target.patch
mm-damon-sysfs-schemes-handle-tried-regions-sysfs-directory-allocation-failure.patch
mm-damon-sysfs-schemes-handle-tried-region-directory-allocation-failure.patch

