Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672152;
	b=mmT3HyJT6AVWHEJllWfUOMD6KY+UF5erjqsTbqM2IHEW/FZIlwAINnaqPSD/20r9lZlc
	 cVrZLK9etHbzJLkjDGP1OPtjcDk75afg+fBrbzf//6OQRfuQ7aUux2dctrG3OXgaR4mIp
	 UTG8YdEl2ejRR6vQVsrMQOaUAsPiQzjOxmlOhKSt3PTRV7opxJyGL+nmku9H/969OZaWg
	 jBisIyE4PMrbRis/wU7UYKALl4FhQfqKkdWA1ta7OSU4YaytOc3hqMCXml0qMTxXjhwo3
	 VsIvjegBdl1n/nYv2DAdBcw6EUvcWrMviRmAeFqCVd/XAuOXozNiy4E7SgiQ825sChQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672152;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=85c5A3bVeRUEk7B7/vApIiex7w0vaay+mVl2RbO8M4I=;
	b=qB6/X/jTfZP40QS8OBEzXL2c/vHxa2071fTRZtdzxqeGNy3JqSrQg44k0uJ2xjs8Doqf
	 q9P0IDdvRXem136cOBosRxTT+k62TKLZK6ByJpFG89dm335+OSVPaxJZRuY5UNu22AXAs
	 c5SPKHeVdyZN6l9eJ6uMUQhF2slOVLV0vdjrQgh8NkCHbp5qP/yVlDH+EHN+PDfpJ0f6b
	 EdrS80/f1DD/YfR5kckElBs6nW6lZSmwXLkrv+uvdASjUNIckCH1ZTqyTqUp8MRgWQwFt
	 fdWWFWdIq94/vWd68aTttgWc8RKQqpLvKNqekB2tsGJhNr3hRwaclLL+LemTfnvB0Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uJB8K+Cx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B7B606A32C;
	Tue,  3 Nov 2026 02:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uJB8K+Cx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21BF91F0093A;
	Tue,  3 Nov 2026 02:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672152;
	bh=85c5A3bVeRUEk7B7/vApIiex7w0vaay+mVl2RbO8M4I=;
	h=Date:To:From:Subject;
	b=uJB8K+CxClEGidH2W6ABYWSM8yAQ8MhxXml0pKnNhBzh79H/IGVAouFCOoVuSTk69
	 1MmuyWJY6UJw2cDQKZ16q8+MGjhrIZQz2Bfmli1EnrHJynqT5V1i5j+2togR3XuqZs
	 LMohCyATZtGJKOktIkmLqygtAp7YadlH3QrXFxnw=
Date: Mon, 02 Nov 2026 18:15:51 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,
	surenb@google.com,stable@vger.kernel.org,skhan@linuxfoundation.org,
	rppt@kernel.org,rdunlap@infradead.org,peterz@infradead.org,osalvador@suse.de,
	muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,
	fvdl@google.com,david@kernel.org,corbet@lwn.net,kas@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb_vmemmap-map-the-shared-tail-page-writable.patch removed from -mm tree
Message-Id: <20261103021552.21BF91F0093A@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/hugetlb_vmemmap: map the shared tail page writable
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-map-the-shared-tail-page-writable.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm/hugetlb_vmemmap: map the shared tail page writable
Date: Wed, 28 Oct 2026 13:26:21 +0000

page_ref_add_unless_zero() reads the refcount and then updates it with a
cmpxchg.  A lockless get, such as a page cache lookup or a PFN scanner,
can read a non-zero refcount from a page that is then freed and reused as
a hugetlb tail page.  If HVO remaps its struct page to the shared tail
page in between, the cmpxchg writes to read-only vmemmap:

    CPU0 (lockless get)               CPU1
    c = atomic_read(&page->_refcount)
                                      page freed
                                      page allocated as a hugetlb tail
                                      HVO remaps the struct page RO
    try_cmpxchg(&page->_refcount, &c, c + 1)
      -> write fault on read-only vmemmap

