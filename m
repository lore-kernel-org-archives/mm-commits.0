Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793326746;
	b=3v/ZHfXyuIX9h/sA77N6uqKMuDRgD/iVmYpW9j5JC7DthbIm70xE0rn7lJTzXlnSPtK+
	 uaiXSmIn5Ax4WN7rajAp9Y5sOXGg8Y5vUaMtuAaSgbhLKrCp2FwnRWhPWBaKt7pkAMV+0
	 pvd1l88UzsEMKCoYdOYakdzhPFo2FS3MqX7hu+faGPxp2XNfukUhNg0qTIecEg9xK2F6w
	 nsxi99Zgj5s2clmmcGsRQj3Q3XCTaUdOWObjhrIUQtJ5iL/NUPBt5dxXuErK2ZrprQSa7
	 e9Itv8Lz8VjQViHMMaKD4OQSPtmoPFj5Nv2UOUfSCcEQYDx7XEzZsNiV967pFTt615w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793326746;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=J8PtrZvollsUE+6TVUCbQD6dtsC7bpBv+FlB9tcSdgQ=;
	b=tMkEkRYWgnyQ2URO3LxmwhGfNAeavGgCtZRNgQIwHb5zkLpyxUjc8vppicBbUNTemaXp
	 JEE4gZSXZMvKQIdceNhqQwxbyWeaa1FfU9pUh/mPrONXD034TVWktaQd07rMACvVdNmZT
	 xQD4T+hE6uS0o9cAnhtjZk6XBhzv5r0yraJyKsKoWrnO/wVPaiLiHwAnoKooXBbnNLhfH
	 SFynHl5CwyiZaDm15L3fu7nQvZE8BJL6dbKytGecjCACGW5+SqA7PKjh6k5jg5A670Ssu
	 mS1gp7KoFS4Jss3XQNWpHQ4wKB8dfg1BlTMPKJQ+8qv/+vKlz0yAC92zx/fValio9oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SeezV4Nz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49A7606A31A;
	Fri, 30 Oct 2026 02:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SeezV4Nz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DCA71F000C1;
	Fri, 30 Oct 2026 02:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793326745;
	bh=J8PtrZvollsUE+6TVUCbQD6dtsC7bpBv+FlB9tcSdgQ=;
	h=Date:To:From:Subject;
	b=SeezV4NzjoQg0GTzqH6csplxypgAtudb2dDqjX2hIDIXKxcYVDqiRzJzIgVXQhzpf
	 LFgOFJeQHIAhEypaHUTl0Q9x8DSjzKKSW/7zWW+vXfuYXJL2M5p1iE/eKEoCpNqMY/
	 Mir/k0kNEMc27CkxDJYyAQiD8vQUuaHUKo+50K5M=
Date: Thu, 29 Oct 2026 19:19:04 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,venkat88@linux.ibm.com,
	stable@vger.kernel.org,pavrampu@linux.ibm.com,muchun.song@linux.dev,
	maddy@linux.ibm.com,david@kernel.org,baolin.wang@linux.alibaba.com,
	ritesh.list@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-set-the-mmu_gather-page-size-in-zap_huge_pud.patch added to mm-hotfixes-unstable branch
Message-Id: <20261030021905.2DCA71F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/huge_memory: set the mmu_gather page size in zap_huge_pud()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-huge_memory-set-the-mmu_gather-page-size-in-zap_huge_pud.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-set-the-mmu_gather-page-size-in-zap_huge_pud.patch

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
Subject: mm/huge_memory: set the mmu_gather page size in zap_huge_pud()
Date: Fri, 30 Oct 2026 05:37:36 +0530

Unmapping a device-dax mapping with 1G alignment on powerpc radix kernel
built with CONFIG_DEBUG_VM triggers this warning on every munmap:

    WARNING: mm/mmu_gather.c:176 at __tlb_remove_folio_pages_size+0x38/0x230
    NIP [c00000000063d508] __tlb_remove_folio_pages_size+0x38/0x230
    LR [c0000000006fb688] zap_huge_pud+0x1b8/0x2d0
    Call Trace:
     zap_huge_pud+0x170/0x2d0 (unreliable)
     __zap_vma_range+0x1604/0x1e20
     unmap_vmas+0xa0/0x1f0
     unmap_region+0xb0/0x130
     vms_complete_munmap_vmas+0x120/0x310
     do_vmi_align_munmap+0x1ec/0x240
     __vm_munmap+0x148/0x220
     sys_munmap+0x28/0x40

To trigger this - it is enough to mmap() /dev/dax0.0, touch the first
byte so that the whole 1G is mapped by a single PUD and then munmap()
it.

PowerPC needs MMU_GATHER_PAGE_SIZE in which mmu_gather needs to record
the page size for which tlb flush is needed. zap_huge_pmd(),
zap_pte_range(), change_huge_pud() etc all do this already. However,
since commit:
  dbe54153296d ("mm/huge_memory: add vmf_insert_folio_pud()")

a device-dax PUD maps a real folio and zap_huge_pud() now hands it to
tlb_remove_page_size(tlb, page, HPAGE_PUD_SIZE). At that point
tlb->page_size is still whatever the previous user left behind, which is
0 for the fresh gather set up by munmap() and so the check fires.

Fix this in the same way like how other similar paths do.

Link: https://lore.kernel.org/8b853e5f9f16145859407b28af654b0f79e12642.1793318297.git.ritesh.list@gmail.com
Fixes: dbe54153296d ("mm/huge_memory: add vmf_insert_folio_pud()")
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Pavithra <pavrampu@linux.ibm.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
---

 mm/huge_memory.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/huge_memory.c~mm-huge_memory-set-the-mmu_gather-page-size-in-zap_huge_pud
+++ a/mm/huge_memory.c
@@ -3040,6 +3040,8 @@ int zap_huge_pud(struct mmu_gather *tlb,
 	spinlock_t *ptl;
 	pud_t orig_pud;
 
+	tlb_change_page_size(tlb, HPAGE_PUD_SIZE);
+
 	ptl = __pud_trans_huge_lock(pud, vma);
 	if (!ptl)
 		return 0;
_

Patches currently in -mm which might be from ritesh.list@gmail.com are

mm-huge_memory-set-the-mmu_gather-page-size-in-zap_huge_pud.patch

