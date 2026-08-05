Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413033BE15D
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896651; cv=none; b=T+0y5aKv+Hn1hRvgQhw0Y8bjmzClA0NL9G+sEijltNUlXMnUj34SCKWqJGzLX//OXKA2bY/olZb3qpTdnMhWmDo7pNzRqj5XDwFnjgsnDOT6EAjcLPca7v0/JexJIv3YhMrFdw5/3hggSFSA01uVl26keB71JuukhJlHh97fp5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896651; c=relaxed/simple;
	bh=jTCD0pypQVzAtVtZvFSOwe3fRgPu7SnRS0q31iL8Z6M=;
	h=Date:To:From:Subject:Message-Id; b=HC761KEQQL/r1GvKJnBkU7GPXVJa/RpwesjDq0wTFzq1zS9lNBw5r9E3E01NXIXWl8YFDLiUDF8kr3qmVDYd59A0jOImWXoPF6DB8myMhOIYRAy+TnDYmb4lHEn6gEiac+P7DufEzWYt3mnOAdNMbDqNXxEVt1V4inxXpqgFYzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZegFMYQ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZegFMYQ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB2B1F000E9;
	Wed,  5 Aug 2026 02:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896650;
	bh=zk9HNbTPswRPr+MXj/f16W51c/8nzcqoZQpJ/KAP/6M=;
	h=Date:To:From:Subject;
	b=ZegFMYQ99ft8fixykJRLN760coLFsIHsv5vmYps1bGtnLRQwuXYIh5pGAxIec9iF/
	 DGSdAz4fSCxz67xeg7XTptoRbB4MAhjPzw1xZ05szNgMi0TeEyWVY8dzyahPh//WYw
	 slUFtFU2C5bC6qcabGCvCGFoObsRSwphynopFoJw=
Date: Tue, 04 Aug 2026 19:24:09 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,svens@linux.ibm.com,surenb@google.com,rppt@kernel.org,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mingo@redhat.com,mhocko@suse.com,luto@kernel.org,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,hpa@zytor.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,brendan.jackman@linux.dev,bp@alien8.de,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-mm-use-free_reserved_pages-in-vmem_free_pages.patch removed from -mm tree
Message-Id: <20260805022410.0DB2B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390/mm: use free_reserved_pages() in vmem_free_pages()
has been removed from the -mm tree.  Its filename was
     s390-mm-use-free_reserved_pages-in-vmem_free_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: s390/mm: use free_reserved_pages() in vmem_free_pages()
Date: Thu, 16 Jul 2026 16:51:02 +0200

Let's use our new generic helper.

Link: https://lore.kernel.org/20260716-bootmem_info_part2-v2-3-4afc76c73d61@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/vmem.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/s390/mm/vmem.c~s390-mm-use-free_reserved_pages-in-vmem_free_pages
+++ a/arch/s390/mm/vmem.c
@@ -39,7 +39,6 @@ static void __ref *vmem_alloc_pages(unsi
 
 static void vmem_free_pages(unsigned long addr, int order, struct vmem_altmap *altmap)
 {
-	unsigned int nr_pages = 1 << order;
 	struct page *page;
 
 	if (altmap) {
@@ -49,8 +48,7 @@ static void vmem_free_pages(unsigned lon
 	page = virt_to_page((void *)addr);
 	if (PageReserved(page)) {
 		/* allocated from memblock */
-		while (nr_pages--)
-			free_reserved_page(page++);
+		free_reserved_pages(page, order);
 	} else {
 		free_pages(addr, order);
 	}
_

Patches currently in -mm which might be from david@kernel.org are

mm-standardize-printing-for-pgtable-entries.patch
mm-gup-fix-always-draining-lru-caches-in-collect_longterm_unpinnable_folios.patch

