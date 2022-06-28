Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1551C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jun 2022 19:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbiF1TGi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Jun 2022 15:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233263AbiF1TGR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jun 2022 15:06:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C250133E22
        for <mm-commits@vger.kernel.org>; Tue, 28 Jun 2022 12:06:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F2DB61BAA
        for <mm-commits@vger.kernel.org>; Tue, 28 Jun 2022 19:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F57C3411D;
        Tue, 28 Jun 2022 19:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656443169;
        bh=aisuSL1slWephWAa5AhEKwgxCI3menuwpPXJ5vyCBxg=;
        h=Date:To:From:Subject:From;
        b=OW2q1nf7RLGuRM8c+yPg5wb9RoFD2wLwHBdA/A3KgcbWgjIsNhxHJdND7KYs9r5ae
         ws3OB2ps5tGVcb2olZDWQIvgoqwsNHOa6B6LErD0CCE/kw9Cy41j+MAM54tkXlLIHK
         l2R/5BoI6FYjU/VFnL16yYhMSiKCkT75tywWO8hY=
Date:   Tue, 28 Jun 2022 12:06:08 -0700
To:     mm-commits@vger.kernel.org, ruansy.fnst@fujitsu.com,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        gaochao49@huawei.com, zhengbin13@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-factor-helpers-for-memory_failure_dev_pagemap-fix-fix.patch added to mm-unstable branch
Message-Id: <20220628190609.A3F57C3411D@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: fix redefinition of mf_generic_kill_procs
has been added to the -mm mm-unstable branch.  Its filename is
     mm-factor-helpers-for-memory_failure_dev_pagemap-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-factor-helpers-for-memory_failure_dev_pagemap-fix-fix.patch

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
@@ -1724,13 +1724,6 @@ out:
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

mm-factor-helpers-for-memory_failure_dev_pagemap-fix-fix.patch

