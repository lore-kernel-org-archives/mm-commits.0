Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84AA8393DE0;
	Fri, 22 Aug 2025 01:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755825683; cv=none; b=dpZ360Oqm8aaHdNM4vLJujh5XrbTp3uhZyvxmEmLj2Efo5iZZbPy0MM5gNSpg5VTOMz62Hm5XcQgT3xuvW2JC5ouxdYiqsmbQQTCxVbviFlQW+7kTCbr+A4TYQveFf46INLAMtgzURIrBGXUnYQ14DAxfsp0WIop4zUdaZcHum0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755825683; c=relaxed/simple;
	bh=tVhsYHxxFfX7gGzpp6/1LpcEhJi77iuO99nxuLjq6VE=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=q9afxS4V+qJ6DfAquIFJ2AVMn/kT3m2IaNl0tnnaDuKIwhOl4DE6xwqReygWMcTR2umJLX/Ww28b8/biAvzr4z/Dvhv3ikcx1nNMTYczVBjyhdml5LOPsR0L5/42IsjBv9d+WIMlA41zJCanXPCH8cPrupQ1YjLB2Snu0bH4E5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VmRuWpWJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VmRuWpWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7DCC4CEEB;
	Fri, 22 Aug 2025 01:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755825683;
	bh=tVhsYHxxFfX7gGzpp6/1LpcEhJi77iuO99nxuLjq6VE=;
	h=Date:From:To:Cc:Subject:From;
	b=VmRuWpWJNQvSp2Yp6FHRGVB4G0XYU6yBwuR9Ey439kdy0gKxIPav8VKcWWeG4FGoV
	 sEX1+CDT1U/YivRO40cVHX1BZEd3SOcRIejgpo3+zRTbetfu+lfNvQlGUBuzoAs04+
	 WICZ4EUJJ9tgfCVPCdSjzDxiWpAsmP621V3ogmzc=
Date: Thu, 21 Aug 2025 18:21:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.17-rc3
Message-Id: <20250821182122.eb19072cafdbc6612e76ac8f@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this week's bunch of mainly-MM hotfixes, thanks.


The following changes since commit c17b750b3ad9f45f2b6f7e6f7f4679844244f0b9:

  Linux 6.17-rc2 (2025-08-17 15:22:10 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-08-21-18-17

for you to fetch changes up to 772e5b4a5e8360743645b9a466842d16092c4f94:

  mm/mremap: fix WARN with uffd that has remap events disabled (2025-08-19 16:35:57 -0700)

----------------------------------------------------------------
20 hotfixes.  10 are cc:stable and the remainder address post-6.16 issues
or aren't considered necessary for -stable kernels.  17 of these fixes are
for MM.

As usual, singletons all over the place, apart from a three-patch series
of KHO followup work from Pasha which is actually also a bunch of
singletons.

----------------------------------------------------------------
Alice Ryhl (1):
      mm: rust: add page.rs to MEMORY MANAGEMENT - RUST

Axel Rasmussen (1):
      MAINTAINERS: mark MGLRU as maintained

David Hildenbrand (1):
      mm/mremap: fix WARN with uffd that has remap events disabled

Dominique Martinet (1):
      iov_iter: iterate_folioq: fix handling of offset >= folio size

Easwar Hariharan (1):
      .mailmap: add entry for Easwar Hariharan

Herton R. Krzesinski (1):
      mm/debug_vm_pgtable: clear page table entries at destroy_args()

Huacai Chen (1):
      mm/migrate: fix NULL movable_ops if CONFIG_ZSMALLOC=m

Jinjiang Tu (1):
      mm/memory-failure: fix infinite UCE for VM_PFNMAP pfn

Lorenzo Stoakes (4):
      tools/testing: add linux/args.h header and fix radix, VMA tests
      mm/mremap: allow multi-VMA move when filesystem uses thp_get_unmapped_area
      mm/mremap: catch invalid multi VMA moves earlier
      selftests/mm: add test for invalid multi VMA operations

Pasha Tatashin (3):
      kho: init new_physxa->phys_bits to fix lockdep
      kho: mm: don't allow deferred struct page with KHO
      kho: warn if KHO is disabled due to an error

Phillip Lougher (1):
      squashfs: fix memory leak in squashfs_fill_super

Sang-Heon Jeon (3):
      mm/damon/core: fix commit_ops_filters by using correct nth function
      selftests/damon: fix selftests by installing drgn related script
      mm/damon/core: fix damos_commit_filter not changing allow

SeongJae Park (1):
      mm/damon/sysfs-schemes: put damos dests dir after removing its files

 .mailmap                                 |   2 +
 MAINTAINERS                              |  19 +++
 fs/squashfs/super.c                      |  14 +-
 include/linux/iov_iter.h                 |  20 +--
 include/linux/migrate.h                  |   5 +
 kernel/Kconfig.kexec                     |   1 +
 kernel/kexec_handover.c                  |  29 +++-
 mm/balloon_compaction.c                  |   6 +
 mm/damon/core.c                          |  15 +-
 mm/damon/sysfs-schemes.c                 |   2 +-
 mm/debug_vm_pgtable.c                    |   9 +-
 mm/memory-failure.c                      |   8 +
 mm/migrate.c                             |  38 ++++-
 mm/mremap.c                              |  82 ++++++----
 mm/zsmalloc.c                            |  10 ++
 tools/include/linux/args.h               |  28 ++++
 tools/testing/selftests/damon/Makefile   |   1 +
 tools/testing/selftests/mm/mremap_test.c | 264 ++++++++++++++++++++++++++++++-
 tools/testing/shared/linux/idr.h         |   4 +
 19 files changed, 487 insertions(+), 70 deletions(-)
 create mode 100644 tools/include/linux/args.h

