Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31CC498915;
	Fri, 18 Sep 2026 20:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789764335; cv=none; b=qJwDZ1/6HqHpUz5oWalbtaW46qzXV7GGYV5Zj0usQjl5ZdrheGiUhXy0TS0/5k61yYPRxKCoHhvEIbF1h+oz83ANj3AhArxZC4wkaetBstfAJjM7NvfuN27BztS1Q6PDiWztOXzzsCVLDihTyaFRuCoTWgJpUIhXj9PQloBOI14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789764335; c=relaxed/simple;
	bh=qQ6hTjmO3qr+aAoczoG+LFOLL7D2rzssTtc7NcmPevU=;
	h=Date:To:From:Subject:Message-Id; b=O9hytI4NCZvLOPnO3fVygRgpXfK+jcTrRBrv2U8jIgjyqGk9MwNr0t7TXfV28NX9yzoQGDyPeoQS/JQf8jvawPFBIpdD1n0DQD8ffGS/MrZBJdfPiNRuIKSUhnLaGqIymqqYJJRqwtLFmJ5NBHRAbveHI3FKVoNrtn7plRDnN74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q0Dvu0MF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q0Dvu0MF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B961F000FF;
	Fri, 18 Sep 2026 20:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789764333;
	bh=CmLOODNIhj53oxfLflzcaSfPQc2kewIj0bGMUzWB9ho=;
	h=Date:To:From:Subject;
	b=Q0Dvu0MFq+ZotC3meomhTCTJdDz8w5ljy0H6l4UCb93IocIzuw5olGFzQhNfDVIGy
	 pW6/OW3bDiEQ/QkqvtYoeWw8BrdyHREOK2gbViGz2EjdeRmQOaxzGG3ysKQP22k+GF
	 HLT7hVTxQaUa8CXARswNgpzWO8j6ZC9tyVMx7M8A=
Date: Fri, 18 Sep 2026 13:45:32 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,paulmck@kernel.org,hughd@google.com,baolin.wang@linux.alibaba.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-report-rcu-tasks-quiescent-states-while-undoing-a-range.patch added to mm-new branch
Message-Id: <20260918204533.41B961F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem: report RCU-tasks quiescent states while undoing a range
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-report-rcu-tasks-quiescent-states-while-undoing-a-range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-report-rcu-tasks-quiescent-states-while-undoing-a-range.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm/shmem: report RCU-tasks quiescent states while undoing a range
Date: Fri, 18 Sep 2026 04:24:37 -0700

This shows up in the Meta fleet on ftruncate() of large tmpfs files:

  INFO: rcu_tasks detected stalls on tasks:
  00000000752fd185: .. nvcsw: 59455/59455 holdout: 1 idle_cpu: -1/0
  task:rocksdb:bottom  state:R  running task
    __folio_split
    find_get_entry
    find_get_entries
    truncate_inode_partial_folio
    shmem_undo_range
    shmem_setattr
    notify_change
    do_ftruncate
    __x64_sys_ftruncate
    do_syscall_64

shmem_undo_range() walks the whole of the requested range in folio_batch
sized steps, twice, and its two cond_resched() calls are the only
reschedule points in that walk.

cond_resched() is not an RCU-tasks quiescent state.  Use
cond_resched_tasks_rcu_qs() at both points so the walk reports an
RCU-tasks quiescent state as it proceeds.

Link: https://lore.kernel.org/20260918-shmem-tasks-rcu-v1-1-79acf91a2569@debian.org
Fixes: 8315f42295d2 ("rcu: Add call_rcu_tasks()")
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/shmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-report-rcu-tasks-quiescent-states-while-undoing-a-range
+++ a/mm/shmem.c
@@ -1367,7 +1367,7 @@ static void shmem_undo_range(struct inod
 		}
 		folio_batch_remove_exceptionals(&fbatch);
 		folio_batch_release(&fbatch);
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 	}
 
 	/*
@@ -1408,7 +1408,7 @@ whole_folios:
 
 	index = start;
 	while (index < end) {
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 
 		if (!find_get_entries(mapping, &index, end - 1, &fbatch,
 				indices)) {
_

Patches currently in -mm which might be from leitao@debian.org are

mm-swap-distinguish-a-malformed-swap-entry-from-a-dying-device.patch
mm-fail-the-fault-on-a-malformed-swap-entry-instead-of-retrying-it.patch
documentation-kmemleak-describe-the-metadata-pool-not-the-early-log.patch
documentation-kmemleak-fix-stale-statements-about-scanning.patch
mm-kmemleak-raise-min_unref_scans-to-3-for-verbose-auto-scan.patch
mm-shmem-report-rcu-tasks-quiescent-states-while-undoing-a-range.patch

