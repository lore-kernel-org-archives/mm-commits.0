Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71B26C7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:35:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232643AbjFIXfR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232536AbjFIXd3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:33:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF55C49EC
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:30:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9728665D0C
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC383C433D2;
        Fri,  9 Jun 2023 23:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353431;
        bh=du+zMJD+ifgQSR3qWLLiVIo7610mZUh/Pd3IMvRZuRI=;
        h=Date:To:From:Subject:From;
        b=IYLV92C0wEGpDnLpYXuZPyeWarTZAfAnm6jL5LrqCFHmnmdcS9uv0N1iKR9N/lRrb
         YxEIIhRV9PUNmaGfwWdEAz07pWmaKzGWfUA5hEBw8s9RtCu6/TZKw1wHkc8t5GJ+/Y
         7wQwEu4ZWYJ5Gmea7pyHtYQXS5GJtvoWNcVo5nmo=
Date:   Fri, 09 Jun 2023 16:30:30 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@kernel.org,
        hannes@cmpxchg.org, david@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-use-helper-macro-flush_time.patch removed from -mm tree
Message-Id: <20230609233030.EC383C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memcg: use helper macro FLUSH_TIME
has been removed from the -mm tree.  Its filename was
     memcg-use-helper-macro-flush_time.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: memcg: use helper macro FLUSH_TIME
Date: Sat, 3 Jun 2023 15:21:16 +0800

Use helper macro FLUSH_TIME to indicate the flush time to improve the
readability a bit. No functional change intended.

Link: https://lkml.kernel.org/r/20230603072116.1101690-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-use-helper-macro-flush_time
+++ a/mm/memcontrol.c
@@ -5428,7 +5428,7 @@ static int mem_cgroup_css_online(struct
 
 	if (unlikely(mem_cgroup_is_root(memcg)))
 		queue_delayed_work(system_unbound_wq, &stats_flush_dwork,
-				   2UL*HZ);
+				   FLUSH_TIME);
 	lru_gen_online_memcg(memcg);
 	return 0;
 offline_kmem:
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-remove-obsolete-alloc_migrate_target.patch
mm-vmscan-mark-kswapd_run-and-kswapd_stop-__meminit.patch
memory-tier-remove-unneeded-disable_all_demotion_targets-when-config_migration.patch

