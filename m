Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 989D0ECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:29:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiILD32 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiILD2x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:28:53 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC05E27B0F
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:28:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 212FACE0E92
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1641C4347C;
        Mon, 12 Sep 2022 03:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953320;
        bh=JnPZG5JAxgz9zHze2ccpTkUIVhOmFuTS5V4/xWXLkPs=;
        h=Date:To:From:Subject:From;
        b=YG5g++lGDxHx9BV/3ariMJ4ZA9WQpQAUeT2j+g8nFYnHlNguLLjKfhgPYqMRlbOLA
         obdVZpBKqF7EX3qzRHsokhRJb6ss/g2PwBn/kW37j2nPEF+VopR3eU/rFiOZHuNKNA
         SVdW5TYqCbIGLwYyvqG5mcG1JzDoGXtAcZxNIlFI=
Date:   Sun, 11 Sep 2022 20:28:39 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        songmuchun@bytedance.com, richard.weiyang@gmail.com,
        mhocko@suse.com, mgorman@techsingularity.net,
        wuyun.abel@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mempolicy-fix-lock-contention-on-mems_allowed.patch removed from -mm tree
Message-Id: <20220912032840.A1641C4347C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mempolicy: fix lock contention on mems_allowed
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-fix-lock-contention-on-mems_allowed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Abel Wu <wuyun.abel@bytedance.com>
Subject: mm/mempolicy: fix lock contention on mems_allowed
Date: Thu, 11 Aug 2022 20:41:57 +0800

The mems_allowed field can be modified by other tasks, so it isn't safe to
access it with alloc_lock unlocked even in the current process context.

Say there are two tasks: A from cpusetA is performing set_mempolicy(2),
and B is changing cpusetA's cpuset.mems:

  A (set_mempolicy)		B (echo xx > cpuset.mems)
  -------------------------------------------------------
  pol = mpol_new();
				update_tasks_nodemask(cpusetA) {
				  foreach t in cpusetA {
				    cpuset_change_task_nodemask(t) {
  mpol_set_nodemask(pol) {
				      task_lock(t); // t could be A
    new = f(A->mems_allowed);
				      update t->mems_allowed;
    pol.create(pol, new);
				      task_unlock(t);
  }
				    }
				  }
				}
  task_lock(A);
  A->mempolicy = pol;
  task_unlock(A);

In this case A's pol->nodes is computed by old mems_allowed, and could
be inconsistent with A's new mems_allowed.

While it is different when replacing vmas' policy: the pol->nodes is
gone wild only when current_cpuset_is_being_rebound():

  A (mbind)			B (echo xx > cpuset.mems)
  -------------------------------------------------------
  pol = mpol_new();
  mmap_write_lock(A->mm);
				cpuset_being_rebound = cpusetA;
				update_tasks_nodemask(cpusetA) {
				  foreach t in cpusetA {
				    cpuset_change_task_nodemask(t) {
  mpol_set_nodemask(pol) {
				      task_lock(t); // t could be A
    mask = f(A->mems_allowed);
				      update t->mems_allowed;
    pol.create(pol, mask);
				      task_unlock(t);
  }
				    }
  foreach v in A->mm {
    if (cpuset_being_rebound == cpusetA)
      pol.rebind(pol, cpuset.mems);
    v->vma_policy = pol;
  }
  mmap_write_unlock(A->mm);
				    mmap_write_lock(t->mm);
				    mpol_rebind_mm(t->mm);
				    mmap_write_unlock(t->mm);
				  }
				}
				cpuset_being_rebound = NULL;

In this case, the cpuset.mems, which has already done updating, is finally
used for calculating pol->nodes, rather than A->mems_allowed.  So it is OK
to call mpol_set_nodemask() with alloc_lock unlocked when doing mbind(2).

Link: https://lkml.kernel.org/r/20220811124157.74888-1-wuyun.abel@bytedance.com
Fixes: 78b132e9bae9 ("mm/mempolicy: remove or narrow the lock on current")
Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-mempolicy-fix-lock-contention-on-mems_allowed
+++ a/mm/mempolicy.c
@@ -853,12 +853,14 @@ static long do_set_mempolicy(unsigned sh
 		goto out;
 	}
 
+	task_lock(current);
 	ret = mpol_set_nodemask(new, nodes, scratch);
 	if (ret) {
+		task_unlock(current);
 		mpol_put(new);
 		goto out;
 	}
-	task_lock(current);
+
 	old = current->mempolicy;
 	current->mempolicy = new;
 	if (new && new->mode == MPOL_INTERLEAVE)
_

Patches currently in -mm which might be from wuyun.abel@bytedance.com are


