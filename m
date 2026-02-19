Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2C91990C7;
	Thu, 19 Feb 2026 04:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771473618; cv=none; b=STOqnJHw3TPZcdq8b+bO+3/cLDlCE+b0Ql/KbQrq7G3DvLwuoVpeYF6be9MAAxzovE+QvCfgTLWKuP+UAr96B5iU83MjmyP+nf2eIFFNI8bdVA+K+bTR6S5M2dP5msugMmS6Ufq0jBP+zIYvCmYdN3gHG3+jG3UB3nPN1zqC1Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771473618; c=relaxed/simple;
	bh=Q07e9JWLPcdyFieUY5FhpW1TNpE6sewdegz7THN/6Sk=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=I9KhJKPprTgO4gj+fBWgahrTR5Kgah1rNTRJllCVToEnQYuceHg3yt4ZiUAvKWXGs2MFnrHx+DWmqxYQZA0vdYjWYjyt5nKJ2Kr+sYBF/WfsNzw5SpCaR88MiKd9hIOLbeVoHkOjJgFOX5J9OmOEVUKrw+Dy7N4sJT91kEDXjds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K+w38PHc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K+w38PHc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64817C4CEF7;
	Thu, 19 Feb 2026 04:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771473617;
	bh=Q07e9JWLPcdyFieUY5FhpW1TNpE6sewdegz7THN/6Sk=;
	h=Date:From:To:Cc:Subject:From;
	b=K+w38PHc+bv1mv3yCOnpllbLE2dUdFhZ54/RLC7uRCkcg6shTQV/O4YXUKFpIIZyM
	 2+0x1kXQg3faoXulpsYnGPAtVqyoRb0AGG6vUKhctNANLAegC6pKo23KgUay7bfiD/
	 WfdG4vqmH5pqMwfwmFwNR6C4uiTCOWDedg/CkpF0=
Date: Wed, 18 Feb 2026 20:00:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: {GIT PULL] additional MM updates for 7.0-rc1
Message-Id: <20260218200016.8906fb904af9439e7b496327@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this second and final batch of MM updates for the
7.0-rcX cycle, thanks.

Merge conflicts which I'm seeing and their possible resolutions are:

drivers/gpu/drm/i915/gem/i915_gem_shmem.c
	https://lkml.kernel.org/r/aXerLzIbpMy9d4lx@sirena.org.uk

fs/ntfs3/file.c
	https://lkml.kernel.org/r/aXeZNSiVv82Gc9HF@sirena.org.uk



