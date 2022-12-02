Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBFBEC4332F
	for <mm-commits@archiver.kernel.org>; Fri,  2 Dec 2022 20:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234516AbiLBUXV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Dec 2022 15:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233548AbiLBUXU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2022 15:23:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572EDE119D
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 12:23:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5003622C0
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 20:23:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356B2C433C1;
        Fri,  2 Dec 2022 20:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670012598;
        bh=OcnFKkH1HQoY1WdouBcPbLRkgQp227ZB9BEUaxST0Aw=;
        h=Date:To:From:Subject:From;
        b=gQ+X+5yfWM84giS5Kyak2RMhyn8ihl5vL1pYHoeYbhw0Lc/A7T7S4YegJ0faUiSiK
         r28w2XNl/JQX82PRxnRZeOaL6c0ORW/Kc34OguL4FSIoAcwNSIe8iJMkdkj0xxV+fc
         B91HzGUzX9nBoBMmIU8Hdh+y8HCzQTq4LCLsn8sQ=
Date:   Fri, 02 Dec 2022 12:23:17 -0800
To:     mm-commits@vger.kernel.org, yujie.liu@intel.com,
        songmuchun@bytedance.com, soheil@google.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mkoutny@suse.com, hannes@cmpxchg.org,
        feng.tang@intel.com, edumazet@google.com, mhocko@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kselftests-cgroup-update-kmem-test-precision-tolerance.patch added to mm-hotfixes-unstable branch
Message-Id: <20221202202318.356B2C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kselftests: cgroup: update kmem test precision tolerance
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kselftests-cgroup-update-kmem-test-precision-tolerance.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kselftests-cgroup-update-kmem-test-precision-tolerance.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Michal Hocko <mhocko@suse.com>
Subject: kselftests: cgroup: update kmem test precision tolerance
Date: Fri, 2 Dec 2022 09:50:26 +0100

OK, so this is a full patch to fix this
---
>From 7f338ed952ba4a100822004bc8399bf720b42899 Mon Sep 17 00:00:00 2001
Date: Fri, 2 Dec 2022 09:45:29 +0100
Subject: [PATCH] kselftests: cgroup: update kmem test precision tolerance

1813e51eece0 ("memcg: increase MEMCG_CHARGE_BATCH to 64") has changed
the batch size while this test case has been left behind. This has led
to a test failure reported by test bot:
not ok 2 selftests: cgroup: test_kmem # exit=1

Update the tolerance for the pcp charges to reflect the
MEMCG_CHARGE_BATCH change to fix this.

Link: https://lkml.kernel.org/r/Y4m8Unt6FhWKC6IH@dhcp22.suse.cz
Fixes: 1813e51eece0a ("memcg: increase MEMCG_CHARGE_BATCH to 64")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: kernel test robot <yujie.liu@intel.com>
  Link: https://lore.kernel.org/oe-lkp/202212010958.c1053bd3-yujie.liu@intel.com
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Tested-by: Yujie Liu <yujie.liu@intel.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Michal Koutný" <mkoutny@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_kmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/cgroup/test_kmem.c~kselftests-cgroup-update-kmem-test-precision-tolerance
+++ a/tools/testing/selftests/cgroup/test_kmem.c
@@ -24,7 +24,7 @@
  * the maximum discrepancy between charge and vmstat entries is number
  * of cpus multiplied by 32 pages.
  */
-#define MAX_VMSTAT_ERROR (4096 * 32 * get_nprocs())
+#define MAX_VMSTAT_ERROR (4096 * 64 * get_nprocs())
 
 
 static int alloc_dcache(const char *cgroup, void *arg)
_

Patches currently in -mm which might be from mhocko@suse.com are

kselftests-cgroup-update-kmem-test-precision-tolerance.patch

