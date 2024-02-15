Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632EB13A254
	for <mm-commits@vger.kernel.org>; Thu, 15 Feb 2024 19:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708026152; cv=none; b=Kz14wrcsD8QVoXG7jLQfG71JuMLlZQbLVSNJCQCRqTSgtHZ2AV6Jty2lGXTPEZaFiq/czDkKEK0TX4D7SzaXUA7UJQc26P+Z+xPJNhf6H0qYOb2sPYr+tdeXsen0hxn8VaFFxaGXiFUhgb0NAYXUj/yXytQNXhjOvX+iSFN2VGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708026152; c=relaxed/simple;
	bh=ho09oX1do4mzXrqWBSJr5ilm6qkmqz/SYdBf6sn/PDI=;
	h=Date:To:From:Subject:Message-Id; b=dbNxDXqN9g1e04pAak1+6+rDeqXRpgMmmkBYrVPASOYqmrOrGUYnc0xErAw+EDxGcwloOBaIjdm5aNF+2faov3Ap5SZUTX87uuVf4lJrGZFwDSeQia44kLvHtWguzLDyeJJdLqH+9Ya4U22Of32kF3VLivnelq4tuEJisGPCZkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wsRWW+qG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wsRWW+qG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2610FC433C7;
	Thu, 15 Feb 2024 19:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708026152;
	bh=ho09oX1do4mzXrqWBSJr5ilm6qkmqz/SYdBf6sn/PDI=;
	h=Date:To:From:Subject:From;
	b=wsRWW+qGnLiB0XE1xgtc/8o7ua/Cc+CXpqT3ui15/j6r7bIA0ydffOpHYO6h/0FMb
	 NAk4G6UYVqqZTs06mDGnicsmL5fXOhW4t1zd1FCPeQLlgOmjjStNLxhueBuPqLrsYM
	 yt6FQhuQ9otjwanLmVT6cTxVla9w1ExMtyO6r+4A=
Date: Thu, 15 Feb 2024 11:42:31 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,james.morse@arm.com,hpa@zytor.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,apopple@nvidia.com,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-clarify-the-spec-for-set_ptes.patch added to mm-unstable branch
Message-Id: <20240215194232.2610FC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: clarify the spec for set_ptes()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-clarify-the-spec-for-set_ptes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-clarify-the-spec-for-set_ptes.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: clarify the spec for set_ptes()
Date: Thu, 15 Feb 2024 10:31:48 +0000

Patch series "Transparent Contiguous PTEs for User Mappings", v6.

This is a series to opportunistically and transparently use contpte
mappings (set the contiguous bit in ptes) for user memory when those
mappings meet the requirements.  The change benefits arm64, but there is
some (very) minor refactoring for x86 to enable its integration with
core-mm.

It is part of a wider effort to improve performance by allocating and
mapping variable-sized blocks of memory (folios).  One aim is for the 4K
kernel to approach the performance of the 16K kernel, but without breaking
compatibility and without the associated increase in memory.  Another aim
is to benefit the 16K and 64K kernels by enabling 2M THP, since this is
the contpte size for those kernels.  We have good performance data that
demonstrates both aims are being met (see below).

Of course this is only one half of the change.  We require the mapped
physical memory to be the correct size and alignment for this to actually
be useful (i.e.  64K for 4K pages, or 2M for 16K/64K pages).  Fortunately
folios are solving this problem for us.  Filesystems that support it (XFS,
AFS, EROFS, tmpfs, ...) will allocate large folios up to the PMD size
today, and more filesystems are coming.  And for anonymous memory,
"multi-size THP" is now upstream.


Patch Layout
============

In this version, I've split the patches to better show each optimization:

  - 1-2:    mm prep: misc code and docs cleanups
  - 3-6:    mm,arm64,x86 prep: Add pte_advance_pfn() and make pte_next_pfn() a
            generic wrapper around it
  - 7-11:   arm64 prep: Refactor ptep helpers into new layer
  - 12:     functional contpte implementation
  - 23-18:  various optimizations on top of the contpte implementation


Testing
=======

I've tested this series on both Ampere Altra (bare metal) and Apple M2 (VM):
  - mm selftests (inc new tests written for multi-size THP); no regressions
  - Speedometer Java script benchmark in Chromium web browser; no issues
  - Kernel compilation; no issues
  - Various tests under high memory pressure with swap enabled; no issues


Performance
===========

High Level Use Cases
~~~~~~~~~~~~~~~~~~~~

First some high level use cases (kernel compilation and speedometer JavaScript
benchmarks). These are running on Ampere Altra (I've seen similar improvements
on Android/Pixel 6).

