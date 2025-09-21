Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD12421D3C0
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489958; cv=none; b=fmwo/ohXVVpIl7e6kxFzihnG2qvXXOfRS+XAAaWrndJmV9IR4HMlSKILhH3ny1nuXSdRz5DNaH3a3AcBs35n/tN6nRqya3EU1GMZZUHaE+oFL1TweTjItKowAWZuZwxXh2Mma9l5XoGrVLO7CvSKCrAraqE4NVE/PK9mtWhW+VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489958; c=relaxed/simple;
	bh=hwRiiLDpsYTRiGFdmnBwnT7ILJ5DC7z52+s1FH5b660=;
	h=Date:To:From:Subject:Message-Id; b=YS0+EvErKlCQeunxyn+8gA+zY+XOo2RPcgoGIN8Qsud50IVpqfAPkrqb9N1RWVsW1xUReQuG189P8ZMz1mJ5OhHKSiN3XA3gDG4UO8Qq8Geb4mU8zo3p0dLWh3H9/FJc+1ATLXG9dgwVfiRIxEWZSCgqmwNoGJcjO42wZFHfpRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UxyY+Nqu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UxyY+Nqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5054C4CEE7;
	Sun, 21 Sep 2025 21:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489958;
	bh=hwRiiLDpsYTRiGFdmnBwnT7ILJ5DC7z52+s1FH5b660=;
	h=Date:To:From:Subject:From;
	b=UxyY+NquOzvSUO8G6pyTiuvJ97ogccQ0gUDarVXfQUhuR7qUwkCs3NBoUVJiJsPnB
	 rmEwaZ4GDAlDQ343/9P3Zjo91rLXkSAqMD2Rdc+n3vCz+0ugKKKhbPctIm668F4VRt
	 USFrfqYlQmYc9C720BXjuNYameYICsFTnepXuVU0=
Date: Sun, 21 Sep 2025 14:25:58 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ptdesc-convert-__page_flags-to-pt_flags.patch removed from -mm tree
Message-Id: <20250921212558.B5054C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ptdesc: convert __page_flags to pt_flags
has been removed from the -mm tree.  Its filename was
     ptdesc-convert-__page_flags-to-pt_flags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

ksm-use-a-folio-inside-cmp_and_merge_page.patch

