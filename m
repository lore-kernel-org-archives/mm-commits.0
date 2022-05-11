Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA094C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 11 May 2022 22:13:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235778AbiEKWNE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 May 2022 18:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231897AbiEKWND (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 May 2022 18:13:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0B56EC4C
        for <mm-commits@vger.kernel.org>; Wed, 11 May 2022 15:13:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCEE261CC4
        for <mm-commits@vger.kernel.org>; Wed, 11 May 2022 22:13:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25276C340EE;
        Wed, 11 May 2022 22:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652307181;
        bh=nf+54SJmRKuS8Re6Om3GzN9WYoEBrwUGw7yzblGzXqw=;
        h=Date:To:From:Subject:From;
        b=IXxljxj+PSU1nlUECedqqu5yDwBFjDKyN1FACRCXGE2kicQPyxBQKTVT07aiFg7Lj
         QQPg3XB3nAE0BU9OG+ssWFQpooWba1QMIe56H42yMSSbUVmvOXcL+7qGGnTucOrdl5
         paFLFR/mZ9lOOQd52bP9Kts9qwWP0K30EbNktngg=
Date:   Wed, 11 May 2022 15:13:00 -0700
To:     mm-commits@vger.kernel.org, vvghjk1234@gmail.com,
        mgorman@techsingularity.net, linmiaohe@huawei.com,
        ddutile@redhat.com, yamamoto.rei@jp.fujitsu.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-fast_find_migrateblock-should-return-pfn-in-the-target-zone.patch added to mm-unstable branch
Message-Id: <20220511221301.25276C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: fast_find_migrateblock() should return pfn in the target zone
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-fast_find_migrateblock-should-return-pfn-in-the-target-zone.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-fast_find_migrateblock-should-return-pfn-in-the-target-zone.patch

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
From: Rei Yamamoto <yamamoto.rei@jp.fujitsu.com>
Subject: mm, compaction: fast_find_migrateblock() should return pfn in the target zone

Prevent returning a pfn outside the target zone in case that not aligned
with pageblock boundary.  Otherwise isolate_migratepages_block() would
handle pages not in the target zone.

Link: https://lkml.kernel.org/r/20220511044300.4069-1-yamamoto.rei@jp.fujitsu.com
Signed-off-by: Rei Yamamoto <yamamoto.rei@jp.fujitsu.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Wonhyuk Yang <vvghjk1234@gmail.com>
Cc: Rei Yamamoto <yamamoto.rei@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/compaction.c~mm-compaction-fast_find_migrateblock-should-return-pfn-in-the-target-zone
+++ a/mm/compaction.c
@@ -1848,6 +1848,8 @@ static unsigned long fast_find_migratebl
 
 				update_fast_start_pfn(cc, free_pfn);
 				pfn = pageblock_start_pfn(free_pfn);
+				if (pfn < cc->zone->zone_start_pfn)
+					pfn = cc->zone->zone_start_pfn;
 				cc->fast_search_fail = 0;
 				found_block = true;
 				set_pageblock_skip(freepage);
_

Patches currently in -mm which might be from yamamoto.rei@jp.fujitsu.com are

mm-compaction-fast_find_migrateblock-should-return-pfn-in-the-target-zone.patch

