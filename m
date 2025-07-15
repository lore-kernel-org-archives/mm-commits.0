Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9F810FD
	for <mm-commits@vger.kernel.org>; Tue, 15 Jul 2025 00:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752537810; cv=none; b=KvGbw3jwv1kiK7hXpgXHcRaXicFZrc4VVQtfImiTMlaT6VzmLLO359Eefe9PR5BlB6IgLZON/05KnPxiy0KDYbwa37eAGM0I1n5sC3mwM7QLC16p9bNnszfaRH6cAMlmmEvdpcA19IzkNs5gPBhHRbdomFWSvDTGUeWxHQJw8co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752537810; c=relaxed/simple;
	bh=ouDJJhdkJjvE4KNqDvn97lAzZSYlMcKsi5ljc03dR8s=;
	h=Date:To:From:Subject:Message-Id; b=dXco+JEeyKSCUl5JcsSL+jzR/XF2dmxqHtoGreXZGYiWO+qUJ5bH+RcZ1trgFqzr5IUjX4aOZZhJtEIsSDSulv9i9oCjQBRuaZqwydPukuxEr6raN3NYkfbKTURRAtZXn55dayh0AGq1QzRp363miHieQ551WaFUgD5jEi+x2rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b3T0jelq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b3T0jelq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4AEC4CEED;
	Tue, 15 Jul 2025 00:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752537809;
	bh=ouDJJhdkJjvE4KNqDvn97lAzZSYlMcKsi5ljc03dR8s=;
	h=Date:To:From:Subject:From;
	b=b3T0jelqilnRWis/sNlh/uxwdf+/OiA/pg/9S6lDY615aIpF0pxV54CzEVM+A7f1J
	 NjQBQkruNkW64Vg8kSmxHjWYuOKuPGV+uYbVYfbrTG3csNZcsoFNaOR0SB1FLr5itW
	 Xpbw0wZTcUgSgvUlya2P/CJ5HQl0eBkq3By4Xsdg=
Date: Mon, 14 Jul 2025 17:03:28 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,sj@kernel.org,shivankg@amd.com,osalvador@suse.de,luizcap@redhat.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-introduce-is_huge_zero_pfn-and-use-it-in-vm_normal_page_pmd.patch added to mm-new branch
Message-Id: <20250715000329.4B4AEC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: introduce is_huge_zero_pfn() and use it in vm_normal_page_pmd()
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-introduce-is_huge_zero_pfn-and-use-it-in-vm_normal_page_pmd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-introduce-is_huge_zero_pfn-and-use-it-in-vm_normal_page_pmd.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -674,7 +674,7 @@ struct page *vm_normal_page_pmd(struct v
 		}
 	}
 
-	if (is_huge_zero_pmd(pmd))
+	if (is_huge_zero_pfn(pfn))
 		return NULL;
 	if (unlikely(pfn > highest_memmap_pfn))
 		return NULL;
_

Patches currently in -mm which might be from david@redhat.com are

mm-convert-fpb_ignore_-into-fpb_respect_.patch
mm-smaller-folio_pte_batch-improvements.patch
mm-split-folio_pte_batch-into-folio_pte_batch-and-folio_pte_batch_flags.patch
mm-remove-boolean-output-parameters-from-folio_pte_batch_ext.patch
mm-memory-introduce-is_huge_zero_pfn-and-use-it-in-vm_normal_page_pmd.patch

