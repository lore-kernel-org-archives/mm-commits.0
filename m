Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CA822F177
	for <mm-commits@vger.kernel.org>; Sun, 14 Dec 2025 23:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765756195; cv=none; b=EK4+0lwZJVTC7U07lI5VYDcYzXzdKT6290+aBKYPTlr9myV3xJ8tGPWy8JKrBHqQeZA/uVq1mAGwg94XbUQsfAxJpxCUfKrlcDJg0nFNjtT55duORJxK5yuX5SFiPyDjQrMjclYee0akfulp/vC1CikbMUgkAXjJXk4+XPhHMII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765756195; c=relaxed/simple;
	bh=r8yofMxqHmC1sZH8iKL6ar+il2B8XedY8835M0Ne+Ds=;
	h=Date:To:From:Subject:Message-Id; b=RjjbUpQumnToZBTauU3DEutIP2iMnnOytLq/LYBI323UoW81ojUel3+m2WIcLmX6pYsKIO54aUHISQIzrvhuvr8rTLSkmg//Av5in0UB3wqid0PxiJ7+jAo7GJUnEbFuixhCcRJbHbA4eRDKt7xpNZQUxy4fnO98dVkeDI9502E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vV63HxQu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vV63HxQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26706C4CEF1;
	Sun, 14 Dec 2025 23:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765756195;
	bh=r8yofMxqHmC1sZH8iKL6ar+il2B8XedY8835M0Ne+Ds=;
	h=Date:To:From:Subject:From;
	b=vV63HxQuFiTYoiQHiHMKWO9FDYu+luz9Fpfu5Gq+cNWb+LPgbzE7ofDKGRHlgwF+i
	 Hr+uV0OPbHnXACAPPoDJQ8T3o45/7dkG9N2if3YyZTM6cLRWOPnmFBtbUvexf3hRLF
	 3CMwvVxryH65I43ejd/AVYq+dbBQniCN8M501Uzs=
Date: Sun, 14 Dec 2025 15:49:54 -0800
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,kartikey406@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-always-allow-writeback-during-memcg-reclaim.patch added to mm-new branch
Message-Id: <20251214234955.26706C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: always allow writeback during memcg reclaim
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-always-allow-writeback-during-memcg-reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-always-allow-writeback-during-memcg-reclaim.patch

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
From: Deepanshu Kartikey <kartikey406@gmail.com>
Subject: mm: vmscan: always allow writeback during memcg reclaim
Date: Sat, 13 Dec 2025 14:06:39 +0530

When laptop_mode is enabled, may_writepage is set to 0 in
try_to_free_mem_cgroup_pages().  This triggers a warning in MGLRU's
lru_gen_shrink_lruvec():

    VM_WARN_ON_ONCE(!sc->may_writepage || !sc->may_unmap);

The warning occurs because MGLRU expects full reclaim capabilities to
function correctly.  The call path is:

    mem_cgroup_resize_max()
      try_to_free_mem_cgroup_pages()
        do_try_to_free_pages()
          shrink_node()
            shrink_lruvec()
              lru_gen_shrink_lruvec()  <-- WARNING

Unlike kswapd or direct reclaim where laptop_mode's disk-saving behavior
is a reasonable optimization, memcg limit enforcement is a hard
requirement - memory MUST be freed when a cgroup exceeds its limit.  The
may_unmap field is already set unconditionally to 1 in this path,
acknowledging that memcg reclaim needs full capabilities.

Set may_writepage unconditionally to 1 for memcg reclaim to ensure MGLRU
works correctly and memory limits are properly enforced.

Link: https://lkml.kernel.org/r/20251213083639.364539-1-kartikey406@gmail.com
Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reported-by: syzbot+90fcab4d88cffed6d0d8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=90fcab4d88cffed6d0d8
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-always-allow-writeback-during-memcg-reclaim
+++ a/mm/vmscan.c
@@ -6671,7 +6671,7 @@ unsigned long try_to_free_mem_cgroup_pag
 		.reclaim_idx = MAX_NR_ZONES - 1,
 		.target_mem_cgroup = memcg,
 		.priority = DEF_PRIORITY,
-		.may_writepage = !laptop_mode,
+		.may_writepage = 1,
 		.may_unmap = 1,
 		.may_swap = !!(reclaim_options & MEMCG_RECLAIM_MAY_SWAP),
 		.proactive = !!(reclaim_options & MEMCG_RECLAIM_PROACTIVE),
_

Patches currently in -mm which might be from kartikey406@gmail.com are

mm-vmscan-always-allow-writeback-during-memcg-reclaim.patch

