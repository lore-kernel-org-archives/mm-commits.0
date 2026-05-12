Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B617357CE3
	for <mm-commits@vger.kernel.org>; Tue, 12 May 2026 21:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778620660; cv=none; b=ayK04abZxj6gurz3l2OBspFdicdZEhhgT8Kzad/60l9utpyupyUwVvTS1Up2SUSglpGRU/jLaBYPhjGpKSN9EVRwHBzGU3GFRBmRYqVzSyiF1+4l/02M1aQSFVSyw5N+JUyMT3biZchsLyRkIX26xaqPuhgE0W9qHsPHwerUmWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778620660; c=relaxed/simple;
	bh=oYdtp93AiPMnYK0vYGE/d5lnO5V6dIDita986/S2tGY=;
	h=Date:To:From:Subject:Message-Id; b=G2FaEC05zpPNu9r9D/K5LGIWgBbzLdH17SSQ56jc0pRYpQbxR6WJPN3U8k4mecrSCAKv6oL5UNXK7bG061bcuRp/ptaY3+3UT6k3k/CUYVF+set931S6aQNuwN4MiaRTE/YaBDBY7JClMxaimcA+BB7m/OZVYBvbcTMLqcdJRwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C2z6eBqt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C2z6eBqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB01C2BCB0;
	Tue, 12 May 2026 21:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778620660;
	bh=oYdtp93AiPMnYK0vYGE/d5lnO5V6dIDita986/S2tGY=;
	h=Date:To:From:Subject:From;
	b=C2z6eBqtHi+b8L+3Iji1rBpTTKMbJnWmZHodRtMMkKUdkDej/6TWxNUHTsckEZd+I
	 AxnSIBrdyveA1Gs+PYhC7EpEPvbEDjmn9BCWCDl/pbczaZU1cX/Wlx33KnHl/jx3Ri
	 Ol9A+4fPQwAyAjYJz03RJhlDJqomxPoho7t6D9eM=
Date: Tue, 12 May 2026 14:17:39 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,svens@linux.ibm.com,surenb@google.com,rppt@kernel.org,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,davem@davemloft.net,borntraeger@linux.ibm.com,andreas@gaisler.com,agordeev@linux.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-bootmem_info-stop-marking-the-pgdat-as-node_info.patch added to mm-new branch
Message-Id: <20260512211740.2AB01C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/bootmem_info: stop marking the pgdat as NODE_INFO
has been added to the -mm mm-new branch.  Its filename is
     mm-bootmem_info-stop-marking-the-pgdat-as-node_info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-bootmem_info-stop-marking-the-pgdat-as-node_info.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/bootmem_info: stop marking the pgdat as NODE_INFO
Date: Mon, 11 May 2026 16:05:33 +0200

We removed the last user of NODE_INFO in commit 119c31caa59e ("mm/sparse:
remove !CONFIG_SPARSEMEM_VMEMMAP leftovers for CONFIG_MEMORY_HOTPLUG").

But it really was never used it besides for safety-checks ever since it was
introduced in commit 04753278769f ("memory hotplug: register section/node
id to free"), where we had the comment:

	5) The node information like pgdat has similar issues. But, this
	   will be able to be solved too by this.
	   (Not implemented yet, but, remembering node id in the pages.)

Of course, that never happened, and we are not planning on freeing the
node data (pgdat/pglist_data), during memory hotunplug.

So let's just stop marking the pgdat as NODE_INFO.

Link: https://lore.kernel.org/20260511-bootmem_info_prep-v1-5-3fb0be6fc688@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem_info.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/mm/bootmem_info.c~mm-bootmem_info-stop-marking-the-pgdat-as-node_info
+++ a/mm/bootmem_info.c
@@ -62,15 +62,8 @@ static void __init register_page_bootmem
 
 void __init register_page_bootmem_info_node(struct pglist_data *pgdat)
 {
-	unsigned long i, pfn, end_pfn, nr_pages;
+	unsigned long pfn, end_pfn;
 	int node = pgdat->node_id;
-	struct page *page;
-
-	nr_pages = PAGE_ALIGN(sizeof(struct pglist_data)) >> PAGE_SHIFT;
-	page = virt_to_page(pgdat);
-
-	for (i = 0; i < nr_pages; i++, page++)
-		get_page_bootmem(node, page, NODE_INFO);
 
 	pfn = pgdat->node_start_pfn;
 	end_pfn = pgdat_end_pfn(pgdat);
_

Patches currently in -mm which might be from david@kernel.org are

mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free.patch
mm-fix-__vm_normal_page-to-handle-missing-support-for-pmd_special-pud_special.patch
sh-use-folio_mapped-instead-of-page_mapped-in-sh4_flush_cache_page.patch
bpf-arena-use-page_ref_count-instead-of-page_mapped-in-arena_free_pages.patch
mm-remove-page_mapped.patch
sparc-mm-remove-register_page_bootmem_info.patch
mm-bootmem_info-drop-initialization-of-page-lru.patch
mm-bootmem_info-stop-using-pg_private.patch
mm-bootmem_info-remove-call-to-kmemleak_free_part_phys.patch
mm-bootmem_info-stop-marking-the-pgdat-as-node_info.patch
mm-bootmem_info-stop-marking-mem_section_usage-as-mix_section_info.patch
s390-mm-use-free_reserved_page-in-vmem_free_pages.patch
powerpc-mm-remove-config_have_bootmem_info_node.patch

