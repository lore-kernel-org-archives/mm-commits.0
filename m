Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F94284B2E
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126258; cv=none; b=ctCXJBrDzkpDoHaPhLAkc7HYZqungFjd97GecM9ws9ZHK1f5/dXnmPo2a9q5n8PX4y0X7cb7j8ZqACimVjOdtavJZrztsRkD5su48Cn9xtGdgHmaWoSgaP3ZEtCYGq17zjkh1vETATwX6KOUWTFx23hmStt65zyH2SD2dCPd4BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126258; c=relaxed/simple;
	bh=Wf4lotJ2SsWSFTIu+2O3h2f727FB4EkooBn7AnKB9OI=;
	h=Date:To:From:Subject:Message-Id; b=ojBa7Fkg/SRI8lTOMD4f+h1lfaTZ/BQaIS01jok61d+2I5rQeCAsQIyULjWQ/8HILfLuEFjeXo6ff+o7yEu452mEItcb5sBOZ9LwFaaWSzwIA9vir88MT7z7tv8MEDPEC3f9KJoj/mM0EKb1Bm7wl22REpq0Je85fH0V7GQrxq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AXtCHrs8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AXtCHrs8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2D3C4CEE3;
	Thu, 10 Jul 2025 05:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126257;
	bh=Wf4lotJ2SsWSFTIu+2O3h2f727FB4EkooBn7AnKB9OI=;
	h=Date:To:From:Subject:From;
	b=AXtCHrs8ecvmzb1Yx2P3SE/47r0EgmfjpaYnIkA+58Uo9qrBn7VsCVUWykTiLUlfM
	 Q7JD1ARqbKwDzRWBe700cZ5l9Akly9mssI90DuM11BvEJMtDu51gf+gzuKcwJiRbAB
	 HSKBMNc470WBtU2QcA9ZDuN6y16tYUKOCx2abLXo=
Date: Wed, 09 Jul 2025 22:44:16 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,jack@suse.cz,david@redhat.com,chaitanyas.prakash@arm.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-filemap-allow-arch-to-request-folio-size-for-exec-memory.patch removed from -mm tree
Message-Id: <20250710054417.7B2D3C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/filemap: allow arch to request folio size for exec memory
has been removed from the -mm tree.  Its filename was
     mm-filemap-allow-arch-to-request-folio-size-for-exec-memory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm/filemap: allow arch to request folio size for exec memory
Date: Mon, 9 Jun 2025 10:27:27 +0100

Change the readahead config so that if it is being requested for an
executable mapping, do a synchronous read into a set of folios with an
arch-specified order and in a naturally aligned manner.  We no longer
center the read on the faulting page but simply align it down to the
previous natural boundary.  Additionally, we don't bother with an
asynchronous part.

On arm64 if memory is physically contiguous and naturally aligned to the
"contpte" size, we can use contpte mappings, which improves utilization of
the TLB.  When paired with the "multi-size THP" feature, this works well
to reduce dTLB pressure.  However iTLB pressure is still high due to
executable mappings having a low likelihood of being in the required folio
size and mapping alignment, even when the filesystem supports readahead
into large folios (e.g.  XFS).

The reason for the low likelihood is that the current readahead algorithm
starts with an order-0 folio and increases the folio order by 2 every time
the readahead mark is hit.  But most executable memory tends to be
accessed randomly and so the readahead mark is rarely hit and most
executable folios remain order-0.

So let's special-case the read(ahead) logic for executable mappings.  The
trade-off is performance improvement (due to more efficient storage of the
translations in iTLB) vs potential for making reclaim more difficult (due
to the folios being larger so if a part of the folio is hot the whole
thing is considered hot).  But executable memory is a small portion of the
overall system memory so I doubt this will even register from a reclaim
perspective.

I've chosen 64K folio size for arm64 which benefits both the 4K and 16K
base page size configs.  Crucially the same amount of data is still read
(usually 128K) so I'm not expecting any read amplification issues.  I
don't anticipate any write amplification because text is always RO.

Note that the text region of an ELF file could be populated into the page
cache for other reasons than taking a fault in a mmapped area.  The most
common case is due to the loader read()ing the header which can be shared
with the beginning of text.  So some text will still remain in small
folios, but this simple, best effort change provides good performance
improvements as is.

Confine this special-case approach to the bounds of the VMA.  This
prevents wasting memory for any padding that might exist in the file
between sections.  Previously the padding would have been contained in
order-0 folios and would be easy to reclaim.  But now it would be part of
a larger folio so more difficult to reclaim.  Solve this by simply not
reading it into memory in the first place.

Benchmarking
============

The below shows pgbench and redis benchmarks on Graviton3 arm64 system.

