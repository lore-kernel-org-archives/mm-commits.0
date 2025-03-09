Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414084C7C;
	Sun,  9 Mar 2025 00:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741480207; cv=none; b=mBpeDQMMwpAV3ixaZ3d7A7bc19ztBamew1z2fQqGGKpUkVHH04cLieM8V7H4u7UtqXYk4NQTcflz9nDuZswJLG+4WKj3QCXLm0rfkl1LJo7WYZfZH/4ZXkaEfyUwR5VTpQf1I3qj0v8Mpc6GLJJ4l4BuiEj6Vve3Oh2kiwUnFtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741480207; c=relaxed/simple;
	bh=aMolwN56vF2dftuMD+Bec1QBO1irjOfXAUGJ0/PDgfk=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=LOgZg8gauvEV/XvBCW1/Kq8kXiYr5TN5NqVXap60s8hgmMoYhnu2Ffn8B53iKeAdRbQjE9jZLwnUTAuuZVCfh3gGReJuq8I7hCjuiCXnAM3Aiu+8qYUzxEHHtAEvjpDkio7cjEXL1dsDUta9UKodIt7CzLB905lwiu7eKpQlsU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TtNcHS+Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TtNcHS+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC48C4CEE0;
	Sun,  9 Mar 2025 00:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741480206;
	bh=aMolwN56vF2dftuMD+Bec1QBO1irjOfXAUGJ0/PDgfk=;
	h=Date:From:To:Cc:Subject:From;
	b=TtNcHS+ZAaw0oWdNaW8cHdE6L5BWVwfSrp+G7KHXAmk6KNHui5BTmAzBqSIWR7lzE
	 f9MdzCfACs6AAe0CwgLZIUSqDa2mwfyescncViNdfu8OaVXX5M9/xV3oUqfJndflPR
	 9h3Pza3QjWOpvaBnMUKD9rH5pu2ajb17cUDYLPlM=
Date: Sat, 8 Mar 2025 16:30:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: [GIT PULL] hotfixes for 6.14-rcc6
Message-Id: <20250308163005.6af4c2fc9651b33f4b0d326d@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable


Linus, pleae merge this batch of hotfixes, thanks.


The following changes since commit 8344017aaf32a7532cff293eb3df7fd2265ebafd:

  test_xarray: fix failure in check_pause when CONFIG_XARRAY_MULTI is not d=
