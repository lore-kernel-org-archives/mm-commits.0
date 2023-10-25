Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF28C25B70
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:49:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235015AbjJYXte (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234816AbjJYXsr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E58D64
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:44 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99FD1C433C8;
        Wed, 25 Oct 2023 23:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277723;
        bh=YJQ2ZTE0pn4wZUEVUe/om3RZDgJYSQ/SrFPuNpcSa7U=;
        h=Date:To:From:Subject:From;
        b=LhBgOBWUk1z/yhl1clx4Ni1ybREbtN8b0nrqnXKyNHPlz12SPHomDdBeKJYnSehZN
         O6ZvmHBuMqDX8gVg4LyAxdT6mWfTbavuleEJ7EytQxckj14OJX5SJRpFCQjmIKJoUR
         /nrGl35lYtBrQ1XEuwud6o9Lldu0We/xl/qrNNsY=
Date:   Wed, 25 Oct 2023 16:48:43 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, vincent.guittot@linaro.org,
        peterz@infradead.org, mingo@redhat.com, juri.lelli@redhat.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-folio_xchg_last_cpupid.patch removed from -mm tree
Message-Id: <20231025234843.99FD1C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add folio_xchg_last_cpupid()
has been removed from the -mm tree.  Its filename was
     mm-add-folio_xchg_last_cpupid.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: add folio_xchg_last_cpupid()
Date: Wed, 18 Oct 2023 22:07:59 +0800

Add folio_xchg_last_cpupid() wrapper, which is required to convert
page_cpupid_xchg_last() to folio vertion later in the series.

Link: https://lkml.kernel.org/r/20231018140806.2783514-13-wangkefeng.wang@huawei.com
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

--- a/include/linux/mm.h~mm-add-folio_xchg_last_cpupid
+++ a/include/linux/mm.h
@@ -1797,6 +1797,11 @@ static inline void vma_set_access_pid_bi
 }
 #endif /* CONFIG_NUMA_BALANCING */
 
+static inline int folio_xchg_last_cpupid(struct folio *folio, int cpupid)
+{
+	return page_cpupid_xchg_last(&folio->page, cpupid);
+}
+
 #if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
 
 /*
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


