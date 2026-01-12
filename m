Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91DB17BB21
	for <mm-commits@vger.kernel.org>; Mon, 12 Jan 2026 19:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768247732; cv=none; b=jgqmtEHOBMvpFvd70DSyY8s4HeJ8pvk+3lTzNPZYOZg8Fwj1I9aiq6zzvt6Sxl9PcIoAB9uZPiBZWdvNO3913EDozEaYn02aaX4hh0L2FeyHuH7YAsmZMXk59xGGpA3wanVihyZb5ZI89nzC2LOVmzSDSAtESQlZYpwFGuQddGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768247732; c=relaxed/simple;
	bh=/TXbfxTvLW+nvd/6+TXYM5ri7Ywa1siJVPdTEwpZmW0=;
	h=Date:To:From:Subject:Message-Id; b=Km2E7ZFGYqrXKGFuomVVTO5q6mM8fCfbNEr9+h7XAbektxGXobsvbNNU9XHunueu2lpCWyasZa2TjlCg4vxKHllJmgYsDWbNx+KVww7809v2Iuk9Yi3sQH5euCcBJnbjrb5LcOb3U4uUVVUjcoRbVxnqZReqBbbw2IFoqJYLMNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1606N2Gm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1606N2Gm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FA8C116D0;
	Mon, 12 Jan 2026 19:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768247732;
	bh=/TXbfxTvLW+nvd/6+TXYM5ri7Ywa1siJVPdTEwpZmW0=;
	h=Date:To:From:Subject:From;
	b=1606N2Gm52fpF/ADzMQ33+f6C+uiDCr1W46o5TpComx7g865wbvpcNAAKrgE1foGw
	 JCoWeDhIeb30p5BCpC2USSh56M73JGWwV/qYiL3LHFK+mm2+g5F/sSly34UPJHK1qe
	 FeSScn4I2/wf49/nn6ddaZgRS1LUXVzW1ydwYNfM=
Date: Mon, 12 Jan 2026 11:55:31 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,tglx@linutronix.de,sweettea-kernel@dorminy.me,surenb@google.com,sj@kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,richard.weiyang@gmail.com,paulmck@kernel.org,mjguzik@gmail.com,mhocko@suse.com,mhiramat@kernel.org,lorenzo.stoakes@oracle.com,liumartin@google.com,linmiaohe@huawei.com,liam.howlett@oracle.com,hannes@cmpxchg.org,dennis@kernel.org,david@redhat.com,cl@linux.com,christian.koenig@amd.com,broonie@kernel.org,brauner@kernel.org,baolin.wang@linux.alibaba.com,aboorvad@linux.ibm.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] tsacct-skip-all-kernel-threads.patch removed from -mm tree
Message-Id: <20260112195532.54FA8C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tsacct: skip all kernel threads
has been removed from the -mm tree.  Its filename was
     tsacct-skip-all-kernel-threads.patch

This patch was dropped because an updated version will be issued

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
lib-introduce-hierarchical-per-cpu-counters.patch
mm-fix-oom-killer-inaccuracy-on-large-many-core-systems.patch
mm-implement-precise-oom-killer-task-selection.patch

