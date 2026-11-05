Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793852049;
	b=czL0U/v0lRPouLxd7s3hM1qx12PBLqnTg36xBDHrz2S0NmrIQ07GS4+3lKfWMnjzNPj1
	 kl3SKOehzi0r/1exKFSdVdxyQ5uotQblHcm0nMXxnOv/uIYF9L/UQ7kdB9ukBGamEPshN
	 0S2YzXoo4IGBC9DFcKb74BE1eP1ifqsHfAMRYfiS/F3YkipMab7w0FlgBe3b+IzpVZq+k
	 DubzmMWQg9APYbQshqHxC8924rJXwB+poRw54fJaTogsaXHkvGwKU8Sz9tGshfqf2FnhO
	 saFYGB8mgf+GxqWHRNDLFWer27kNGQmc/9SN5Fdru2lD/YrnWGWKSE4dySvn+nhnoLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793852049;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:X-Mailer:
	 Mime-Version:Content-Type:Content-Transfer-Encoding;
	bh=82C0pMCYwMzWMRl19g9H4sTrB8Sq3TP728Ks6dqFnPk=;
	b=jv5dEbnQUbPdmD8OiJ8Yi48Gh3ZdH75jjF63XEW0wjAYH4o7D279bq4e+eR9+u6uD93K
	 +Mh9fM0GSrSQBTJEH81R3nitM1gqQIasteGYHudrE31RrOPfnekTqgK76QJLtVvzZXm5U
	 KsfS9TSOYWUGvzymNRBSiej3nEtr41ADFKkzI8tEwfV2dFA33u0g3hZ41xev+bfkstC9i
	 RevupEYW7xrIwwm8V6rvAVp35ptjkBWp4BCH/aXbjW/TwMQymif6xrjrZeLkSACakqsmW
	 oQnxXvzY3eH7r9DF0uB/6iJ2yL7XM5dbR306Rm538ESUKszj4cqltINEMj/nd9Qj45g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fMuRMBBc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C8D606A326;
	Thu,  5 Nov 2026 04:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fMuRMBBc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9221F1F000C1;
	Thu,  5 Nov 2026 04:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793852048;
	bh=82C0pMCYwMzWMRl19g9H4sTrB8Sq3TP728Ks6dqFnPk=;
	h=Date:From:To:Cc:Subject;
	b=fMuRMBBcxjfVKX72ikgs6rV4/6aNZ4lGc7ylD5catLudQ3gRPolVBNa1TYvP8Kh5p
	 xmgALlpu5IepSZJmD52pmSWeNujLKlM38z42YeFpDDfl9ML2kORZdw6VX+agi+tco/
	 01G5Dhderx4jxQoXw1QrJmcB653YTZDsg0NpaslQ=
Date: Wed, 4 Nov 2026 20:14:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 mm-commits@vger.kernel.org, David Hildenbrand <david@kernel.org>
Subject: [GIT PULL] MM hotfixes for 7.4-rc2
Message-Id: <20261104201408.90579e9988fe725faf3ad859@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this batch of hotfixes, thanks.


