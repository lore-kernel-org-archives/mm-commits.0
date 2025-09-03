Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50333287518
	for <mm-commits@vger.kernel.org>; Wed,  3 Sep 2025 21:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756935519; cv=none; b=jRLv/eAYZkCq/gTmsacAOFXf06fOVPXbB19l0yqjF9eI7IB8HeJf4qzyOVd5rE/yMDNtOOEDzFnguAgOQpLQriWk/3uAhVEwrhVJ8Mwe4g7pcJv+LKuce2VSxkPQ4xTFj79M0g8P/oIH/Ip9qAPH1XJ6kMX3xz8zbVMhmW9aMjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756935519; c=relaxed/simple;
	bh=6kkzdZj3l0LXAIM4tncXjquBwlItbMpYDPlmVIUKH7g=;
	h=Date:To:From:Subject:Message-Id; b=Kv+Pf6W63R16keokvbCUhNlCbTinWGdkKB4YyLC/GSEZmCzwuquuOVI7jV0ANrMb8SJoKcBVc6R2/CbGxAhSa+X/31L/xycWAL3BkxiMPwVyK8kX+27SOfyBI9vCSIUjXbxL+ah+7RJqgNQURK4cR4hYNXTJawL0EegJ/KdwWig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iqGumZKM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iqGumZKM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADDABC4CEE7;
	Wed,  3 Sep 2025 21:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756935518;
	bh=6kkzdZj3l0LXAIM4tncXjquBwlItbMpYDPlmVIUKH7g=;
	h=Date:To:From:Subject:From;
	b=iqGumZKM7Rvq6s8OnqLvEp+raeZ6S7l1pfdNck8W8um+J2HqTvqL7J0ScHKH4wBso
	 DNZCTen742NfOKNcxc/LYnEuaICFpfbx8F7tijbsA3unkWkY+RPCLfcT3+eoJ3IJgR
	 sic9GcSwAlEPSPf21agGjJ+Q1+ePmJKELN/2AB6U=
Date: Wed, 03 Sep 2025 14:38:38 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vishal.moola@gmail.com,vbabka@suse.cz,usamaarif642@gmail.com,surenb@google.com,shakeel.butt@linux.dev,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,pyyjason@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-show_mem-add-trylock-while-printing-alloc-info.patch added to mm-new branch
Message-Id: <20250903213838.ADDABC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/show_mem: add trylock while printing alloc info
has been added to the -mm mm-new branch.  Its filename is
     mm-show_mem-add-trylock-while-printing-alloc-info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-show_mem-add-trylock-while-printing-alloc-info.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Yueyang Pan <pyyjason@gmail.com>
Subject: mm/show_mem: add trylock while printing alloc info
Date: Wed, 3 Sep 2025 04:16:14 -0700

In production, show_mem() can be called concurrently from two different
entities, for example one from oom_kill_process() another from
__alloc_pages_slowpath from another kthread.  This patch adds a spinlock
and invokes trylock before printing out the kernel alloc info in
show_mem().  This way two alloc info won't interleave with each other,
which then makes parsing easier.

Link: https://lkml.kernel.org/r/4ed91296e0c595d945a38458f7a8d9611b0c1e52.1756897825.git.pyyjason@gmail.com
Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
Acked-by: Usama Arif <usamaarif642@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/show_mem.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/show_mem.c~mm-show_mem-add-trylock-while-printing-alloc-info
+++ a/mm/show_mem.c
@@ -425,7 +425,9 @@ void __show_mem(unsigned int filter, nod
 	printk("%lu pages hwpoisoned\n", atomic_long_read(&num_poisoned_pages));
 #endif
 #ifdef CONFIG_MEM_ALLOC_PROFILING
-	{
+	static DEFINE_SPINLOCK(mem_alloc_profiling_spinlock);
+
+	if (spin_trylock(&mem_alloc_profiling_spinlock)) {
 		struct codetag_bytes tags[10];
 		size_t i, nr;
 
@@ -452,6 +454,7 @@ void __show_mem(unsigned int filter, nod
 						  ct->lineno, ct->function);
 			}
 		}
+		spin_unlock(&mem_alloc_profiling_spinlock);
 	}
 #endif
 }
_

Patches currently in -mm which might be from pyyjason@gmail.com are

mm-damon-paddr-move-filters-existence-check-function-to-ops-common.patch
mm-damon-vaddr-support-stat-purpose-damos-filters.patch
mm-show_mem-dump-the-status-of-the-mem-alloc-profiling-before-printing.patch
mm-show_mem-add-trylock-while-printing-alloc-info.patch

