Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E3B632;
	Sat,  1 Feb 2025 11:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738411144; cv=none; b=nJU11LPGCRF6TbvqU4+ILoSPPb7Gt0pB9dNO8d4Z/lLZPjHMOnFLMqZjR2rA2XMTEK70xfUUFR2qLP+68r0m7//I2IKNuZNUOcG+OWKPrdcCON1YH3GPQ4NTsVO9VWWyoUIsHO8ks2G66AZ0/IHvVoAPDilBmMswJaI3JRXdDVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738411144; c=relaxed/simple;
	bh=94xyT6OmGThoKOv8bPZlaAi0PgcMCi5BlDB+nEBsSuU=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=LF0loDoJxd239tA360h446apGrYt6YVROnAC9cxv3jbsDwh9I8kSAp6lFnG210E9X1iqKl8u5QNdvLBUAR0LeRK3i8+ge3K5SGBDO98uRM0sQCn/J802y12L4czCExXtX/dVU2nMdEJFqLD95a21ySqDF36C+IhaQG895AOriRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cWJJ3IlQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cWJJ3IlQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B526C4CED3;
	Sat,  1 Feb 2025 11:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738411144;
	bh=94xyT6OmGThoKOv8bPZlaAi0PgcMCi5BlDB+nEBsSuU=;
	h=Date:From:To:Cc:Subject:From;
	b=cWJJ3IlQDlprMONsV6f0Dgg1uDyFh1zW2RgVfeUPII8e6c3C/pubegh+4KeW5Qg/P
	 5vIg1mb/9U++Uny747BZsB29O+ONbE2UAVmkWx7ZstwXdAqZs8wQdkS0DBKBSEn4gz
	 k7j/+MKBFWdTE64zEPIDZ9Z5W70mCHyzCTSHRrtA=
Date: Sat, 1 Feb 2025 03:59:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.14-rc1
Message-Id: <20250201035903.6b2e2113f5b6cd38b07b46b5@linux-foundation.org>
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


The following changes since commit b4b0881156fb8209bf5ef6cb63211bb0ad6e1a6b:

  Merge tag 'docs-6.14-2' of git://git.lwn.net/linux (2025-01-30 10:57:19 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-02-01-03-56

for you to fetch changes up to e5b2a356dc8a88708d97bd47cca3b8f7ed7af6cb:

  MAINTAINERS: include linux-mm for xarray maintenance (2025-02-01 03:53:28 -0800)

----------------------------------------------------------------
21 hotfixes.  8 are cc:stable and the remainder address post-6.13 issues.
13 are for MM and 8 are for non-MM.  All are singletons, please see the
changelogs for details.

----------------------------------------------------------------
Andrew Morton (2):
      revert "xarray: port tests to kunit"
      MAINTAINERS: include linux-mm for xarray maintenance

Bruno Faccini (1):
      mm/fake-numa: handle cases with no SRAT info

Carlos Bilbao (1):
      mailmap, MAINTAINERS, docs: update Carlos's email address

Catalin Marinas (1):
      mm: kmemleak: fix upper boundary check for physical address objects

Christopher Obbard (1):
      .mailmap: update email address for Christopher Obbard

Hamza Mahfooz (1):
      mailmap: add an entry for Hamza Mahfooz

Heming Zhao (1):
      ocfs2: fix incorrect CPU endianness conversion causing mount failure

Hyeonggon Yoo (1):
      mm/zsmalloc: add __maybe_unused attribute for is_first_zpdesc()

Jan Kiszka (1):
      scripts/gdb: fix aarch64 userspace detection in get_current_task

Kairui Song (1):
      mm, swap: fix reclaim offset calculation error during allocation

Li Zhijian (1):
      mm/vmscan: accumulate nr_demoted for accurate demotion statistics

Liam R. Howlett (1):
      kernel: be more careful about dup_mmap() failures and uprobe registering

Marco Elver (1):
      kfence: skip __GFP_THISNODE allocations on NUMA systems

Nikita Zhandarovich (1):
      nilfs2: fix possible int overflows in nilfs_fiemap()

Ritesh Harjani (IBM) (1):
      mm/hugetlb: fix hugepage allocation for interleaved memory nodes

Tamir Duberstein (1):
      MAINTAINERS: add lib/test_xarray.c

Yosry Ahmed (1):
      MAINTAINERS: mailmap: update Yosry Ahmed's email address

Zhaoyang Huang (1):
      mm: gup: fix infinite loop within __get_longterm_locked

liuye (1):
      mm/vmscan: fix hard LOCKUP in function isolate_lru_folios

yangge (1):
      mm: compaction: use the proper flag to determine watermarks

 .mailmap                                   |   7 +-
 Documentation/translations/sp_SP/index.rst |   2 +-
 MAINTAINERS                                |  12 +-
 arch/m68k/configs/amiga_defconfig          |   1 +
 arch/m68k/configs/apollo_defconfig         |   1 +
 arch/m68k/configs/atari_defconfig          |   1 +
 arch/m68k/configs/bvme6000_defconfig       |   1 +
 arch/m68k/configs/hp300_defconfig          |   1 +
 arch/m68k/configs/mac_defconfig            |   1 +
 arch/m68k/configs/multi_defconfig          |   1 +
 arch/m68k/configs/mvme147_defconfig        |   1 +
 arch/m68k/configs/mvme16x_defconfig        |   1 +
 arch/m68k/configs/q40_defconfig            |   1 +
 arch/m68k/configs/sun3_defconfig           |   1 +
 arch/m68k/configs/sun3x_defconfig          |   1 +
 arch/powerpc/configs/ppc64_defconfig       |   1 +
 drivers/acpi/numa/srat.c                   |  11 +-
 fs/nilfs2/inode.c                          |   6 +-
 fs/ocfs2/super.c                           |   2 +-
 include/linux/swap.h                       |   1 +
 kernel/events/uprobes.c                    |   4 +
 kernel/fork.c                              |  17 +-
 lib/Kconfig.debug                          |  18 +-
 lib/Makefile                               |   2 +-
 lib/test_xarray.c                          | 671 ++++++++++++-----------------
 mm/compaction.c                            |  29 +-
 mm/gup.c                                   |  14 +-
 mm/hugetlb.c                               |   2 +-
 mm/kfence/core.c                           |   2 +
 mm/kmemleak.c                              |   2 +-
 mm/swapfile.c                              |   2 +-
 mm/vmscan.c                                |  13 +-
 mm/zsmalloc.c                              |   2 +-
 scripts/gdb/linux/cpus.py                  |   2 +-
 34 files changed, 386 insertions(+), 448 deletions(-)

