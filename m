Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A601CAA8E
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274537; cv=none; b=r8tncg5aQMh6yIfU0Rznx6S+NXWVToQqjVnwxZNBBamMvWoawf7Ftrc+OPUyVEwRhDwuwJLMFIRnQQCPT5QxrcfscINXApQfNl2Hzp1XcbFZ+KpsP3LBTrmxymqd/nJV/ItKeFArKpkksalSu97u9E0/rC7dZO9AaDPZoxm9I9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274537; c=relaxed/simple;
	bh=Fl5aHag/qNW8Z7lIaQILmBuMuRJ+5dyOewc+NSgnXwU=;
	h=Date:To:From:Subject:Message-Id; b=S82maZ/oih8yJfzbacXNGQCFs+2BhF813UXl/bEf8QyAztjaRiNqS5GZnn0yLtYTlA2/nlxdjRglDB1B9gUhqLcdsIpEAprTWlJuQKxOxfYf3vwgrl7EO19+hwq1ZyOxTMuFyxAPJKwtX9mjKK7PFSCUXWjOjScilFZvIyLqqow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z+CNjnv2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z+CNjnv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47962C4CEDD;
	Tue, 18 Mar 2025 05:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274537;
	bh=Fl5aHag/qNW8Z7lIaQILmBuMuRJ+5dyOewc+NSgnXwU=;
	h=Date:To:From:Subject:From;
	b=z+CNjnv2dJVGInSHfaiEfwTYqBJ//wS4A7sOyDDvrzbaMJz01pECIv2Y782rNc8y2
	 g0kJ+XhE8p0kwT9WqPPb9nsWGyGIOKX7CZr8EEfjY/ajaAIGP6Ks60z/3r9MLMUiOr
	 Avu56cN5QmcWo+VwOIaonr9x4XCQytJzLbAX2qbw=
Date: Mon, 17 Mar 2025 22:08:56 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tj@kernel.org,tglx@linutronix.de,muchun.song@linux.dev,mkoutny@suse.com,mingo@redhat.com,luto@kernel.org,lorenzo.stoakes@oracle.com,lizefan.x@bytedance.com,liam.howlett@oracle.com,kirill.shutemov@linux.intel.com,jannh@google.com,ioworker0@gmail.com,hannes@cmpxchg.org,dave.hansen@linux.intel.com,corbet@lwn.net,bp@alien8.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-pass-vma-to-__folio_add_rmap.patch removed from -mm tree
Message-Id: <20250318050857.47962C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: pass vma to __folio_add_rmap()
has been removed from the -mm tree.  Its filename was
     mm-rmap-pass-vma-to-__folio_add_rmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: pass vma to __folio_add_rmap()
Date: Mon, 3 Mar 2025 17:30:01 +0100

We'll need access to the destination MM when modifying the mapcount large
folios next.  So pass in the VMA.

Link: https://lkml.kernel.org/r/20250303163014.1128035-9-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andy Lutomirks^H^Hski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Michal Koutn <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: tejun heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/rmap.c~mm-rmap-pass-vma-to-__folio_add_rmap
+++ a/mm/rmap.c
@@ -1242,8 +1242,8 @@ int pfn_mkclean_range(unsigned long pfn,
 }
 
 static __always_inline unsigned int __folio_add_rmap(struct folio *folio,
-		struct page *page, int nr_pages, enum rmap_level level,
-		int *nr_pmdmapped)
+		struct page *page, int nr_pages, struct vm_area_struct *vma,
+		enum rmap_level level, int *nr_pmdmapped)
 {
 	atomic_t *mapped = &folio->_nr_pages_mapped;
 	const int orig_nr_pages = nr_pages;
@@ -1411,7 +1411,7 @@ static __always_inline void __folio_add_
 
 	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
 
-	nr = __folio_add_rmap(folio, page, nr_pages, level, &nr_pmdmapped);
+	nr = __folio_add_rmap(folio, page, nr_pages, vma, level, &nr_pmdmapped);
 
 	if (likely(!folio_test_ksm(folio)))
 		__page_check_anon_rmap(folio, page, vma, address);
@@ -1582,7 +1582,7 @@ static __always_inline void __folio_add_
 
 	VM_WARN_ON_FOLIO(folio_test_anon(folio), folio);
 
-	nr = __folio_add_rmap(folio, page, nr_pages, level, &nr_pmdmapped);
+	nr = __folio_add_rmap(folio, page, nr_pages, vma, level, &nr_pmdmapped);
 	__folio_mod_stat(folio, nr, nr_pmdmapped);
 
 	/* See comments in folio_add_anon_rmap_*() */
_

Patches currently in -mm which might be from david@redhat.com are


