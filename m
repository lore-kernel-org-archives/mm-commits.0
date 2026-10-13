Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E6D4848A5;
	Tue, 13 Oct 2026 04:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791866011; cv=none; b=DcmcNo54h2lLNWcRLK9ppVCQffhic8UTPWnnv4wxTST97363f/fqithSthgCYX1pxv+VTOklRNjPfBpwqsWyJlaE9eGbVu6JNaALrb1xNaTMH3VLXu6BgE63K4ojiObKE8o0+2dGQfXuRBR30++JuRLJoWejlbqf9snjbrmkUFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791866011; c=relaxed/simple;
	bh=LxU5Juz9kSoqD0JyDxlyA2S0m3BQNUtI8AF5u6M1LmI=;
	h=Date:To:From:Subject:Message-Id; b=HWBYn4qdGrskugJmTG2On5zts12blJPCDPAdizkhZRytxtKrezuFIBW60nrH5A2YmB84AhXmj7NQqjNjG/2umijz4aa0ZOgiXlpZGyJ+RiuvZMk3JAghiXc5F14ma9kDLI16rQCGlfi/l2JLVIcGRbej5J+y/BDkv7oXiqH3yhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Pigmyr0m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pigmyr0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF1D1F00893;
	Tue, 13 Oct 2026 04:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791866009;
	bh=J/7QxNrBYn49lJF+FgAThlNSHL0e9GGvl5xudSqUi28=;
	h=Date:To:From:Subject;
	b=Pigmyr0m18Ci+FAums8/akpRnQM2b2cvd1mDr5Ig/DkI1ZZ0+sY0BMRH74tC9jXad
	 7rSrXFFltiSs5O628oP2JRB7ob7G5g0XtTvip/bzzgcxDe31ByapDc7aBn32zoc+Ll
	 URuMQW3Zsg5179oqpTnQmhpE5Of6CQkOrDFzVbPw=
Date: Mon, 12 Oct 2026 21:33:29 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,paulmck@kernel.org,hughd@google.com,baolin.wang@linux.alibaba.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-report-rcu-tasks-quiescent-states-while-undoing-a-range.patch removed from -mm tree
Message-Id: <20261013043329.BBF1D1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/shmem: report RCU-tasks quiescent states while undoing a range
has been removed from the -mm tree.  Its filename was
     mm-shmem-report-rcu-tasks-quiescent-states-while-undoing-a-range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: SJ Park <sj@kernel.org>
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


