Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B48A3128A3
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334294; cv=none; b=bHxmhpEa8QK6Z21Jniwp52mGZLX7myjTBXz2SO7RTDGMUKNvUPDDnQdM+u2GAKoZqoFA1ebdlAZN+fjS+oJnIBNWmubJEMHtdnVyL56cK3N14k/GtgAhzNJxuPcG/Akw7qVwqbKLps6fpqOICId40jl2m9KfQHccDlgRfvpcHUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334294; c=relaxed/simple;
	bh=lwUS3x25PCs/f/cLTM9Jb8T/wpsc9z4qcQJj0KSxepQ=;
	h=Date:To:From:Subject:Message-Id; b=Z4aWyeqTX2KHXrUd6dQ6DoxN3n7vNznf7R7TTf5bkEgGoeo9OFIZxUUwRkXpVg0okP5b5nCJdsRbXKWLy/4fulkvMdTCYZKX2J3DZIxsjk9YCoRzbkfQwXXM/PLLOATTOBpdyQeenLCFlcjaunVpt0ksr1c50+krB0SO3KbiYC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WGDopQgs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WGDopQgs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F381F1F0089C;
	Wed,  7 Oct 2026 00:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334293;
	bh=G4CyQeV9Qo70WjCyEiGgwZvQAA2gfq9jKm9V+q0vRBA=;
	h=Date:To:From:Subject;
	b=WGDopQgs8X6z0ye16RU2xicaHFDwdGugMc4/YP7j1G80AM70FJqZfivMmvcGWlhRf
	 xArRsVwxfNc9DZBkk8d7rILvOl92TRxpEuwA6KJlBC5RYM4gxmQR/XsyL2Hk835jJE
	 gbD5oYo76HQjWJYCE6zWYlmp/k5wx3lOFDsC7zig=
Date: Tue, 06 Oct 2026 17:51:32 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,muchun.song@linux.dev,mingo@redhat.com,kees@kernel.org,david@kernel.org,dave.hansen@linux.intel.com,bp@alien8.de,balbirs@nvidia.com,arnd@arndb.de,apopple@nvidia.com,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-a-set_page_section_from_pfn-helper.patch removed from -mm tree
Message-Id: <20261007005132.F381F1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add a set_page_section_from_pfn() helper
has been removed from the -mm tree.  Its filename was
     mm-add-a-set_page_section_from_pfn-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: mm: add a set_page_section_from_pfn() helper
Date: Mon, 31 Aug 2026 19:16:33 +0800

Callers that want to update section bits from a PFN currently need to
open-code:

	set_page_section(page, pfn_to_section_nr(pfn));

and guard that sequence with #ifdef SECTION_IN_PAGE_FLAGS.

Add set_page_section_from_pfn() to wrap that update in one place.  When
section bits are stored in page flags, the helper derives the section
number from the PFN and updates the page flags.  Otherwise keep it as a
no-op so callers can use one helper without open-coding
SECTION_IN_PAGE_FLAGS.

Convert set_page_links() to use the new helper so later ZONE_DEVICE
fast-path patches can also update section bits without open-coding
SECTION_IN_PAGE_FLAGS at each callsite.

This keeps the PFN-to-section translation local to the configurations that
actually store section bits in struct page flags, and avoids exposing that
detail to generic callers.

No functional change intended.

Link: https://lore.kernel.org/20260831111638.76012-3-lizhe.67@bytedance.com
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <kees@kernel.org>
---

 include/linux/mm.h |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h~mm-add-a-set_page_section_from_pfn-helper
+++ a/include/linux/mm.h
@@ -2632,12 +2632,23 @@ static inline void set_page_section(stru
 	page->flags.f |= (section & SECTIONS_MASK) << SECTIONS_PGSHIFT;
 }
 
+static inline void set_page_section_from_pfn(struct page *page,
+		unsigned long pfn)
+{
+	set_page_section(page, pfn_to_section_nr(pfn));
+}
+
 static inline unsigned long memdesc_section(const memdesc_flags_t *mdf)
 {
 	ASSERT_EXCLUSIVE_BITS(mdf->f, SECTIONS_MASK << SECTIONS_PGSHIFT);
 	return (mdf->f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
 }
 #else /* !SECTION_IN_PAGE_FLAGS */
+static inline void set_page_section_from_pfn(struct page *page,
+		unsigned long pfn)
+{
+}
+
 static inline unsigned long memdesc_section(const memdesc_flags_t *mdf)
 {
 	return 0;
@@ -2860,9 +2871,7 @@ static inline void set_page_links(struct
 {
 	set_page_zone(page, zone);
 	set_page_node(page, node);
-#ifdef SECTION_IN_PAGE_FLAGS
-	set_page_section(page, pfn_to_section_nr(pfn));
-#endif
+	set_page_section_from_pfn(page, pfn);
 }
 
 /**
_

Patches currently in -mm which might be from lizhe.67@bytedance.com are

mm-hugetlb-fix-overbroad-mmu-notifiers-for-unshared-pmds.patch