baseline:                  mm-unstable (mTHP switched off)
mTHP:                      + enable 16K, 32K, 64K mTHP sizes "always"
mTHP + contpte:            + this series
mTHP + contpte + exefolio: + patch at [6], which series supports

Kernel Compilation with -j8 (negative is faster):

| kernel                    | real-time | kern-time | user-time |
|---------------------------|-----------|-----------|-----------|
| baseline                  |      0.0% |      0.0% |      0.0% |
| mTHP                      |     -5.0% |    -39.1% |     -0.7% |
| mTHP + contpte            |     -6.0% |    -41.4% |     -1.5% |
| mTHP + contpte + exefolio |     -7.8% |    -43.1% |     -3.4% |

Kernel Compilation with -j80 (negative is faster):

| kernel                    | real-time | kern-time | user-time |
|---------------------------|-----------|-----------|-----------|
| baseline                  |      0.0% |      0.0% |      0.0% |
| mTHP                      |     -5.0% |    -36.6% |     -0.6% |
| mTHP + contpte            |     -6.1% |    -38.2% |     -1.6% |
| mTHP + contpte + exefolio |     -7.4% |    -39.2% |     -3.2% |

Speedometer (positive is faster):

| kernel                    | runs_per_min |
|:--------------------------|--------------|
| baseline                  |         0.0% |
| mTHP                      |         1.5% |
| mTHP + contpte            |         3.2% |
| mTHP + contpte + exefolio |         4.5% |


Micro Benchmarks
~~~~~~~~~~~~~~~~

The following microbenchmarks are intended to demonstrate the performance of
fork() and munmap() do not regress. I'm showing results for order-0 (4K)
mappings, and for order-9 (2M) PTE-mapped THP. Thanks to David for sharing his
benchmarks.

baseline:                  mm-unstable + batch zap [7] series
contpte-basic:             + patches 0-19; functional contpte implementation
contpte-batch:             + patches 20-23; implement new batched APIs
contpte-inline:            + patch 24; __always_inline to help compiler
contpte-fold:              + patch 25; fold contpte mapping when sensible

Primary platform is Ampere Altra bare metal. I'm also showing results for M2 VM
(on top of MacOS) for reference, although experience suggests this might not be
the most reliable for performance numbers of this sort:

| FORK           |         order-0        |         order-9        |
| Ampere Altra   |------------------------|------------------------|
| (pte-map)      |       mean |     stdev |       mean |     stdev |
|----------------|------------|-----------|------------|-----------|
| baseline       |       0.0% |      2.7% |       0.0% |      0.2% |
| contpte-basic  |       6.3% |      1.4% |    1948.7% |      0.2% |
| contpte-batch  |       7.6% |      2.0% |      -1.9% |      0.4% |
| contpte-inline |       3.6% |      1.5% |      -1.0% |      0.2% |
| contpte-fold   |       4.6% |      2.1% |      -1.8% |      0.2% |

| MUNMAP         |         order-0        |         order-9        |
| Ampere Altra   |------------------------|------------------------|
| (pte-map)      |       mean |     stdev |       mean |     stdev |
|----------------|------------|-----------|------------|-----------|
| baseline       |       0.0% |      0.5% |       0.0% |      0.3% |
| contpte-basic  |       1.8% |      0.3% |    1104.8% |      0.1% |
| contpte-batch  |      -0.3% |      0.4% |       2.7% |      0.1% |
| contpte-inline |      -0.1% |      0.6% |       0.9% |      0.1% |
| contpte-fold   |       0.1% |      0.6% |       0.8% |      0.1% |

| FORK           |         order-0        |         order-9        |
| Apple M2 VM    |------------------------|------------------------|
| (pte-map)      |       mean |     stdev |       mean |     stdev |
|----------------|------------|-----------|------------|-----------|
| baseline       |       0.0% |      1.4% |       0.0% |      0.8% |
| contpte-basic  |       6.8% |      1.2% |     469.4% |      1.4% |
| contpte-batch  |      -7.7% |      2.0% |      -8.9% |      0.7% |
| contpte-inline |      -6.0% |      2.1% |      -6.0% |      2.0% |
| contpte-fold   |       5.9% |      1.4% |      -6.4% |      1.4% |

| MUNMAP         |         order-0        |         order-9        |
| Apple M2 VM    |------------------------|------------------------|
| (pte-map)      |       mean |     stdev |       mean |     stdev |
|----------------|------------|-----------|------------|-----------|
| baseline       |       0.0% |      0.6% |       0.0% |      0.4% |
| contpte-basic  |       1.6% |      0.6% |     233.6% |      0.7% |
| contpte-batch  |       1.9% |      0.3% |      -3.9% |      0.4% |
| contpte-inline |       2.2% |      0.8% |      -1.6% |      0.9% |
| contpte-fold   |       1.5% |      0.7% |      -1.7% |      0.7% |

