Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376BF47F4A
	for <mm-commits@vger.kernel.org>; Mon,  8 Sep 2025 22:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757372354; cv=none; b=cbXeeI+HPyitF+oiKl98nXmvVEO7SgC0oaL2GZY8MwSes7wH+WPinRAK6FpeiYzc6Mm6eQJ8JlsVkW90bP5baWiMyQUGCZD+CCF+NH32y2ttjEKvX+NtSQpyV3nfzmF+DaC8abjv9KMj9pahC7JYV5qqop3NNZWXTNM5EZZneL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757372354; c=relaxed/simple;
	bh=fmtIKlti9D+4//PH0qvxsR/YexkXx7kp1dAd13l7lzU=;
	h=Date:To:From:Subject:Message-Id; b=K3dyVVXEo9dh0nFQaMWvY7TyLo2o6mI3h6Hs/8b03CR+OMXA5FxXYafF1RsK/+35pM/P/ta4dy4tBobZcWFV/Yml7NjzI104Tg/XhP/8IhAj45n8BRIY8d+YqBBwoJZGAZlj4Lx6QGuh3c1EXgUfv1YW3/DhwSyFvHDM6iPCA10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NcSWMeEV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NcSWMeEV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16A9C4CEF1;
	Mon,  8 Sep 2025 22:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757372353;
	bh=fmtIKlti9D+4//PH0qvxsR/YexkXx7kp1dAd13l7lzU=;
	h=Date:To:From:Subject:From;
	b=NcSWMeEVQSoSqr1OMPDU7GXQnOUyq6ZP5v5EGAarvZmovIdhRNKNV7hpEo88Yoyb1
	 xYmOoTo/fJmda5o5cqTlxxBcvJBwz30IQ4iaIvmabxDd027XQ8VsPN3e3XLMh+xBH6
	 LuMmlE7iFw6rMMOz5KpzThV/7aVBGEVovnG5uqU8=
Date: Mon, 08 Sep 2025 15:59:12 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ptdesc-convert-__page_flags-to-pt_flags.patch added to mm-new branch
Message-Id: <20250908225913.B16A9C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ptdesc: convert __page_flags to pt_flags
has been added to the -mm mm-new branch.  Its filename is
     ptdesc-convert-__page_flags-to-pt_flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ptdesc-convert-__page_flags-to-pt_flags.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ptdesc: convert __page_flags to pt_flags
Date: Mon, 8 Sep 2025 18:11:00 +0100

Patch series "Some ptdesc cleanups".

The first two patches here are preparation for splitting struct ptdesc
from struct page and struct folio.  I think their only dependency is on
the memdesc_flags_t patches from August which is in mm-new.  The third
patch is just something I noticed while working on the code.


This patch (of 3):

Use the new memdesc_flags_t type to show that these are the same bits as
page/folio/slab and thesefore have the zone/node/section information in
them.  Remove a use of ptdesc_folio() by converting
pagetable_is_reserved() to use test_bit() directly.

Link: https://lkml.kernel.org/r/20250908171104.2409217-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20250908171104.2409217-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |    7 ++++++-
 include/linux/mm_types.h |    6 +++---
 2 files changed, 9 insertions(+), 4 deletions(-)

--- a/include/linux/mm.h~ptdesc-convert-__page_flags-to-pt_flags
+++ a/include/linux/mm.h
@@ -2934,6 +2934,11 @@ static inline pmd_t *pmd_alloc(struct mm
 }
 #endif /* CONFIG_MMU */
 
+enum pt_flags {
+	PT_reserved = PG_reserved,
+	/* High bits are used for zone/node/section */
+};
+
 static inline struct ptdesc *virt_to_ptdesc(const void *x)
 {
 	return page_ptdesc(virt_to_page(x));
@@ -2951,7 +2956,7 @@ static inline void *ptdesc_address(const
 
 static inline bool pagetable_is_reserved(struct ptdesc *pt)
 {
-	return folio_test_reserved(ptdesc_folio(pt));
+	return test_bit(PT_reserved, &pt->pt_flags.f);
 }
 
 /**
--- a/include/linux/mm_types.h~ptdesc-convert-__page_flags-to-pt_flags
+++ a/include/linux/mm_types.h
@@ -524,7 +524,7 @@ FOLIO_MATCH(compound_head, _head_3);
 
 /**
  * struct ptdesc -    Memory descriptor for page tables.
- * @__page_flags:     Same as page flags. Powerpc only.
+ * @pt_flags: enum pt_flags plus zone/node/section.
  * @pt_rcu_head:      For freeing page table pages.
  * @pt_list:          List of used page tables. Used for s390 gmap shadow pages
  *                    (which are not linked into the user page tables) and x86
@@ -546,7 +546,7 @@ FOLIO_MATCH(compound_head, _head_3);
  * understanding of the issues.
  */
 struct ptdesc {
-	unsigned long __page_flags;
+	memdesc_flags_t pt_flags;
 
 	union {
 		struct rcu_head pt_rcu_head;
@@ -584,7 +584,7 @@ struct ptdesc {
 
 #define TABLE_MATCH(pg, pt)						\
 	static_assert(offsetof(struct page, pg) == offsetof(struct ptdesc, pt))
-TABLE_MATCH(flags, __page_flags);
+TABLE_MATCH(flags, pt_flags);
 TABLE_MATCH(compound_head, pt_list);
 TABLE_MATCH(compound_head, _pt_pad_1);
 TABLE_MATCH(mapping, __page_mapping);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-introduce-memdesc_flags_t.patch
mm-introduce-memdesc_flags_t-fix.patch
mm-convert-page_to_section-to-memdesc_section.patch
mm-introduce-memdesc_nid.patch
mm-introduce-memdesc_zonenum.patch
slab-use-memdesc_flags_t.patch
slab-use-memdesc_nid.patch
mm-introduce-memdesc_is_zone_device.patch
mm-reimplement-folio_is_device_private.patch
mm-reimplement-folio_is_device_coherent.patch
mm-reimplement-folio_is_fsdax.patch
mm-add-folio_is_pci_p2pdma.patch
mm-remove-mlock_count-from-struct-page.patch
ptdesc-convert-__page_flags-to-pt_flags.patch
ptdesc-remove-references-to-folios-from-__pagetable_ctor-and-pagetable_dtor.patch
ptdesc-remove-ptdesc_to_virt.patch

