Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8241C4321E
	for <mm-commits@archiver.kernel.org>; Wed, 30 Nov 2022 23:43:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiK3XnO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 18:43:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbiK3Xmk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 18:42:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BC6281
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 15:42:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC741B81D4C
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 23:42:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7454BC43470;
        Wed, 30 Nov 2022 23:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669851749;
        bh=CGU6hYB6htRiZlAxnASb9dIGbe0KcVAWYha4RcS2TX0=;
        h=Date:To:From:Subject:From;
        b=FnA1ZBvY9B38o9lZN/fxEsSMABGWYAvhq44b4opZhJqC5mEPT2fX27DMJZ+dQREJL
         7b8vMuHiG7XZ9g/KOnOcVBte8371NdWvcIlVoSLAQg/zaGdBR6RUGMVjDGOT6ZWQNa
         MKLMhOAJrrol9nSYj8oXikW0IOkqdYMWEkWTWojM=
Date:   Wed, 30 Nov 2022 15:42:28 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command-fix.patch removed from -mm tree
Message-Id: <20221130234229.7454BC43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: skip schemes regions clearing if the scheme directory has removed
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command-fix.patch

This patch was dropped because it was folded into mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command.patch

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: skip schemes regions clearing if the scheme directory has removed
Date: Mon, 14 Nov 2022 18:29:54 +0000

A DAMON sysfs interface user can start DAMON with a scheme, remove the
sysfs directory for the scheme, and then ask clearing of the scheme's
tried regions.  Because the schemes tried regions clearing logic doesn't
aware of the situation, it results in an invalid memory access.  Fix the
bug by checking if the scheme sysfs directory exists.

Link: https://lkml.kernel.org/r/20221114182954.4745-3-sj@kernel.org
Fixes: ("mm/damon/sysfs-schemes: implement DAMOS-tried regions clear command")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command-fix
+++ a/mm/damon/sysfs-schemes.c
@@ -1302,6 +1302,10 @@ int damon_sysfs_schemes_clear_regions(
 	damon_for_each_scheme(scheme, ctx) {
 		struct damon_sysfs_scheme *sysfs_scheme;
 
+		/* user could have removed the scheme sysfs dir */
+		if (schemes_idx >= sysfs_schemes->nr)
+			break;
+
 		sysfs_scheme = sysfs_schemes->schemes_arr[schemes_idx++];
 		damon_sysfs_scheme_regions_rm_dirs(
 				sysfs_scheme->tried_regions);
_

Patches currently in -mm which might be from sj@kernel.org are

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
selftests-damon-test-non-context-inputs-to-rm_contexts-file.patch