efined (2025-02-17 22:40:04 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-st=
able-2025-03-08-16-27

for you to fetch changes up to 8fe9ed44dc29fba0786b7e956d2e87179e407582:

  mm/page_alloc: fix uninitialized variable (2025-03-05 21:36:20 -0800)

----------------------------------------------------------------
33 hotfixes.  24 are cc:stable and the remainder address post-6.13 issues
or aren't considered necessary for -stable kernels.

26 are for MM and 7 are for non-MM.

- "mm: memory_failure: unmap poisoned folio during migrate properly"
  from Ma Wupeng fixes a couple of two year old bugs involving the
  migration of hwpoisoned folios.

- "selftests/damon: three fixes for false results" from SeongJae Park
  fixes three one year old bugs in the SAMON selftest code.

The remainder are singletons and doubletons.  Please see the individual
changelogs for details.

----------------------------------------------------------------
Baolin Wang (1):
      mm: shmem: fix potential data corruption during shmem swapin

Barry Song (1):
      mm: fix kernel BUG when userfaultfd_move encounters swapcache

Brian Geffon (1):
      mm: fix finish_fault() handling for large folios

Gabriel Krisman Bertazi (1):
      Revert "mm/page_alloc.c: don't show protection in zone's ->lowmem_res=
erve[] for empty zone"

Ge Yang (1):
      mm/hugetlb: wait for hugetlb folios to be freed

Hao Zhang (1):
      mm/page_alloc: fix uninitialized variable

Haoxiang Li (3):
      m68k: sun3: add check for __pgd_alloc()
      rapidio: fix an API misues when rio_add_net() fails
      rapidio: add check for rio_add_net() in rio_scan_alloc_net()

John Hubbard (1):
      Revert "selftests/mm: remove local __NR_* definitions"

Kemeng Shi (3):
      mm: swap: add back full cluster when no entry is reclaimed
      mm: swap: use correct step in loop to wait all clusters in wait_for_a=
llocation()
      mm, swap: avoid BUG_ON in relocate_cluster()

Lorenzo Stoakes (1):
      mm: abort vma_modify() on merge out of memory failure

Ma Wupeng (3):
      mm: memory-failure: update ttu flag inside unmap_poisoned_folio
      mm: memory-hotplug: check folio ref count first in do_migrate_range
      hwpoison, memory_hotplug: lock folio before unmap hwpoisoned folio

Mike Snitzer (1):
      NFS: fix nfs_release_folio() to not deadlock via kcompactd writeback

Qi Zheng (1):
      arm: pgtable: fix NULL pointer dereference issue

Ricardo Ca=F1uelo Navarro (1):
      mm: shmem: remove unnecessary warning in shmem_writepage()

Ryan Roberts (1):
      mm: don't skip arch_sync_kernel_mappings() in error paths

Sebastian Andrzej Siewior (1):
      dma: kmsan: export kmsan_handle_dma() for modules

SeongJae Park (4):
      selftests/damon/damos_quota_goal: handle minimum quota that cannot be=
 further reduced
      selftests/damon/damos_quota: make real expectation of quota exceeds
      selftests/damon/damon_nr_regions: set ops update for merge results ch=
eck to 100ms
      selftests/damon/damon_nr_regions: sort collected regiosn before check=
ing with min/max boundaries

Su Hui (1):
      include/linux/log2.h: mark is_power_of_2() with __always_inline

Sumit Garg (1):
      MAINTAINERS: .mailmap: update Sumit Garg's email address

Sun YangKai (1):
      mm: zswap: use ATOMIC_LONG_INIT to initialize zswap_stored_pages

Suren Baghdasaryan (2):
      userfaultfd: do not block on locking a large folio with raised refcou=
nt
      userfaultfd: fix PTE unmapping stack-allocated PTE copies

Ujwal Kundur (1):
      Documentation: fix doc link to fault-injection.rst

gao xu (1):
      mm: fix possible NULL pointer dereference in __swap_duplicate

 .mailmap                                          |   1 +
 MAINTAINERS                                       |   6 +-
 arch/arm/mm/fault-armv.c                          |  37 +++++---
 arch/m68k/include/asm/sun3_pgalloc.h              |   6 +-
 drivers/rapidio/devices/rio_mport_cdev.c          |   3 +-
 drivers/rapidio/rio-scan.c                        |   5 +-
 fs/nfs/file.c                                     |   3 +-
 include/linux/compaction.h                        |   5 +
 include/linux/hugetlb.h                           |   5 +
 include/linux/log2.h                              |   2 +-
 include/linux/sched.h                             |   2 +-
 lib/Kconfig.debug                                 |   2 +-
 mm/compaction.c                                   |   3 +
 mm/hugetlb.c                                      |   8 ++
 mm/internal.h                                     |   5 +-
 mm/kmsan/hooks.c                                  |   1 +
 mm/memory-failure.c                               |  63 +++++++------
 mm/memory.c                                       |  21 +++--
 mm/memory_hotplug.c                               |  26 +++---
 mm/page_alloc.c                                   |   4 +-
 mm/page_isolation.c                               |  10 ++
 mm/shmem.c                                        |  33 ++++++-
 mm/swapfile.c                                     |  12 ++-
 mm/userfaultfd.c                                  | 107 ++++++++++++++++++=
----
 mm/vma.c                                          |  12 ++-
 mm/vmalloc.c                                      |   4 +-
 mm/zswap.c                                        |   2 +-
 tools/testing/selftests/damon/damon_nr_regions.py |   2 +
 tools/testing/selftests/damon/damos_quota.py      |   9 +-
 tools/testing/selftests/damon/damos_quota_goal.py |   3 +
 tools/testing/selftests/mm/hugepage-mremap.c      |   2 +-
 tools/testing/selftests/mm/ksm_functional_tests.c |   8 +-
 tools/testing/selftests/mm/memfd_secret.c         |  14 ++-
 tools/testing/selftests/mm/mkdirty.c              |   8 +-
 tools/testing/selftests/mm/mlock2.h               |   1 -
 tools/testing/selftests/mm/protection_keys.c      |   2 +-
 tools/testing/selftests/mm/uffd-common.c          |   4 +
 tools/testing/selftests/mm/uffd-stress.c          |  15 ++-
 tools/testing/selftests/mm/uffd-unit-tests.c      |  14 ++-
 39 files changed, 348 insertions(+), 122 deletions(-)

