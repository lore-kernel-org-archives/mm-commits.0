Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00DF8C001DB
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjFSX1W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbjFSXZu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:25:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F9B10D2
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:23:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FDDC60FB7
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:23:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7AEFC433C0;
        Mon, 19 Jun 2023 23:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687217008;
        bh=drw8tcw4vypm9qDWHbFp0mFTzPF252aTVLMqlZpQ52M=;
        h=Date:To:From:Subject:From;
        b=xcqdkLda0EMj2dZdijyfrSZCI32aTDr99VWKGi2EIUn9p4OkmGeI9/LZ33P3qu71b
         UmzGawK8oRjTrQ9X7wNLmyQjfbyLp1nkja3lk5WTreEUCarFAhYp9gt8bqJKJSqN6s
         Y44KpFYJITsKi7SaeJEuo3HC2q1lsFkD9pTrPAXM=
Date:   Mon, 19 Jun 2023 16:23:28 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        sunnanyong@huawei.com, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@kernel.org,
        hannes@cmpxchg.org, zhangpeng362@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-remove-return-value-of-mem_cgroup_scan_tasks.patch removed from -mm tree
Message-Id: <20230619232328.A7AEFC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memcg: remove return value of mem_cgroup_scan_tasks()
has been removed from the -mm tree.  Its filename was
     mm-memcg-remove-return-value-of-mem_cgroup_scan_tasks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm/memcg: remove return value of mem_cgroup_scan_tasks()
Date: Fri, 16 Jun 2023 14:30:30 +0800

No user checks the return value of mem_cgroup_scan_tasks(). Make the
return value void.

Link: https://lkml.kernel.org/r/20230616063030.977586-1-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    7 +++----
 mm/memcontrol.c            |    9 ++++-----
 2 files changed, 7 insertions(+), 9 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-remove-return-value-of-mem_cgroup_scan_tasks
+++ a/include/linux/memcontrol.h
@@ -820,8 +820,8 @@ struct mem_cgroup *mem_cgroup_iter(struc
 				   struct mem_cgroup *,
 				   struct mem_cgroup_reclaim_cookie *);
 void mem_cgroup_iter_break(struct mem_cgroup *, struct mem_cgroup *);
-int mem_cgroup_scan_tasks(struct mem_cgroup *,
-			  int (*)(struct task_struct *, void *), void *);
+void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
+			   int (*)(struct task_struct *, void *), void *arg);
 
 static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
 {
@@ -1364,10 +1364,9 @@ static inline void mem_cgroup_iter_break
 {
 }
 
-static inline int mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
+static inline void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 		int (*fn)(struct task_struct *, void *), void *arg)
 {
-	return 0;
 }
 
 static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
--- a/mm/memcontrol.c~mm-memcg-remove-return-value-of-mem_cgroup_scan_tasks
+++ a/mm/memcontrol.c
@@ -1259,13 +1259,13 @@ static void invalidate_reclaim_iterators
  *
  * This function iterates over tasks attached to @memcg or to any of its
  * descendants and calls @fn for each task. If @fn returns a non-zero
- * value, the function breaks the iteration loop and returns the value.
- * Otherwise, it will iterate over all tasks and return 0.
+ * value, the function breaks the iteration loop. Otherwise, it will iterate
+ * over all tasks and return 0.
  *
  * This function must not be called for the root memory cgroup.
  */
-int mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
-			  int (*fn)(struct task_struct *, void *), void *arg)
+void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
+			   int (*fn)(struct task_struct *, void *), void *arg)
 {
 	struct mem_cgroup *iter;
 	int ret = 0;
@@ -1285,7 +1285,6 @@ int mem_cgroup_scan_tasks(struct mem_cgr
 			break;
 		}
 	}
-	return ret;
 }
 
 #ifdef CONFIG_DEBUG_VM
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are


