Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AEE3CB2C8
	for <mm-commits@vger.kernel.org>; Wed,  4 Mar 2026 17:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772646311; cv=none; b=R97rSFssjDiKL5kcGPLcvS3Sr5Oyqh84EG596PIoUvAO5UXHf5bJioCEhmeEhfqN1vqahiutk7rUesU9SPssO3qlttRWsnFdua+u+P8cgN9na9biF3NIOtkZWa1vigCQ9Br4baU3jrvudMv62OiHOYUP2Jb/am+M5EwNfBr/TSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772646311; c=relaxed/simple;
	bh=6H0Qz65ldptbbed/l0raSYWXSC2WVJT+qUdFvh2pxZw=;
	h=Date:To:From:Subject:Message-Id; b=IjwHhKXsAJx4FZu21+7ezIiWIdSSdYa6ZxDkjYl1UmXIH1dYxJIoIjLYf41xZVGEf+sUjYf3Lq36XEgymDEc6SrZxUDx6DsZG3OJGffV8DBJv88QoJvECKsZXeApYTBbceG+cfcwcc1j7CbxCcETzPPJ56eNH4XvaNZhsZhp5c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HE7TWmOA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HE7TWmOA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F1CC19425;
	Wed,  4 Mar 2026 17:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772646310;
	bh=6H0Qz65ldptbbed/l0raSYWXSC2WVJT+qUdFvh2pxZw=;
	h=Date:To:From:Subject:From;
	b=HE7TWmOACZG6j14XXR6fwyS0mXQpFL9GaCk34M0mjsRmsq9jYBvggk1YnmtuGB8bw
	 v7kjyvJQYB48afjNmmKHAty6oh5+wZz9wew/UgOjDuIOMIy8NefuVOfhG77Iz2G53p
	 O+N21eBFI9y2HY1040hjBfKWSXrPMGhWVzKMro5I=
Date: Wed, 04 Mar 2026 09:45:10 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,ritesh.list@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlbc-use-__pa-instead-of-virt_to_phys-in-early-bootmem-alloc-code.patch removed from -mm tree
Message-Id: <20260304174510.B6F1CC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb.c: use __pa() instead of virt_to_phys() in early bootmem alloc code
has been removed from the -mm tree.  Its filename was
     mm-hugetlbc-use-__pa-instead-of-virt_to_phys-in-early-bootmem-alloc-code.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: mm/hugetlb.c: use __pa() instead of virt_to_phys() in early bootmem alloc code
Date: Thu, 26 Feb 2026 17:56:30 +0530

Architecture like powerpc, checks for pfn_valid() in their virt_to_phys()
implementation (when CONFIG_DEBUG_VIRTUAL is enabled) [1].  Commit
d49004c5f0c1 "arch, mm: consolidate initialization of nodes, zones and
memory map" changed the order of initialization between
hugetlb_bootmem_alloc() and free_area_init().  This means, pfn_valid() can
now return false in alloc_bootmem() path, since sparse_init() is not yet
done.

Since, alloc_bootmem() uses memblock_alloc(.., MEMBLOCK_ALLOC_ACCESSIBLE),
this means these allocations are always going to happen below high_memory,
where __pa() should return valid physical addresses.  Hence this patch
converts the two callers of virt_to_phys() in alloc_bootmem() path to
__pa() to avoid this bootup warning:

 ------------[ cut here ]------------
 WARNING: arch/powerpc/include/asm/io.h:879 at virt_to_phys+0x44/0x1b8, CPU#0: swapper/0
 Modules linked in:
 <...>
 NIP [c000000000601584] virt_to_phys+0x44/0x1b8
 LR [c000000004075de4] alloc_bootmem+0x144/0x1a8
 Call Trace:
 [c000000004d1fb50] [c000000004075dd4] alloc_bootmem+0x134/0x1a8
 [c000000004d1fba0] [c000000004075fac] __alloc_bootmem_huge_page+0x164/0x230
 [c000000004d1fbe0] [c000000004030bc4] alloc_bootmem_huge_page+0x44/0x138
 [c000000004d1fc10] [c000000004076e48] hugetlb_hstate_alloc_pages+0x350/0x5ac
 [c000000004d1fd30] [c0000000040782f0] hugetlb_bootmem_alloc+0x15c/0x19c
 [c000000004d1fd70] [c00000000406d7b4] mm_core_init_early+0x7c/0xdf4
 [c000000004d1ff30] [c000000004011d84] start_kernel+0xac/0xc58
 [c000000004d1ffe0] [c00000000000e99c] start_here_common+0x1c/0x20

[1]: https://lore.kernel.org/linuxppc-dev/87tsv5h544.ritesh.list@gmail.com/

Link: https://lkml.kernel.org/r/b4a7d2c6c4c1dd81dddc904fc21f01303290a4b8.1772107852.git.riteshh@linux.ibm.com
Fixes: d49004c5f0c1 ("arch, mm: consolidate initialization of nodes, zones and memory map")
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlbc-use-__pa-instead-of-virt_to_phys-in-early-bootmem-alloc-code
+++ a/mm/hugetlb.c
@@ -3101,7 +3101,7 @@ static __init void *alloc_bootmem(struct
 			 * extract the actual node first.
 			 */
 			if (m)
-				listnode = early_pfn_to_nid(PHYS_PFN(virt_to_phys(m)));
+				listnode = early_pfn_to_nid(PHYS_PFN(__pa(m)));
 		}
 
 		if (m) {
@@ -3160,7 +3160,7 @@ found:
 	 * The head struct page is used to get folio information by the HugeTLB
 	 * subsystem like zone id and node id.
 	 */
-	memblock_reserved_mark_noinit(virt_to_phys((void *)m + PAGE_SIZE),
+	memblock_reserved_mark_noinit(__pa((void *)m + PAGE_SIZE),
 		huge_page_size(h) - PAGE_SIZE);
 
 	return 1;
_

Patches currently in -mm which might be from ritesh.list@gmail.com are

mm-kasan-fix-double-free-for-kasan-pxds.patch

