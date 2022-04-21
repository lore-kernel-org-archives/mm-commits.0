Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6C00C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 21 Apr 2022 19:28:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391697AbiDUTbr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Apr 2022 15:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354925AbiDUTbr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2022 15:31:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C624D61F
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 12:28:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD341B828D3
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 19:28:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F4AC385A7;
        Thu, 21 Apr 2022 19:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650569334;
        bh=+iEkIB1iV5KvzfVLpNdooP2bNArIzlRAxaDrrJuPtJo=;
        h=Date:To:From:Subject:From;
        b=s5ypwzDdZ6IF3XsvyU2UTu7KR3jS9+0wcWS3t3dMEvH7Dctab/0Yfg2HDERawc8Gi
         ycONuEd2vKoe9oj3Mb2FlNCtGtaSJSSPgYh7G8+jBFaYsPkmc3FmEPCRzto57Om7OH
         Iv4voxX4i0scKlmoNjH5iGxV7QMQkRgw+hNG/+Bs=
Date:   Thu, 21 Apr 2022 12:28:53 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        lujialin4@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrolc-make-cgroup_memory_noswap-static.patch added to -mm tree
Message-Id: <20220421192854.83F4AC385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c: make cgroup_memory_noswap static
has been added to the -mm tree.  Its filename is
     mm-memcontrolc-make-cgroup_memory_noswap-static.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrolc-make-cgroup_memory_noswap-static.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrolc-make-cgroup_memory_noswap-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lu Jialin <lujialin4@huawei.com>
Subject: mm/memcontrol.c: make cgroup_memory_noswap static

cgroup_memory_noswap is only used in mm/memcontrol.c, therefore just make
it static, and remove export in include/linux/memcontrol.h

Link: https://lkml.kernel.org/r/20220421124736.62180-1-lujialin4@huawei.com
Signed-off-by: Lu Jialin <lujialin4@huawei.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ----
 mm/memcontrol.c            |    2 +-
 2 files changed, 1 insertion(+), 5 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrolc-make-cgroup_memory_noswap-static
+++ a/include/linux/memcontrol.h
@@ -937,10 +937,6 @@ struct mem_cgroup *mem_cgroup_get_oom_gr
 					    struct mem_cgroup *oom_domain);
 void mem_cgroup_print_oom_group(struct mem_cgroup *memcg);
 
-#ifdef CONFIG_MEMCG_SWAP
-extern bool cgroup_memory_noswap;
-#endif
-
 void folio_memcg_lock(struct folio *folio);
 void folio_memcg_unlock(struct folio *folio);
 void lock_page_memcg(struct page *page);
--- a/mm/memcontrol.c~mm-memcontrolc-make-cgroup_memory_noswap-static
+++ a/mm/memcontrol.c
@@ -90,7 +90,7 @@ static bool cgroup_memory_nokmem __ro_af
 
 /* Whether the swap controller is active */
 #ifdef CONFIG_MEMCG_SWAP
-bool cgroup_memory_noswap __ro_after_init;
+static bool cgroup_memory_noswap __ro_after_init;
 #else
 #define cgroup_memory_noswap		1
 #endif
_

Patches currently in -mm which might be from lujialin4@huawei.com are

mm-memcontrolc-make-cgroup_memory_noswap-static.patch

