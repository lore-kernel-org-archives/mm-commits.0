Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B54D3A4F5B;
	Tue, 20 Jan 2026 21:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768943487; cv=none; b=S9wQ+aTaRIyeQnkAyRP9KYX5Wxy9f/MqV4gHRMxHNAQaAEagZvo6ZSwFOHWeIvvHMUfBW2mhOy/pOo2cI5he37ENhc68ucj5/OhQnRUQq4wlfCYUfqGBrSYZ4adKhrLWnmywuoODekQ7Y4+qfvxJNv+sxv1beqSoAb17vdgtwjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768943487; c=relaxed/simple;
	bh=zO1+9fWdrUgZan1uwLv79ojapf4loed4yuRWdNTOGq8=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=rzg8WeGAmCZ7/O+tRb7zcgiX2QX76iTmIGAZPLkELKCuB+Qj/v5fY6O/NAhh8va5D6UH2yhuXC2ec8JKu9F9utoUjGf1D5CKRKq7rNkY+DFtX2ZXC5xf8owPXMfdd1M6AriPFspsaA8oDPuVJ3KY3ED8gKPdZU247a0m+/ndyI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QXxXb6bD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QXxXb6bD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E635EC19422;
	Tue, 20 Jan 2026 21:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768943487;
	bh=zO1+9fWdrUgZan1uwLv79ojapf4loed4yuRWdNTOGq8=;
	h=Date:From:To:Cc:Subject:From;
	b=QXxXb6bDImBF6DTrm9sNTs+s+aQF+2+6b/VXPCYb/Zj6PxsytHkfn7GPom4YN06Wc
	 KRjiDl9X1Cp/kqz4eqllhUFpJjavlym/6Xp7vyUUcSyLub88TsowVV4YqEUmDvfnBj
	 xNwnV8xIs5VpWQRlXLpbGzJGTxD+hhWGEIr3w/M4=
Date: Tue, 20 Jan 2026 13:11:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.19-rc7
Message-Id: <20260120131126.fcd6df1111d067948a8244c4@linux-foundation.org>
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


The following changes since commit 24d479d26b25bce5faea3ddd9fa8f3a6c3129ea7:

  Linux 6.19-rc6 (2026-01-18 15:42:45 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-01-20-13-09

for you to fetch changes up to 16aca2c98a6fdf071e5a1a765a295995d7c7e346:

  mm: restore per-memcg proactive reclaim with !CONFIG_NUMA (2026-01-20 09:34:27 -0800)

----------------------------------------------------------------
17 hotfixes.  12 are cc:stable, 16 are for MM.

- A 4 patch series from David Hildenbrand which fixes a few things
  realted to hugetlb PMD sharing

- The remainder are singletons, please see their changelogs for details.

----------------------------------------------------------------
Andrew Cooper (1):
      x86/kfence: avoid writing L1TF-vulnerable PTEs

Breno Leitao (1):
      mm/kfence: fix potential deadlock in reboot notifier

David Hildenbrand (Red Hat) (4):
      mm/hugetlb: fix hugetlb_pmd_shared()
      mm/hugetlb: fix two comments related to huge_pmd_unshare()
      mm/rmap: fix two comments related to huge_pmd_unshare()
      mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables using mmu_gather

Gal Pressman (1):
      panic: only warn about deprecated panic_print on write access

Joanne Koong (1):
      fs/writeback: skip AS_NO_DATA_INTEGRITY mappings in wait_sb_inodes()

Lorenzo Stoakes (3):
      mm/vma: do not leak memory when .mmap_prepare swaps the file
      mm: remove unnecessary and incorrect mmap lock assert
      mm: do not copy page tables unnecessarily for VM_UFFD_WP

Mathieu Desnoyers (3):
      mm: add missing static initializer for init_mm::mm_cid.lock
      mm: rename cpu_bitmap field to flexible_array
      mm: take into account mm_cid size for mm_struct static definitions

Matthew Wilcox (Oracle) (1):
      migrate: correct lock ordering for hugetlb file folios

Suren Baghdasaryan (1):
      Docs/mm/allocation-profiling: describe sysctrl limitations in debug mode

Yosry Ahmed (1):
      mm: restore per-memcg proactive reclaim with !CONFIG_NUMA

 Documentation/admin-guide/sysctl/vm.rst   |   4 +
 Documentation/mm/allocation-profiling.rst |  10 +++
 arch/x86/include/asm/kfence.h             |  29 +++++--
 drivers/firmware/efi/efi.c                |   2 +-
 fs/fs-writeback.c                         |   7 +-
 fs/fuse/file.c                            |   4 +-
 include/asm-generic/tlb.h                 |  77 +++++++++++++++++-
 include/linux/hugetlb.h                   |  17 ++--
 include/linux/mm.h                        |   6 +-
 include/linux/mm_types.h                  |  19 +++--
 include/linux/pagemap.h                   |  11 +++
 kernel/panic.c                            |   4 +-
 mm/hugetlb.c                              | 131 ++++++++++++++++--------------
 mm/init-mm.c                              |   5 +-
 mm/internal.h                             |   8 --
 mm/kfence/core.c                          |  17 ++--
 mm/memory.c                               |  11 ++-
 mm/migrate.c                              |  12 +--
 mm/mmu_gather.c                           |  33 ++++++++
 mm/rmap.c                                 |  45 +++++-----
 mm/vma.c                                  |  11 ++-
 mm/vmscan.c                               |  13 ++-
 22 files changed, 341 insertions(+), 135 deletions(-)

