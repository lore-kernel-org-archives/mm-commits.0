Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793221423;
	b=Ox1O4k/jdLb/jUvpA0YLVfY0/6ndE5cCV0AnOuZyzs86I5cBOxQdc800hfXUSLI2TOzv
	 GhXWzeLPfIkdkav2FXLmAS6QBhtGIYPk8wwkXo3ba9PAksfz3fiu7+h9HDH9nH3Znd6P2
	 v0b5Njltcc/xlHsN6A/uP2H3sVYkiDHSkH5rxTr/SazMEjIuu2e8LgQAy9re2DXcSr6oG
	 MAp943UwBPkzvVANOD4ce1z06l1/DXps7dN1NryYXJzT41ig98lSrJflQcAE8YnhbEN1j
	 EA6Q+AQlPJsU9kOUlfPlIVWYMT2oaLf7dAXC1/3bLEtRlJiATanYSBjkfsh9LyurN6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793221423;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=sNoq/q5v2gy6THgfkJ0jctuAt1yCxccWDLK2hZWX1DU=;
	b=dLi7wE8Ww4Qrn5JIAS4iQ3L1jmL6DTrMLnxj8xWuNqKO3Nfm6gHDpNphchEAzSjcKX+A
	 VaPJMKFwONqjdw+LtLpUap+EdkBC3b/NNOjVzir70K/b2Y6YWmd46UD9ed+y4ZRJjE4bN
	 6p2vDLMzzxU80vP5bAp/nsMwCuqbOU+UlU9gBYbW+naAl0XBvowGINzSAQzM/Vlj+AX+y
	 PGj4V+v5AmZOEWOwbUwwkSCr62+FxB33ROEfN3zUlH1xADpx6UYce9Pqt5n+mia9wzjHO
	 ksiW2EoN9ouk0ZDA8TxKqMBv2qPrEPecYXRBb8kBhZ9hM7y0dCozgh2als+Am9hdg7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vd4kXFxS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916E1606A31C;
	Wed, 28 Oct 2026 21:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vd4kXFxS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C4C1F01828;
	Wed, 28 Oct 2026 21:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793221422;
	bh=sNoq/q5v2gy6THgfkJ0jctuAt1yCxccWDLK2hZWX1DU=;
	h=Date:To:From:Subject;
	b=vd4kXFxS3VRpnR9DUv7DAZpCidT0bc4mMBJ9JgULlNz4JuTroKjR5ZIJkueEYtwz5
	 o3JNOqxJ37xvhmwKqcc/IoVGQHHXG2xHmCtuKQ3HQM3DEoir6W4kjjsK4Yovjk+cMH
	 mM9LRgXz7pS/3fOfbMHvI7JxwyISvBlaescTUGEs=
Date: Wed, 28 Oct 2026 14:03:41 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,
	surenb@google.com,stable@vger.kernel.org,skhan@linuxfoundation.org,
	rppt@kernel.org,rdunlap@infradead.org,peterz@infradead.org,osalvador@suse.de,
	muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,
	fvdl@google.com,david@kernel.org,corbet@lwn.net,kas@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-map-the-shared-tail-page-writable.patch added to mm-hotfixes-unstable branch
Message-Id: <20261028210341.F1C4C1F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/hugetlb_vmemmap: map the shared tail page writable
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-map-the-shared-tail-page-writable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-map-the-shared-tail-page-writable.patch

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
Cc: Oscar Salvador <osalvador@suse.de>
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

mm-hugetlb_vmemmap-map-the-shared-tail-page-writable.patch

