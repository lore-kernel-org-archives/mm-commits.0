Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A0782D69;
	Wed, 10 Jul 2024 20:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720643014; cv=none; b=D592UvA3FSIUPcDAMFH6BhyW3PWnLUpZnzQuE5XEOprBJzzZkkV4m/5ghiyhNOoYrJ+itwhAZ7TAQJVhSOcqgwUMfvDYr7gTWMZOEBmJ0Whby7nO1KVMHbyQvcwu1nahn5X4ZSshZfwo020GE+xyQYDd71IlAVZHlj/A4YizXXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720643014; c=relaxed/simple;
	bh=C+LOEY5AOPNH//aXmXYOYWWB7w+l1ylAfyxYeJjyUs4=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=ukvtpDAhUdq6ZQq8pETxo71gho8wffq1XwzBSKTWbsVzcUVLj9yUCeIbhGM4qNEBDqL0dgCNb3vWw7IuMGYdqE16cGgkfeH8kJ0dkhBqXL9zkcREyRjr+LogSudC1V4yULHmkWhDOz0azr3IRuVQhizGLsm16F5SIw9S6fAXhwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vSOVlW4V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vSOVlW4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06511C32781;
	Wed, 10 Jul 2024 20:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720643014;
	bh=C+LOEY5AOPNH//aXmXYOYWWB7w+l1ylAfyxYeJjyUs4=;
	h=Date:From:To:Cc:Subject:From;
	b=vSOVlW4Vc0gvuFETmWPOANPHiw97FZseCaF3+hn/eaVUc+3myp/f/bU2lw5hXBkP+
	 tqZT7Ri+pV+p6bX7VBGfeqZXgdPeE3bz3B2PdR7xBwukYWgzLnNv6dhUq0uZ7nY36u
	 6h/TxKHfaT1JnnwkkAYlAaebz26V7WQaSUF/t0sE=
Date: Wed, 10 Jul 2024 13:23:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] hotfixes against 6.10-rc7
Message-Id: <20240710132333.0ef20b0442ffd813429ec240@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this batch of hotfixes, thanks.



The following changes since commit 93aef9eda1cea9e84ab2453fcceb8addad0e46f1:

  nilfs2: fix incorrect inode allocation from reserved inodes (2024-07-03 12:29:25 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-07-10-13-19

for you to fetch changes up to f708f6970cc9d6bac71da45c129482092e710537:

  mm/hugetlb: fix kernel NULL pointer dereference when migrating hugetlb folio (2024-07-09 15:41:11 -0700)

----------------------------------------------------------------
21 hotfixes, 15 of which are cc:stable.

No identifiable theme here - all are singleton patches, 19 are for MM.

----------------------------------------------------------------
Audra Mitchell (1):
      Fix userfaultfd_api to return EINVAL as expected

Gavin Shan (4):
      mm/filemap: make MAX_PAGECACHE_ORDER acceptable to xarray
      mm/readahead: limit page cache size in page_cache_ra_order()
      mm/filemap: skip to create PMD-sized page cache if needed
      mm/shmem: disable PMD-sized page cache if needed

Hugh Dickins (1):
      mm: fix crashes from deferred split racing folio migration

Lorenzo Stoakes (1):
      MAINTAINERS: mailmap: update Lorenzo Stoakes's email address

Miaohe Lin (2):
      mm/hugetlb: fix potential race in __update_and_free_hugetlb_folio()
      mm/hugetlb: fix kernel NULL pointer dereference when migrating hugetlb folio

Nhat Pham (1):
      cachestat: do not flush stats in recency check

Paul Menzel (1):
      lib/build_OID_registry: avoid non-destructive substitution for Perl < 5.13.2 compat

Ryusuke Konishi (1):
      nilfs2: fix kernel bug on rename operation of broken directory

SeongJae Park (1):
      mm/damon/core: merge regions aggressively when max_nr_regions is unmet

Suren Baghdasaryan (2):
      sched.h: always_inline alloc_tag_{save|restore} to fix modpost warnings
      arch/xtensa: always_inline get_current() and current_thread_info()

Uladzislau Rezki (Sony) (1):
      mm: vmalloc: check if a hash-index is in cpu_possible_mask

Waiman Long (1):
      mm: prevent derefencing NULL ptr in pfn_section_valid()

Yang Shi (2):
      mm: page_ref: remove folio_try_get_rcu()
      mm: gup: stop abusing try_grab_folio

Yu Zhao (1):
      mm/hugetlb_vmemmap: fix race with speculative PFN walkers

ZhangPeng (1):
      filemap: replace pte_offset_map() with pte_offset_map_nolock()

 .mailmap                              |   1 +
 MAINTAINERS                           |   2 +-
 arch/xtensa/include/asm/current.h     |   2 +-
 arch/xtensa/include/asm/thread_info.h |   2 +-
 fs/nilfs2/dir.c                       |  32 +++-
 fs/userfaultfd.c                      |   7 +-
 include/linux/mmzone.h                |   3 +-
 include/linux/page_ref.h              |  57 ++-----
 include/linux/pagemap.h               |  11 +-
 include/linux/sched.h                 |   4 +-
 include/linux/swap.h                  |   3 +-
 lib/build_OID_registry                |   4 +-
 mm/damon/core.c                       |  23 ++-
 mm/filemap.c                          |  20 ++-
 mm/gup.c                              | 291 ++++++++++++++++++----------------
 mm/huge_memory.c                      |   2 +-
 mm/hugetlb.c                          |  70 ++------
 mm/hugetlb_vmemmap.c                  |  16 ++
 mm/internal.h                         |   4 +-
 mm/memcontrol.c                       |  11 --
 mm/migrate.c                          |  13 ++
 mm/readahead.c                        |   8 +-
 mm/shmem.c                            |  15 +-
 mm/vmalloc.c                          |  10 +-
 mm/workingset.c                       |  14 +-
 25 files changed, 339 insertions(+), 286 deletions(-)

