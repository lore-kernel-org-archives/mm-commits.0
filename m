Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6117C4167D
	for <mm-commits@archiver.kernel.org>; Wed,  6 Apr 2022 01:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453418AbiDFB5W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358521AbiDEUgQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2022 16:36:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 684C9246
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 13:18:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C279161987
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 20:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2174BC385A1;
        Tue,  5 Apr 2022 20:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649189790;
        bh=5wz7bTGTc3J8Uqrncrigtx4L3/k3VGRVVdAU7SgZ1eY=;
        h=Date:To:From:Subject:From;
        b=NsZHFVL0+E8Z5E9Ly4w3tTvfmTLS8iaVUGH2gCq2R9UM9ZVKx72malwE8YrCdpgWz
         TFXkgeH5TOdyZDUUFmMRSJtEuse2E6bVPwbT0Ycd+mP/0suX1VMUWzBPKbMKLOgmvm
         CrInxgdTCMe9151im++rmkNpX9j1L/QCNpz4jVCs=
Date:   Tue, 05 Apr 2022 13:16:29 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, jglisse@redhat.com,
        hughd@google.com, david@redhat.com, axelrasmussen@google.com,
        apopple@nvidia.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-pte_marker-swap-entry.patch added to -mm tree
Message-Id: <20220405201630.2174BC385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce PTE_MARKER swap entry
has been added to the -mm tree.  Its filename is
     mm-introduce-pte_marker-swap-entry.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-pte_marker-swap-entry.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-pte_marker-swap-entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: introduce PTE_MARKER swap entry

Patch series "userfaultfd-wp: Support shmem and hugetlbfs", v8.


Overview
========

Userfaultfd-wp anonymous support was merged two years ago.  There're quite
a few applications that started to leverage this capability either to take
snapshots for user-app memory, or use it for full user controled swapping.

This series tries to complete the feature for uffd-wp so as to cover all
the RAM-based memory types.  So far uffd-wp is the only missing piece of
the rest features (uffd-missing & uffd-minor mode).

One major reason to do so is that anonymous pages are sometimes not
satisfying the need of applications, and there're growing users of either
shmem and hugetlbfs for either sharing purpose (e.g., sharing guest mem
between hypervisor process and device emulation process, shmem local live
migration for upgrades), or for performance on tlb hits.

All these mean that if a uffd-wp app wants to switch to any of the memory
types, it'll stop working.  I think it's worthwhile to have the kernel to
cover all these aspects.

This series chose to protect pages in pte level not page level.

One major reason is safety.  I have no idea how we could make it safe if
any of the uffd-privileged app can wr-protect a page that any other
application can use.  It means this app can block any process potentially
for any time it wants.

The other reason is that it aligns very well with not only the anonymous
uffd-wp solution, but also uffd as a whole.  For example, userfaultfd is
implemented fundamentally based on VMAs.  We set flags to VMAs showing the
status of uffd tracking.  For another per-page based protection solution,
it'll be crossing the fundation line on VMA-based, and it could simply be
too far away already from what's called userfaultfd.

PTE markers
===========

The patchset is based on the idea called PTE markers.  It was discussed in
one of the mm alignment sessions, proposed starting from v6, and this is
the 2nd version of it using PTE marker idea.

PTE marker is a new type of swap entry that is ony applicable to file
backed memories like shmem and hugetlbfs.  It's used to persist some
pte-level information even if the original present ptes in pgtable are
zapped.

Logically pte markers can store more than uffd-wp information, but so far
only one bit is used for uffd-wp purpose.  When the pte marker is
installed with uffd-wp bit set, it means this pte is wr-protected by uffd.

It solves the problem on e.g.  file-backed memory mapped ptes got zapped
due to any reason (e.g.  thp split, or swapped out), we can still keep the
wr-protect information in the ptes.  Then when the page fault triggers
again, we'll know this pte is wr-protected so we can treat the pte the
same as a normal uffd wr-protected pte.

The extra information is encoded into the swap entry, or swp_offset to be
explicit, with the swp_type being PTE_MARKER.  So far uffd-wp only uses
one bit out of the swap entry, the rest bits of swp_offset are still
reserved for other purposes.

There're two configs to enable/disable PTE markers:

  CONFIG_PTE_MARKER
  CONFIG_PTE_MARKER_UFFD_WP

