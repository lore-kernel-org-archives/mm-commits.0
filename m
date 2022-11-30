Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE6EC4321E
	for <mm-commits@archiver.kernel.org>; Wed, 30 Nov 2022 23:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiK3Xlt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 18:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiK3Xlr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 18:41:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C69D24AF03
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 15:41:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84401B81D4C
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 23:41:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A27C4347C;
        Wed, 30 Nov 2022 23:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669851704;
        bh=vec0spVyJgW87p3GIywWulLSJcA33w3ewVHIvwmfAAc=;
        h=Date:To:From:Subject:From;
        b=ExAthVjTyduFYSUMNBvhVcLe65BiWaIySrXaX/RwlVeia4ehiGO4aQzXleyqv0i1x
         4tw7c0M1XTyDKV99i66QMSn1PXUe7IJWsakkxEKEsOwKWgN+hAE1AuNExiRAsgTiuf
         EhdKPmtMIJqTEhpA7xADB9uCIvpMkdRvUB+cUBM4=
Date:   Wed, 30 Nov 2022 15:41:43 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-sysfs-implement-damos-tried-regions-update-command-fix.patch removed from -mm tree
Message-Id: <20221130234144.37A27C4347C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: skip tried regions update if the scheme directory has removed
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-implement-damos-tried-regions-update-command-fix.patch

This patch was dropped because it was folded into mm-damon-sysfs-implement-damos-tried-regions-update-command.patch

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
@@ -1273,6 +1273,11 @@ static int damon_sysfs_before_damos_appl
 			break;
 		schemes_idx++;
 	}
+
+	/* user could have removed the scheme sysfs dir */
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
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command.patch
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command-fix.patch
tools-selftets-damon-sysfs-test-tried_regions-directory-existence.patch
docs-admin-guide-mm-damon-usage-document-schemes-s-tried_regions-sysfs-directory.patch
docs-abi-damon-document-schemes-s-tried_regions-sysfs-directory.patch
selftests-damon-test-non-context-inputs-to-rm_contexts-file.patch

