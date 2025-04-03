Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F05A38DE9;
	Thu,  3 Apr 2025 05:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743657341; cv=none; b=HKrTWYCofEWSG1KPrSGjJ0C+gk+gb0cIeJUdFs7dpNCaZHeurDVbz7QofiwgzxhY8ABeJfSsQqGX4e/4XDAi/N53ObGIwlkB2No/F7/rwkFJC47UbrEQe5BgDjr/RC7zyB0a7JOEIRhm7qfGLpq0VSvZT5zh/DxHMTgmGpEj0VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743657341; c=relaxed/simple;
	bh=bJvutSflwNAHxccWEKos9Zv3IvVPhS5fbsyHMXbz5M8=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=MqUxh22Ubif9+dydj9RB1vA1Zoohup78YOZ3uEHWiPJ5ErNYT/5G2bVrV39ZINwlFOiwVaAWKLIicuNUvr2S9Vja31D4lYH8NVIWZfkDjpd7PoS45eUKAElIwU4ULthbc92J0FY7BO4LkagePutBx4EYlhVhrxzRtA9SUCo+d0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aoPkWRUD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aoPkWRUD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0ACCC4CEE3;
	Thu,  3 Apr 2025 05:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743657340;
	bh=bJvutSflwNAHxccWEKos9Zv3IvVPhS5fbsyHMXbz5M8=;
	h=Date:From:To:Cc:Subject:From;
	b=aoPkWRUDcfu9wW+Y3KE0uWJPU8nbl96ElxLWerLt/81u8Clg1JxLLfZEebMjMhIZh
	 aoB9NXTZbwvxVfLw+1AFQQjYmDHmFJb2oCgwxTjwUbRlbMzv5XG3hd3CUMtpjxbhPJ
	 LwKGV/TYRh2b8o38BPUebCl/8yZ8nxAepEp//1l0=
Date: Wed, 2 Apr 2025 22:15:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] Additional MM updates for 6.15-rc1
Message-Id: <20250402221540.435857db0b10cfeb489ae299@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please this second set of MM updates.

A couple of series which were dependent on -tip patches and a few
stragglers and latecomers.

I'm not seeing any merge issues with this batch,

Thanks.


The following changes since commit 25601e85441dd91cf7973b002f27af4c5b8691ea:

  Merge tag 'char-misc-6.15-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc (2025-04-01 11:26:08 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-04-02-22-07

for you to fetch changes up to e20706d5385b10a6f6a2fe5ad6b1333dad2d1416:

  mseal sysmap: add arch-support txt (2025-04-01 15:17:17 -0700)

----------------------------------------------------------------
- The 2 patch series "mm: fixes for fallouts from mem_init() cleanup"
  from Mike Rapoport fixes a couple of issues with the just-merged "arch,
  mm: reduce code duplication in mem_init()" series.

- The 4 patch series "MAINTAINERS: add my isub-entries to MM part." from
  Mike Rapoport does some maintenance on MAINTAINERS.

- The 6 patch series "remove tlb_remove_page_ptdesc()" from Qi Zheng
  does some cleanup work to the page mapping code.

- The 7 patch series "mseal system mappings" from Jeff Xu permits
  sealing of "system mappings", such as vdso, vvar, vvar_vclock, vectors
  (arm compat-mode), sigpage (arm compat-mode).

- Plus the usual shower of singleton patches.

----------------------------------------------------------------
Harry Yoo (1):
      mm/kasan: use SLAB_NO_MERGE flag instead of an empty constructor

Heiko Carstens (2):
      mseal sysmap: generic vdso vvar mapping
      mseal sysmap: enable s390

Jeff Xu (8):
      mseal sysmap: kernel config and header change
      selftests: x86: test_mremap_vdso: skip if vdso is msealed
      mseal sysmap: enable x86-64
      mseal sysmap: enable arm64
      mseal sysmap: uprobe mapping
      mseal sysmap: update mseal.rst
      selftest: test system mappings are sealed
      mseal sysmap: add arch-support txt

Jinjiang Tu (1):
      mm/memory_hotplug: fix call folio_test_large with tail page in do_migrate_range

Johannes Weiner (1):
      mm: page_alloc: fix defrag_mode's retry & OOM path

Li Wang (1):
      selftest/mm: va_high_addr_switch: add ppc64 support check

Lorenzo Stoakes (1):
      mm/mremap: do not set vrm->vma NULL immediately prior to checking it

