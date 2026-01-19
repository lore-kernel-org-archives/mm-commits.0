Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF15275B05;
	Mon, 19 Jan 2026 20:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768854641; cv=none; b=GH1r/I9Q6bJkGOXK5lfqMSu88AEvQYdGMfep+ItrsV6DRBgBTmRmKl9mt84u2fLtyZ17AaLPdq1MkUznUV7mM7NsDBBTxTm7lN9uFz2gaHX9+VpRjFs+3jf/AQxtAGF6tfzE2uPNFSh1uDW4aDmvR9uZG5kNam4nRc8WD9ShpY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768854641; c=relaxed/simple;
	bh=HFEHCiRDel003sUznNZA/cm9bXQgeWOcSJWPoEYFNAM=;
	h=Date:To:From:Subject:Message-Id; b=idzJElFCJ79Va5dlA71keUXlLUxOgv8ur2gFE9y91o61DUpb239CFQmL41WDMdD4KHIwsHToW1O0S6vlr0plyeWoKJ6h/BWOV4Ti20UlOZgKyQZ2ZyujN2UPrhFRBI5/RGULiksM6NEvFptS/d6T0N7QuOp5D67pMv9l7Rfk4D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HXYWR4Ad; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HXYWR4Ad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43672C116C6;
	Mon, 19 Jan 2026 20:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768854641;
	bh=HFEHCiRDel003sUznNZA/cm9bXQgeWOcSJWPoEYFNAM=;
	h=Date:To:From:Subject:From;
	b=HXYWR4AdFtRPP1C2n8LX5reuTx4+hdD/4l6b6w85ZU8UkMo0m2zkb6Iamky7Qa8GA
	 zyGkfHYgmZEVahoI9uqMAPxCmzO8n0B05co789I64tqGqGbjxWmrkQg3vDgOuSjnR6
	 zrqUmC3xWngsN4aotMgjO8uqqmb8lVP12Txs3mI4=
Date: Mon, 19 Jan 2026 12:30:40 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,tglx@kernel.org,sweettea-kernel@dorminy.me,surenb@google.com,stable@vger.kernel.org,sj@kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,richard.weiyang@gmail.com,peterz@infradead.org,paulmck@kernel.org,mjguzik@gmail.com,mhocko@suse.com,mhiramat@kernel.org,lorenzo.stoakes@oracle.com,liumartin@google.com,linmiaohe@huawei.com,liam.howlett@oracle.com,hannes@cmpxchg.org,dennis@kernel.org,david@redhat.com,cl@linux.com,christian.koenig@amd.com,broonie@kernel.org,brauner@kernel.org,baolin.wang@linux.alibaba.com,aboorvad@linux.ibm.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-add-missing-static-initializer-for-init_mm-mm_cidlock.patch removed from -mm tree
Message-Id: <20260119203041.43672C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add missing static initializer for init_mm::mm_cid.lock
has been removed from the -mm tree.  Its filename was
     mm-add-missing-static-initializer-for-init_mm-mm_cidlock.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: mm: add missing static initializer for init_mm::mm_cid.lock
Date: Wed, 24 Dec 2025 12:33:56 -0500

Initialize the mm_cid.lock struct member of init_mm.

Link: https://lkml.kernel.org/r/20251224173358.647691-2-mathieu.desnoyers@efficios.com
Fixes: 8cea569ca785 ("sched/mmcid: Use proper data structures")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Thomas Gleixner <tglx@kernel.org>
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

tsacct-skip-all-kernel-threads.patch
mm-fix-oom-killer-inaccuracy-on-large-many-core-systems.patch

