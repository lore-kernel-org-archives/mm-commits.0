Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB26BC433EF
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jul 2022 23:25:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiGQXZb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 19:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiGQXZ2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 19:25:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B981120B4
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 16:25:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCB03B80EA6
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 23:25:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9E5C341C0;
        Sun, 17 Jul 2022 23:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658100325;
        bh=eOS8ThE6mAP0+hnJBdS7qcW30/vtVgRbqwKk+xKI/4M=;
        h=Date:To:From:Subject:From;
        b=YFZNTcWhVqPDt36OEDtvIPLOOetEfcvD7Dnl+Zzamv2AL2Hryz2Za+r4ScA8veAEn
         ol95AY0g1pqPCGgxMai33BVpIQe6KOsm14I/0DsVX1cC5lYcl/+yjgbQWFV5bTVaxO
         Y+AKmgG5eM4B0oMOQlZAuyrNQboOzXYmKjfBrdKs=
Date:   Sun, 17 Jul 2022 16:25:24 -0700
To:     mm-commits@vger.kernel.org, ruansy.fnst@fujitsu.com,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        gaochao49@huawei.com, zhengbin13@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-factor-helpers-for-memory_failure_dev_pagemap-fix-fix.patch removed from -mm tree
Message-Id: <20220717232525.7B9E5C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory-failure: fix redefinition of mf_generic_kill_procs
has been removed from the -mm tree.  Its filename was
     mm-factor-helpers-for-memory_failure_dev_pagemap-fix-fix.patch

This patch was dropped because it was folded into mm-factor-helpers-for-memory_failure_dev_pagemap.patch

------------------------------------------------------
From: Zheng Bin <zhengbin13@huawei.com>
Subject: mm/memory-failure: fix redefinition of mf_generic_kill_procs
Date: Tue, 28 Jun 2022 19:21:43 +0800

If CONFIG_HUGETLB_PAGE=n, building fails:

mm/memory-failure.c:1805:19: error: redefinition of `mf_generic_kill_procs'
 static inline int mf_generic_kill_procs(unsigned long long pfn, int flags,
                   ^~~~~~~~~~~~~~~~~~~~~
mm/memory-failure.c:1564:12: note: previous definition of `mf_generic_kill_procs' was here
 static int mf_generic_kill_procs(unsigned long long pfn, int flags,

This patch fixes that.

Link: https://lkml.kernel.org/r/20220628112143.1170473-1-zhengbin13@huawei.com
Fixes: 4184e8d7d056 ("mm-factor-helpers-for-memory_failure_dev_pagemap-fix")
Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: gaochao <gaochao49@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/mm/memory-failure.c~mm-factor-helpers-for-memory_failure_dev_pagemap-fix-fix
+++ a/mm/memory-failure.c
@@ -1725,13 +1725,6 @@ out:
 }
 
 #else
-
-static inline int mf_generic_kill_procs(unsigned long long pfn, int flags,
-					struct dev_pagemap *pgmap)
-{
-	return 0;
-}
-
 static inline int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb)
 {
 	return 0;
_

Patches currently in -mm which might be from zhengbin13@huawei.com are

mm-factor-helpers-for-memory_failure_dev_pagemap.patch

