Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6394325771
	for <mm-commits@vger.kernel.org>; Wed, 12 Aug 2026 03:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786504927; cv=none; b=mWEowN/ZhL7GPBA5TMXqmBlCqDcli407U5rjnbmo5t5FJD4lyyi+cMq+R6p2HnCHhu2scuZav54pn77QFHdf0MURw+vUF21YYY7EEULI0cv+Q9UaBAtkH8FkXbKm3fg5tkXHyVleGeUdk5d5KnRnVEnpAO+HoE2TnnB65e7fh5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786504927; c=relaxed/simple;
	bh=3Jai49UrKLqYS0xkG4A9zZMBFwmOGxC2dLC3zryYC9c=;
	h=Date:To:From:Subject:Message-Id; b=OsiNDetHfUH1cZ2v5D9IKGspJvm2pql1OYQYDCh01avFS0Jk4HfD8rCLbiUsZgknUtpTrdKss70ElvnD1uX8sZwSlAyH0HuHb0YCW/hxRKO75FgMwJcKXwfvBIncvmIzsyUnVJxVgZEYa+U4WsyZFc5zUoTethGhjl7FOnLRFmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F8bcKGjd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F8bcKGjd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66731F000E9;
	Wed, 12 Aug 2026 03:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786504925;
	bh=6++jR8fzXV1aECS40AeDUOR59LjzqKFvWG4NvWU8ss0=;
	h=Date:To:From:Subject;
	b=F8bcKGjdEst1aimO3jO+KRvFwpoN48c2/qaNSrTBfFq2x8eb7xz3GNeN7MkD/wjq9
	 hb3OIxJNVFUr8VccsLxFwy1BKHqvWebP0mNhwUz9i7Om1RUKHmnL2PkuYuhoT+sRR2
	 R8mDaTFA+7BzQDpXWe5UNDxSXLRQm84esmuqQk0s=
Date: Tue, 11 Aug 2026 20:22:05 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix.patch removed from -mm tree
Message-Id: <20260812032205.B66731F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix
has been removed from the -mm tree.  Its filename was
     mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix.patch

This patch was dropped because it was folded into mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping.patch

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

mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping.patch
mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix-fix.patch
tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour-fix.patch
mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix.patch
selftests-mm-use-pattern-matching-in-gitignore-fix.patch
alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
selftests-mm-fix-soft-dirty-kselftest-supported-check-fix.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning-fix.patch
lib-kconfigdebug-make-debug_force_weak_per_cpu-depend-on-s390alpha.patch
selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

