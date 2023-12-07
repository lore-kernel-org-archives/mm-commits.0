Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4170C10DC1
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 00:13:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442097AbjLGANd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 19:13:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442031AbjLGAN2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 19:13:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB055D44
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 16:13:33 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93EB0C433C9;
        Thu,  7 Dec 2023 00:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701908013;
        bh=VK4z4mbYnAwxdbfosn0x/l8EwBMGFMLcMGnwQpfRzYc=;
        h=Date:To:From:Subject:From;
        b=RBL7bsufSESb8PQLnJL7IKCYxKDvOl6JE26YW9LdXp+tYqx4vn0Qh3xF4cNIUnyKh
         xD/Kmw6sPD9CZBYY28XMSVTgADcMjXq0dZZP5WBmhm9GD+ba9nxtWqip0FWm0EpWY8
         nC0pXthJqZTJQ961i2GF/WmCGNjTeFI9O9bNYmhg=
Date:   Wed, 06 Dec 2023 16:13:33 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-core-copy-nr_accesses-when-splitting-region.patch removed from -mm tree
Message-Id: <20231207001333.93EB0C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: copy nr_accesses when splitting region
has been removed from the -mm tree.  Its filename was
     mm-damon-core-copy-nr_accesses-when-splitting-region.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: copy nr_accesses when splitting region
Date: Sun, 19 Nov 2023 17:15:28 +0000

Regions split function ('damon_split_region_at()') is called at the
beginning of an aggregation interval, and when DAMOS applying the actions
and charging quota.  Because 'nr_accesses' fields of all regions are reset
at the beginning of each aggregation interval, and DAMOS was applying the
action at the end of each aggregation interval, there was no need to copy
the 'nr_accesses' field to the split-out region.

However, commit 42f994b71404 ("mm/damon/core: implement scheme-specific
apply interval") made DAMOS applies action on its own timing interval. 
Hence, 'nr_accesses' should also copied to split-out regions, but the
commit didn't.  Fix it by copying it.

Link: https://lkml.kernel.org/r/20231119171529.66863-1-sj@kernel.org
Fixes: 42f994b71404 ("mm/damon/core: implement scheme-specific apply interval")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/core.c~mm-damon-core-copy-nr_accesses-when-splitting-region
+++ a/mm/damon/core.c
@@ -1225,6 +1225,7 @@ static void damon_split_region_at(struct
 	new->age = r->age;
 	new->last_nr_accesses = r->last_nr_accesses;
 	new->nr_accesses_bp = r->nr_accesses_bp;
+	new->nr_accesses = r->nr_accesses;
 
 	damon_insert_region(new, r, damon_next_region(r), t);
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-test-test-damon_split_region_ats-access-rate-copying.patch
mm-damon-core-implement-goal-oriented-feedback-driven-quota-auto-tuning.patch
mm-damon-core-implement-goal-oriented-feedback-driven-quota-auto-tuning-fix.patch
mm-damon-sysfs-schemes-implement-files-for-scheme-quota-goals-setup.patch
mm-damon-sysfs-schemes-commit-damos-quota-goals-user-input-to-damos.patch
mm-damon-sysfs-schemes-implement-a-command-for-scheme-quota-goals-only-commit.patch
mm-damon-core-test-add-a-unit-test-for-the-feedback-loop-algorithm.patch
selftests-damon-test-quota-goals-directory.patch
docs-mm-damon-design-document-damos-quota-auto-tuning.patch
docs-abi-damon-document-damos-quota-goals.patch
docs-admin-guide-mm-damon-usage-document-for-quota-goals.patch

