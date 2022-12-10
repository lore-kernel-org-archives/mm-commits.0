Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60570C4332F
	for <mm-commits@archiver.kernel.org>; Sat, 10 Dec 2022 02:42:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiLJCl6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Dec 2022 21:41:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiLJCl5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2022 21:41:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3504079C86
        for <mm-commits@vger.kernel.org>; Fri,  9 Dec 2022 18:41:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68CB7623D8
        for <mm-commits@vger.kernel.org>; Sat, 10 Dec 2022 02:41:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E9AC433D2;
        Sat, 10 Dec 2022 02:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670640114;
        bh=q4BUOhlyF7qSD7i/Z706dKs7XflQvMPwl0caembp9UM=;
        h=Date:To:From:Subject:From;
        b=z9Ugniiw7weJc5875wTefSJth7Y6tf1FjI2Bm5KFSxA3sqQtSXHSWuIIuDNEnW0D7
         mqLtL4Y4luNhLi4Gb9sux1Lx4QfbkPiJckFAR9MGmoeiqTGXymn3oGgSJJJVRWxfs4
         XcFqzv4OF6/khdk/Mtmz+zk2mimRclyVHpRoG+0w=
Date:   Fri, 09 Dec 2022 18:41:54 -0800
To:     mm-commits@vger.kernel.org, yujie.liu@intel.com,
        songmuchun@bytedance.com, soheil@google.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mkoutny@suse.com, hannes@cmpxchg.org,
        feng.tang@intel.com, edumazet@google.com, mhocko@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kselftests-cgroup-update-kmem-test-precision-tolerance.patch removed from -mm tree
Message-Id: <20221210024154.B8E9AC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kselftests: cgroup: update kmem test precision tolerance
has been removed from the -mm tree.  Its filename was
     kselftests-cgroup-update-kmem-test-precision-tolerance.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: kselftests: cgroup: update kmem test precision tolerance
Date: Fri, 2 Dec 2022 09:50:26 +0100

1813e51eece0 ("memcg: increase MEMCG_CHARGE_BATCH to 64") has changed
the batch size while this test case has been left behind. This has led
to a test failure reported by test bot:
not ok 2 selftests: cgroup: test_kmem # exit=1

Update the tolerance for the pcp charges to reflect the
MEMCG_CHARGE_BATCH change to fix this.

[akpm@linux-foundation.org: update comments, per Roman]
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

 tools/testing/selftests/cgroup/test_kmem.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/cgroup/test_kmem.c~kselftests-cgroup-update-kmem-test-precision-tolerance
+++ a/tools/testing/selftests/cgroup/test_kmem.c
@@ -19,12 +19,12 @@
 
 
 /*
- * Memory cgroup charging is performed using percpu batches 32 pages
+ * Memory cgroup charging is performed using percpu batches 64 pages
  * big (look at MEMCG_CHARGE_BATCH), whereas memory.stat is exact. So
  * the maximum discrepancy between charge and vmstat entries is number
- * of cpus multiplied by 32 pages.
+ * of cpus multiplied by 64 pages.
  */
-#define MAX_VMSTAT_ERROR (4096 * 32 * get_nprocs())
+#define MAX_VMSTAT_ERROR (4096 * 64 * get_nprocs())
 
 
 static int alloc_dcache(const char *cgroup, void *arg)
_

Patches currently in -mm which might be from mhocko@suse.com are


