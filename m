Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FFB30C37A
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439015; cv=none; b=Xn96bADOCFzSvphPHsotfpVVGF0KqMyAc3jrSltkFpH2pIr+K5ois10FJuuy7lKdkrGaagcjXh32KRVJ0a7tumlFPRodpN5C39nwG/d04n30qNFUvIp5uQpZopPLWNHbLVtraxQxNE/jA7KvOU8IAPbsbxB2RhOF/73lm/aWVbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439015; c=relaxed/simple;
	bh=CB5cPJmmPYqaNjFn9nHP1KeTSKGLuYtesAIVHazg428=;
	h=Date:To:From:Subject:Message-Id; b=bTKbZgmRXuGzRMwr2GCKNQ3Rdj4mqgFmAMLEbYoIY6mI44VM6xG9lpzLD9FaPue96FYwRggb11FQjbo8u/qS1scnyZSDwR47aAT39y/Royq7xAl6KKnOigxO/sl7HMlWtnwV1SP4Io/0lUjSAY90vNJs/Pan/2fABKsjde40nsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mjMu8SPa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mjMu8SPa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8511F00898;
	Tue,  2 Jun 2026 22:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439014;
	bh=471i8AQ0N4D9xlkJsnmnjOxVXDs56h8nirAKMfaknnk=;
	h=Date:To:From:Subject;
	b=mjMu8SPaqyg/V6gpIwdwT76tRGzzbePzZ+3UCKjOrKUSsIPZfjBqDdKkLXZssyrL9
	 TwB4QmdIfCfgt1QlLjKRSPNR9Lujx0nuu/QzIN2HnbphklhGCzZ/BoJ0QZ55k/1dmT
	 TbWvAc0a4zUeYINfB55kcjMrmCcJGY6y6nK38kDk=
Date: Tue, 02 Jun 2026 15:23:34 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,svens@linux.ibm.com,surenb@google.com,rppt@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,davem@davemloft.net,borntraeger@linux.ibm.com,andreas@gaisler.com,agordeev@linux.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-bootmem_info-drop-initialization-of-page-lru.patch removed from -mm tree
Message-Id: <20260602222334.8F8511F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/bootmem_info: drop initialization of page->lru
has been removed from the -mm tree.  Its filename was
     mm-bootmem_info-drop-initialization-of-page-lru.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
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
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
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


