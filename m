Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01076425CED
	for <mm-commits@vger.kernel.org>; Thu, 26 Feb 2026 16:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772124520; cv=none; b=BgVlj5PPTmOMTwuS6wupnFFq3y0E73VzEHNBuv28opIXM9Am7c2Fz5/meb+fX6DS0avgkmgCfqovU7IVcmKnQ41UDdNiSo9kclqdwV6Kk22IpUdoOTz7GZA5LEHZ3IZ4zcA2m5IvFAz8N9Mxuo2hocFgCnRkp7Sti2XyQCZB9SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772124520; c=relaxed/simple;
	bh=zYHHyO10AhW9Q9nXUe+TcDEzhR5/a1EsYlneGojPWZk=;
	h=Date:To:From:Subject:Message-Id; b=Du09aFRHrYSKNT9nZ2tkuTTlieKQw4Je5nMA4QYPThD+u0374TYuZNV6rLZB1idSep5YIscQSHPQQrX+b62Q8H76baiVg+R9cVwsbFvVzwEGczY2Wp5APk1KxFAo4PYPNV2hateqV/6cUIH9sKn/evP8lDfq6VAPRroMFVCyoH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OmmBWSgG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OmmBWSgG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7916FC116C6;
	Thu, 26 Feb 2026 16:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772124519;
	bh=zYHHyO10AhW9Q9nXUe+TcDEzhR5/a1EsYlneGojPWZk=;
	h=Date:To:From:Subject:From;
	b=OmmBWSgGYQi8AMbHJBspk5gN7wqQjua3vWyOM6JhYzus1VFFAIDbFgk1BWzqJwMT8
	 uvTU6IYj2068SUGwsij+8ydpn3LbYlFz5A28LLoISRf9qHYh6vP6LiSIXE/2GlNzqu
	 F4zq35sU8e20trVVrODi7nI7tZa0D8PN9RxAbwyA=
Date: Thu, 26 Feb 2026 08:48:38 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,ritesh.list@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlbc-use-__pa-instead-of-virt_to_phys-in-early-bootmem-alloc-code.patch added to mm-hotfixes-unstable branch
Message-Id: <20260226164839.7916FC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb.c: use __pa() instead of virt_to_phys() in early bootmem alloc code
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlbc-use-__pa-instead-of-virt_to_phys-in-early-bootmem-alloc-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlbc-use-__pa-instead-of-virt_to_phys-in-early-bootmem-alloc-code.patch

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
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
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

mm-hugetlbc-use-__pa-instead-of-virt_to_phys-in-early-bootmem-alloc-code.patch

