Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD30309EEC;
	Mon, 13 Jul 2026 23:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783983733; cv=none; b=uc46csup8Q9gXURlRC+g+rtq+IxOW9AJvWwAp1d/NS3goXALQ5G/N85M3O2HbNZYRCHCd2lB4uXpiXWnJXy+Y7tQPC1gLunDx1GHj7B7XOwAnwuZ5ZP/4iyKnJJ3UurnpeSUFlkOTyuoFXmf5yryKhf9UoLPI1RC9+7ayIPKaug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783983733; c=relaxed/simple;
	bh=Xwb4JUOFvErGMW5pK7HquCWrZTDek9wKddSCHRmb8BA=;
	h=Date:To:From:Subject:Message-Id; b=jnFE6/or0nMVQIEeHwJ68tUesyueddPJoIz3eoaOV0oiwaPK8rDIjn8FFyKPCIZtcu/Gwsrk5+kc38lwmb4r/1Jw84OfwAJwHtH1tobj+2MjXE3k7iWRjuiqkVynXtLqyLAOTw1Y5B3hd0tF2TAPQzykI81MswUU3pmLQcXA7Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KHXguKsA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KHXguKsA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031FC1F000E9;
	Mon, 13 Jul 2026 23:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783983732;
	bh=rp6xdnUpg579Gpc0SsT7O6Ssf2d36mK3EDG9HzUOYf8=;
	h=Date:To:From:Subject;
	b=KHXguKsALFT58oxDcJcIvN01J3jtBnIld7J/y36HFAwlQ8ogwNpqt5+GRogyvrhUz
	 7oAig6WbxS3rvEv6nJDtxGw9anbAqhTql8YwfJNPnM1TnExDgWA9jyAJCDzvloAvfD
	 n/yqBreIzDxeDbfLtQTQptzpmbFZa1mFJqEFGgtE=
Date: Mon, 13 Jul 2026 16:02:11 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,richard.weiyang@linux.alibaba.com,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,baoquan.he@linux.dev,caixiangfeng@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-list-corruption-in-allocate_file_region_entries.patch added to mm-hotfixes-unstable branch
Message-Id: <20260713230212.031FC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix list corruption in allocate_file_region_entries()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-fix-list-corruption-in-allocate_file_region_entries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-list-corruption-in-allocate_file_region_entries.patch

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
From: "Xiangfeng Cai" <caixiangfeng@bytedance.com>
Subject: mm/hugetlb: fix list corruption in allocate_file_region_entries()
Date: Tue, 14 Jul 2026 01:14:55 +0800

allocate_file_region_entries() tops up resv->region_cache with freshly
allocated file_region descriptors.  The allocation uses GFP_KERNEL, so
resv->lock is dropped around it: the new entries are gathered on a
stack-local list head, allocated_regions, and spliced into
resv->region_cache once the lock is re-acquired.

The splice used list_splice(), which moves the entries but does not
re-initialize the source head, so allocated_regions is left pointing at an
entry that now lives on resv->region_cache.  The top-up runs in a while
loop that re-checks the cache deficit after re-acquiring the lock.  For a
shared mapping the resv_map is shared by every mapper of the hugetlbfs
inode, so a concurrent region_chg()/region_add()/region_del() on the same
resv_map can consume cache entries during the unlocked window and force a
second iteration.  That iteration calls list_add() on the stale head and
corrupts the list; with CONFIG_DEBUG_LIST the __list_add_valid() check
trips:

  list_add corruption. next->prev should be prev (ffffc900011ff7f8),
  but was ffff88814c281460. (next=ffff88814c545640).
  kernel BUG at lib/list_debug.c:31!
   allocate_file_region_entries+0x191/0x420
   region_chg+0x267/0x300
   hugetlb_reserve_pages+0x387/0xc80
   hugetlbfs_file_mmap+0x2ce/0x3f0
   mmap_region+0x1348/0x1a80
   do_mmap+0x85e/0xb90
   vm_mmap_pgoff+0x18c/0x330
   ksys_mmap_pgoff+0x2a1/0x3e0
   do_syscall_64+0xd7/0x420

Without CONFIG_DEBUG_LIST the bad list_add() silently links a kernel-stack
address into resv->region_cache, leading to later use-after-free.

Use list_splice_init() so the source head is re-initialized empty after
each splice, making the retry loop safe.

Link: https://lore.kernel.org/20260713171456.300518-2-caixiangfeng@bytedance.com
Fixes: d3ec7b6e09e5 ("mm/hugetlb: use list_splice to merge two list at once")
Signed-off-by: Xiangfeng Cai <caixiangfeng@bytedance.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-list-corruption-in-allocate_file_region_entries
+++ a/mm/hugetlb.c
@@ -693,7 +693,7 @@ static int allocate_file_region_entries(
 
 		spin_lock(&resv->lock);
 
-		list_splice(&allocated_regions, &resv->region_cache);
+		list_splice_init(&allocated_regions, &resv->region_cache);
 		resv->region_cache_count += to_allocate;
 	}
 
_

Patches currently in -mm which might be from caixiangfeng@bytedance.com are

mm-hugetlb-fix-list-corruption-in-allocate_file_region_entries.patch

