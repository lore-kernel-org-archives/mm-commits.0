Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06B01A8408;
	Sat, 21 Dec 2024 20:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734811890; cv=none; b=kD3/cNk9ZZC/LLIinAz3ULv69Fmx3T4yIE2WWBcGs9nov2Gv+ZE63lUkaZT7EpKugSGkXfQVFRITIcrQ4Su/R8o4eRwnmlcqsKhsCsMuDKr6ATzhvwfUJqxREbHvI7oa9M1kHjqo/yo/XHIFi8H0gzam4kvlvpCFxER+Tr1dqgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734811890; c=relaxed/simple;
	bh=Ipjna+Z5UUA2Y79eerTQxc/6gkKd9ECENC603HTXlqc=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=WTaDm/x48bp9qhOmSDrWWPQEnIEar7d6v+45SPAdxl79gFrmkHC0+ivOSyT3TzJsCaPmvDwB3iHLegyv1fqg5yP7+2DkDZK9Zgx+sX8dyOr+p4L+4wA/I0fEiQDoxSbG53dSmgNl2vB5Q1H5c7xp0GKv9++7/5QhxTHz/eLoQco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B0hTkcA5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B0hTkcA5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E57C4CECE;
	Sat, 21 Dec 2024 20:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734811890;
	bh=Ipjna+Z5UUA2Y79eerTQxc/6gkKd9ECENC603HTXlqc=;
	h=Date:From:To:Cc:Subject:From;
	b=B0hTkcA5Y4uJW/iTm/7Ha2ylDuFzjiRhROGwD6kSCOVNw/Y6xLM70cGvXtwwAlN3D
	 0FJKO15C0IWAvhGyC+UgeE7WIIq6655GNhlXHC3HVr8fPs9muihXcik3H16wqK76gq
	 HBO4AIAkI/jTuu1j+S2oqPsO/UCRRnNV9s8SsmXY=
Date: Sat, 21 Dec 2024 12:11:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.13-rc4
Message-Id: <20241221121129.db5f29eeddf08a80f5585bb7@linux-foundation.org>
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


The following changes since commit 78d4f34e2115b517bcbfe7ec0d018bbbb6f9b0b8:

  Linux 6.13-rc3 (2024-12-15 15:58:23 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-12-21-12-09

for you to fetch changes up to d3ac65d274b3a93cf9cf9559fd1473ab65e00e10:

  mm: huge_memory: handle strsep not finding delimiter (2024-12-18 19:04:47 -0800)

----------------------------------------------------------------
25 hotfixes.  16 are cc:stable.  19 are MM and 6 are non-MM.

The usual bunch of singletons and doubletons - please see the relevant
changelogs for details.

----------------------------------------------------------------
Bart Van Assche (1):
      mm/vmstat: fix a W=1 clang compiler warning

David Hildenbrand (1):
      mm/page_alloc: don't call pfn_to_page() on possibly non-existent PFN in split_large_buddy()

David Wang (1):
      mm/codetag: clear tags before swap

Edward Adam Davis (1):
      nilfs2: prevent use of deleted inode

Heming Zhao (2):
      ocfs2: revert "ocfs2: fix the la space leak when unmounting an ocfs2 volume"
      ocfs2: fix the space leak in LA when releasing LA

Huang Ying (1):
      mailmap: add entry for Ying Huang

Hugh Dickins (1):
      mm: shmem: fix ShmemHugePages at swapout

Isaac J. Manjarres (1):
      selftests/memfd: run sysctl tests when PID namespace support is enabled

Kairui Song (2):
      zram: refuse to use zero sized block device as backing device
      zram: fix uninitialized ZRAM not releasing backing device

Kefeng Wang (2):
      mm: use aligned address in clear_gigantic_page()
      mm: use aligned address in copy_user_gigantic_page()

Leo Stone (1):
      mm: huge_memory: handle strsep not finding delimiter

Lorenzo Stoakes (3):
      docs/mm: add VMA locks documentation
      mm: correctly reference merged VMA
      fork: avoid inappropriate uprobe access to invalid mm

Matthew Wilcox (Oracle) (1):
      vmalloc: fix accounting with i915

Petr Malat (1):
      mm: add RCU annotation to pte_offset_map(_lock)

Ryusuke Konishi (1):
      nilfs2: fix buffer head leaks in calls to truncate_inode_pages()

Suren Baghdasaryan (2):
      alloc_tag: fix module allocation tags populated area calculation
      alloc_tag: fix set_codetag_empty() when !CONFIG_MEM_ALLOC_PROFILING_DEBUG

Usama Arif (1):
      mm: convert partially_mapped set/clear operations to be atomic

Zi Yan (2):
      mm: introduce cpu_icache_is_aliasing() across all architectures
      mm: use clear_user_(high)page() for arch with special user folio handling

 .mailmap                                   |   1 +
 Documentation/mm/process_addrs.rst         | 850 +++++++++++++++++++++++++++++
 arch/arc/Kconfig                           |   1 +
 arch/arc/include/asm/cachetype.h           |   8 +
 drivers/block/zram/zram_drv.c              |  15 +-
 fs/hugetlbfs/inode.c                       |   2 +-
 fs/nilfs2/btnode.c                         |   1 +
 fs/nilfs2/gcinode.c                        |   2 +-
 fs/nilfs2/inode.c                          |  13 +-
 fs/nilfs2/namei.c                          |   5 +
 fs/nilfs2/nilfs.h                          |   1 +
 fs/ocfs2/localalloc.c                      |  27 +-
 include/linux/alloc_tag.h                  |   9 +-
 include/linux/cacheinfo.h                  |   6 +
 include/linux/highmem.h                    |   8 +-
 include/linux/mm.h                         |  31 +-
 include/linux/page-flags.h                 |  12 +-
 include/linux/vmstat.h                     |   2 +-
 kernel/fork.c                              |  13 +-
 lib/alloc_tag.c                            |  41 +-
 mm/huge_memory.c                           |  19 +-
 mm/hugetlb.c                               |   5 +-
 mm/internal.h                              |   6 -
 mm/memory.c                                |  18 +-
 mm/page_alloc.c                            |   6 +-
 mm/pgtable-generic.c                       |   2 +-
 mm/shmem.c                                 |  22 +-
 mm/vma.c                                   |   5 +-
 mm/vmalloc.c                               |   6 +-
 tools/testing/selftests/memfd/memfd_test.c |  14 +-
 30 files changed, 1049 insertions(+), 102 deletions(-)
 create mode 100644 arch/arc/include/asm/cachetype.h

