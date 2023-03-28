Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F366C76196
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:17:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjC1XRo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjC1XRn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:17:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 155201BF0
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:17:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADAF1B81F4D
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:17:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D29AC433EF;
        Tue, 28 Mar 2023 23:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045459;
        bh=0OtY9h1bwKs/yCLK9lqbVVvMN4/lBFhJ3KUL5jLqZjE=;
        h=Date:To:From:Subject:From;
        b=uT3yagWjpR8CjzhG3CUHnKPeBeqxsUFB0Q0QXmKDaaDRgWNjorRU+wBP8izWbdD4N
         HVNM5mgwhyh6Eyxplcau+v1Y7pbi0Wp7jEhoTUXf72DU0MKtbfwErqyblk0s0N0jQu
         5nZvNlbgGBONUMhoyPx5npUkihJYyZ1Ob0IDnjGs=
Date:   Tue, 28 Mar 2023 16:17:38 -0700
To:     mm-commits@vger.kernel.org, shy828301@gmail.com, david@redhat.com,
        aneesh.kumar@linux.ibm.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported-fix.patch removed from -mm tree
Message-Id: <20230328231739.6D29AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported-fix
has been removed from the -mm tree.  Its filename was
     mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported-fix.patch

This patch was dropped because it was folded into mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported.patch

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported-fix
Date: Thu, 16 Mar 2023 11:18:25 -0400

fix comment, per David.

Link: https://lkml.kernel.org/r/ZBMzQW674oHQJV7F@x1n
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/huge_memory.c~mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported-fix
+++ a/mm/huge_memory.c
@@ -460,10 +460,6 @@ static int __init hugepage_init(void)
 	struct kobject *hugepage_kobj;
 
 	if (!has_transparent_hugepage()) {
-		/*
-		 * Hardware doesn't support hugepages, hence disable
-		 * DAX PMD support.
-		 */
 		transparent_hugepage_flags = 1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED;
 		return -EINVAL;
 	}
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path.patch
mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path-v2.patch
mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path-v3.patch
mm-khugepaged-alloc_charge_hpage-take-care-of-mem-charge-errors.patch
mm-khugepaged-cleanup-memcg-uncharge-for-failure-path.patch
mm-thp-rename-transparent_hugepage_never_dax-to-_unsupported.patch
mm-uffd-uffd_feature_wp_unpopulated.patch
mm-uffd-uffd_feature_wp_unpopulated-fix.patch
selftests-mm-smoke-test-uffd_feature_wp_unpopulated.patch