The refcount is zero by then and the compare fails, but a compare-and-swap
instruction needs write access whether or not it succeeds.  The kernel
oopses when hugetlb pages are allocated at runtime with HVO enabled while
a lockless get races with it.

Commit bd225530a4c7 ("mm/hugetlb_vmemmap: fix race with speculative PFN
walkers") closed the window with RCU on both sides.  The RCU was removed
together with fake heads, on the wrong belief that it was only needed for
them.

Map the shared tail page writable instead of restoring the RCU.  Every
struct page on it is a tail with a zero refcount, so a late cmpxchg
fails and leaves the page unchanged.  RCU would put rcu_read_lock()
back around every get and synchronize_rcu() back into hugetlb
allocation and freeing.

The cost is the protection against stray writes to tail struct pages.  The
shared page is shared by all hugetlb folios of the same order in the zone,
so such a write now corrupts all of them instead of oopsing.

Bootmem folios optimized when the memmap is set up keep their tails
read-only.  Nothing does a lockless get on them before hugetlb takes them
over.

Link: https://lore.kernel.org/20261028132623.2560146-1-kirill@shutemov.name
Fixes: 32c440d67e6c ("mm: drop fake head checks")
Fixes: 01b1d0ffb6f7 ("hugetlb: remove VMEMMAP_SYNCHRONIZE_RCU")
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: David Hildenbrand (Arm) <david@kernel.org>
Closes: https://lore.kernel.org/r/ebc7bde1-f52e-4da8-b16f-822d6c0a4d74@kernel.org
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: <stable@vger.kernel.org>
---

 Documentation/mm/vmemmap_dedup.rst |   15 +++++++++++++--
 mm/hugetlb_vmemmap.c               |    8 +++++---
 2 files changed, 18 insertions(+), 5 deletions(-)

--- a/Documentation/mm/vmemmap_dedup.rst~mm-hugetlb_vmemmap-map-the-shared-tail-page-writable
+++ a/Documentation/mm/vmemmap_dedup.rst
@@ -130,8 +130,19 @@ pages of ``struct page`` (page 1 to page
 The optimization is only applied when the size of the struct page is a power
 of 2. In this case, all tail pages of the same order are identical. See
 compound_head(). This allows us to remap the tail pages of the vmemmap to a
-shared, read-only page. The head page is also remapped to a new page. This
-allows the original vmemmap pages to be freed.
+shared page. The head page is also remapped to a new page. This allows the
+original vmemmap pages to be freed.
+
+The shared page is mapped writable. A lockless get of a page reference can
+read a non-zero refcount before the remap and attempt its atomic update
+after it. The refcount of a tail page is zero, so the update fails without
+changing the page. Nothing else may write to the shared page: it is shared
+by all HugeTLB pages of the same size in the zone, and a stray write would
+corrupt all of them.
+
+HugeTLB pages whose vmemmap is optimized when the memmap is first set up at
+boot keep a read-only mapping of the shared page. Nothing can do a lockless
+get on them before they are handed to HugeTLB.
 
 Here is how things look after remapping::
 
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-map-the-shared-tail-page-writable
+++ a/mm/hugetlb_vmemmap.c
@@ -222,10 +222,12 @@ static void vmemmap_remap_pte(pte_t *pte
 		VM_WARN_ON_ONCE(!PageTail((const struct page *)addr));
 
 		/*
-		 * Remap the tail pages as read-only to catch illegal write
-		 * operation to the tail pages.
+		 * Map the shared tail page writable. A lockless get that read
+		 * a non-zero refcount before the remap can still do its
+		 * cmpxchg after it. The refcount is zero, so the cmpxchg
+		 * fails and leaves the page unchanged.
 		 */
-		entry = mk_pte(walk->vmemmap_tail, PAGE_KERNEL_RO);
+		entry = mk_pte(walk->vmemmap_tail, PAGE_KERNEL);
 	}
 
 	list_add(&page->lru, walk->vmemmap_pages);
_

Patches currently in -mm which might be from kas@kernel.org are

mm-vma-read-anon_vma-carefully-in-validate_mm-fix.patch

