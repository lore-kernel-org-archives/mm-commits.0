Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB533EB0E9;
	Tue, 21 Jul 2026 00:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784594625; cv=none; b=W7cc/9A1eYO5jt84I2lP0+b7zu1LPGZw/E8P2GALze+Z5FZ0yvdQ006zR86aDh/Q7xHktdYOJlI4aps8uiyF3S/Bw0cSAcDMD+s2o7IAGInNzCkz+/fm6xcudC6l73N8F3DHbM2RImkMKqJ4YrsZNbp38ffwTUHDI+R4fx8uGwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784594625; c=relaxed/simple;
	bh=3CG6LTyxiuk02JBTI0Cyxvj6+KtiFnbSIMly2me38IQ=;
	h=Date:To:From:Subject:Message-Id; b=A2yWL29AcxtzyUSz/4WQWWyY0PUkK0kAeVQ75Ht4fF3YFNFLaoEBOkK4v37YhX603FkdQ2rC0ZwT2uOYn3omQ0L9+bWeqjbQ5pc1MtxvYjFN0eJH0X2MfRY3KWdFzli01NZioRVsTDqlhtSXeS2P6QGl4YZad63BA7ao/m9TCwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xmvuz5G9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xmvuz5G9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0307A1F00A3A;
	Tue, 21 Jul 2026 00:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784594624;
	bh=75xrHzzzlNXKrmvoGmLpwPF23IcipF1VL70EqoBSWF8=;
	h=Date:To:From:Subject;
	b=Xmvuz5G96A44UEEZFIHV+f1nX7NiQXhdseGgEeDKhqSoQW6TmS+9BybUpoqQW79ch
	 nf57v6FtUKgdBxisSbZmX0zE5cWlQWm0DJAO+GlR2Ozo8yG51uxe7hMd4ixI1QVogd
	 dyGUgd9FsO3SOURkBmIge9no2GuiI0O9Ehcfe/Jo=
Date: Mon, 20 Jul 2026 17:43:43 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,richard.weiyang@linux.alibaba.com,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,baoquan.he@linux.dev,caixiangfeng@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-fix-list-corruption-in-allocate_file_region_entries.patch removed from -mm tree
Message-Id: <20260721004344.0307A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: fix list corruption in allocate_file_region_entries()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-list-corruption-in-allocate_file_region_entries.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

This was observed as a real host panic on a dense KVM host where a QEMU
guest-RAM hugetlbfs file was mapped MAP_SHARED by both QEMU and a separate
SPDK/DPDK vhost-user target, generating concurrent region_* traffic on one
shared resv_map.

Use list_splice_init() so the source head is re-initialized empty after
each splice, making the retry loop safe.

Link: https://lore.kernel.org/20260713171456.300518-2-caixiangfeng@bytedance.com
Fixes: d3ec7b6e09e5 ("mm/hugetlb: use list_splice to merge two list at once")
Signed-off-by: Xiangfeng Cai <caixiangfeng@bytedance.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
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


