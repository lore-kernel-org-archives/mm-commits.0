Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AEFDEB64DD
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jun 2023 17:42:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234518AbjFPRmj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Jun 2023 13:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344778AbjFPRmi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2023 13:42:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7207826B6
        for <mm-commits@vger.kernel.org>; Fri, 16 Jun 2023 10:42:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DDE461866
        for <mm-commits@vger.kernel.org>; Fri, 16 Jun 2023 17:42:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5751DC433CC;
        Fri, 16 Jun 2023 17:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686937356;
        bh=Je0rVV+a16aGM4J5NaRPvT8NutaaThKXn/U7fUMlR80=;
        h=Date:To:From:Subject:From;
        b=b0ymUdIdvRm4XcrKHWX3D2zUF9mJui8Go3MkwP+o4/YVBRROv2LCA8S5HfUEO2lIJ
         4EyzE8Qz5+p98Qwu44qbfIt8nIBjfBnXUbUumGfoZmXSby2Zj7IHGER5S5sTxg9N6e
         SRoEUxcvsTIl+qBJtj0Pegj2xffNXK2+dSus7024=
Date:   Fri, 16 Jun 2023 10:42:35 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        sunnanyong@huawei.com, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@kernel.org,
        hannes@cmpxchg.org, zhangpeng362@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-remove-return-value-of-mem_cgroup_scan_tasks.patch added to mm-unstable branch
Message-Id: <20230616174236.5751DC433CC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: remove return value of mem_cgroup_scan_tasks()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-remove-return-value-of-mem_cgroup_scan_tasks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-remove-return-value-of-mem_cgroup_scan_tasks.patch

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

mm-hugetlb-use-a-folio-in-copy_hugetlb_page_range.patch
mm-hugetlb-use-a-folio-in-hugetlb_wp.patch
mm-hugetlb-use-a-folio-in-hugetlb_fault.patch
mm-memcg-remove-return-value-of-mem_cgroup_scan_tasks.patch