The following changes since commit 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4:

  Linux 7.4-rc1 (2026-11-01 13:26:31 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-11-04-20-02

for you to fetch changes up to 19eab4cf787c917bfb7615460933e4ae894af65b:

  MAINTAINERS: move SLAB ALLOCATOR under MEMORY MANAGEMENT (2026-11-02 18:14:50 -0800)

----------------------------------------------------------------
mm.git review status for linus..mm-hotfixes-stable

Everything:

Total patches:       43
Fixes: tags:         42
cc:stable patches:   30
Reviews/patch:       3.67
Reviewed rate:       88%

Excluding DAMON:

Total patches:       40
Fixes: tags:         39
cc:stable patches:   27
Reviews/patch:       3.95
Reviewed rate:       95%

Summary of patch series in this merge:

- "mm: avoid losing atomic VMA flags" (Lorenzo Stoakes):

  Preserve guard-page and soft-dirty state across VMA changes. Prevent
  fork and THP collapse from losing guard markers, and keep changes
  visible to applications which track modified memory.

- "MAINTAINERS: MM updates" (David Hildenbrand):

  Start routing more MM components through mm/core.git and add Zi Yan
  as a THP co-maintainer. Update component coverage and integration
  branches as part of the transition to separate MM component trees.

- "mm/hugetlb: fix mremap bugs" (Li Zhe):

  Fix hugetlb mremap deadlocks and truncated move lengths. Prevent
  userfaultfd poison markers from affecting other processes through
  shared hugetlb page tables.

- "MAINTAINERS updates for page and slab allocators" (Vlastimil Babka):

  Add Johannes Weiner as a page allocator co-maintainer and update
  page and slab allocator entries for their component trees and
  integration through mm/linux.

- "mm/damon: fix three race bugs in sysfs and core" (SJ Park):

  Serialize DAMOS tuning updates and stop monitoring contexts from
  sharing mutable state. Avoid interference between concurrent DAMON
  instances and incorrect auto-tuning.

- "mm: page_alloc: fix reserve access for non-blocking requests"
  (Johannes Weiner):

  Stop ordinary non-blocking allocations from consuming reserves or
  bypassing watermarks. Avoid severe allocation stalls under memory
  pressure and preserve reserves for requests entitled to use them.

- "mm/cma: accept memory of CMA areas reserved with memblock_reserve()"
  (Mike Rapoport):

  Accept memory in fixed-address and multi-range CMA reservations.
  Prevent fatal accesses to these pages in TDX and SEV-SNP guests.

Summary of the 20 singletons in this merge:

Several fixes address crashes and unsafe memory access. Failed THP
collapse now flushes stale translations before releasing pages which
another collapse can free. A truncation race with MADV_DONTNEED could
remove still-mapped shmem pages and hit a kernel BUG. Large-folio
page-table scans no longer wrap addresses and crash near address-space
boundaries. Hugetlb vmemmap optimization no longer causes write faults
from racing reference-count operations. Memory-cgroup teardown is
also protected against reclaim work accessing released state.

KSM now preserves userfaultfd protection during merging and unmerging,
and retains soft-dirty information needed by incremental memory
dumpers. Reads of /proc/PID/maps and related files no longer omit
continuously mapped ranges during concurrent VMA changes. There are
also fixes for expanding mixed mappings with mremap() and querying
NUMA placement with tagged addresses. Swapoff checks for signals while
processing large address spaces and shmem files, so it can be
interrupted without holding up suspend until the whole object is read.

Costly allocations with cheap smaller-order fallbacks avoid direct
reclaim and compaction. Reported arm64 PostgreSQL tests improved from
58,602 to 157,246 transactions per second with defrag_mode disabled;
this addresses a buffered-write regression under fragmentation.
Background reclaim can recover on the highest-numbered memory node
after it has given up, and 32-bit writeback threshold calculations
no longer overflow and assign incorrect dirty-memory limits.

----------------------------------------------------------------
Baolin Wang (1):
      mm: memory: fix truncation removing mapped folios

Chris Down (1):
      mm: make swapoff interruptible when unusing mms/shmem

Danish Khateeb (1):
      selftests/mm: merge: keep the far mremap() targets in the carveout

David Hildenbrand (Arm) (11):
      mm: fix address wraparound when scanning large folio PTEs
      mm/hugetlb: disable PMD sharing for UFFD missing mode
      mm/vma: write lock source VMA before duplicating it in __split_vma()
      mm/madvise: preserve VMA_SOFTDIRTY_BIT when changing anonymous names
      MAINTAINERS: mention for-next branch in MEMORY MANAGEMENT - MEMORY MAP
      MAINTAINERS: TMPFS (SHMEM FILESYSTEM) updates
      MAINTAINERS: add Zi Yan as co-maintainer for MEMORY MANAGEMENT - THP
      MAINTAINERS: sort entries in MM sections
      MAINTAINERS: add missing files to MM component sections
      MAINTAINERS: rename and move MEMORY HOT(UN)PLUG
      MAINTAINERS: route more MM changes through mm/core.git

Gregory Price (Meta) (1):
      mm/page_alloc: let the highest memory node recover from hopeless state

Hengyu Liang (1):
      fs/proc/task_mmu: return -ENOTTY for unknown pagemap ioctls

Hungyu Lin (2):
      mm/page-writeback: avoid 32-bit overflow in dirty threshold shares
      mm/migrate: untag addresses when querying page nodes

Johannes Weiner (2):
      mm: page_alloc: do not give all non-blocking requests reserve access
      mm: page_alloc: remove ALLOC_NON_BLOCK from ALLOC_RESERVES

Kiryl Shutsemau (Meta) (1):
      mm/hugetlb_vmemmap: map the shared tail page writable

Kyle Zeng (1):
      mm/khugepaged: flush deferred unmaps before dropping a failed folio

Lance Yang (1):
      mm/ksm: fix userfaultfd protection during merge and unmerge

Li Zhe (2):
      mm/hugetlb: fix mremap move length truncation
      mm/hugetlb: fix mremap deadlock when PMD sharing is possible

Lorenzo Stoakes (ARM) (5):
      mm/vma: fix expansion of VMA_MIXEDMAP_BIT VMAs
      mm: do not unintentionally overwrite atomic VMA flags
      mm/vma: avoid losing atomic VMA flags when setting sticky VMA flags
      mm/vma: update VMA iterator state on error in new VMA merge
      fs/proc/task_mmu: fix missed VMAs when reading /proc/PID/maps and friends

Mike Rapoport (Microsoft) (2):
      mm/cma: accept memory of multi-range CMA areas
      mm/cma: accept memory of CMA areas reserved at a fixed address

SJ Park (3):
      mm/damon/sysfs-schemes: hold damon_sysfs_lock in target_metric_store()
      mm/damon/core: move static variable last_nr_regions to damon_ctx
      mm/damon/core: move static variable rotation to damon_ctx

Salvatore Dipietro (1):
      mm/page_alloc: avoid direct reclaim and compaction for costly __GFP_NORETRY allocations

Samarth Narang (1):
      mm/ksm: keep soft-dirty when merging a page

T.J. Mercier (1):
      mm: memcontrol: fix NULL pointer deref and UAF from high_work_func() on dying memcg

Vlastimil Babka (SUSE) (2):
      MAINTAINERS: add Johannes as the page allocator co-maintainer
      MAINTAINERS: move SLAB ALLOCATOR under MEMORY MANAGEMENT

Yafang Shao (1):
      mm/migrate: snapshot the source nid before the misplaced migration

Zenghui Yu (Huawei) (2):
      mm/page_alloc: mark pages freed by __free_pages_core() as not tagged
      selftests/mm: fix khugepaged_race build with older glibc

 Documentation/mm/vmemmap_dedup.rst           |  15 +-
 MAINTAINERS                                  | 224 ++++++++++++++++-----------
 fs/proc/internal.h                           |   1 +
 fs/proc/task_mmu.c                           |  15 +-
 include/linux/damon.h                        |  10 ++
 include/linux/hugetlb.h                      |  15 +-
 include/linux/mm.h                           | 166 ++++++++++----------
 include/linux/mmap_lock.h                    |  22 ++-
 include/linux/userfaultfd_k.h                |  16 +-
 mm/cma.c                                     |   4 +
 mm/damon/core.c                              |  10 +-
 mm/damon/sysfs-schemes.c                     |   3 +
 mm/hugetlb.c                                 |  55 +++++--
 mm/hugetlb_vmemmap.c                         |   8 +-
 mm/internal.h                                |  10 +-
 mm/khugepaged.c                              |  10 +-
 mm/ksm.c                                     |  10 ++
 mm/madvise.c                                 |  10 +-
 mm/memcontrol.c                              |   5 +
 mm/memory.c                                  |  99 ++++++++----
 mm/migrate.c                                 |   5 +-
 mm/mlock.c                                   |   6 +-
 mm/mm_init.c                                 |   2 -
 mm/mmap_lock.c                               |  61 ++++++--
 mm/mprotect.c                                |   2 +-
 mm/page-writeback.c                          |   8 +-
 mm/page_alloc.c                              |  30 +++-
 mm/page_alloc.h                              |  14 +-
 mm/shmem.c                                   |   4 +
 mm/swapfile.c                                |   4 +-
 mm/vma.c                                     | 104 ++++++++-----
 mm/vma_init.c                                |   3 +
 tools/testing/selftests/mm/khugepaged_race.c |   1 +
 tools/testing/selftests/mm/merge.c           |  33 ++--
 tools/testing/vma/include/dup.h              |  83 ++++++----
 tools/testing/vma/include/stubs.h            |   2 +-
 tools/testing/vma/shared.h                   |  16 +-
 37 files changed, 682 insertions(+), 404 deletions(-)