The following changes since commit fb4ddf2085115ed28dedc427d9491707b476bbfe:

  mm/memory: handle non-split locks correctly in zap_empty_pte_table() (2026-02-06 15:47:19 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-02-18-19-48

for you to fetch changes up to ac1ea219590c09572ed5992dc233bbf7bb70fef9:

  mm/page_alloc: clear page->private in free_pages_prepare() (2026-02-12 15:43:02 -0800)

----------------------------------------------------------------
mm.git review status for linus..mm-stable

Total patches:       36
Reviews/patch:       1.77
Reviewed rate:       83%

- The 2 patch series "mm/vmscan: fix demotion targets checks in
  reclaim/demotion" from Bing Jiao fixes a couple of issues in the
  demotion code - pages were failed demotion and were finding themselves
  demoted into disallowed nodes.

- The 11 patch series "Remove XA_ZERO from error recovery of dup_mmap()"
  from Liam Howlett fixes a rare mapledtree race and performs a number of
  cleanups.

- The 13 patch series "mm: add bitmap VMA flag helpers and convert all
  mmap_prepare to use them" from Lorenzo Stoakes implements a lot of
  cleanups following on from the conversion of the VMA flags into a
  bitmap.

- The 5 patch series "support batch checking of references and unmapping
  for large folios" from Baolin Wang implements batching to greatly
  improve the performance of reclaiming clean file-backed large folios.

- The 3 patch series "selftests/mm: add memory failure selftests" from
  Miaohe Lin does as claimed.

----------------------------------------------------------------
Ankur Arora (1):
      mm: folio_zero_user: open code range computation in folio_zero_user()

Baolin Wang (5):
      mm: rmap: support batched checks of the references for large folios
      arm64: mm: factor out the address and ptep alignment into a new helper
      arm64: mm: support batch clearing of the young flag for large folios
      arm64: mm: implement the architecture-specific clear_flush_young_ptes()
      mm: rmap: support batched unmapping for file large folios

Bing Jiao (2):
      mm/vmscan: fix demotion targets checks in reclaim/demotion
      mm/vmscan: select the closest preferred node in demote_folio_list()

Liam R. Howlett (11):
      mm: relocate the page table ceiling and floor definitions
      mm/mmap: move exit_mmap() trace point
      mm/mmap: abstract vma clean up from exit_mmap()
      mm/vma: add limits to unmap_region() for vmas
      mm/memory: add tree limit to free_pgtables()
      mm/vma: add page table limit to unmap_region()
      mm: change dup_mmap() recovery
      mm: introduce unmap_desc struct to reduce function arguments
      mm/vma: use unmap_desc in exit_mmap() and vms_clear_ptes()
      mm/vma: use unmap_region() in vms_clear_ptes()
      mm: use unmap_desc struct for freeing page tables

Lorenzo Stoakes (13):
      mm/vma: remove __private sparse decoration from vma_flags_t
      mm: rename vma_flag_test/set_atomic() to vma_test/set_atomic_flag()
      mm: add mk_vma_flags() bitmap flag macro helper
      tools: bitmap: add missing bitmap_[subset(), andnot()]
      mm: add basic VMA flag operation helper functions
      mm: update hugetlbfs to use VMA flags on mmap_prepare
      mm: update secretmem to use VMA flags on mmap_prepare
      mm: update shmem_[kernel]_file_*() functions to use vma_flags_t
      mm: update all remaining mmap_prepare users to use vma_flags_t
      mm: make vm_area_desc utilise vma_flags_t only
      tools/testing/vma: separate VMA userland tests into separate files
      tools/testing/vma: separate out vma_internal.h into logical headers
      tools/testing/vma: add VMA userland tests for VMA flag functions

Miaohe Lin (3):
      selftests/mm: add memory failure anonymous page test
      selftests/mm: add memory failure clean pagecache test
      selftests/mm: add memory failure dirty pagecache test

Mikhail Gavrilov (1):
      mm/page_alloc: clear page->private in free_pages_prepare()

 MAINTAINERS                                       |    1 +
 arch/arm64/include/asm/pgtable.h                  |   23 +-
 arch/arm64/mm/contpte.c                           |   62 +-
 arch/x86/kernel/cpu/sgx/ioctl.c                   |    2 +-
 drivers/char/mem.c                                |    6 +-
 drivers/dax/device.c                              |   10 +-
 drivers/gpu/drm/drm_gem.c                         |    5 +-
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c         |    2 +-
 drivers/gpu/drm/i915/gem/i915_gem_ttm.c           |    3 +-
 drivers/gpu/drm/i915/gt/shmem_utils.c             |    3 +-
 drivers/gpu/drm/ttm/tests/ttm_tt_test.c           |    2 +-
 drivers/gpu/drm/ttm/ttm_backup.c                  |    3 +-
 drivers/gpu/drm/ttm/ttm_tt.c                      |    2 +-
 fs/aio.c                                          |    2 +-
 fs/erofs/data.c                                   |    5 +-
 fs/ext4/file.c                                    |    4 +-
 fs/hugetlbfs/inode.c                              |   14 +-
 fs/ntfs3/file.c                                   |    2 +-
 fs/orangefs/file.c                                |    4 +-
 fs/ramfs/file-nommu.c                             |    2 +-
 fs/resctrl/pseudo_lock.c                          |    2 +-
 fs/romfs/mmap-nommu.c                             |    2 +-
 fs/xfs/scrub/xfile.c                              |    3 +-
 fs/xfs/xfs_buf_mem.c                              |    2 +-
 fs/xfs/xfs_file.c                                 |    4 +-
 fs/zonefs/file.c                                  |    3 +-
 include/linux/cpuset.h                            |    6 +-
 include/linux/dax.h                               |    8 +-
 include/linux/hugetlb.h                           |    6 +-
 include/linux/hugetlb_inline.h                    |   10 +
 include/linux/memcontrol.h                        |    6 +-
 include/linux/memory-tiers.h                      |    6 +-
 include/linux/mm.h                                |  252 ++-
 include/linux/mm_types.h                          |   23 +-
 include/linux/mmu_notifier.h                      |    9 +-
 include/linux/pgtable.h                           |   73 +-
 include/linux/shmem_fs.h                          |    8 +-
 ipc/shm.c                                         |   12 +-
 kernel/cgroup/cpuset.c                            |   54 +-
 kernel/relay.c                                    |    2 +-
 mm/filemap.c                                      |    2 +-
 mm/hugetlb.c                                      |   22 +-
 mm/internal.h                                     |   10 +-
 mm/khugepaged.c                                   |    2 +-
 mm/madvise.c                                      |    2 +-
 mm/memcontrol.c                                   |   16 +-
 mm/memfd.c                                        |    6 +-
 mm/memory-tiers.c                                 |   21 +-
 mm/memory.c                                       |  101 +-
 mm/mmap.c                                         |  110 +-
 mm/mremap.c                                       |    2 +-
 mm/page_alloc.c                                   |    1 +
 mm/rmap.c                                         |   38 +-
 mm/secretmem.c                                    |    7 +-
 mm/shmem.c                                        |   61 +-
 mm/util.c                                         |    2 +-
 mm/vma.c                                          |   67 +-
 mm/vma.h                                          |   73 +-
 mm/vma_internal.h                                 |    1 +
 mm/vmscan.c                                       |   31 +-
 security/keys/big_key.c                           |    2 +-
 tools/include/linux/bitmap.h                      |   22 +
 tools/lib/bitmap.c                                |   29 +
 tools/testing/selftests/mm/.gitignore             |    1 +
 tools/testing/selftests/mm/Makefile               |    2 +
 tools/testing/selftests/mm/config                 |    2 +
 tools/testing/selftests/mm/ksft_memory_failure.sh |    4 +
 tools/testing/selftests/mm/memory-failure.c       |  359 ++++
 tools/testing/selftests/mm/run_vmtests.sh         |   21 +
 tools/testing/selftests/mm/vm_util.c              |   41 +
 tools/testing/selftests/mm/vm_util.h              |    3 +
 tools/testing/vma/Makefile                        |    7 +-
 tools/testing/vma/include/custom.h                |  119 ++
 tools/testing/vma/include/dup.h                   | 1320 +++++++++++++++
 tools/testing/vma/include/stubs.h                 |  428 +++++
 tools/testing/vma/main.c                          |   55 +
 tools/testing/vma/shared.c                        |  131 ++
 tools/testing/vma/shared.h                        |  114 ++
 tools/testing/vma/{vma.c => tests/merge.c}        |  332 +---
 tools/testing/vma/tests/mmap.c                    |   57 +
 tools/testing/vma/tests/vma.c                     |  339 ++++
 tools/testing/vma/vma_internal.h                  | 1847 +--------------------
 82 files changed, 3939 insertions(+), 2519 deletions(-)
 create mode 100755 tools/testing/selftests/mm/ksft_memory_failure.sh
 create mode 100644 tools/testing/selftests/mm/memory-failure.c
 create mode 100644 tools/testing/vma/include/custom.h
 create mode 100644 tools/testing/vma/include/dup.h
 create mode 100644 tools/testing/vma/include/stubs.h
 create mode 100644 tools/testing/vma/main.c
 create mode 100644 tools/testing/vma/shared.c
 create mode 100644 tools/testing/vma/shared.h
 rename tools/testing/vma/{vma.c => tests/merge.c} (82%)
 create mode 100644 tools/testing/vma/tests/mmap.c
 create mode 100644 tools/testing/vma/tests/vma.c

