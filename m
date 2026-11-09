Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794202565;
	b=Xml39tNfA0Lrsx9VrezPbCf0Xafkw4JnYDsKrIClSXX3Q3Mz8ZnLGVgq9Y7mjGnoQi82
	 Mxm/Bauhoram5Rd+H7gr2SvPjDLBVfM8Ftm11Fx8jGsKCbXq6PgR9e1Di4VN0EOYikRmj
	 SoEugR7ByN7Al+COH28qu2yYLIhDz1JywTdhl4UgopZSrJhmwW54r1GCdu1WE39DYZ8EZ
	 0IZ3sh7oELn3SsAogTWNmhL1nG6kvvUM1O1ufrdhsRmpeu2p/DBWhNlg+My8aB+ame9qB
	 uUiTdXdFr/2uyDt1KmMhY6/b09dULgFUXOsRjIS1D4YkRgu4hb6MwkRFiGdT3cvT94g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794202565;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=zEHzahGRMT/SXnUT0PLyL436MEuNRv0wJUECgD7a2iA=;
	b=E0fM9W01e7cF5/h6O+AnmYNGQkDPvLa3SBPVMet4JiUoXN1onfRNLVVoZ94w3DHor9T1
	 qbQ30/90U5EgwLPavX4qFeqTtKZBKwsFl+BnsLjwp5VaR8U1wWWbDZfQ0iWtfvIGGyX5H
	 9u99wP76k/B7x6T6PrW68HExx8YAE+caARGIiUVnILgBRK/OKQhpdlkCqvkqyEWVpQcOy
	 ++84EafuKZl46dnv8Iv5JsNOMy1i6XvDbC0ok4VQaAmqpCKoLGC1YD27mZarqx+pDP1fj
	 xMg9hZuZKwIN3TWMv7BccTz4ruq2XS0h/47xBJV4K7+vX2U1PU3DlED/ywUwmW+jNTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=cWtylABb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581A7606A31C;
	Mon,  9 Nov 2026 05:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=cWtylABb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF0F1F0089F;
	Mon,  9 Nov 2026 05:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794202565;
	bh=zEHzahGRMT/SXnUT0PLyL436MEuNRv0wJUECgD7a2iA=;
	h=Date:To:From:Subject;
	b=cWtylABbIK7l+Ykn/V8uDxXAQ+9Kuj6VmI3ykmDwncpzAIpxC7Ryv7YR2R1l+SZtf
	 8o60sBoS9RV2odk2P/CpsxLAjM4A4Y24doUasR3WVM7kLmysAzcf9i4GP2Bd7pa6j1
	 YOLqM51R1QhISJwwG0OwwnA0KWvr0aXD80NpY5oY=
Date: Sun, 08 Nov 2026 21:36:04 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,tz2294@columbia.edu,
	stable@vger.kernel.org,rppt@kernel.org,qi.zheng@linux.dev,pfalcato@suse.de,
	peterx@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,
	jannh@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mprotect-dont-skip-uffd-marker-install-when-racing-with-pte-table-reclaim.patch added to mm-new branch
Message-Id: <20261109053605.0BF0F1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mprotect: don't skip uffd marker install when racing with PTE table reclaim
has been added to the -mm mm-new branch.  Its filename is
     mm-mprotect-dont-skip-uffd-marker-install-when-racing-with-pte-table-reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mprotect-dont-skip-uffd-marker-install-when-racing-with-pte-table-reclaim.patch

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
Subject: mm/mprotect: don't skip uffd marker install when racing with PTE table reclaim
Date: Sat, 07 Nov 2026 00:28:55 +0100

change_pmd_range() populates PTE tables before installing uffd-wp markers.
An empty PTE table can be removed after change_pmd_prepare() returns but
before the pmd_none() check.

That check then skips the range, allowing UFFDIO_WRITEPROTECT to report
success without installing the required markers.  Subsequent writes by
userspace to these areas will not trigger uffd events.

PTE table reclaim during MADV_DONTNEED and page table retraction during
khugepaged can trigger this.