Mike Rapoport (Microsoft) (6):
      mm/mm_init: init holes in the end of the memory map for FLATMEM
      memblock: don't release high memory to page allocator when HIGHMEM is off
      MAINTAINERS: fixup USERFAULTFD entry
      MAINTAINERS: mm: add entry for execmem
      MAINTAINERS: mm: add entry for numa memblocks and numa emulation
      MAINTAINERS: mm: add entry for secretmem

Peter Xu (1):
      MAINTAINERS: add peterx as userfaultfd reviewer

Qi Zheng (6):
      mm: pgtable: make generic tlb_remove_table() use struct ptdesc
      mm: pgtable: change pt parameter of tlb_remove_ptdesc() to struct ptdesc*
      mm: pgtable: convert some architectures to use tlb_remove_ptdesc()
      riscv: pgtable: unconditionally use tlb_remove_ptdesc()
      x86: pgtable: convert to use tlb_remove_ptdesc()
      mm: pgtable: remove tlb_remove_page_ptdesc()

Taotao Chen (1):
      mm/damon/core: simplify control flow in damon_register_ops()

Wei Yang (1):
      microblaze/mm: put mm_cmdline_setup() in .init.text section

Ye Liu (1):
      mm/page_alloc: replace flag check with PageHWPoison() in check_new_page_bad()

 .../core/mseal_sys_mappings/arch-support.txt       |  30 ++++++
 Documentation/userspace-api/mseal.rst              |  21 ++++
 MAINTAINERS                                        |  39 +++++++
 arch/arm64/Kconfig                                 |   1 +
 arch/arm64/kernel/vdso.c                           |   9 +-
 arch/csky/include/asm/pgalloc.h                    |   7 +-
 arch/hexagon/include/asm/pgalloc.h                 |   7 +-
 arch/loongarch/include/asm/pgalloc.h               |   7 +-
 arch/m68k/include/asm/sun3_pgalloc.h               |   7 +-
 arch/microblaze/mm/init.c                          |   2 +-
 arch/mips/include/asm/pgalloc.h                    |   7 +-
 arch/nios2/include/asm/pgalloc.h                   |   7 +-
 arch/openrisc/include/asm/pgalloc.h                |   7 +-
 arch/riscv/include/asm/pgalloc.h                   |  26 +----
 arch/s390/Kconfig                                  |   1 +
 arch/s390/kernel/vdso.c                            |   2 +-
 arch/sh/include/asm/pgalloc.h                      |   7 +-
 arch/um/include/asm/pgalloc.h                      |  21 ++--
 arch/x86/Kconfig                                   |   1 +
 arch/x86/entry/vdso/vma.c                          |   5 +-
 arch/x86/mm/pgtable.c                              |   8 +-
 include/asm-generic/tlb.h                          |  14 +--
 include/linux/mm.h                                 |  10 ++
 init/Kconfig                                       |  22 ++++
 kernel/events/uprobes.c                            |   3 +-
 lib/vdso/datastore.c                               |   3 +-
 mm/damon/core.c                                    |   9 +-
 mm/kasan/kasan_test_c.c                            |   5 +-
 mm/memblock.c                                      |   3 +
 mm/memory_hotplug.c                                |  12 +--
 mm/mm_init.c                                       |  12 +--
 mm/mremap.c                                        |   3 +-
 mm/page_alloc.c                                    |   6 +-
 security/Kconfig                                   |  21 ++++
 tools/testing/selftests/Makefile                   |   1 +
 tools/testing/selftests/mm/va_high_addr_switch.sh  |  28 +++++
 .../selftests/mseal_system_mappings/.gitignore     |   2 +
 .../selftests/mseal_system_mappings/Makefile       |   6 ++
 .../testing/selftests/mseal_system_mappings/config |   1 +
 .../mseal_system_mappings/sysmap_is_sealed.c       | 119 +++++++++++++++++++++
 tools/testing/selftests/x86/test_mremap_vdso.c     |  43 ++++++++
 41 files changed, 417 insertions(+), 128 deletions(-)
 create mode 100644 Documentation/features/core/mseal_sys_mappings/arch-support.txt
 create mode 100644 tools/testing/selftests/mseal_system_mappings/.gitignore
 create mode 100644 tools/testing/selftests/mseal_system_mappings/Makefile
 create mode 100644 tools/testing/selftests/mseal_system_mappings/config
 create mode 100644 tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c

