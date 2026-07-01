Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175CF3A255A
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 23:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782948514; cv=none; b=i2w8GdxL/bRsfmBHWO/M4WZjn+rbZTuzyOS22a+RtWEsw6y6WEgiNEcvt8M/yOblbz5IPbN1MRSogiIv1X4mgXdlSYlqaWEsfVsQLZH+lk1Mn01p4vUNE/1c/UVvQ3CSp6tsL1rODjFg8SO84jGC/VYqEV9Hl6CCHs7KpGSynz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782948514; c=relaxed/simple;
	bh=jruHfwDMojXDQT41IkbpN0+3tBobWMKiAbhp6MlXeRU=;
	h=Date:To:From:Subject:Message-Id; b=HrURR1cmCOTqwACtoVMo83cAsffKyKooCuePeJCfHQjFtNt9omK1wUu52fy4veAvcCy7zV8ODWhhALo3GfrdJSm2JHtCDe2jTG6NuTAADHHZqRRbMFnXH9fv3cyrt+xjVWcFxVeKHCOP1GIZId7bq7yKxXgZhDs9/TOUTv5UPz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y0+enHJi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y0+enHJi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A592B1F000E9;
	Wed,  1 Jul 2026 23:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782948512;
	bh=oLYje94fYCmryZIqeWBaTzc2hya5g/Uk0G6BUpLy4Rs=;
	h=Date:To:From:Subject;
	b=Y0+enHJimnvfr6tc3HvlhN08GRBT1hviiV040HVHRbofBP66RuniDJjox2zdqODq+
	 3RA0LUOISB0zL+ZxC53lKrLTnhSoe9R2Nc0obui8x7m8bRrJWqfnYlyW/GPl2zlzJN
	 jMobiXRzBnrrawObxQkHYlcKnEE2r3GKQtgJnAO4=
Date: Wed, 01 Jul 2026 16:28:32 -0700
To: mm-commits@vger.kernel.org,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-a-set_page_section_from_pfn-helper.patch added to mm-new branch
Message-Id: <20260701232832.A592B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add a set_page_section_from_pfn() helper
has been added to the -mm mm-new branch.  Its filename is
     mm-add-a-set_page_section_from_pfn-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-a-set_page_section_from_pfn-helper.patch

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

mm-fix-stale-zone_device-refcount-comment.patch
mm-factor-zone-device-page-init-helpers-out-of-__init_zone_device_page.patch
mm-add-a-set_page_section_from_pfn-helper.patch
mm-add-a-template-based-fast-path-for-zone-device-page-init.patch
mm-extend-the-template-fast-path-to-zone-device-compound-tails.patch
string-introduce-memcpy_nt-helpers.patch
x86-string-extend-memcpy_flushcache-fixed-size-fastpaths.patch
mm-use-memcpy_nt-in-zone-device-template-copies.patch

