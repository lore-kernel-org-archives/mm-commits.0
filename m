Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D35229108;
	Thu, 17 Oct 2024 23:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729206628; cv=none; b=euNLQmmfoWknJmL8l3jXlhfQtK7TSw3JCaNdQkW4omsEBjMaGuqkndogm38jivHJJXf7B5HMbnTxzHaWVdp7fGpsqAkXSD77IJdWlXSs+7ob7INu5LAyzdZVlWBf2TW6OWfpRlKyXpc7PRwgP5jJjXdyHpJv4A4lENmL5+6eteU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729206628; c=relaxed/simple;
	bh=HDmuaWsiZ3tHdNhaJNT6hRkfDbACt6MfbWGEIMOuO08=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=ucFo7DRXh8kjA1JclWmH5hNSCU3K8SxBt/GvnIB+XHVW21vHTI8rUv/AJpNBpVxehZhiC7D0MxBhEFE8HtFHj4Tm0Ku7yNxWuDBNF9nDBLGUJp6b4OZnZ6rKwpre+HWmbWEKe21zoc7dTglkMuk0+qGS64B1K95JRDn9D2GUkWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p9vK3DqB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p9vK3DqB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10268C4CEC7;
	Thu, 17 Oct 2024 23:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729206628;
	bh=HDmuaWsiZ3tHdNhaJNT6hRkfDbACt6MfbWGEIMOuO08=;
	h=Date:From:To:Cc:Subject:From;
	b=p9vK3DqBOf9IyhDqlBviGdImkMZDzkK9vpPiw6pk3fUwpj9spNFa5TdxLl1OeLGGu
	 WRAQ5mBrei70X3+Jk1RfI1Is1W914owI4hJkg/Oli713NbnmGbeaEX9JhUcFFYXQCw
	 eLkHHt2+DV+dRToUc4xhdjUCLEI2W1mXGkNOTVRM=
Date: Thu, 17 Oct 2024 16:10:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.12-rc4
Message-Id: <20241017161027.f7fd7303fd91dbd1e6e18537@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this batch of hotfixes, thanks.

The following changes since commit 8e929cb546ee42c9a61d24fae60605e9e3192354:

  Linux 6.12-rc3 (2024-10-13 14:33:32 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-10-17-16-08

for you to fetch changes up to e993457df65896696e165defa8a468a831d0da1b:

  maple_tree: add regression test for spanning store bug (2024-10-17 08:35:10 -0700)

----------------------------------------------------------------
28 hotfixes.  13 are cc:stable.  23 are MM.

It is the usual shower of unrelated singletons - please see the individual
changelogs for details.

----------------------------------------------------------------
Andrey Konovalov (1):
      MAINTAINERS: kasan, kcov: add bugzilla links

Andy Chiu (1):
      mailmap: add an entry for Andy Chiu

Andy Shevchenko (1):
      mm: remove unused stub for can_swapin_thp()

Baolin Wang (1):
      mm: khugepaged: fix the incorrect statistics when collapsing large file folios

Brahmajit Das (1):
      fs/proc: fix build with GCC 15 due to -Werror=unterminated-string-initialization

David Hildenbrand (1):
      mm: don't install PMD mappings when THPs are disabled by the hw/process/vma

Edward Liaw (2):
      selftests/mm: replace atomic_bool with pthread_barrier_t
      selftests/mm: fix deadlock for fork after pthread_create on ARM

Florian Westphal (1):
      lib: alloc_tag_module_unload must wait for pending kfree_rcu calls

Jann Horn (2):
      mm/mremap: fix move_normal_pmd/retract_page_tables race
      MAINTAINERS: add Jann as memory mapping/VMA reviewer

Jeongjun Park (1):
      mm: swap: prevent possible data-race in __try_to_reclaim_swap

Jinjie Ruan (1):
      mm/damon/tests/sysfs-kunit.h: fix memory leak in damon_sysfs_test_add_targets()

Kefeng Wang (1):
      mm: huge_memory: add vma_thp_disabled() and thp_disabled_by_hw()

Liu Shixin (1):
      mm/swapfile: skip HugeTLB pages for unuse_vma

Lorenzo Stoakes (4):
      mm/mmap: correct error handling in mmap_region()
      MAINTAINERS: add memory mapping/VMA co-maintainers
      maple_tree: correct tree corruption on spanning store
      maple_tree: add regression test for spanning store bug

Nanyong Sun (1):
      selftests: mm: fix the incorrect usage() info of khugepaged

OGAWA Hirofumi (1):
      fat: fix uninitialized variable

Ryusuke Konishi (1):
      nilfs2: propagate directory read errors from nilfs_find_entry()

Sebastian Andrzej Siewior (1):
      mm: percpu: increase PERCPU_DYNAMIC_SIZE_SHIFT on certain builds.

SeongJae Park (2):
      Docs/damon/maintainer-profile: add missing '_' suffixes for external web links
      Docs/damon/maintainer-profile: update deprecated awslabs GitHub URLs

Sidhartha Kumar (1):
      maple_tree: check for MA_STATE_BULK on setting wr_rebalance

Wei Xu (1):
      mm/mglru: only clear kswapd_failures if reclaimable

Yang Shi (1):
      mm: khugepaged: fix the arguments order in khugepaged_collapse_file trace point

 .mailmap                                      |   2 +
 Documentation/mm/damon/maintainer-profile.rst |  38 ++++-----
 MAINTAINERS                                   |  12 ++-
 fs/fat/namei_vfat.c                           |   2 +-
 fs/nilfs2/dir.c                               |  48 +++++------
 fs/nilfs2/namei.c                             |  39 ++++++---
 fs/nilfs2/nilfs.h                             |   2 +-
 fs/proc/task_mmu.c                            |  16 ++--
 include/linux/huge_mm.h                       |  18 +++++
 include/linux/percpu.h                        |   6 +-
 include/trace/events/huge_memory.h            |   4 +-
 lib/codetag.c                                 |   3 +
 lib/maple_tree.c                              |  14 ++--
 mm/damon/tests/sysfs-kunit.h                  |   1 +
 mm/huge_memory.c                              |  13 +--
 mm/khugepaged.c                               |   6 +-
 mm/memory.c                                   |  14 ++--
 mm/mmap.c                                     |  32 +++++---
 mm/mremap.c                                   |  11 ++-
 mm/shmem.c                                    |   7 +-
 mm/swapfile.c                                 |   9 ++-
 mm/vmscan.c                                   |   4 +-
 tools/testing/radix-tree/maple.c              | 110 ++++++++++++++++++++++++++
 tools/testing/selftests/mm/khugepaged.c       |   2 +-
 tools/testing/selftests/mm/uffd-common.c      |   5 +-
 tools/testing/selftests/mm/uffd-common.h      |   3 +-
 tools/testing/selftests/mm/uffd-unit-tests.c  |  21 +++--
 27 files changed, 309 insertions(+), 133 deletions(-)

