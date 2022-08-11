Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 249F0C19F2A
	for <mm-commits@archiver.kernel.org>; Thu, 11 Aug 2022 21:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235962AbiHKVaI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Aug 2022 17:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235221AbiHKVaH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2022 17:30:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0628A9D8ED
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 14:30:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC926B822A2
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 21:30:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5264BC433C1;
        Thu, 11 Aug 2022 21:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660253403;
        bh=0mhgb32ELQCtsMFdgHG09yIecwi2v6347x2yK3VcvoA=;
        h=Date:To:From:Subject:From;
        b=EY8vj9UUiPAUBw/B735loMT3VDaxOPS8Ci0xQsv9bYK+ArlObdtWnJaSdbjp5x2om
         hZ0xAhPdwxAR9S9ZVfPbt9xLVi56anEEglRLACnPPPoWROlNZZiq/mqmIWYQwvv3cv
         ebcnfALeQjbeEVQVTq72ofufVm+GaGLvtHJ7v88c=
Date:   Thu, 11 Aug 2022 14:30:02 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        songmuchun@bytedance.com, richard.weiyang@linux.alibaba.com,
        mhocko@kernel.org, mgorman@techsingularity.net,
        wuyun.abel@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-fix-lock-contention-on-mems_allowed.patch added to mm-unstable branch
Message-Id: <20220811213003.5264BC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: fix lock contention on mems_allowed
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempolicy-fix-lock-contention-on-mems_allowed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-fix-lock-contention-on-mems_allowed.patch

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
Cc: Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
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

mm-mempolicy-fix-lock-contention-on-mems_allowed.patch

