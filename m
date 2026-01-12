Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6244C23C506
	for <mm-commits@vger.kernel.org>; Mon, 12 Jan 2026 20:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768250999; cv=none; b=kC57tp67XUFnLCNxaMytGceycwSWpVS72KE4Dq1LjXCqHSiAjyBPaHkZ5hfVi5aUGrDj7CFoqwAV1zaK1cNPkgvtyTEXkzCv39ixd7TAlApgj7Pk4P3xlqG0FeRTWoRWDktIji6+mjv6vN3k1Tsj6c20L++dQhEYSZOxOYQIbhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768250999; c=relaxed/simple;
	bh=HDBtSdGnuB57xRqreyslYQ7UTG9vv/gRxpDJIZqazBo=;
	h=Date:To:From:Subject:Message-Id; b=kJ4qEErl5b8zl5pfp+B7ME+frKZG1HOM+REolXKgVydzR5573jd7MixJ2wM7kr8ijQV1Ab7zrWPxVy0qcxkrQWGsWJ7qyAhTK/PddAq5nnbRygmJWPKDcMQN33te5Ywr89gbXjQpdT9pawYk9iv7NUKhUJiGZwnb/EC9bzb8YqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iH10q0lH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iH10q0lH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8DEC19424;
	Mon, 12 Jan 2026 20:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768250998;
	bh=HDBtSdGnuB57xRqreyslYQ7UTG9vv/gRxpDJIZqazBo=;
	h=Date:To:From:Subject:From;
	b=iH10q0lHhu4Pw0vWuF17bgCmZ0Lq5e85fWKcBGF1G9x0tNA5k8PFP7KEfb4CD6sxp
	 LNx62Y9L8stXjF+HOTcuz2xjaSzIL+RHB3vTXKRashxUKT4OiRRmR9WktKoBeLs5AE
	 ZyxSAslEMngxK5ScMPnsJ+N7fy9Z3uUy5rDI+6r4=
Date: Mon, 12 Jan 2026 12:49:58 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,tglx@linutronix.de,sweettea-kernel@dorminy.me,surenb@google.com,sj@kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,richard.weiyang@gmail.com,paulmck@kernel.org,mjguzik@gmail.com,mhocko@suse.com,mhiramat@kernel.org,lorenzo.stoakes@oracle.com,liumartin@google.com,linmiaohe@huawei.com,liam.howlett@oracle.com,hannes@cmpxchg.org,dennis@kernel.org,david@redhat.com,cl@linux.com,christian.koenig@amd.com,broonie@kernel.org,brauner@kernel.org,baolin.wang@linux.alibaba.com,aboorvad@linux.ibm.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tsacct-skip-all-kernel-threads.patch added to mm-new branch
Message-Id: <20260112204958.CC8DEC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tsacct: skip all kernel threads
has been added to the -mm mm-new branch.  Its filename is
     tsacct-skip-all-kernel-threads.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tsacct-skip-all-kernel-threads.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: tsacct: skip all kernel threads
Date: Wed, 24 Dec 2025 12:38:10 -0500

This patch is a preparation step for HPCC, for the OOM killer
improvements.  I suspect that this patch is useful on its own, because it
really makes no sense to sum up accounting statistics of use_mm within
kernel threads which are only temporarily using those mm.

When we hit acct_account_cputime within a irq handler over a kthread that
happens to use a userspace mm, we end up summing up the mm's RSS into the
tsk acct_rss_mem1, which eventually decays.

I don't see a good rationale behind tracking the mm's rss in that way when
a kthread use a userspace mm temporarily through use_mm.

It causes issues with init_mm and efi_mm which only partially initialize
their mm_struct when introducing the new hierarchical percpu counters to
replace RSS counters, which requires a pointer dereference when reading
the approximate counter sum.  The current percpu counters simply load a
zeroed atomic counter, which happen to work.

Skip all kernel threads in acct_account_cputime(), not just those that
happen to have a NULL mm.

This is a preparation step before introducing the hierarchical percpu
counters.

Link: https://lkml.kernel.org/r/20251224173810.648699-2-mathieu.desnoyers@efficios.com
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Christan König <christian.koenig@amd.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Liam R . Howlett" <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Martin Liu <liumartin@google.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/tsacct.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/tsacct.c~tsacct-skip-all-kernel-threads
+++ a/kernel/tsacct.c
@@ -125,7 +125,7 @@ static void __acct_update_integrals(stru
 {
 	u64 time, delta;
 
-	if (!likely(tsk->mm))
+	if (unlikely(!tsk->mm || (tsk->flags & PF_KTHREAD)))
 		return;
 
 	time = stime + utime;
_

Patches currently in -mm which might be from mathieu.desnoyers@efficios.com are

mm-add-missing-static-initializer-for-init_mm-mm_cidlock.patch
mm-rename-cpu_bitmap-field-to-flexible_array.patch
mm-take-into-account-mm_cid-size-for-mm_struct-static-definitions.patch
tsacct-skip-all-kernel-threads.patch

