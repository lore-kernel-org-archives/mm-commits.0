Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8D80CD4853
	for <mm-commits@archiver.kernel.org>; Mon, 25 Sep 2023 18:33:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbjIYSdp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Sep 2023 14:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233266AbjIYSd2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Sep 2023 14:33:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41080120
        for <mm-commits@vger.kernel.org>; Mon, 25 Sep 2023 11:33:02 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D28C433C7;
        Mon, 25 Sep 2023 18:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695666782;
        bh=cRa6yyTKZ6h3cazfD/1f+mYGUJY3yYsrSaoiG49eqGI=;
        h=Date:To:From:Subject:From;
        b=pvbBuSyDOoHVO7W2nTQd+jbJ4tSn6lXFEffod8cU1dSw3Cw5j1e8JhcuHWvN06C2F
         LbjN3S48s42aFqDlMSoZgbZXGglAkHkBLEr6FQDv+4fTuNDMV9jW5G75SDNkqzTlXz
         Aku6ASO6BpN61Vq08Ap4URPodP9bYNkeFk3Vshyw=
Date:   Mon, 25 Sep 2023 11:33:01 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@suse.com,
        jpiotrowski@linux.microsoft.com, hannes@cmpxchg.org,
        gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-reconsider-kmemlimit_in_bytes-deprecation-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20230925183302.49D28C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcg-reconsider-kmemlimit_in_bytes-deprecation-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memcg-reconsider-kmemlimit_in_bytes-deprecation-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-reconsider-kmemlimit_in_bytes-deprecation-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcg-reconsider-kmemlimit_in_bytes-deprecation-fix
Date: Mon Sep 25 11:31:21 AM PDT 2023

fix build - remove unused local

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-reconsider-kmemlimit_in_bytes-deprecation-fix
+++ a/mm/memcontrol.c
@@ -3097,7 +3097,6 @@ static void obj_cgroup_uncharge_pages(st
 static int obj_cgroup_charge_pages(struct obj_cgroup *objcg, gfp_t gfp,
 				   unsigned int nr_pages)
 {
-	struct page_counter *counter;
 	struct mem_cgroup *memcg;
 	int ret;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-memcg-reconsider-kmemlimit_in_bytes-deprecation-fix.patch
mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim-fix.patch
mm-hugetlb-skip-initialization-of-gigantic-tail-struct-pages-if-freed-by-hvo-fix.patch
vmscan-add-trace-events-for-lru_gen-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix.patch
kthread-add-kthread_stop_put-v2-fix.patch

