Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27B41A58D
	for <mm-commits@vger.kernel.org>; Sat, 10 Jan 2026 23:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768087830; cv=none; b=nj4JKcHKhpEmNraJ1tGXQvMYwFHqK5oE7fjDnlCA0F8BcNA3uoFVXAS5U2BtXrKA1Iv50Uh9KFWJo59ZzpW0+e6WcKSp07X0AmSYUHOAB/MtWbfETxGPEwDhrsGR8nnzlJmuQIQ+kVz5XaS/DX/tx3MnHMFZFgMIxHFhgXoEIJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768087830; c=relaxed/simple;
	bh=PF9l53kHNtiz4ZRhAlpDhPUW4aas7L9cJmFrwlf3p8U=;
	h=Date:To:From:Subject:Message-Id; b=c2i1SQQTqn9wWUo8Ewt31pO9GnbGUkfFG8CCWK/r/EQzhKaRbBJOPEy5yxhLmnPi2RJZcB2u9kcCmjENrHFzMO9EJWizNOfcUzpsz0i+n+nU0HY7LOJJMsI3BY55eneGa1wiaEkvaNaJtL5F+RyS6bl4g/t8zAUGWrRDeUJ3RPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X4iVusT7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X4iVusT7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C56FC116C6;
	Sat, 10 Jan 2026 23:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768087830;
	bh=PF9l53kHNtiz4ZRhAlpDhPUW4aas7L9cJmFrwlf3p8U=;
	h=Date:To:From:Subject:From;
	b=X4iVusT7FdPdK44yzZqsokNNSREocXE7JiI/kXMu4Ilu3ESVvcGehH9T/q8DWTBL/
	 kJ4V79bSsFtffbvk7iL9BmcmSmB3tNj/uFupQZMeSh0sjWWZtaMEe98KJZht7WWGMx
	 /Cv1aCJrplxbmCp2gsAat41EdgcnwSqQPTHeSJsE=
Date: Sat, 10 Jan 2026 15:30:29 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,kartikey406@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap_cgroup-fix-kernel-bug-in-swap_cgroup_record.patch added to mm-hotfixes-unstable branch
Message-Id: <20260110233030.5C56FC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap_cgroup: fix kernel BUG in swap_cgroup_record
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-swap_cgroup-fix-kernel-bug-in-swap_cgroup_record.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap_cgroup-fix-kernel-bug-in-swap_cgroup_record.patch

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
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reported-by: syzbot+d97580a8cceb9b03c13e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d97580a8cceb9b03c13e
Tested-by: syzbot+d97580a8cceb9b03c13e@syzkaller.appspotmail.com
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
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

mm-swap_cgroup-fix-kernel-bug-in-swap_cgroup_record.patch
ocfs2-validate-i_refcount_loc-when-refcount-flag-is-set.patch
ocfs2-validate-inline-data-i_size-during-inode-read.patch
ocfs2-add-check-for-free-bits-before-allocation-in-ocfs2_move_extent.patch