First, confirmation that this patch causes more text to be contained in
64K folios:

+----------------------+---------------+---------------+---------------+
| File-backed folios by|  system boot  |    pgbench    |     redis     |
| size as percentage of+-------+-------+-------+-------+-------+-------+
| all mapped text mem  |before | after |before | after |before | after |
+======================+=======+=======+=======+=======+=======+=======+
| base-page-4kB        |   78% |   30% |   78% |   11% |   73% |   14% |
| thp-aligned-8kB      |    1% |    0% |    0% |    0% |    1% |    0% |
| thp-aligned-16kB     |   17% |    4% |   17% |    3% |   20% |    4% |
| thp-aligned-32kB     |    1% |    1% |    1% |    2% |    1% |    1% |
| thp-aligned-64kB     |    3% |   63% |    3% |   81% |    4% |   77% |
| thp-aligned-128kB    |    0% |    1% |    1% |    1% |    1% |    2% |
| thp-unaligned-64kB   |    0% |    0% |    0% |    1% |    0% |    1% |
| thp-unaligned-128kB  |    0% |    1% |    0% |    0% |    0% |    0% |
| thp-partial          |    0% |    0% |    0% |    1% |    0% |    1% |
+----------------------+-------+-------+-------+-------+-------+-------+
| cont-aligned-64kB    |    4% |   65% |    4% |   83% |    6% |   79% |
+----------------------+-------+-------+-------+-------+-------+-------+

The above shows that for both workloads (each isolated with cgroups) as
well as the general system state after boot, the amount of text backed by
4K and 16K folios reduces and the amount backed by 64K folios increases
significantly.  And the amount of text that is contpte-mapped
significantly increases (see last row).

And this is reflected in performance improvement.  "(I)" indicates a
statistically significant improvement.  Note TPS and Reqs/sec are rates so
bigger is better, ms is time so smaller is better:

+-------------+-------------------------------------------+------------+
| Benchmark   | Result Class                              | Improvemnt |
+=============+===========================================+============+
| pts/pgbench | Scale: 1 Clients: 1 RO (TPS)              |  (I) 3.47% |
|             | Scale: 1 Clients: 1 RO - Latency (ms)     |     -2.88% |
|             | Scale: 1 Clients: 250 RO (TPS)            |  (I) 5.02% |
|             | Scale: 1 Clients: 250 RO - Latency (ms)   | (I) -4.79% |
|             | Scale: 1 Clients: 1000 RO (TPS)           |  (I) 6.16% |
|             | Scale: 1 Clients: 1000 RO - Latency (ms)  | (I) -5.82% |
|             | Scale: 100 Clients: 1 RO (TPS)            |      2.51% |
|             | Scale: 100 Clients: 1 RO - Latency (ms)   |     -3.51% |
|             | Scale: 100 Clients: 250 RO (TPS)          |  (I) 4.75% |
|             | Scale: 100 Clients: 250 RO - Latency (ms) | (I) -4.44% |
|             | Scale: 100 Clients: 1000 RO (TPS)         |  (I) 6.34% |
|             | Scale: 100 Clients: 1000 RO - Latency (ms)| (I) -5.95% |
+-------------+-------------------------------------------+------------+
| pts/redis   | Test: GET Connections: 50 (Reqs/sec)      |  (I) 3.20% |
|             | Test: GET Connections: 1000 (Reqs/sec)    |  (I) 2.55% |
|             | Test: LPOP Connections: 50 (Reqs/sec)     |  (I) 4.59% |
|             | Test: LPOP Connections: 1000 (Reqs/sec)   |  (I) 4.81% |
|             | Test: LPUSH Connections: 50 (Reqs/sec)    |  (I) 5.31% |
|             | Test: LPUSH Connections: 1000 (Reqs/sec)  |  (I) 4.36% |
|             | Test: SADD Connections: 50 (Reqs/sec)     |  (I) 2.64% |
|             | Test: SADD Connections: 1000 (Reqs/sec)   |  (I) 4.15% |
|             | Test: SET Connections: 50 (Reqs/sec)      |  (I) 3.11% |
|             | Test: SET Connections: 1000 (Reqs/sec)    |  (I) 3.36% |
+-------------+-------------------------------------------+------------+

[ryan.roberts@arm.com: fix use-after-free]
  Link: https://lkml.kernel.org/r/ea7f9da7-9a9f-4b85-9d0a-35b320f5ed25@arm.com
[ryan.roberts@arm.com: use the vma_pages() helper instead of open-coding]
  Link: https://lkml.kernel.org/r/0e0f674b-3b7e-494f-ae7a-fc9dbb98dad4@arm.com