Retry page-table allocation in that case. Simplify the code, getting
rid of change_pmd_prepare() by routing all code through the "again" label.

It's a small race though, so likely this is not very urgent.

Link: https://lore.kernel.org/20261107-uffd_shmem_marker-v1-1-91fa2d653cfe@kernel.org
Fixes: fe2567eb5521 ("mm/shmem: allow uffd wr-protect none pte for file-backed mem")
Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Tal Zussman <tz2294@columbia.edu>
Cc: <stable@vger.kernel.org>
---

 mm/mprotect.c |   48 +++++++++++-------------------------------------
 1 file changed, 11 insertions(+), 37 deletions(-)

--- a/mm/mprotect.c~mm-mprotect-dont-skip-uffd-marker-install-when-racing-with-pte-table-reclaim
+++ a/mm/mprotect.c
@@ -470,25 +470,8 @@ pgtable_populate_needed(struct vm_area_s
 }
 
 /*
- * Populate the pgtable underneath for whatever reason if requested.
- * When {pte|pmd|...}_alloc() failed we treat it the same way as pgtable
- * allocation failures during page faults by kicking OOM and returning
- * error.
- */
-#define  change_pmd_prepare(vma, pmd, cp_flags)				\
-	({								\
-		long err = 0;						\
-		if (unlikely(pgtable_populate_needed(vma, cp_flags))) {	\
-			if (pte_alloc(vma->vm_mm, pmd))			\
-				err = -ENOMEM;				\
-		}							\
-		err;							\
-	})
-
-/*
- * This is the general pud/p4d/pgd version of change_pmd_prepare(). We need to
- * have separate change_pmd_prepare() because pte_alloc() returns 0 on success,
- * while {pmd|pud|p4d}_alloc() returns the valid pointer on success.
+ * Populate the lower-level page table if marker installation requires it.
+ * Return -ENOMEM on allocation failure.
  */
 #define  change_prepare(vma, high, low, addr, cp_flags)			\
 	  ({								\
@@ -517,30 +500,21 @@ static inline long change_pmd_range(stru
 again:
 		next = pmd_addr_end(addr, end);
 
-		ret = change_pmd_prepare(vma, pmd, cp_flags);
-		if (ret) {
-			pages = ret;
-			break;
-		}
-
-		if (pmd_none(*pmd))
+		if (unlikely(pgtable_populate_needed(vma, cp_flags))) {
+			if (pte_alloc(vma->vm_mm, pmd)) {
+				pages = -ENOMEM;
+				break;
+			}
+		} else if (pmd_none(*pmd)) {
 			goto next;
+		}
 
 		_pmd = pmdp_get_lockless(pmd);
 		if (pmd_is_huge(_pmd)) {
 			if ((next - addr != HPAGE_PMD_SIZE) ||
 			    pgtable_split_needed(vma, cp_flags)) {
 				__split_huge_pmd(vma, pmd, addr, false);
-				/*
-				 * For file-backed, the pmd could have been
-				 * cleared; make sure pmd populated if
-				 * necessary, then fall-through to pte level.
-				 */
-				ret = change_pmd_prepare(vma, pmd, cp_flags);
-				if (ret) {
-					pages = ret;
-					break;
-				}
+				goto again;
 			} else {
 				ret = change_huge_pmd(tlb, vma, pmd,
 						addr, newprot, cp_flags);
@@ -554,7 +528,7 @@ again:
 					goto next;
 				}
 			}
-			/* fall through, the trans huge pmd just split */
+			/* The PMD might have been split. */
 		}
 
 		ret = change_pte_range(tlb, vma, pmd, addr, next, newprot,
_

Patches currently in -mm which might be from david@kernel.org are

mm-memory-failure-fix-folio-refcount-leak-and-min_order_for_split-locking.patch
mm-free-unused-page-table-allocated-by-do_set_pmd.patch
mm-dont-allocate-a-page-table-under-rcu-in-do_set_pmd.patch
mm-mprotect-dont-skip-uffd-marker-install-when-racing-with-pte-table-reclaim.patch