We can set !PTE_MARKER to completely disable all the PTE markers, along
with uffd-wp support.  I made two config so we can also enable PTE marker
but disable uffd-wp file-backed for other purposes.  At the end of current
series, I'll enable CONFIG_PTE_MARKER by default, but that patch is
standalone and if anyone worries about having it by default, we can also
consider turn it off by dropping that oneliner patch.  So far I don't see
a huge risk of doing so, so I kept that patch.

In most cases, PTE markers should be treated as none ptes.  It is because
that unlike most of the other swap entry types, there's no PFN or block
offset information encoded into PTE markers but some extra well-defined
bits showing the status of the pte.  These bits should only be used as
extra data when servicing an upcoming page fault, and then we behave as if
it's a none pte.

I did spend a lot of time observing all the pte_none() users this time. 
It is indeed a challenge because there're a lot, and I hope I didn't miss
a single of them when we should take care of pte markers.  Luckily, I
don't think it'll need to be considered in many cases, for example: boot
code, arch code (especially non-x86), kernel-only page handlings (e.g. 
CPA), or device driver codes when we're tackling with pure PFN mappings.

I introduced pte_none_mostly() in this series when we need to handle pte
markers the same as none pte, the "mostly" is the other way to write
"either none pte or a pte marker".

I didn't replace pte_none() to cover pte markers for below reasons:

  - Very rare case of pte_none() callers will handle pte markers.  E.g., all
    the kernel pages do not require knowledge of pte markers.  So we don't
    pollute the major use cases.

  - Unconditionally change pte_none() semantics could confuse people, because
    pte_none() existed for so long a time.

  - Unconditionally change pte_none() semantics could make pte_none() slower
    even if in many cases pte markers do not exist.

  - There're cases where we'd like to handle pte markers differntly from
    pte_none(), so a full replace is also impossible.  E.g. khugepaged should
    still treat pte markers as normal swap ptes rather than none ptes, because
    pte markers will always need a fault-in to merge the marker with a valid
    pte.  Or the smap code will need to parse PTE markers not none ptes.

Patch Layout
============

Introducing PTE marker and uffd-wp bit in PTE marker:

  mm: Introduce PTE_MARKER swap entry
  mm: Teach core mm about pte markers
  mm: Check against orig_pte for finish_fault()
  mm/uffd: PTE_MARKER_UFFD_WP

Adding support for shmem uffd-wp:

  mm/shmem: Take care of UFFDIO_COPY_MODE_WP
  mm/shmem: Handle uffd-wp special pte in page fault handler
  mm/shmem: Persist uffd-wp bit across zapping for file-backed
  mm/shmem: Allow uffd wr-protect none pte for file-backed mem
  mm/shmem: Allows file-back mem to be uffd wr-protected on thps
  mm/shmem: Handle uffd-wp during fork()

Adding support for hugetlbfs uffd-wp:

  mm/hugetlb: Introduce huge pte version of uffd-wp helpers
  mm/hugetlb: Hook page faults for uffd write protection
  mm/hugetlb: Take care of UFFDIO_COPY_MODE_WP
  mm/hugetlb: Handle UFFDIO_WRITEPROTECT
  mm/hugetlb: Handle pte markers in page faults
  mm/hugetlb: Allow uffd wr-protect none ptes
  mm/hugetlb: Only drop uffd-wp special pte if required
  mm/hugetlb: Handle uffd-wp during fork()

Misc handling on the rest mm for uffd-wp file-backed:

  mm/khugepaged: Don't recycle vma pgtable if uffd-wp registered
  mm/pagemap: Recognize uffd-wp bit for shmem/hugetlbfs

Enabling of uffd-wp on file-backed memory:

  mm/uffd: Enable write protection for shmem & hugetlbfs
  mm: Enable PTE markers by default
  selftests/uffd: Enable uffd-wp for shmem/hugetlbfs

Tests
=====

- Compile test on x86_64 and aarch64 on different configs
- Kernel selftests
- uffd-test [0]
- Umapsort [1,2] test for shmem/hugetlb, with swap on/off

[0] https://github.com/xzpeter/clibs/tree/master/uffd-test
[1] https://github.com/xzpeter/umap-apps/tree/peter
[2] https://github.com/xzpeter/umap/tree/peter-shmem-hugetlbfs


