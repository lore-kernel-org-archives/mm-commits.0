Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B72F1C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 14 Nov 2022 22:06:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235838AbiKNWGe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Nov 2022 17:06:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236124AbiKNWGc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2022 17:06:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB79010573
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2022 14:06:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5791361469
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2022 22:06:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E1FC433C1;
        Mon, 14 Nov 2022 22:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668463590;
        bh=ZUrUSS6xm06eMGIviZ1fs+Wq8bjOR6OHFjWHjRbIFuk=;
        h=Date:To:From:Subject:From;
        b=i79P4tTAvx/VwSMSiUJtNDtwY04wR1s2uzXv/2HTYOEw1+FmPvflYsLznun54UU4R
         wZw1BDyRGJjfvY38TC0lLYuH4zTWcU028RqObrsJ3kCBnpEtQ8hMfS0u3wVJ19SQ7R
         jJhguxfs1O1duIlIt8f7axYAfwfJI7DSivDm1Bh8=
Date:   Mon, 14 Nov 2022 14:06:29 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-implement-damos-tried-regions-update-command-fix.patch added to mm-unstable branch
Message-Id: <20221114220630.A2E1FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs-schemes: skip tried regions update if the scheme directory has removed
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-implement-damos-tried-regions-update-command-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-implement-damos-tried-regions-update-command-fix.patch

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
Subject: mm/damon/sysfs-schemes: skip tried regions update if the scheme directory has removed
Date: Mon, 14 Nov 2022 18:29:53 +0000

A DAMON sysfs interface user can start DAMON with a scheme, remove the
sysfs directory for the scheme, and then ask updates of the scheme's tried
regions.  Because the schemes tried regions update logic doesn't aware of
the situation, it results in an invalid memory access.  Fix the bug by
checking if the scheme sysfs directory exists.

Link: https://lkml.kernel.org/r/20221114182954.4745-2-sj@kernel.org
Fixes: ("mm/damon/sysfs: implement DAMOS tried regions update command")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-implement-damos-tried-regions-update-command-fix
+++ a/mm/damon/sysfs-schemes.c
@@ -1227,6 +1227,11 @@ static int damon_sysfs_before_damos_appl
 			break;
 		schemes_idx++;
 	}
+
+	/* user could removed the scheme sysfs dir */
+	if (schemes_idx >= sysfs_schemes->nr)
+		return 0;
+
 	sysfs_regions = sysfs_schemes->schemes_arr[schemes_idx]->tried_regions;
 	region = damon_sysfs_scheme_region_alloc(r);
 	list_add_tail(&region->list, &sysfs_regions->regions_list);
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-mm-damon-usage-describe-the-rules-of-sysfs-region-directories.patch
docs-admin-guide-mm-damon-usage-fix-wrong-usage-example-of-init_regions-file.patch
mm-damon-core-add-a-callback-for-scheme-target-regions-check.patch
mm-damon-sysfs-schemes-implement-schemes-tried_regions-directory.patch
mm-damon-sysfs-schemes-implement-scheme-region-directory.patch
mm-damon-sysfs-implement-damos-tried-regions-update-command.patch
mm-damon-sysfs-implement-damos-tried-regions-update-command-fix.patch
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command.patch
mm-damon-sysfs-schemes-skip-schemes-regions-clearing-if-the-scheme-directory-has-removed.patch
tools-selftets-damon-sysfs-test-tried_regions-directory-existence.patch
docs-admin-guide-mm-damon-usage-document-schemes-s-tried_regions-sysfs-directory.patch
docs-abi-damon-document-schemes-s-tried_regions-sysfs-directory.patch
selftests-damon-test-non-context-inputs-to-rm_contexts-file.patch

