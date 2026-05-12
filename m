Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C252F8E94
	for <mm-commits@vger.kernel.org>; Tue, 12 May 2026 21:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778620656; cv=none; b=Ag74QOQQuYUvOWpxEPNr7P0FjqcopdS0KoQZSQmUrzSP46Krd6ZkHywgA2QmqceaDwPoztbKsuAxjbMMR3svTo6DU9ZYiBUUw7y98frg+BGOiJBTdCXi4D+UCjrNElqjxy2Ha7aEF0j8J14PDKCGroI3XLlDIv5AI2SSRKzii2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778620656; c=relaxed/simple;
	bh=CLc1xc7cROaU2ZAQTa6UNxiSNWj/CLksPYO+K+79gcA=;
	h=Date:To:From:Subject:Message-Id; b=ZcUImw3tLiOcBtrgGktX05RY9805isBVzJzgaNQVnf8dllz3maywsMiSJ8XiliAPWy8eCfNhdDG1EUNBtXrakh682W13PpOjTray2/caMDDao5rLGVibZ1CMnn+Q8/l+tMIA/2vPfBmkVp2wXQC3fA30Rpfv1HeTl6CvvvRwEd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mz7WCsSB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mz7WCsSB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DADC2BCFA;
	Tue, 12 May 2026 21:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778620656;
	bh=CLc1xc7cROaU2ZAQTa6UNxiSNWj/CLksPYO+K+79gcA=;
	h=Date:To:From:Subject:From;
	b=Mz7WCsSBBNbdAStkPbqw7rqK3khpTfoP2bj/hgcF/fokUZ6VdmbIvgAqBjNP8unaI
	 BQ6osVQ6JC4778YhX4TyyXuLy0joqPnJCL8d/en/8up7nLH7Vr9cIKlTBxJjGpyKMs
	 QwVXpIKnVMes3LjEhYH8S23TAY1b2MWoOfJNAt4s=
Date: Tue, 12 May 2026 14:17:35 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,svens@linux.ibm.com,surenb@google.com,rppt@kernel.org,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,davem@davemloft.net,borntraeger@linux.ibm.com,andreas@gaisler.com,agordeev@linux.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-bootmem_info-drop-initialization-of-page-lru.patch added to mm-new branch
Message-Id: <20260512211736.15DADC2BCFA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/bootmem_info: drop initialization of page->lru
has been added to the -mm mm-new branch.  Its filename is
     mm-bootmem_info-drop-initialization-of-page-lru.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-bootmem_info-drop-initialization-of-page-lru.patch

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
Subject: mm/bootmem_info: drop initialization of page->lru
Date: Mon, 11 May 2026 16:05:30 +0200

In the past, we used to store the type in page->lru.next, introduced by
commit 5f24ce5fd34c ("thp: remove PG_buddy"). The location changed over
the years; ever since commit 0386aaa6e9c8 ("bootmem: stop using
page->index"), we store it alongside the info in page->private.

Consequently, there is no need to reset page->lru anymore.

Link: https://lore.kernel.org/20260511-bootmem_info_prep-v1-2-3fb0be6fc688@kernel.org
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

 mm/bootmem_info.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/bootmem_info.c~mm-bootmem_info-drop-initialization-of-page-lru
+++ a/mm/bootmem_info.c
@@ -34,7 +34,6 @@ void put_page_bootmem(struct page *page)
 	if (page_ref_dec_return(page) == 1) {
 		ClearPagePrivate(page);
 		set_page_private(page, 0);
-		INIT_LIST_HEAD(&page->lru);
 		kmemleak_free_part_phys(PFN_PHYS(page_to_pfn(page)), PAGE_SIZE);
 		free_reserved_page(page);
 	}
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