This patch (of 23):

Introduces a new swap entry type called PTE_MARKER.  It can be installed
for any pte that maps a file-backed memory when the pte is temporarily
zapped, so as to maintain per-pte information.

The information that kept in the pte is called a "marker".  Here we define
the marker as "unsigned long" just to match pgoff_t, however it will only
work if it still fits in swp_offset(), which is e.g.  currently 58 bits on
x86_64.

A new config CONFIG_PTE_MARKER is introduced too; it's by default off.  A
bunch of helpers are defined altogether to service the rest of the pte
marker code.

Link: https://lkml.kernel.org/r/20220405014646.13522-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20220405014646.13522-2-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/hugetlb.h |    9 +++
 include/linux/swap.h          |   15 +++++-
 include/linux/swapops.h       |   78 ++++++++++++++++++++++++++++++++
 mm/Kconfig                    |    6 ++
 4 files changed, 107 insertions(+), 1 deletion(-)

--- a/include/asm-generic/hugetlb.h~mm-introduce-pte_marker-swap-entry
+++ a/include/asm-generic/hugetlb.h
@@ -2,6 +2,9 @@
 #ifndef _ASM_GENERIC_HUGETLB_H
 #define _ASM_GENERIC_HUGETLB_H
 
+#include <linux/swap.h>
+#include <linux/swapops.h>
+
 static inline pte_t mk_huge_pte(struct page *page, pgprot_t pgprot)
 {
 	return mk_pte(page, pgprot);
@@ -80,6 +83,12 @@ static inline int huge_pte_none(pte_t pt
 }
 #endif
 
+/* Please refer to comments above pte_none_mostly() for the usage */
+static inline int huge_pte_none_mostly(pte_t pte)
+{
+	return huge_pte_none(pte) || is_pte_marker(pte);
+}
+
 #ifndef __HAVE_ARCH_HUGE_PTE_WRPROTECT
 static inline pte_t huge_pte_wrprotect(pte_t pte)
 {
--- a/include/linux/swap.h~mm-introduce-pte_marker-swap-entry
+++ a/include/linux/swap.h
@@ -56,6 +56,19 @@ static inline int current_is_kswapd(void
  */
 
 /*
+ * PTE markers are used to persist information onto PTEs that are mapped with
+ * file-backed memories.  As its name "PTE" hints, it should only be applied to
+ * the leaves of pgtables.
+ */
+#ifdef CONFIG_PTE_MARKER
+#define SWP_PTE_MARKER_NUM 1
+#define SWP_PTE_MARKER     (MAX_SWAPFILES + SWP_HWPOISON_NUM + \
+			    SWP_MIGRATION_NUM + SWP_DEVICE_NUM)
+#else
+#define SWP_PTE_MARKER_NUM 0
+#endif
+
+/*
  * Unaddressable device memory support. See include/linux/hmm.h and
  * Documentation/vm/hmm.rst. Short description is we need struct pages for
  * device memory that is unaddressable (inaccessible) by CPU, so that we can
@@ -107,7 +120,7 @@ static inline int current_is_kswapd(void
 
 #define MAX_SWAPFILES \
 	((1 << MAX_SWAPFILES_SHIFT) - SWP_DEVICE_NUM - \
-	SWP_MIGRATION_NUM - SWP_HWPOISON_NUM)
+	SWP_MIGRATION_NUM - SWP_HWPOISON_NUM - SWP_PTE_MARKER_NUM)
 
 /*
  * Magic header for a swap area. The first part of the union is
--- a/include/linux/swapops.h~mm-introduce-pte_marker-swap-entry
+++ a/include/linux/swapops.h
@@ -274,6 +274,84 @@ static inline int is_readable_migration_
 
 #endif
 
+typedef unsigned long pte_marker;
+
+#define  PTE_MARKER_MASK     (0)
+
+#ifdef CONFIG_PTE_MARKER
+
+static inline swp_entry_t make_pte_marker_entry(pte_marker marker)
+{
+	return swp_entry(SWP_PTE_MARKER, marker);
+}
+
+static inline bool is_pte_marker_entry(swp_entry_t entry)
+{
+	return swp_type(entry) == SWP_PTE_MARKER;
+}
+
+static inline pte_marker pte_marker_get(swp_entry_t entry)
+{
+	return swp_offset(entry) & PTE_MARKER_MASK;
+}
+
+static inline bool is_pte_marker(pte_t pte)
+{
+	return is_swap_pte(pte) && is_pte_marker_entry(pte_to_swp_entry(pte));
+}
+
+#else /* CONFIG_PTE_MARKER */
+
+static inline swp_entry_t make_pte_marker_entry(pte_marker marker)
+{
+	/* This should never be called if !CONFIG_PTE_MARKER */
+	WARN_ON_ONCE(1);
+	return swp_entry(0, 0);
+}
+
+static inline bool is_pte_marker_entry(swp_entry_t entry)
+{
+	return false;
+}
+
+static inline pte_marker pte_marker_get(swp_entry_t entry)
+{
+	return 0;
+}
+
+static inline bool is_pte_marker(pte_t pte)
+{
+	return false;
+}
+
+#endif /* CONFIG_PTE_MARKER */
+
+static inline pte_t make_pte_marker(pte_marker marker)
+{
+	return swp_entry_to_pte(make_pte_marker_entry(marker));
+}
+
+/*
+ * This is a special version to check pte_none() just to cover the case when
+ * the pte is a pte marker.  It existed because in many cases the pte marker
+ * should be seen as a none pte; it's just that we have stored some information
+ * onto the none pte so it becomes not-none any more.
+ *
+ * It should be used when the pte is file-backed, ram-based and backing
+ * userspace pages, like shmem.  It is not needed upon pgtables that do not
+ * support pte markers at all.  For example, it's not needed on anonymous
+ * memory, kernel-only memory (including when the system is during-boot),
+ * non-ram based generic file-system.  It's fine to be used even there, but the
+ * extra pte marker check will be pure overhead.
+ *
+ * For systems configured with !CONFIG_PTE_MARKER this will be automatically
+ * optimized to pte_none().
+ */
+static inline int pte_none_mostly(pte_t pte)
+{
+	return pte_none(pte) || is_pte_marker(pte);
+}
+
 static inline struct page *pfn_swap_entry_to_page(swp_entry_t entry)
 {
 	struct page *p = pfn_to_page(swp_offset(entry));
--- a/mm/Kconfig~mm-introduce-pte_marker-swap-entry
+++ a/mm/Kconfig
@@ -909,6 +909,12 @@ config ANON_VMA_NAME
 	  area from being merged with adjacent virtual memory areas due to the
 	  difference in their name.
 
+config PTE_MARKER
+	bool "Marker PTEs support"
+
+	help
+	  Allows to create marker PTEs for file-backed memory.
+
 source "mm/damon/Kconfig"
 
 endmenu
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-introduce-pte_marker-swap-entry.patch
mm-teach-core-mm-about-pte-markers.patch
mm-check-against-orig_pte-for-finish_fault.patch
mm-uffd-pte_marker_uffd_wp.patch
mm-shmem-take-care-of-uffdio_copy_mode_wp.patch
mm-shmem-handle-uffd-wp-special-pte-in-page-fault-handler.patch
mm-shmem-persist-uffd-wp-bit-across-zapping-for-file-backed.patch
mm-shmem-allow-uffd-wr-protect-none-pte-for-file-backed-mem.patch
mm-shmem-allows-file-back-mem-to-be-uffd-wr-protected-on-thps.patch
mm-shmem-handle-uffd-wp-during-fork.patch
mm-hugetlb-introduce-huge-pte-version-of-uffd-wp-helpers.patch
mm-hugetlb-hook-page-faults-for-uffd-write-protection.patch
mm-hugetlb-take-care-of-uffdio_copy_mode_wp.patch
mm-hugetlb-handle-uffdio_writeprotect.patch
mm-hugetlb-handle-pte-markers-in-page-faults.patch
mm-hugetlb-allow-uffd-wr-protect-none-ptes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required.patch
mm-hugetlb-handle-uffd-wp-during-fork.patch
mm-khugepaged-dont-recycle-vma-pgtable-if-uffd-wp-registered.patch
mm-pagemap-recognize-uffd-wp-bit-for-shmem-hugetlbfs.patch
mm-uffd-enable-write-protection-for-shmem-hugetlbfs.patch
mm-enable-pte-markers-by-default.patch
selftests-uffd-enable-uffd-wp-for-shmem-hugetlbfs.patch

