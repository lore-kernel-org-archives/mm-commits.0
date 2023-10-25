Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83C29C0032E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:49:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234431AbjJYXta (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234559AbjJYXsr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941CBD4D
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DFFC433C7;
        Wed, 25 Oct 2023 23:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277719;
        bh=StllyZfduTS/9aeK4o6xm1Z9cfWkkxO6YghRUZUf8JY=;
        h=Date:To:From:Subject:From;
        b=ID8UFdhtka5FTV2/jSww/Ei968QfX3y7EWn/C8HPyIIbn15dxRsuQ5uV8hcGdVaL9
         GMYsogwTBkTChj165dmy09k9EQq4wOImTKu/3vE3fZKIOqup1WgnxFLs8WBh29w30Z
         67soTSLiQdalE2J9F8CvpvshiGUcEi0Ml8HGwqZ0=
Date:   Wed, 25 Oct 2023 16:48:38 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, vincent.guittot@linaro.org,
        peterz@infradead.org, mingo@redhat.com, juri.lelli@redhat.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-folio_xchg_access_time.patch removed from -mm tree
Message-Id: <20231025234839.30DFFC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add folio_xchg_access_time()
has been removed from the -mm tree.  Its filename was
     mm-add-folio_xchg_access_time.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: add folio_xchg_access_time()
Date: Wed, 18 Oct 2023 22:07:54 +0800

Add folio_xchg_access_time() wrapper, which is required to convert
xchg_page_access_time() to folio vertion later in the series.

Link: https://lkml.kernel.org/r/20231018140806.2783514-8-wangkefeng.wang@huawei.com
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

--- a/include/linux/mm.h~mm-add-folio_xchg_access_time
+++ a/include/linux/mm.h
@@ -1796,6 +1796,11 @@ static inline void vma_set_access_pid_bi
 }
 #endif /* CONFIG_NUMA_BALANCING */
 
+static inline int folio_xchg_access_time(struct folio *folio, int time)
+{
+	return xchg_page_access_time(&folio->page, time);
+}
+
 #if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
 
 /*
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


