Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C014029D292
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489907; cv=none; b=IbpBnBQzgsig1e7r6iokW3+OwQJGdfeSFZWWiqgNZsZpqz/bt2IkVBKy5FRAsHl5oQcR8Etg7UirBUIKLlEzwlNHfDMmpWH2KI9uzMIiCAkEBOiq271KrbqPnIZ7qB0wz/9T/CV61ZfXkk1E/bDe3yjIPsXUQgKE/oD6I6jZhSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489907; c=relaxed/simple;
	bh=+EGWy1g/bd45BWHlYtr0VzeKeSFSYkvwR9+8RqD6T3o=;
	h=Date:To:From:Subject:Message-Id; b=uZbc21LAqCDg3UaMLFglUYh4uVeH1+8HSgmgVTBGw8Frxxf0jXRNql57oWJpxwb3WFJQ0rIOXqSt5QZE7Cw2jwnc74h93Lp0qu720z6p1qwjPsdyFytOM8YRhfU9TekZuTuZJ1tySBpMEGhqfc8vWx0BHadxuJkT1HURLZ+1jFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OoBsdd5C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OoBsdd5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95ADCC4CEE7;
	Sun, 21 Sep 2025 21:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489907;
	bh=+EGWy1g/bd45BWHlYtr0VzeKeSFSYkvwR9+8RqD6T3o=;
	h=Date:To:From:Subject:From;
	b=OoBsdd5C/m0QdKUXWJp9LRiLnr1INAwx2cfc2kwiwDWtaPGpWDFHbLQxlYWXlMYUd
	 ng16+OrEag1V6kGSjA4BkjsRuPuxHPWcCA/I7Lg6PILPHSOMgzjaHE2parur54qvrj
	 iur24pF/ulFOEMWUk/1yGXUOyYaGdR8XEK3x7JNA=
Date: Sun, 21 Sep 2025 14:25:07 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vishal.moola@gmail.com,vbabka@suse.cz,usamaarif642@gmail.com,surenb@google.com,shakeel.butt@linux.dev,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,pyyjason@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-show_mem-dump-the-status-of-the-mem-alloc-profiling-before-printing.patch removed from -mm tree
Message-Id: <20250921212507.95ADCC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/show_mem: dump the status of the mem alloc profiling before printing
has been removed from the -mm tree.  Its filename was
     mm-show_mem-dump-the-status-of-the-mem-alloc-profiling-before-printing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yueyang Pan <pyyjason@gmail.com>
Subject: mm/show_mem: dump the status of the mem alloc profiling before printing
Date: Wed, 3 Sep 2025 04:16:13 -0700

This patchset fixes two issues we saw in production rollout.  

The first issue is that we saw all zero output of memory allocation
profiling information from show_mem() if CONFIG_MEM_ALLOC_PROFILING is set
and sysctl.vm.mem_profiling=0.  This cause ambiguity as we don't know what
0B actually means in the output.  It can mean either memory allocation
profiling is temporary disabled or the allocation at that position is
actually 0.  Such ambiguity will make further parsing harder as we cannot
differentiate between two case.

The second issue is that multiple entities can call show_mem() which
messed up the allocation info in dmesg.  We saw outputs like this: 

    327 MiB    83635 mm/compaction.c:1880 func:compaction_alloc
   48.4 GiB 12684937 mm/memory.c:1061 func:folio_prealloc
   7.48 GiB    10899 mm/huge_memory.c:1159 func:vma_alloc_anon_folio_pmd
    298 MiB    95216 kernel/fork.c:318 func:alloc_thread_stack_node
    250 MiB    63901 mm/zsmalloc.c:987 func:alloc_zspage
    1.42 GiB   372527 mm/memory.c:1063 func:folio_prealloc
    1.17 GiB    95693 mm/slub.c:2424 func:alloc_slab_page
     651 MiB   166732 mm/readahead.c:270 func:page_cache_ra_unbounded
     419 MiB   107261 net/core/page_pool.c:572 func:__page_pool_alloc_pages_slow
     404 MiB   103425 arch/x86/mm/pgtable.c:25 func:pte_alloc_one

The above example is because one kthread invokes show_mem() from
__alloc_pages_slowpath while kernel itself calls oom_kill_process()


This patch (of 2):

This patch prints the status of the memory allocation profiling before
__show_mem actually prints the detailed allocation info.  This way will
let us know the `0B` we saw in allocation info is because the profiling is
disabled or the allocation is actually 0B.

Link: https://lkml.kernel.org/r/cover.1756897825.git.pyyjason@gmail.com
Link: https://lkml.kernel.org/r/d7998ea0ddc2ea1a78bb6e89adf530526f76679a.1756897825.git.pyyjason@gmail.com
Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
Acked-by: Usama Arif <usamaarif642@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/show_mem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/show_mem.c~mm-show_mem-dump-the-status-of-the-mem-alloc-profiling-before-printing
+++ a/mm/show_mem.c
@@ -431,7 +431,8 @@ void __show_mem(unsigned int filter, nod
 
 		nr = alloc_tag_top_users(tags, ARRAY_SIZE(tags), false);
 		if (nr) {
-			pr_notice("Memory allocations:\n");
+			pr_notice("Memory allocations (profiling is currently turned %s):\n",
+				mem_alloc_profiling_enabled() ? "on" : "off");
 			for (i = 0; i < nr; i++) {
 				struct codetag *ct = tags[i].ct;
 				struct alloc_tag *tag = ct_to_alloc_tag(ct);
_

Patches currently in -mm which might be from pyyjason@gmail.com are


