Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E798C4332F
	for <mm-commits@archiver.kernel.org>; Sat, 10 Dec 2022 01:54:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiLJByG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Dec 2022 20:54:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiLJByE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2022 20:54:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221B71EAE4
        for <mm-commits@vger.kernel.org>; Fri,  9 Dec 2022 17:54:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A831F623C4
        for <mm-commits@vger.kernel.org>; Sat, 10 Dec 2022 01:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E634DC433EF;
        Sat, 10 Dec 2022 01:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670637243;
        bh=xSAECt43ahQ4Vdhrk17VlM9Rsx8zf4GhFA4Szmbi6wQ=;
        h=Date:To:From:Subject:From;
        b=SB2q0uyapZ9HNnYlf+94wi191YFS0U3YSktywKTeokFWcJcYj9XGBy3fgUUrz1Rnd
         1V2uV47WFA/JBXQ78/Ta44+4ko02lkRxsR3uGHbveppSQKUsfq8Pa1odBD5zaI8HmZ
         y/ivEdojUOmcJuSsumqpfllbxEWyNzYtBL/uDIbc=
Date:   Fri, 09 Dec 2022 17:54:02 -0800
To:     mm-commits@vger.kernel.org, yujie.liu@intel.com,
        songmuchun@bytedance.com, soheil@google.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mkoutny@suse.com, mhocko@suse.com,
        hannes@cmpxchg.org, feng.tang@intel.com, edumazet@google.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kselftests-cgroup-update-kmem-test-precision-tolerance-fix.patch removed from -mm tree
Message-Id: <20221210015402.E634DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kselftests-cgroup-update-kmem-test-precision-tolerance-fix
has been removed from the -mm tree.  Its filename was
     kselftests-cgroup-update-kmem-test-precision-tolerance-fix.patch

This patch was dropped because it was folded into kselftests-cgroup-update-kmem-test-precision-tolerance.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kselftests-cgroup-update-kmem-test-precision-tolerance-fix
Date: Fri Dec  2 12:22:25 PM PST 2022

update comments, per Roman

Cc: Eric Dumazet <edumazet@google.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: kernel test robot <yujie.liu@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Michal Koutný" <mkoutny@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_kmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/cgroup/test_kmem.c~kselftests-cgroup-update-kmem-test-precision-tolerance-fix
+++ a/tools/testing/selftests/cgroup/test_kmem.c
@@ -19,10 +19,10 @@
 
 
 /*
- * Memory cgroup charging is performed using percpu batches 32 pages
+ * Memory cgroup charging is performed using percpu batches 64 pages
  * big (look at MEMCG_CHARGE_BATCH), whereas memory.stat is exact. So
  * the maximum discrepancy between charge and vmstat entries is number
- * of cpus multiplied by 32 pages.
+ * of cpus multiplied by 64 pages.
  */
 #define MAX_VMSTAT_ERROR (4096 * 64 * get_nprocs())
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-mm-align-larger-anonymous-mappings-on-thp-boundaries.patch
kselftests-cgroup-update-kmem-test-precision-tolerance.patch
mm-gup-remove-foll_migration-fix.patch
fsdax-zero-the-edges-if-source-is-hole-or-unwritten-fix.patch
mm-disable-top-tier-fallback-to-reclaim-on-proactive-reclaim-fix.patch

