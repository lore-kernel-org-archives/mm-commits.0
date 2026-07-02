Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2541331F9A7
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 16:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783008232; cv=none; b=ajGFJP0Ohj0et/g2tgHUUHbDX+/mF0kOK3anobq8EM0PK1p9rSO12xYrn/C8ChMYxOVM1gxsyEgzyrf/58A+YPT4yOuD0Ve3j8aN9ut+DB9+YbNXZITeKXWZr3p9F6wSh7/8oO6FvR7xFYQh39T4y1Wg/Nc2SydbNLVrhAC0VN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783008232; c=relaxed/simple;
	bh=mSAJEPUAAc00vPxbYAeBgpbhC1j4disJiHZz0PR1AqA=;
	h=Date:To:From:Subject:Message-Id; b=TVq3u7gn06Ta0Tkd4RxuI+liquXPy+Leza21bpYnuurovRnijka5UStNTEPugDtY7TI1S6HLKqomHi8BT15+1ZY8+AAy1uPDulRt4kBfatTExBcSCH9C2rzfu4purDWDV15bBxjXC2JQ2WhEgDQpKO/GvSnlYhw4lHyQZbbFs8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t3uy6aGF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t3uy6aGF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53F01F00A3A;
	Thu,  2 Jul 2026 16:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783008231;
	bh=J4bhqKq86VDUJsJxlruFKH6yErTrnMJaoUM/jeZesHc=;
	h=Date:To:From:Subject;
	b=t3uy6aGF4yqf9+y9xBlOc+LmsrHI+OdualYGu9KOdwa76dPHy5GabzLQjhfxN3fM7
	 Nv50VhKYenatoTwCYhHQg41I63PiVyhCXCN9ihApsRn+LaY5WuO4nEe4/xQpFh38hn
	 2mk+1ViZDHZuGPey5Gz17/7U7Vaw2c6/m1xpb/Ag=
Date: Thu, 02 Jul 2026 09:03:50 -0700
To: mm-commits@vger.kernel.org,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-add-a-set_page_section_from_pfn-helper.patch removed from -mm tree
Message-Id: <20260702160350.E53F01F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add a set_page_section_from_pfn() helper
has been removed from the -mm tree.  Its filename was
     mm-add-a-set_page_section_from_pfn-helper.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: mm: add a set_page_section_from_pfn() helper
Date: Wed, 1 Jul 2026 17:05:48 +0800

Callers that want to update section bits from a PFN currently need to
open-code:

	set_page_section(page, pfn_to_section_nr(pfn));

and guard that sequence with #ifdef SECTION_IN_PAGE_FLAGS.

Add set_page_section_from_pfn() to wrap that update in one place. When
section bits are stored in page flags, the helper derives the section
number from the PFN and updates the page flags. Otherwise it degrades to
a no-op.

Convert set_page_links() to use the new helper so later ZONE_DEVICE
fast-path patches can also update section bits without open-coding
SECTION_IN_PAGE_FLAGS at each callsite.

This keeps the PFN-to-section translation local to the configurations
that actually store section bits in struct page flags, and avoids
exposing that detail to generic callers.

No functional change intended.

Link: https://lore.kernel.org/20260701090553.62691-4-lizhe.67@bytedance.com
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h~mm-add-a-set_page_section_from_pfn-helper
+++ a/include/linux/mm.h
@@ -2564,6 +2564,12 @@ static inline void set_page_section(stru
 	page->flags.f |= (section & SECTIONS_MASK) << SECTIONS_PGSHIFT;
 }
 
+static inline void set_page_section_from_pfn(struct page *page,
+					     unsigned long pfn)
+{
+	set_page_section(page, pfn_to_section_nr(pfn));
+}
+
 static inline unsigned long memdesc_section(const memdesc_flags_t *mdf)
 {
 #if SECTIONS_WIDTH != 0
@@ -2572,6 +2578,16 @@ static inline unsigned long memdesc_sect
 	return (mdf->f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
 }
 #else /* !SECTION_IN_PAGE_FLAGS */
+
+static inline void set_page_section(struct page *page, unsigned long section)
+{
+}
+
+static inline void set_page_section_from_pfn(struct page *page,
+					     unsigned long pfn)
+{
+}
+
 static inline unsigned long memdesc_section(const memdesc_flags_t *mdf)
 {
 	return 0;
@@ -2794,9 +2810,7 @@ static inline void set_page_links(struct
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

mm-add-a-template-based-fast-path-for-zone-device-page-init.patch
mm-extend-the-template-fast-path-to-zone-device-compound-tails.patch
string-introduce-memcpy_nt-helpers.patch
x86-string-extend-memcpy_flushcache-fixed-size-fastpaths.patch
mm-use-memcpy_nt-in-zone-device-template-copies.patch

