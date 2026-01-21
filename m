Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3948A266565
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 16:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769013364; cv=none; b=OqJJ0GG/cMGNkEAjCMiVck5fL/7gqTwBRlg4uzNWCfFQivyvNsEeiKJVjJ9oWzC6VosmFe/Osj8Vl3VLXewmmxWqTgW1kzz5Hrwy2z8HORvpHsNFAuZwAiUYh5HlUqVcufVdLelgJpse2VzEbxlCV55mafma7gsFIgaP1ZSC/hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769013364; c=relaxed/simple;
	bh=koGO2IFGmxttZH08g2Uyc1fr+xW5IVUfc0hDWJR60jg=;
	h=Date:To:From:Subject:Message-Id; b=AKFwE4AxFQ6lboDf3/DUpMZQvH14YpDjH9TmHoA5wyUREaHOU5+kxyeddbx9EMj+27OTUOH8Cnn3DV4L88K0n6P6DmbQ+KTeGcg+3DHR9ocYNd5JX4dSJGlPxF+eqo+Ud1hc6asw/NkWhQgUnseXLv2OMO0f8sCeyFsPCAbeDmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jl2m4sUz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jl2m4sUz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0CFCC116D0;
	Wed, 21 Jan 2026 16:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769013363;
	bh=koGO2IFGmxttZH08g2Uyc1fr+xW5IVUfc0hDWJR60jg=;
	h=Date:To:From:Subject:From;
	b=Jl2m4sUz5pOw7/s650ulY+Sqg1CWV721iLk0IxSYpNRadBGzikQAOcspmMWJFS213
	 PlwioliynMMQH7/nW0HDsZfV6em6m5efP9SRc8poffsdFwDS3CfSquo3MwTnG+cQlx
	 UpoNQlz1ZoSMXEAvQx0fJYwFc1Ia925xzclbNqQo=
Date: Wed, 21 Jan 2026 08:36:03 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,ryncsn@gmail.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,kartikey406@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] mm-swap_cgroup-fix-kernel-bug-in-swap_cgroup_record.patch removed from -mm tree
Message-Id: <20260121163603.C0CFCC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap_cgroup: fix kernel BUG in swap_cgroup_record
has been removed from the -mm tree.  Its filename was
     mm-swap_cgroup-fix-kernel-bug-in-swap_cgroup_record.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Deepanshu Kartikey <kartikey406@gmail.com>
Subject: mm/swap_cgroup: fix kernel BUG in swap_cgroup_record
Date: Sat, 10 Jan 2026 12:16:13 +0530

When using MADV_PAGEOUT, pages can remain in swapcache with their swap
entries assigned.  If MADV_PAGEOUT is called again on these pages, they
reuse the same swap entries, causing memcg1_swapout() to call
swap_cgroup_record() with an already-recorded entry.

The existing code assumes swap entries are always being recorded for the
first time (oldid == 0), triggering VM_BUG_ON when it encounters an
already-recorded entry:

  ------------[ cut here ]------------
  kernel BUG at mm/swap_cgroup.c:78!
  Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
  CPU: 0 UID: 0 PID: 6176 Comm: syz.0.30 Not tainted
  RIP: 0010:swap_cgroup_record+0x19c/0x1c0 mm/swap_cgroup.c:78
  Call Trace:
   memcg1_swapout+0x2fa/0x830 mm/memcontrol-v1.c:623
   __remove_mapping+0xac5/0xe30 mm/vmscan.c:773
   shrink_folio_list+0x2786/0x4f40 mm/vmscan.c:1528
   reclaim_folio_list+0xeb/0x4e0 mm/vmscan.c:2208
   reclaim_pages+0x454/0x520 mm/vmscan.c:2245
   madvise_cold_or_pageout_pte_range+0x19a0/0x1ce0 mm/madvise.c:563
   ...
   do_madvise+0x1bc/0x270 mm/madvise.c:2030
   __do_sys_madvise mm/madvise.c:2039

This bug occurs because pages in swapcache can be targeted by MADV_PAGEOUT
multiple times without being swapped in between.  Each time, the same swap
entry is reused, but swap_cgroup_record() expects to only record new,
unused entries.

Fix this by checking if the swap entry already has the correct cgroup ID
recorded before attempting to record it.  Use the existing
lookup_swap_cgroup_id() to read the current cgroup ID, and return early
from memcg1_swapout() if the entry is already correctly recorded.  Only
call swap_cgroup_record() when the entry needs to be set or updated.

This approach avoids unnecessary atomic operations, reference count
manipulations, and statistics updates when the entry is already correct.

Link: https://syzkaller.appspot.com/bug?extid=d97580a8cceb9b03c13e
Link: https://lkml.kernel.org/r/20260110064613.606532-1-kartikey406@gmail.com
Fixes: 1a4e58cce84e ("mm: introduce MADV_PAGEOUT")
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reported-by: syzbot+d97580a8cceb9b03c13e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d97580a8cceb9b03c13e
Tested-by: syzbot+d97580a8cceb9b03c13e@syzkaller.appspotmail.com
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/memcontrol-v1.c~mm-swap_cgroup-fix-kernel-bug-in-swap_cgroup_record
+++ a/mm/memcontrol-v1.c
@@ -592,6 +592,7 @@ void memcg1_swapout(struct folio *folio,
 {
 	struct mem_cgroup *memcg, *swap_memcg;
 	unsigned int nr_entries;
+	unsigned short oldid;
 
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
@@ -609,6 +610,16 @@ void memcg1_swapout(struct folio *folio,
 		return;
 
 	/*
+	 * Check if this swap entry is already recorded. This can happen
+	 * when MADV_PAGEOUT is called multiple times on pages that remain
+	 * in swapcache, reusing the same swap entries.
+	 */
+	oldid = lookup_swap_cgroup_id(entry);
+	if (oldid == mem_cgroup_id(memcg))
+		return;
+	VM_WARN_ON_ONCE(oldid != 0);
+
+	/*
 	 * In case the memcg owning these pages has been offlined and doesn't
 	 * have an ID allocated to it anymore, charge the closest online
 	 * ancestor for the swap instead and transfer the memory+swap charge.
_

Patches currently in -mm which might be from kartikey406@gmail.com are

mm-vmalloc-prevent-rcu-stalls-in-kasan_release_vmalloc_node.patch

