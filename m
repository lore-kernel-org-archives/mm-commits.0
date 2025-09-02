Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9538CA5E;
	Tue,  2 Sep 2025 00:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756772555; cv=none; b=tRM1D8CXCMC8AOoLali/q/4DFeqKRvV4Ke72b2jdYD9tuh6NEL773CzB1HFBiJvVV375Qz2OWgzEHcp5g0PQTFBlMfz5dYuPRD3W9nmuITUZT1pdsvYK1AJKMsJrElyQc/46YFey++5jPiNDSLYrutkevwPAHoR8BECGzeWY+zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756772555; c=relaxed/simple;
	bh=y4WZ00EXLNOU4Dwc3A5fvI5jPMAfBOHh+PUZX1asazc=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=RNjPXRmMbh/WU+d8wm6Q7FWRsnXXoQXz7P493AqUCgG0rc1J9JsVoWPR9+Ic/qJQJe91igu71N/xfDPIHz03CtJJ5vPfFKfBufXAs+1mljMG8jNbx9t3Gj7KCgLKhcP8gu0tNJSWP7ZQtnz2VgCobnTNvdLvGqEPND3Am2LsC54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kGKv9AjU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kGKv9AjU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A5AC4CEF0;
	Tue,  2 Sep 2025 00:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756772555;
	bh=y4WZ00EXLNOU4Dwc3A5fvI5jPMAfBOHh+PUZX1asazc=;
	h=Date:From:To:Cc:Subject:From;
	b=kGKv9AjUrSkK0VZwVhBMOPhSeX1oTmpVcExKGhxd+LMeO4hMyWMuZluwOVCCoN3VC
	 jhW5ca+1uOVXITiXti5dd3hhqvQV+djPKSaQb9tlJvwsArUSOPuLk+DY1wGl0/wL4t
	 KecXMbWOQiR3Af6tVvcH9b54TBPWuXRiL8cfu9QU=
Date: Mon, 1 Sep 2025 17:22:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.17-rc5
Message-Id: <20250901172234.3a74524a97b595a5a81d1697@linux-foundation.org>
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


The following changes since commit 1b237f190eb3d36f52dffe07a40b5eb210280e00:

  Linux 6.17-rc3 (2025-08-24 12:04:12 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-09-01-17-20

for you to fetch changes up to c873ccbb2f8db46ad9b4a989ea924b6d8f19abf1:

  mm: fix possible deadlock in kmemleak (2025-09-01 17:11:37 -0700)

----------------------------------------------------------------
17 hotfixes.  13 are cc:stable and the remainder address post-6.16 issues
or aren't considered necessary for -stable kernels.  11 of these fixes are
for MM.

This includes a three-patch series from Harry Yoo which fixes an
intermittent boot failure which can occur on x86 systems.  And a two-patch
series from Alexander Gordeev which fixes a KASAN crash on S390 systems.

----------------------------------------------------------------
Ada Couprie Diaz (1):
      kasan: fix GCC mem-intrinsic prefix with sw tags

Alexander Gordeev (2):
      mm/kasan: fix vmalloc shadow memory (de-)population races
      mm/kasan: avoid lazy MMU mode hazards

Baptiste Lepers (1):
      rust: mm: mark VmaNew as transparent

Brian Mak (1):
      kexec: add KEXEC_FILE_NO_CMA as a legal flag

Edward Adam Davis (1):
      ocfs2: prevent release journal inode after journal shutdown

Gu Bowen (1):
      mm: fix possible deadlock in kmemleak

Harry Yoo (3):
      mm: move page table sync declarations to linux/pgtable.h
      mm: introduce and use {pgd,p4d}_populate_kernel()
      x86/mm/64: define ARCH_PAGE_TABLE_SYNC_MASK and arch_sync_kernel_mappings()

Quanmin Yan (1):
      mm/damon/core: prevent unnecessary overflow in damos_set_effective_quota()

Sasha Levin (1):
      mm/userfaultfd: fix kmap_local LIFO ordering for CONFIG_HIGHPTE

Sumanth Korikkar (1):
      mm: fix accounting of memmap pages

Yeoreum Yun (1):
      kunit: kasan_test: disable fortify string checker on kasan_strings() test

Yin Tirui (1):
      of_numa: fix uninitialized memory nodes causing kernel panic

Zi Yan (1):
      selftests/mm: fix FORCE_READ to read input value correctly

wangzijie (1):
      proc: fix missing pde_set_flags() for net proc files

 arch/x86/include/asm/pgtable_64_types.h           |  3 ++
 arch/x86/mm/init_64.c                             | 18 +++++++++++
 drivers/of/of_numa.c                              |  5 ++-
 fs/ocfs2/inode.c                                  |  3 ++
 fs/proc/generic.c                                 | 38 +++++++++++++----------
 include/linux/kexec.h                             |  3 +-
 include/linux/pgalloc.h                           | 29 +++++++++++++++++
 include/linux/pgtable.h                           | 25 ++++++++++++---
 include/linux/vmalloc.h                           | 16 ----------
 mm/damon/core.c                                   |  4 +--
 mm/kasan/init.c                                   | 12 +++----
 mm/kasan/kasan_test_c.c                           |  2 ++
 mm/kasan/shadow.c                                 | 22 ++++++++-----
 mm/kmemleak.c                                     | 27 +++++++++++-----
 mm/percpu.c                                       |  6 ++--
 mm/sparse-vmemmap.c                               | 11 ++-----
 mm/sparse.c                                       | 15 +++++----
 mm/userfaultfd.c                                  |  9 ++++--
 rust/kernel/mm/virt.rs                            |  1 +
 scripts/Makefile.kasan                            | 12 ++++---
 tools/testing/selftests/mm/cow.c                  |  4 +--
 tools/testing/selftests/mm/guard-regions.c        |  2 +-
 tools/testing/selftests/mm/hugetlb-madvise.c      |  4 ++-
 tools/testing/selftests/mm/migration.c            |  2 +-
 tools/testing/selftests/mm/pagemap_ioctl.c        |  2 +-
 tools/testing/selftests/mm/split_huge_page_test.c |  7 +++--
 tools/testing/selftests/mm/vm_util.h              |  2 +-
 27 files changed, 190 insertions(+), 94 deletions(-)
 create mode 100644 include/linux/pgalloc.h

