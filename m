Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631DC3314AE
	for <mm-commits@vger.kernel.org>; Mon, 10 Aug 2026 22:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786399816; cv=none; b=kVoBwjQbfz27h8GPZVeM9Q7CGs733RZ6ub9F22JqkwvRmovAFXRmSf6mEL6GBbrTotJy6ChjkhjOSPJ0UU5XUGfuhuv6mZbfK6wGGb8IY9iTMcVd5rSEe2zyOJpgd3ZiXKX12lpOQXxEz6Eh1IuExgv8WE1YU4UmXnej22DayEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786399816; c=relaxed/simple;
	bh=IGeU6NgHiFWBhmEe6AKcMoK7chsPdjtPfTgwJKU0tjg=;
	h=Date:To:From:Subject:Message-Id; b=iHRekfqB0A6zBqy8VwWWbIILOVWGsUf1YaoP0SkTjsuiNczjEmuXjmXwB53zU7CNZkTqaWeHuI2rHMmCpmDgqPdMB6CJpI9eNaG3Oe6K3FLUcZnB53vOGQcddhwPKPF24Eq2kalA2PSKVi9O5e4p7c4910gZFC+tTwPi/6JsFZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tz2u9dIw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tz2u9dIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10D61F000E9;
	Mon, 10 Aug 2026 22:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786399815;
	bh=4ND4EEfp6k5Dj/MYz/oMUIaGjGDFBIgASMYpkgVhEq0=;
	h=Date:To:From:Subject;
	b=Tz2u9dIwNqsTGx0oupF/6AusCdqZue8l8JUJfHtGnCVpGESKBxyWjRPGsVz0Tc3lI
	 u5peZzh8Wa+EHyvXMn3647kKNeDMyOXFXwcJFncyvUAgIYeNDPD/nhM13brTE0VrEY
	 yYF8vwxyLuQIqJKXYNIDEz7lQW6NXUuUxL24FNi4=
Date: Mon, 10 Aug 2026 15:10:14 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix.patch added to mm-unstable branch
Message-Id: <20260810221014.F10D61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix
Date: Mon Aug 10 03:07:02 PM PDT 2026

add comments, per Lorenzo

Link: https://lore.kernel.org/ann-vS6MYT9kuXqu@lucifer
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   57 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

--- a/include/linux/mm.h~mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix
+++ a/include/linux/mm.h
@@ -2271,17 +2271,74 @@ void unpin_user_pages(struct page **page
 void unpin_user_folio(struct folio *folio, unsigned long npages);
 void unpin_folios(struct folio **folios, unsigned long nfolios);
 
+/**
+ * vma_flags_is_cow_mapping() - Do these VMA flags imply a CoW mapping?
+ * @flags: The VMA flags to check.
+ *
+ * Mappings which could be CoW'd (subject to Copy-On-Write faults) are
+ * described as CoW mappings.
+ *
+ * All mappings backed by anonymous folios (all anonymous mappings and most
+ * MAP_PRIVATE-file backed ranges) are CoW mappings.
+ *
+ * All other mappings (including all writable MAP_SHARED mappings) are
+ * non-CoW.
+ *
+ * The criteria are !VMA_SHARED_BIT, VMA_MAYWRITE_BIT.
+ *
+ * VMA_MAYWRITE_BIT is checked instead of VMA_WRITE_BIT to account for both
+ * future mprotect() calls which can render a read-only mapping writable, and
+ * GUP with FOLL_FORCE (e.g. ptrace) which can CoW a read-only mapping.
+ *
+ * - No anonymous mapping can ever clear VMA_MAYWRITE_BIT.
+ *
+ * - Writes to anonymous mappings do not immediately result in CoW faults but
+ *   may do so after the process is forked or if a read is followed by a
+ *   write.
+ *
+ * - Writes to MAP_PRIVATE file-backed mappings result in CoW faults and may
+ *   do so again after fork.
+ *
+ * - MAP_SHARED mappings of a file opened read-only are transformed into
+ *   VMA_MAYSHARE_BIT, !VMA_SHARED_BIT, !VMA_MAYWRITE_BIT mappings, so remain
+ *   non-CoW.
+ *
+ * - Drivers may clear VMA_MAYWRITE_BIT but do so at mmap() time and cannot
+ *   mark themselves anonymous. Having cleared this flag it is not valid for
+ *   them to leave the VMA_WRITE_BIT flag set.
+ *
+ * As a consequence, the anonymous reverse mapping only tracks CoW mappings.
+ *
+ * Returns: true if the flags indicate a CoW mapping, otherwise false.
+ */
 static inline bool vma_flags_is_cow_mapping(const vma_flags_t *flags)
 {
 	return vma_flags_test(flags, VMA_MAYWRITE_BIT) &&
 		!vma_flags_test(flags, VMA_SHARED_BIT);
 }
 
+/**
+ * vma_is_cow_mapping() - Is this VMA a CoW mapping?
+ * @desc: The VMA to check.
+ *
+ * See vma_flags_is_cow_mapping() for details.
+ *
+ * Returns: true if the VMA is a CoW mapping, otherwise false.
+ */
 static inline bool vma_is_cow_mapping(const struct vm_area_struct *vma)
 {
 	return vma_flags_is_cow_mapping(&vma->flags);
 }
 
+/**
+ * vma_desc_is_cow_mapping() - Is this VMA descriptor a CoW mapping?
+ * @desc: The VMA descriptor to check.
+ *
+ * See vma_flags_is_cow_mapping() for details.
+ *
+ * Returns: true if the VMA descriptor describes a CoW mapping, otherwise
+ * false.
+ */
 static inline bool vma_desc_is_cow_mapping(struct vm_area_desc *desc)
 {
 	return vma_flags_is_cow_mapping(&desc->vma_flags);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix.patch
mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix.patch
selftests-mm-use-pattern-matching-in-gitignore-fix.patch
selftests-mm-fix-soft-dirty-kselftest-supported-check-fix.patch
alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

