Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3987B2D9ECA
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334168; cv=none; b=a76JegDDc170yyf1VeoTPkDNHyAuxpmh+h38deIRldTm3ky+lGHim0pfg/b2c0Nlp//y/aOne/6wCZVZ6tdZE1gzcHa/2NmR/3sWyWzuKUv//I/8NTB8iVALIVY6kMEMuDWzmKvwQjhp6CW4ze75ie5MXo0IDkJXRB5NILixFjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334168; c=relaxed/simple;
	bh=ojMZmK2sQKzY6wGVJ8A2jyYRxKW7+ij3Yy4aO3MLHc8=;
	h=Date:To:From:Subject:Message-Id; b=hxYms3Dm5t5VTrumeFR1ogCPRUZ0WHJ8WlE6WQg2qE+1pOLEVcKzAQJaWz/IwPDVNp/vgUbzd5654juUWZiTA9bv3nAk1LptLNgpYYBqY/tHXXi+ts4ki5bpOY/5QW1nnxMXQwQCTBCTrNhWYsd60G9VOziNxxyMsm8npXiQqXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zl2C5BAv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zl2C5BAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091311F0089B;
	Wed,  7 Oct 2026 00:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334165;
	bh=LOoq+Z6gHt0rZvkRjq4DU+Jn3Emf1wrE+Z4xHiDspuI=;
	h=Date:To:From:Subject;
	b=zl2C5BAvfmaqZRXf3oYVP+kiWikp+nMWQW3k1TvLvwP91ccjKmlCXfwCADNs2i3ph
	 jFH3vos4wYshkXHvY7bCFjrdqjl84yGBq21HVXuaSUZtScYxafw0jUPYYQ9i3BDYvT
	 LaChaZcYNClTFWlaNazAKRAP15p/HtdADTb0JXIM=
Date: Tue, 06 Oct 2026 17:49:24 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david.laight.linux@gmail.com,david@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-inline-usemap-allocation-into-sparse_init_nid.patch removed from -mm tree
Message-Id: <20261007004925.091311F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse: inline usemap allocation into sparse_init_nid()
has been removed from the -mm tree.  Its filename was
     mm-sparse-inline-usemap-allocation-into-sparse_init_nid.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/sparse: inline usemap allocation into sparse_init_nid()
Date: Thu, 10 Sep 2026 14:32:51 +0800

After removing SPARSEMEM_VMEMMAP_PREINIT, sparse_init_nid() no longer
needs the transient sparse_usagebuf state and its helper wrappers.

Allocate the usemap buffer directly in sparse_init_nid(), pass it to
sparse_init_one_section(), and drop sparse_usage_init(),
sparse_usage_fini(), and sparse_init_early_section().

Link: https://lore.kernel.org/20260910063256.64386-13-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 include/linux/mmzone.h |    3 --
 mm/sparse.c            |   46 +++++----------------------------------
 2 files changed, 7 insertions(+), 42 deletions(-)

--- a/include/linux/mmzone.h~mm-sparse-inline-usemap-allocation-into-sparse_init_nid
+++ a/include/linux/mmzone.h
@@ -2223,9 +2223,6 @@ static inline bool pfn_section_first_val
 }
 #endif
 
-void sparse_init_early_section(int nid, struct page *map, unsigned long pnum,
-			       unsigned long flags);
-
 #ifndef CONFIG_HAVE_ARCH_PFN_VALID
 /**
  * pfn_valid - check if there is a valid memory map entry for a PFN
--- a/mm/sparse.c~mm-sparse-inline-usemap-allocation-into-sparse_init_nid
+++ a/mm/sparse.c
@@ -234,42 +234,6 @@ void __weak __meminit vmemmap_populate_p
 {
 }
 
-static void *sparse_usagebuf __initdata;
-static void *sparse_usagebuf_end __initdata;
-
-/*
- * Helper function that is used for generic section initialization, and
- * can also be used by any hooks added above.
- */
-void __init sparse_init_early_section(int nid, struct page *map,
-				      unsigned long pnum, unsigned long flags)
-{
-	BUG_ON(!sparse_usagebuf || sparse_usagebuf >= sparse_usagebuf_end);
-	sparse_init_one_section(__nr_to_section(pnum), pnum, map,
-			sparse_usagebuf, SECTION_IS_EARLY | flags);
-	sparse_usagebuf = (void *)sparse_usagebuf + mem_section_usage_size();
-}
-
-static int __init sparse_usage_init(int nid, unsigned long map_count)
-{
-	unsigned long size;
-
-	size = mem_section_usage_size() * map_count;
-	sparse_usagebuf = memblock_alloc_node(size, SMP_CACHE_BYTES, nid);
-	if (!sparse_usagebuf) {
-		sparse_usagebuf_end = NULL;
-		return -ENOMEM;
-	}
-
-	sparse_usagebuf_end = sparse_usagebuf + size;
-	return 0;
-}
-
-static void __init sparse_usage_fini(void)
-{
-	sparse_usagebuf = sparse_usagebuf_end = NULL;
-}
-
 /*
  * Initialize sparse on a specific node. The node spans [pnum_begin, pnum_end)
  * And number of present sections in this node is map_count.
@@ -279,8 +243,11 @@ static void __init sparse_init_nid(int n
 				   unsigned long map_count)
 {
 	unsigned long pnum;
+	struct mem_section_usage *usage;
 
-	if (sparse_usage_init(nid, map_count))
+	usage = memblock_alloc_node(map_count * mem_section_usage_size(),
+				    SMP_CACHE_BYTES, nid);
+	if (!usage)
 		panic("Failed to allocate usemap for node %d\n", nid);
 
 	for_each_present_section_nr(pnum_begin, pnum) {
@@ -296,9 +263,10 @@ static void __init sparse_init_nid(int n
 			panic("Failed to allocate memmap for section %lu\n", pnum);
 		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
 							       NULL, NULL));
-		sparse_init_early_section(nid, map, pnum, 0);
+		sparse_init_one_section(__nr_to_section(pnum), pnum, map, usage,
+					SECTION_IS_EARLY);
+		usage = (void *)usage + mem_section_usage_size();
 	}
-	sparse_usage_fini();
 }
 
 /*
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