Link: https://lkml.kernel.org/r/20250609092729.274960-6-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Will Deacon <will@kernel.org>
Cc: Chaitanya S Prakash <chaitanyas.prakash@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |    8 ++++
 include/linux/pgtable.h          |   11 ++++++
 mm/filemap.c                     |   48 +++++++++++++++++++++++------
 3 files changed, 58 insertions(+), 9 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-filemap-allow-arch-to-request-folio-size-for-exec-memory
+++ a/arch/arm64/include/asm/pgtable.h
@@ -1643,6 +1643,14 @@ static inline void update_mmu_cache_rang
  */
 #define arch_wants_old_prefaulted_pte	cpu_has_hw_af
 
+/*
+ * Request exec memory is read into pagecache in at least 64K folios. This size
+ * can be contpte-mapped when 4K base pages are in use (16 pages into 1 iTLB
+ * entry), and HPA can coalesce it (4 pages into 1 TLB entry) when 16K base
+ * pages are in use.
+ */
+#define exec_folio_order() ilog2(SZ_64K >> PAGE_SHIFT)
+
 static inline bool pud_sect_supported(void)
 {
 	return PAGE_SIZE == SZ_4K;
--- a/include/linux/pgtable.h~mm-filemap-allow-arch-to-request-folio-size-for-exec-memory
+++ a/include/linux/pgtable.h
@@ -456,6 +456,17 @@ static inline bool arch_has_hw_pte_young
 }
 #endif
 
+#ifndef exec_folio_order
+/*
+ * Returns preferred minimum folio order for executable file-backed memory. Must
+ * be in range [0, PMD_ORDER). Default to order-0.
+ */
+static inline unsigned int exec_folio_order(void)
+{
+	return 0;
+}
+#endif
+
 #ifndef arch_check_zapped_pte
 static inline void arch_check_zapped_pte(struct vm_area_struct *vma,
 					 pte_t pte)
--- a/mm/filemap.c~mm-filemap-allow-arch-to-request-folio-size-for-exec-memory
+++ a/mm/filemap.c
@@ -3238,8 +3238,11 @@ static struct file *do_sync_mmap_readahe
 	}
 #endif
 
-	/* If we don't want any read-ahead, don't bother */
-	if (vm_flags & VM_RAND_READ)
+	/*
+	 * If we don't want any read-ahead, don't bother. VM_EXEC case below is
+	 * already intended for random access.
+	 */
+	if ((vm_flags & (VM_RAND_READ | VM_EXEC)) == VM_RAND_READ)
 		return fpin;
 	if (!ra->ra_pages)
 		return fpin;
@@ -3262,14 +3265,41 @@ static struct file *do_sync_mmap_readahe
 	if (mmap_miss > MMAP_LOTSAMISS)
 		return fpin;
 
-	/*
-	 * mmap read-around
-	 */
+	if (vm_flags & VM_EXEC) {
+		/*
+		 * Allow arch to request a preferred minimum folio order for
+		 * executable memory. This can often be beneficial to
+		 * performance if (e.g.) arm64 can contpte-map the folio.
+		 * Executable memory rarely benefits from readahead, due to its
+		 * random access nature, so set async_size to 0.
+		 *
+		 * Limit to the boundaries of the VMA to avoid reading in any
+		 * pad that might exist between sections, which would be a waste
+		 * of memory.
+		 */
+		struct vm_area_struct *vma = vmf->vma;
+		unsigned long start = vma->vm_pgoff;
+		unsigned long end = start + vma_pages(vma);
+		unsigned long ra_end;
+
+		ra->order = exec_folio_order();
+		ra->start = round_down(vmf->pgoff, 1UL << ra->order);
+		ra->start = max(ra->start, start);
+		ra_end = round_up(ra->start + ra->ra_pages, 1UL << ra->order);
+		ra_end = min(ra_end, end);
+		ra->size = ra_end - ra->start;
+		ra->async_size = 0;
+	} else {
+		/*
+		 * mmap read-around
+		 */
+		ra->start = max_t(long, 0, vmf->pgoff - ra->ra_pages / 2);
+		ra->size = ra->ra_pages;
+		ra->async_size = ra->ra_pages / 4;
+		ra->order = 0;
+	}
+
 	fpin = maybe_unlock_mmap_for_io(vmf, fpin);
-	ra->start = max_t(long, 0, vmf->pgoff - ra->ra_pages / 2);
-	ra->size = ra->ra_pages;
-	ra->async_size = ra->ra_pages / 4;
-	ra->order = 0;
 	ractl._index = ra->start;
 	page_cache_ra_order(&ractl, ra);
 	return fpin;
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-remove-arch_flush_tlb_batched_pending-arch-helper.patch

