Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7B346C825;
	Fri, 18 Sep 2026 05:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789710245; cv=none; b=WF5ojgQScSHfe7z8AXZBIShqIu7J62+e0IBLKrKzentYivDH6VsGlZzfw3n131cZnFQiKyK5l0LqBEyHuI+m1f8pB7rYtKk69x5h8CZwjJhgaalMS+ptkT98OxFHL3fTCvN234v6aSxSionnu/Y5KDImjs4+xoj+38PTP0AEDAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789710245; c=relaxed/simple;
	bh=XOSIgTb8S0MpObQN88Rs+ugbTUl8Xef1fWWbtzJ3pK4=;
	h=Date:To:From:Subject:Message-Id; b=pBdkWnoWJolECTuJ0Swy2jXRXYT9lsd6m5JqeXoG+EPlShp+AhrQ3/knQYCRYnigO+M0npl7/HKmEB3LOT7KbyjOgGBFo9jQSCBPqGIeuzZF7g0Y5aJwuqZEmpe0WqhNkYzSNYCuiPGI4XDXhleQTqORaYw+khXzjrwInduKMhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nDG2W0Lx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nDG2W0Lx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A3C81F00893;
	Fri, 18 Sep 2026 05:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789710243;
	bh=cgc+n7eLZTLgU2u7Jjk3Yco41I3Y+MKnxGdHOx9J4jY=;
	h=Date:To:From:Subject;
	b=nDG2W0LxX3kQ/SLZVaE5YlSfNXMIo4m8cgX6yTMAGp1Pr44liZ6g7XQoOKDlE+4K2
	 46LbSai0yrzBfnanB5Jcw/B2f6PtwUaXC3VjhhbdW+vFKrZ87J8PNAwxxfKwkTFiy1
	 aXd+oI9nvyU33BMdT+oBhK0v6obcKH980DEs4+7c=
Date: Thu, 17 Sep 2026 22:44:03 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,tj@kernel.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,roman.gushchin@linux.dev,paulmck@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jack@suse.cz,dennis@kernel.org,david@kernel.org,josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] writeback-report-a-tasks-rcu-quiescent-state-per-cgwb-drain-pass.patch removed from -mm tree
Message-Id: <20260918054403.9A3C81F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: writeback: report a Tasks-RCU quiescent state per cgwb drain pass
has been removed from the -mm tree.  Its filename was
     writeback-report-a-tasks-rcu-quiescent-state-per-cgwb-drain-pass.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Josef Bacik <josef@toxicpanda.com>
Subject: writeback: report a Tasks-RCU quiescent state per cgwb drain pass
Date: Wed, 09 Sep 2026 18:01:07 +0000

cleanup_offline_cgwbs_workfn() drains a dying cgwb by calling
cleanup_offline_cgwb() until it returns false, with a cond_resched()
between passes.  On a CONFIG_PREEMPTION kernel that cond_resched() does
nothing: _cond_resched() is a plain "return 0", and under PREEMPT_DYNAMIC
the full and lazy modes disable it.  Since commit 7dadeaa6e851 ("sched:
Further restrict the preemption modes") those are the only two models on
the architectures with PREEMPT_LAZY support, arm64 and x86 among them, so
the drain loop never reports a Tasks-RCU quiescent state.

A worker draining a cgwb with millions of attached inodes runs for
minutes.  On a 6.18 arm64 host in lazy mode the cgwb worker drained one
dying cgroup's writeback domain for over 11 minutes.  A BPF program unlink
(bpf_trampoline_unlink_prog -> bpf_trampoline_update ->
unregister_ftrace_direct -> ftrace_shutdown -> synchronize_rcu_tasks())
waited on that grace period while holding the trampoline mutex, 42 tasks
queued behind it in D state, and the hung task detector fired at 614 s and
panicked the host.  Any BPF or ftrace detach during a long drain inherits
the drain's length.

Fix this by calling cond_resched_tasks_rcu_qs() so we do not stall out
anybody who calls sycnrhonize_rcu_tasks().  We put this in a do { } while
loop because if we have many small cgroups cleanup_offline_cgwb() will
return false and we will never call cond_resched_tasks_rcu_qs(), creating
the same problem.

Link: https://lore.kernel.org/20260909-cgwb-tasks-rcu-qs-v1-1-967a7754771f@toxicpanda.com
Fixes: c22d70a162d3 ("writeback, cgroup: release dying cgwbs by switching attached inodes")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Link: https://lore.kernel.org/bpf/9d444098-7c03-4163-af12-bd0a79a51443@paulmck-laptop/
Assisted-by: LLM
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/backing-dev.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/backing-dev.c~writeback-report-a-tasks-rcu-quiescent-state-per-cgwb-drain-pass
+++ a/mm/backing-dev.c
@@ -910,8 +910,9 @@ static void cleanup_offline_cgwbs_workfn
 			continue;
 
 		spin_unlock_irq(&cgwb_lock);
-		while (cleanup_offline_cgwb(wb))
-			cond_resched();
+		do {
+			cond_resched_tasks_rcu_qs();
+		} while (cleanup_offline_cgwb(wb));
 		spin_lock_irq(&cgwb_lock);
 
 		wb_put(wb);
_

Patches currently in -mm which might be from josef@toxicpanda.com are