Misc
~~~~

John Hubbard at Nvidia has indicated dramatic 10x performance improvements
for some workloads at [8], when using 64K base page kernel.

[1] https://lore.kernel.org/linux-arm-kernel/20230622144210.2623299-1-ryan.roberts@arm.com/
[2] https://lore.kernel.org/linux-arm-kernel/20231115163018.1303287-1-ryan.roberts@arm.com/
[3] https://lore.kernel.org/linux-arm-kernel/20231204105440.61448-1-ryan.roberts@arm.com/
[4] https://lore.kernel.org/lkml/20231218105100.172635-1-ryan.roberts@arm.com/
[5] https://lore.kernel.org/linux-mm/633af0a7-0823-424f-b6ef-374d99483f05@arm.com/
[6] https://lore.kernel.org/lkml/08c16f7d-f3b3-4f22-9acc-da943f647dc3@arm.com/
[7] https://lore.kernel.org/linux-mm/20240214204435.167852-1-david@redhat.com/
[8] https://lore.kernel.org/linux-mm/c507308d-bdd4-5f9e-d4ff-e96e4520be85@nvidia.com/
[9] https://gitlab.arm.com/linux-arm/linux-rr/-/tree/features/granule_perf/contpte-lkml_v6




This patch (of 18):

set_ptes() spec implies that it can only be used to set a present pte
because it interprets the PFN field to increment it.  However,
set_pte_at() has been implemented on top of set_ptes() since set_ptes()
was introduced, and set_pte_at() allows setting a pte to a not-present
state.  So clarify the spec to state that when nr==1, new state of pte may
be present or not present.  When nr>1, new state of all ptes must be
present.

While we are at it, tighten the spec to set requirements around the
initial state of ptes; when nr==1 it may be either present or not-present.
But when nr>1 all ptes must initially be not-present.  All set_ptes()
callsites already conform to this requirement.  Stating it explicitly is
useful because it allows for a simplification to the upcoming arm64
contpte implementation.

Link: https://lkml.kernel.org/r/20240215103205.2607016-1-ryan.roberts@arm.com
Link: https://lkml.kernel.org/r/20240215103205.2607016-2-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Morse <james.morse@arm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/pgtable.h~mm-clarify-the-spec-for-set_ptes
+++ a/include/linux/pgtable.h
@@ -229,6 +229,10 @@ static inline pte_t pte_next_pfn(pte_t p
  * @pte: Page table entry for the first page.
  * @nr: Number of pages to map.
  *
+ * When nr==1, initial state of pte may be present or not present, and new state
+ * may be present or not present. When nr>1, initial state of all ptes must be
+ * not present, and new state must be present.
+ *
  * May be overridden by the architecture, or the architecture can define
  * set_pte() and PFN_PTE_SHIFT.
  *
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

tools-mm-add-thpmaps-script-to-dump-thp-usage-info.patch
arm64-mm-make-set_ptes-robust-when-oas-cross-48-bit-boundary.patch
mm-clarify-the-spec-for-set_ptes.patch
mm-thp-batch-collapse-pmd-with-set_ptes.patch
mm-introduce-pte_advance_pfn-and-use-for-pte_next_pfn.patch
arm64-mm-convert-pte_next_pfn-to-pte_advance_pfn.patch
x86-mm-convert-pte_next_pfn-to-pte_advance_pfn.patch
mm-tidy-up-pte_next_pfn-definition.patch
arm64-mm-convert-read_onceptep-to-ptep_getptep.patch
arm64-mm-convert-set_pte_at-to-set_ptes-1.patch
arm64-mm-convert-ptep_clear-to-ptep_get_and_clear.patch
arm64-mm-new-ptep-layer-to-manage-contig-bit.patch
arm64-mm-split-__flush_tlb_range-to-elide-trailing-dsb.patch
arm64-mm-wire-up-pte_cont-for-user-mappings.patch
arm64-mm-implement-new-wrprotect_ptes-batch-api.patch
arm64-mm-implement-new-clear_full_ptes-batch-apis.patch
mm-add-pte_batch_hint-to-reduce-scanning-in-folio_pte_batch.patch
arm64-mm-implement-pte_batch_hint.patch
arm64-mm-__always_inline-to-improve-fork-perf.patch
arm64-mm-automatically-fold-contpte-mappings.patch

