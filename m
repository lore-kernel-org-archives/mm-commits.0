Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A67194098
	for <mm-commits@vger.kernel.org>; Sun, 28 Dec 2025 22:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766960616; cv=none; b=tvrYztyggXjjFk2pmkGTYMv8Vltq5nVNQz9wZFM+RZ5bIa0Acmg25nhNFXl4y57ey19vcZHaP14qLO6z7rHWGfb7ZZryQGrLvgl/51iKChE2eoi7HsDP7ZgVgLzjFR9EP4E/k1EAf7Bn9sX6Nj4mojFJLyRgqO36aHh/3Pz73T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766960616; c=relaxed/simple;
	bh=8f3Q/zLk2cgZ9JA4GrX7/PkE1+WrimbMwAtyRQluI+k=;
	h=Date:To:From:Subject:Message-Id; b=l7OBb7jgy7MM80am4d6/zI5VopNthslvvz7rPu0VaRtmfnsDUkWSBA0IWjb45lg5YVRId2V4xsFUQg6oWkiY8oVLqIoP3ezbVAL9cQBj8yNyEYQIVPyT9n+oQ++NcEUu8HC2S3pdryvd/69RJxKy47ImzooInxPi0aohgTUwrng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kZKMiN8/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kZKMiN8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59A4C4CEFB;
	Sun, 28 Dec 2025 22:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766960615;
	bh=8f3Q/zLk2cgZ9JA4GrX7/PkE1+WrimbMwAtyRQluI+k=;
	h=Date:To:From:Subject:From;
	b=kZKMiN8/6GG8wrqU91tYJdi/aRwpWZhyuvV1ySPHzFAFsVSVAXrV/CufTymoR5RCE
	 YiHIlxLYZIyxgA1pN9eNwSFM3zs1ETJAzcQZPlPYj9ICsPCqN5MDdS8mDUsLQF11GB
	 EuNdH8CyyWGd62o8qDtmLgeDt5PZpe8FBqfbfuWM=
Date: Sun, 28 Dec 2025 14:23:35 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,tglx@linutronix.de,sweettea-kernel@dorminy.me,surenb@google.com,sj@kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,richard.weiyang@gmail.com,paulmck@kernel.org,mjguzik@gmail.com,mhocko@suse.com,mhiramat@kernel.org,lorenzo.stoakes@oracle.com,liumartin@google.com,linmiaohe@huawei.com,liam.howlett@oracle.com,hannes@cmpxchg.org,dennis@kernel.org,david@redhat.com,cl@linux.com,christian.koenig@amd.com,broonie@kernel.org,brauner@kernel.org,baolin.wang@linux.alibaba.com,aboorvad@linux.ibm.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tsacct-skip-all-kernel-threads.patch added to mm-new branch
Message-Id: <20251228222335.D59A4C4CEFB@smtp.kernel.org>
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
lib-introduce-hierarchical-per-cpu-counters.patch
mm-fix-oom-killer-inaccuracy-on-large-many-core-systems.patch
mm-implement-precise-oom-killer-task-selection.patch

