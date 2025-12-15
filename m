Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70EC2857EE
	for <mm-commits@vger.kernel.org>; Mon, 15 Dec 2025 20:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765831175; cv=none; b=S38+wcp3gLZByjEwXuhJltjKsJSxkV6rqXE42cIoT85cRYbTntb6c3o4i1nk1jAM0BqcH9MmeC7x09QmX23JbF1Mlb6S9NE6tZzM0h+9ccSzde0HbeFzl6KlVLGoz69xGHIscTPjQAUC9qlsn5W6BKn3qaTdZkGSb2foTNSEux4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765831175; c=relaxed/simple;
	bh=pbjSRYnnT/4sUJu+F1E+RGgqrLR3Z5vWealG+JCmVHA=;
	h=Date:To:From:Subject:Message-Id; b=Hf95c4tfjKhiE0KX5tSXr5SUWiHhqToIoQbj+MyAF2yxc8BPAbPf5Gto2R9bGBriyx+C8nSd/nTng6+ni/cnv2I2GDwjgQ6Pb6N5jO197BxKa4IbbGC/peC3s4BsjR7YQbznyet/uTq86J8x/7HG/uZ4sW1Z60eutXDwui99lVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gwnTzkFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gwnTzkFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C229C4CEF5;
	Mon, 15 Dec 2025 20:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765831175;
	bh=pbjSRYnnT/4sUJu+F1E+RGgqrLR3Z5vWealG+JCmVHA=;
	h=Date:To:From:Subject:From;
	b=gwnTzkFecV4j9z0xK5uglPWBO+3xsmTvEC3l0VUopUFM5Ng3wB6slrPZN+h7XigIc
	 TdWh6nNrP5RNCMYI4hHO3Ai2el3ODLfrxHLhGWEXeK9GtpLP3MAVbfgwd449U/gSFU
	 X81znd7uWyUKfCyAo1T/HFf0ZwQ9ccosC7RLAgLg=
Date: Mon, 15 Dec 2025 12:39:34 -0800
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,kartikey406@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-vmscan-always-allow-writeback-during-memcg-reclaim.patch removed from -mm tree
Message-Id: <20251215203935.1C229C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmscan: always allow writeback during memcg reclaim
has been removed from the -mm tree.  Its filename was
     mm-vmscan-always-allow-writeback-during-memcg-reclaim.patch

This patch was dropped because it was nacked

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

ocfs2-validate-i_refcount_loc-when-refcount-flag-is-set.patch
ocfs2-validate-inline-data-i_size-during-inode-read.patch

