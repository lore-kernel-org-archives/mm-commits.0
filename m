Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958841DB356;
	Sun, 28 Dec 2025 23:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766964022; cv=none; b=e/ptnxFtR8QnYmmIYcynQAGjn8vmKDtxQ+/8CoCplAVHM3608duM0Du0592iUOeSCHnjpbp/tfK3iYibL3cODBVSDftVMQq2fOWBLkh4+dmU2hnZ1r6qf94gXn9nH9j9rUzIotIs54vesL1H1Exl5jq6lv90xO6ATsTg/IK1WJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766964022; c=relaxed/simple;
	bh=AvCojGRS8lod2Q4pZ+INFu9/ShAWrIyQ6J+VG6tmnk0=;
	h=Date:To:From:Subject:Message-Id; b=AOQ4ef8sOqjSHOXYYxW8e5MZpa3dw1gGuMqLADqVMal4p43nw25mEpjnnMfLqjKWoa2L0Ty5zm/gFUY7M98akHLh1ZTkh66AnltU2xk1zZpcAm5bOjbKCQLcAsnYabUdtFnmVdqIHJTgHebiw+iY1w3TSYIt0P2T9JeYTAx0ato=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M2mh1HbW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M2mh1HbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2329C4CEFB;
	Sun, 28 Dec 2025 23:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766964022;
	bh=AvCojGRS8lod2Q4pZ+INFu9/ShAWrIyQ6J+VG6tmnk0=;
	h=Date:To:From:Subject:From;
	b=M2mh1HbWBbYGGrofnj2+WgPvtE48qY2igpReLM/Q9guRC/V4YPaGT8cn6+Zes7X+G
	 D15OkAWRO115u3XG/O9GyJLqHXfdo4RDmOC3mBYw1jzrUo4I3xZMuledW0YkBNZ9tD
	 fS3y+qsyQyhJsvq/XTH5OtmpCSvWIUs4idHrRMsg=
Date: Sun, 28 Dec 2025 15:20:21 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,tglx@linutronix.de,sweettea-kernel@dorminy.me,surenb@google.com,stable@vger.kernel.org,sj@kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,richard.weiyang@gmail.com,peterz@infradead.org,paulmck@kernel.org,mjguzik@gmail.com,mhocko@suse.com,mhiramat@kernel.org,lorenzo.stoakes@oracle.com,liumartin@google.com,linmiaohe@huawei.com,liam.howlett@oracle.com,hannes@cmpxchg.org,dennis@kernel.org,david@redhat.com,cl@linux.com,christian.koenig@amd.com,broonie@kernel.org,brauner@kernel.org,baolin.wang@linux.alibaba.com,aboorvad@linux.ibm.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-missing-static-initializer-for-init_mm-mm_cidlock.patch added to mm-hotfixes-unstable branch
Message-Id: <20251228232021.F2329C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add missing static initializer for init_mm::mm_cid.lock
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-add-missing-static-initializer-for-init_mm-mm_cidlock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-missing-static-initializer-for-init_mm-mm_cidlock.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm: add missing static initializer for init_mm::mm_cid.lock
Date: Wed, 24 Dec 2025 12:33:56 -0500

Initialize the mm_cid.lock struct member of init_mm.

Link: https://lkml.kernel.org/r/20251224173358.647691-2-mathieu.desnoyers@efficios.com
Fixes: 8cea569ca785 ("sched/mmcid: Use proper data structures")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
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
Cc: Mark Brown <broonie@kernel.org>
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
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/init-mm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/init-mm.c~mm-add-missing-static-initializer-for-init_mm-mm_cidlock
+++ a/mm/init-mm.c
@@ -44,6 +44,9 @@ struct mm_struct init_mm = {
 	.mm_lock_seq	= SEQCNT_ZERO(init_mm.mm_lock_seq),
 #endif
 	.user_ns	= &init_user_ns,
+#ifdef CONFIG_SCHED_MM_CID
+	.mm_cid.lock = __RAW_SPIN_LOCK_UNLOCKED(init_mm.mm_cid.lock),
+#endif
 	.cpu_bitmap	= CPU_BITS_NONE,
 	INIT_MM_CONTEXT(init_mm)
 };
_

Patches currently in -mm which might be from mathieu.desnoyers@efficios.com are

mm-add-missing-static-initializer-for-init_mm-mm_cidlock.patch
mm-rename-cpu_bitmap-field-to-flexible_array.patch
mm-take-into-account-mm_cid-size-for-mm_struct-static-definitions.patch
tsacct-skip-all-kernel-threads.patch
lib-introduce-hierarchical-per-cpu-counters.patch
mm-fix-oom-killer-inaccuracy-on-large-many-core-systems.patch
mm-implement-precise-oom-killer-task-selection.patch

