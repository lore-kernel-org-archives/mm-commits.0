Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BB1218EBA
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409697; cv=none; b=shvz5j6CLBv2oU3M8peqgrWoPPYGI+YDuNpr5M2dO17bwflob6EsHPEYxJO3eZuT1xcAde1qpaRuIgSQmH23h7pk/1HsEt5rsSlBGIpMtrunnS2Tn6s+XXv0jgoYL5p6LD6BnBcoAfdG5IiJpI0bfPDbgCa0Q3SDjIeMKGK7EKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409697; c=relaxed/simple;
	bh=930C1VR2uxoYG4Dz5Cm/kUWDlUzUQ/T8nnyjTSkT9u0=;
	h=Date:To:From:Subject:Message-Id; b=KCbGfr7pSUK+YBuYTCf2nX42qvJ4xDydi/gwikTu3ozXfjeSdq6iVpcr0CJJ+1YRecwngf7yS7aPsAwt4aPHL6OejW/l2jkgloLckI0YhDjTAHz8Ot58rqSZFmTQUXTf0l5W2HryLNSacZjPelRDe3JbM9n/JeuYW7mJjeE880Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ton62lRW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ton62lRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E79C4CEED;
	Fri, 25 Jul 2025 02:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409697;
	bh=930C1VR2uxoYG4Dz5Cm/kUWDlUzUQ/T8nnyjTSkT9u0=;
	h=Date:To:From:Subject:From;
	b=ton62lRWV5cT38+BPRT69N/ev1iOttongAN4rrL0aUZrirOMksAn3aqENmTe3RVUj
	 ZR92arIAOATJNqNhvmWuNcf7Z9JbnNLWBF8xKLiepjUZpSiePOYpaRhZFgLQcOK+Go
	 x0tETJ0vVQk+6jGP3AdkOrbJoCBwUBLTMC21GLbc=
Date: Thu, 24 Jul 2025 19:14:57 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,sj@kernel.org,shivankg@amd.com,osalvador@suse.de,luizcap@redhat.com,harry.yoo@oracle.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-introduce-is_huge_zero_pfn-and-use-it-in-vm_normal_page_pmd.patch removed from -mm tree
Message-Id: <20250725021457.A4E79C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: introduce is_huge_zero_pfn() and use it in vm_normal_page_pmd()
has been removed from the -mm tree.  Its filename was
     mm-memory-introduce-is_huge_zero_pfn-and-use-it-in-vm_normal_page_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory: introduce is_huge_zero_pfn() and use it in vm_normal_page_pmd()
Date: Mon, 14 Jul 2025 09:16:51 -0400

Patch series "mm: introduce snapshot_page()", v3.

This series introduces snapshot_page(), a helper function that can be used
to create a snapshot of a struct page and its associated struct folio.

This function is intended to help callers with a consistent view of a a
folio while reducing the chance of encountering partially updated or
inconsistent state, such as during folio splitting which could lead to
crashes and BUG_ON()s being triggered.


This patch (of 4):

Let's avoid working with the PMD when not required.  If
vm_normal_page_pmd() would be called on something that is not a present
pmd, it would already be a bug (pfn possibly garbage).

While at it, let's support passing in any pfn covered by the huge zero
folio by masking off PFN bits -- which should be rather cheap.

Link: https://lkml.kernel.org/r/cover.1752499009.git.luizcap@redhat.com
Link: https://lkml.kernel.org/r/4940826e99f0c709a7cf7beb94f53288320aea5a.1752499009.git.luizcap@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Tested-by: Harry Yoo <harry.yoo@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   12 +++++++++++-
 mm/memory.c             |    2 +-
 2 files changed, 12 insertions(+), 2 deletions(-)

--- a/include/linux/huge_mm.h~mm-memory-introduce-is_huge_zero_pfn-and-use-it-in-vm_normal_page_pmd
+++ a/include/linux/huge_mm.h
@@ -482,9 +482,14 @@ static inline bool is_huge_zero_folio(co
 	return READ_ONCE(huge_zero_folio) == folio;
 }
 
+static inline bool is_huge_zero_pfn(unsigned long pfn)
+{
+	return READ_ONCE(huge_zero_pfn) == (pfn & ~(HPAGE_PMD_NR - 1));
+}
+
 static inline bool is_huge_zero_pmd(pmd_t pmd)
 {
-	return pmd_present(pmd) && READ_ONCE(huge_zero_pfn) == pmd_pfn(pmd);
+	return pmd_present(pmd) && is_huge_zero_pfn(pmd_pfn(pmd));
 }
 
 struct folio *mm_get_huge_zero_folio(struct mm_struct *mm);
@@ -631,6 +636,11 @@ static inline bool is_huge_zero_folio(co
 {
 	return false;
 }
+
+static inline bool is_huge_zero_pfn(unsigned long pfn)
+{
+	return false;
+}
 
 static inline bool is_huge_zero_pmd(pmd_t pmd)
 {
--- a/mm/memory.c~mm-memory-introduce-is_huge_zero_pfn-and-use-it-in-vm_normal_page_pmd
+++ a/mm/memory.c
@@ -668,7 +668,7 @@ struct page *vm_normal_page_pmd(struct v
 		}
 	}
 
-	if (is_huge_zero_pmd(pmd))
+	if (is_huge_zero_pfn(pfn))
 		return NULL;
 	if (unlikely(pfn > highest_memmap_pfn))
 		return NULL;
_

Patches currently in -mm which might be from david@redhat.com are

mm-add-get_and_clear_ptes-and-clear_ptes.patch

