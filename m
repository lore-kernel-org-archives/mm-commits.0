Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AEE3C25B6F
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:49:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233628AbjJYXtK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbjJYXsq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007E21BD
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:34 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F576C433C8;
        Wed, 25 Oct 2023 23:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277714;
        bh=19kfZRSUb6U3pS+pWKhzBDukJMSEWWrArnWujNil+u8=;
        h=Date:To:From:Subject:From;
        b=kkkJkvaxOIOsDdgQhP/u6/2eDNLmCRo+e1KOcpKW75lvxDbcMuIU65rCKL+hTAvtY
         63IWeM/5taWH3xzjOAUWf2igFD5iv8KKyDHIN1gurlg4Mx6g5zA95c+zAq2KatwVSt
         KjZv00oJQue/M4TY1G53kBtmrGHOWRrOv18pdLoQ=
Date:   Wed, 25 Oct 2023 16:48:33 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, vincent.guittot@linaro.org,
        peterz@infradead.org, mingo@redhat.com, juri.lelli@redhat.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-folio_last_cpupid.patch removed from -mm tree
Message-Id: <20231025234834.8F576C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add folio_last_cpupid()
has been removed from the -mm tree.  Its filename was
     mm-add-folio_last_cpupid.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: add folio_last_cpupid()
Date: Wed, 18 Oct 2023 22:07:49 +0800

Add folio_last_cpupid() wrapper, which is required to convert
page_cpupid_last() to folio vertion later in the series.

Link: https://lkml.kernel.org/r/20231018140806.2783514-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/linux/mm.h~mm-add-folio_last_cpupid
+++ a/include/linux/mm.h
@@ -1796,6 +1796,11 @@ static inline void vma_set_access_pid_bi
 }
 #endif /* CONFIG_NUMA_BALANCING */
 
+static inline int folio_last_cpupid(struct folio *folio)
+{
+	return page_cpupid_last(&folio->page);
+}
+
 #if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
 
 /*
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


