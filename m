Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07907C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2EA261402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhEHWuP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:50:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229713AbhEHWuO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:50:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8453B613EA;
        Sat,  8 May 2021 22:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514152;
        bh=yRl7AtldkyKdAtZs15fDyQLLr5hW8Gz3MR4RdmZG0gg=;
        h=Date:From:To:Subject:From;
        b=KDf1SU3RydRvQG9rwgDbc/3Jju3j5xKnWh1Y4CHwSYrLHlRg6i0YDLXljbmmnEjBc
         lqSR7lOyoH9kCgtkMBedBj18f5ye8quQN8Rev8osuLl/eNLympDtB5SpYLVSW9ROlU
         zZpm3x4lM8G93wnn9qdIMaJZQuO9Dq2YAdjnBrHQ=
Date:   Sat, 08 May 2021 15:49:12 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, aquini@redhat.com, david@redhat.com,
        jglisse@redhat.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com
Subject:  [merged]
 =?US-ASCII?Q?mm-migratec-remove-unnecessary-rc-=3D-migratepage=5Fsuccess-?=
 =?US-ASCII?Q?check-in-else-case.patch?= removed from -mm tree
Message-ID: <20210508224912.7wJ9l8u7m%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate.c: remove unnecessary rc != MIGRATEPAGE_SUCCESS check in 'else' case
has been removed from the -mm tree.  Its filename was
     mm-migratec-remove-unnecessary-rc-=-migratepage_success-check-in-else-case.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/migrate.c: remove unnecessary rc != MIGRATEPAGE_SUCCESS check in 'else' case

It's guaranteed that in the 'else' case of the rc == MIGRATEPAGE_SUCCESS
check, rc does not equal to MIGRATEPAGE_SUCCESS.  Remove this unnecessary
check.

Link: https://lkml.kernel.org/r/20210325131524.48181-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migratec-remove-unnecessary-rc-=-migratepage_success-check-in-else-case
+++ a/mm/migrate.c
@@ -1348,7 +1348,7 @@ out_unlock:
 out:
 	if (rc == MIGRATEPAGE_SUCCESS)
 		putback_active_hugepage(hpage);
-	else if (rc != -EAGAIN && rc != MIGRATEPAGE_SUCCESS)
+	else if (rc != -EAGAIN)
 		list_move_tail(&hpage->lru, ret);
 
 	/*
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


