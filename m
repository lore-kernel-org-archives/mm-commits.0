Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793464345;
	b=ylgXmTYIvHq4znXgTm4bu23ZDNVMdoOv9jWmqlvLlObvYyRQen43hHeaztBmCPqbUIK7
	 aNl3ykzUw7o69zvCHYCpXzkICJP/j+08zYP3Dn4Ro955uNqc2UV40FHpR0O1BKM6K3Uts
	 wIbT+C6j16jihUtEyzjbVrZtjizW/rCRhXDb69wD9PJLB3yhPw43ou7aswSUqQvbzXtL2
	 06kksQ+hHCvjw5u+LSwcmNipK76yVem0GNNuxPpatTVtpdnV4mNnAgpf0msqC6JkRv/p6
	 XA+APBw+5T1zE6LVv0+O3u400/gB8tsEO3K0AXAIs9k37ErKSAlr33tO8DrpwSPMyZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793464345;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=WlNJ4NGjg9pr1+gUxcQN0ABy+maLPvMK/dxNqNjuv9k=;
	b=emrjz/JX/2acma80LL/kbvQ0MWu85t3SdpuF9fR4vTlQ5vSA1W5d1LyOeD4dwLOFm72v
	 6hLjCaWoeF1WQClSm+jq4NcBwylzg8qsggWibifP2PcAJ/c9xG5eejJzMRvcTen54pIgM
	 hCuQb/Li2EbQHhw4xwhzKwj8VMaBjHhgGnYdSNjOOeStAUA+mG5z8M/NTdMxOpF+Pehh+
	 ye/DQek9UBF08JUZ92RxF967mB4GUq+FY+zyYWLh9HASYSsC17PqnxqguPxakiNoJUHCo
	 hT5FNRPRVRerbxRZNiIOwf+nV1ujxLp/0/Ua/mqpKbzkK/Y3JYVB1DPV8TsLGjAsbyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lX3pE8sR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B3C606A31C;
	Sat, 31 Oct 2026 16:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lX3pE8sR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971CB1F000C1;
	Sat, 31 Oct 2026 16:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793464344;
	bh=WlNJ4NGjg9pr1+gUxcQN0ABy+maLPvMK/dxNqNjuv9k=;
	h=Date:To:From:Subject;
	b=lX3pE8sRWgrS5q8bu9KaJMnXxvHDmine7jjAsyhp+tpXYoM8mGyNFt9+Udsl4pCth
	 LLr3MeSDY3VsTcr6mOVCac7FSgbhUTdcE93YBCo3G6NW35jxl04gA7iBExgQQ1QWdb
	 DptRMtNcWyhdNzMu+BNIuTQptzg3ijnq0c0URTgE=
Date: Sat, 31 Oct 2026 09:32:24 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,venkat88@linux.ibm.com,
	stable@vger.kernel.org,pavrampu@linux.ibm.com,muchun.song@linux.dev,
	maddy@linux.ibm.com,david@kernel.org,baolin.wang@linux.alibaba.com,
	ritesh.list@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-huge_memory-set-the-mmu_gather-page-size-in-zap_huge_pud.patch removed from -mm tree
Message-Id: <20261031163224.971CB1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/huge_memory: set the mmu_gather page size in zap_huge_pud()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-set-the-mmu_gather-page-size-in-zap_huge_pud.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Muchun Song <muchun.song@linux.dev>
Tested-by: Pavithra Prakash <pavrampu@linux.ibm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
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


