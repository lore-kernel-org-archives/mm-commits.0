Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 058C6C001DF
	for <mm-commits@archiver.kernel.org>; Fri,  4 Aug 2023 20:05:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbjHDUFC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Aug 2023 16:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbjHDUEs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2023 16:04:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6663170F;
        Fri,  4 Aug 2023 13:04:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45B90620F9;
        Fri,  4 Aug 2023 20:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BAA9C433C8;
        Fri,  4 Aug 2023 20:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691179466;
        bh=aMN1YstFJ0t7c13bUEWeqlqCAG2y1/2EUviDwQTgFUI=;
        h=Date:To:From:Subject:From;
        b=P801m20Tc840v92w9guae0iTHsZiqrQTTXOXU0zjQsENPExgODfzp/Em3Te2RtN4s
         CmsoVPyqO181WKWjzYT0+t7F6joObYp3m9VExN0Ow87hAFOWlWjJpp/4LORH2Zz9av
         +a/SKoq1Jj+18/+GegoOIBxG66mwLIUxNE182hLc=
Date:   Fri, 04 Aug 2023 13:04:26 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-core-initialize-damo_filter-list-from-damos_new_filter.patch removed from -mm tree
Message-Id: <20230804200426.9BAA9C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: initialize damo_filter->list from damos_new_filter()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-initialize-damo_filter-list-from-damos_new_filter.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: initialize damo_filter->list from damos_new_filter()
Date: Sat, 29 Jul 2023 20:37:32 +0000

damos_new_filter() is not initializing the list field of newly allocated
filter object.  However, DAMON sysfs interface and DAMON_RECLAIM are not
initializing it after calling damos_new_filter().  As a result, accessing
uninitialized memory is possible.  Actually, adding multiple DAMOS filters
via DAMON sysfs interface caused NULL pointer dereferencing.  Initialize
the field just after the allocation from damos_new_filter().

Link: https://lkml.kernel.org/r/20230729203733.38949-2-sj@kernel.org
Fixes: 98def236f63c ("mm/damon/core: implement damos filter")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/core.c~mm-damon-core-initialize-damo_filter-list-from-damos_new_filter
+++ a/mm/damon/core.c
@@ -273,6 +273,7 @@ struct damos_filter *damos_new_filter(en
 		return NULL;
 	filter->type = type;
 	filter->matching = matching;
+	INIT_LIST_HEAD(&filter->list);
 	return filter;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-test-add-a-test-for-damos_new_filter.patch
mm-damon-sysfs-schemes-implement-damos-tried-total-bytes-file.patch
mm-damon-sysfs-implement-a-command-for-updating-only-schemes-tried-total-bytes.patch
selftests-damon-sysfs-test-tried_regions-total_bytes-file.patch
docs-abi-damon-update-for-tried_regions-total_bytes.patch
docs-admin-guide-mm-damon-usage-update-for-tried_regions-total_bytes.patch
mm-damon-core-introduce-address-range-type-damos-filter.patch
mm-damon-sysfs-schemes-support-address-range-type-damos-filter.patch
mm-damon-core-test-add-a-unit-test-for-__damos_filter_out.patch
selftests-damon-sysfs-test-address-range-damos-filter.patch
docs-mm-damon-design-update-for-address-range-filters.patch
docs-abi-damon-update-for-address-range-damos-filter.patch
docs-admin-guide-mm-damon-usage-update-for-address-range-type-damos-filter.patch
mm-damon-core-implement-target-type-damos-filter.patch
mm-damon-sysfs-schemes-support-target-damos-filter.patch
selftests-damon-sysfs-test-damon_target-filter.patch
docs-mm-damon-design-update-for-damon-monitoring-target-type-damos-filter.patch
docs-abi-damon-update-for-damon-monitoring-target-type-damos-filter.patch
docs-admin-guide-mm-damon-usage-update-for-damon-monitoring-target-type-damos-filter.patch

