Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0486C27A92D;
	Thu, 15 Jan 2026 16:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768493207; cv=none; b=FIJvytX6aRt4ZnmdOi542vimhdyw0YJfYlz/WXj9vpWSBZKH1WCC/hAZXXNdlfgCWENkd2q+0oBNYeD6RUyeCADFBkZbE4FoGe7Zu5s9cwLsypbJruOq5+rrvLwz+jVERX2bMYs48VmVOosbGfWQfoF4VZOKmiHC0seH2MoC17M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768493207; c=relaxed/simple;
	bh=NVJo7J8yhwfa5AT6TXzZR3usJmOp8dPjAOt3Iy8w++8=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=TMc2wx3HwKFE+8viz9RLeMOm7clZfwsavg5rdGNyHCsxLvUdEZWjvFHEaP85FLDTPyBlQuRfJ2xjHRpvc2A8j+MZI/N5mxth/qpMtKtjfWPt0bvHG7Xf5aPC8l4pQbPiIl9s5CGppIPs24bSs1ktEfoyYbVmnou9+finoEnaP8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o+X7fBAa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o+X7fBAa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71BA7C116D0;
	Thu, 15 Jan 2026 16:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768493206;
	bh=NVJo7J8yhwfa5AT6TXzZR3usJmOp8dPjAOt3Iy8w++8=;
	h=Date:From:To:Cc:Subject:From;
	b=o+X7fBAaEfqJPPICRdhNboEMHxZAgXFnck/0Zipxfls7scCDBDNtMvXh21cUdQzmT
	 XdIGcHvv9YRXuA4CAJLu/uFR3j8iNq6K/bKznP/wX+eQ/I5jWiL9/nHv4H1b8i6hqT
	 OgP7KRaNEH/IN+5s+TofyFY5UZzqi/unDV1sbu38=
Date: Thu, 15 Jan 2026 08:06:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.19-rc6
Message-Id: <20260115080645.3744d9e4178884f988d6366d@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please pull this batch of hotfixes, thanks.


The following changes since commit 0f61b1860cc3f52aef9036d7235ed1f017632193:

  Linux 6.19-rc5 (2026-01-11 17:03:14 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-01-15-08-03

for you to fetch changes up to 3e8e590fd65d0572584ab7bba89a35e6d19931f1:

  drivers/dax: add some missing kerneldoc comment fields for struct dev_dax (2026-01-14 22:16:26 -0800)

----------------------------------------------------------------
32 hotfixes.  16 are cc:stable, 24 are for MM.

- four kerneldoc fixes from Bagas Sanjaya

- four DAMON fixes from SeongJae

- four mremap VMA-related fixes from Lorenzo

- various singletons - please see the changelogs for details

----------------------------------------------------------------
Aboorva Devarajan (1):
      mm/page_alloc: make percpu_pagelist_high_fraction reads lock-free

Bagas Sanjaya (4):
      mm: describe @flags parameter in memalloc_flags_save()
      textsearch: describe @list member in ts_ops search
      mm: vmalloc: fix up vrealloc_node_align() kernel-doc macro name
      mm, kfence: describe @slab parameter in __kfence_obj_info()

Ben Dooks (1):
      mm: numa,memblock: include <asm/numa.h> for 'numa_nodes_parsed'

Carlos Llamas (1):
      iommu/sva: include mmu_notifier.h header

Daniel Thompson (1):
      mailmap: add entry for Daniel Thompson

Feng Tang (1):
      powerpc/watchdog: add support for hardlockup_sys_info sysctl

John Groves (1):
      drivers/dax: add some missing kerneldoc comment fields for struct dev_dax

Lorenzo Stoakes (5):
      mm/vma: fix anon_vma UAF on mremap() faulted, unfaulted merge
      tools/testing/selftests: add tests for !tgt, src mremap() merges
      mm/vma: enforce VMA fork limit on unfaulted,faulted mremap merge too
      tools/testing/selftests: add forked (un)/faulted VMA merge tests
      tools/testing/selftests: fix gup_longterm for unknown fs

Marco Elver (1):
      docs: kernel-parameters: add kfence parameters

Mike Rapoport (Microsoft) (1):
      mips: fix HIGHMEM initialization

Pasha Tatashin (1):
      kho: validate preserved memory map during population

Pavel Butsykin (1):
      mm/zswap: fix error pointer free in zswap_cpu_comp_prepare()

Ryan Roberts (1):
      mm: kmsan: fix poisoning of high-order non-compound pages

SeongJae Park (5):
      mm/damon/core: remove call_control in inactive contexts
      mm/damon/sysfs: cleanup intervals subdirs on attrs dir setup failure
      mm/damon/sysfs: cleanup attrs subdirs on context dir setup failure
      mm/damon/sysfs-scheme: cleanup quotas subdirs on scheme dir setup failure
      mm/damon/sysfs-scheme: cleanup access_pattern subdirs on scheme dir setup failure

Shakeel Butt (2):
      lib/buildid: use __kernel_read() for sleepable context
      mm/damon/core: get memcg reference before access

Sourabh Jain (1):
      mm/hugetlb: ignore hugepage kernel args if hugepages are unsupported

Szymon Wilczek (1):
      mailmap: update email address for Szymon Wilczek

Vlastimil Babka (1):
      mm/page_alloc: prevent pcp corruption with SMP=n

 .mailmap                                        |   2 +
 Documentation/admin-guide/kernel-parameters.txt |  35 +++
 arch/mips/mm/init.c                             |  23 ++
 arch/powerpc/kernel/watchdog.c                  |  15 +-
 drivers/dax/dax-private.h                       |  10 +-
 drivers/iommu/iommu-sva.c                       |   1 +
 include/linux/kfence.h                          |   1 +
 include/linux/nmi.h                             |   1 +
 include/linux/sched/mm.h                        |   1 +
 include/linux/textsearch.h                      |   1 +
 kernel/liveupdate/kexec_handover.c              |  37 +--
 kernel/watchdog.c                               |   2 +-
 lib/buildid.c                                   |  32 +-
 mm/damon/core.c                                 |  41 ++-
 mm/damon/sysfs-schemes.c                        |  10 +-
 mm/damon/sysfs.c                                |   9 +-
 mm/hugetlb.c                                    |  16 +
 mm/kmsan/shadow.c                               |   2 +-
 mm/numa_memblks.c                               |   2 +
 mm/page_alloc.c                                 |  57 +++-
 mm/vma.c                                        | 111 ++++---
 mm/vma.h                                        |   3 +
 mm/vmalloc.c                                    |   2 +-
 mm/zswap.c                                      |   2 +-
 tools/testing/selftests/mm/gup_longterm.c       |   2 +-
 tools/testing/selftests/mm/merge.c              | 384 ++++++++++++++++++++++--
 26 files changed, 674 insertions(+), 128 deletions(-)

